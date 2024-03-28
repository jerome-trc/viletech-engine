const libPath = when defined(release):
    "../build/src/Release/libviletech.a"
else:
    "../build/src/Debug/libviletech.a"

{.link: libPath.}
{.passc: "-I./src".}

proc cMain(argc: cint, argv: cstringArray): cint {.importc.}

from std/cmdline import commandLineParams, paramCount
from std/parseopt import initOptParser, getopt
from std/os import nil
from std/paths import Path
from std/strformat import `&`
import std/times

import zdfs

import src/[actor, exports, flecs, stdx]
from src/args import nil
from src/core import nil
from src/platform import nil

let startTime = getTime()

var cx = core.Core()
cx.world = initWorld()
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
let ret = cMain(paramCount().cint + 1, argv)

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

let uptime = startTime.elapsed()
echo(&"Engine uptime: {uptime.inHours()}:{uptime.inMinutes()}:{uptime.inSeconds()}")

quit(ret)
