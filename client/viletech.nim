{.link: "../build/src/Debug/libviletech.a".}
{.passc: "-I./src".}

proc cParseCommandLineArgs(argc: cint, argv: cstringArray) {.importc: "dsda_ParseCommandLineArgs".}
proc cLoadDefaults() {.importc: "M_LoadDefaults".}
proc cSetProcessPriority() {.importc: "I_SetProcessPriority".}
proc cPreInitGraphics() {.importc: "I_PreInitGraphics".}
proc cDoomMain() {.importc: "D_DoomMain".}

from std/cmdline import commandLineParams, paramCount
from std/parseopt import initOptParser, getopt
from std/paths import Path
from std/strformat import `&`
from std/os import nil

from src/args import nil
from src/core import nil
from src/platform import nil

var cx = core.Core()
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

var argv = clArgs.toOpenArray(0, paramCount()).allocCStringArray()
cParseCommandLineArgs(paramCount().cint + 1, argv)
cLoadDefaults()
cSetProcessPriority()
cPreInitGraphics()
cDoomMain()
