from std/cmdline import commandLineParams, paramCount
from std/envvars import getEnv
from std/parseopt import initOptParser, getopt
from std/os import nil
from std/paths import Path
from std/strformat import `&`
import std/times

import wasmtime
import zdfs

import src/[actor, exports, flecs, stdx]
from src/args import nil
from src/core import nil
from src/platform import nil

const libPath = when defined(release):
    "../build/src/Release/libviletech.a"
else:
    "../build/src/Debug/libviletech.a"

{.link: libPath.}
{.passc: "-I./src".}

{.link: getEnv("VTEC_WASMTIME_CLIB").}
{.passc: "-isystem " & getEnv("VTEC_WASMTIME_INCL").}

const projectDir* {.strdefine.} = "."
    ## i.e. `viletech-engine/client`.

proc cMain(
    ccx: ptr core.CCore,
    argc: cint,
    argv: cstringArray
): cint {.importc.}

let startTime = getTime()

var cx = core.Core()
let ccx: ref core.CCore = cx

cx.world = initWorld()
cx.wasm = initWasmEngine()
assert(cx.world != nil)
assert(cx.wasm != nil)

var clArgs = commandLineParams()

var p = initOptParser(clArgs)

for kind, key, val in p.getopt():
    case kind
    of cmdShortOption:
        for param in args.params:
            if key == param.keyShort:
                if param.noValue and val != "":
                    quit(&"`{param.keyLong}`/`{param.keyShort}` does not accept values", QuitFailure)

                param.callback()

                if param.earlyExit:
                    quit(QuitSuccess)
    of cmdLongOption:
        for param in args.params:
            if key == param.keyLong:
                if param.noValue and val != "":
                    quit(&"`{param.keyLong}`/`{param.keyShort}` does not accept values", QuitFailure)

                param.callback()

                if param.earlyExit:
                    quit(QuitSuccess)
    of cmdArgument:
        cx.loadOrder.add(key.Path)
        discard
    of cmdEnd:
        assert(false, "unreachable `cmdEnd`")

clArgs.insert(os.getAppFileName(), 0)

block:
    let world = cx.world
    ecsComponent(world, FxSpace)
    ecsComponent(world, Rendered)

let argv = clArgs.toOpenArray(0, paramCount()).allocCStringArray()
var ccxPtr: ptr core.CCore = nil

for field in fields(ccx[]):
    ccxPtr = cast[ptr core.CCore](field.addr)
    break

let ret = cMain(ccxPtr, paramCount().cint + 1, argv)

#[

proc cParseCommandLineArgs(argc: cint, argv: cstringArray) {.importc: "dsda_ParseCommandLineArgs".}
proc cLoadDefaults() {.importc: "M_LoadDefaults".}
proc cSetProcessPriority() {.importc: "I_SetProcessPriority".}
proc cPreInitGraphics() {.importc: "I_PreInitGraphics".}
proc cDoomMain() {.importc: "D_DoomMain", noreturn.}

cParseCommandLineArgs(paramCount().cint + 1, argv)
cLoadDefaults()
cSetProcessPriority()
cPreInitGraphics()

cDoomMain()

]#

let uptime = startTime.elapsed().hoursMinsSecs()
echo(&"Engine uptime: {uptime.hours:02}:{uptime.mins:02}:{uptime.secs:02}")

quit(ret)
