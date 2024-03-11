## Launch arguments and their callbacks.

from std/streams import newStringStream
from std/strformat import `&`

from parsecfg import loadConfig, getSectionValue

type
    Param* = tuple
        keyLong: string
        keyShort: string
        desc: string
        earlyExit: bool = false
        callback: proc() = nil
        noValue: bool = true

proc printHelp()
proc printVersion()

const params* = @[
    (keyLong: "help", keyShort: "h", desc: "print this usage information and then exit",
            earlyExit: true, callback: printHelp, noValue: true),
    (keyLong: "version", keyShort: "V", desc: "print the engine version and compile date/time",
            earlyExit: true, callback: printVersion, noValue: true),
]

proc printHelp() =
    echo "https://github.com/jerome-trc/viletech-engine\n"

    for param in params:
        echo &"{param.keyLong} {param.keyShort} : {param.desc}"

proc printVersion() =
    const vers = staticRead("../viletech.nimble").newStringStream().loadConfig(
        ).getSectionValue("", "version")
    const commit = staticExec("git rev-parse HEAD")

    echo &"VileTech Engine {vers}\n{commit}"
