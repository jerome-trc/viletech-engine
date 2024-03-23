version = "0.0.0"
author = "jerome-trc"
description = "Play id Tech 1 games on the VileTech Client"
license = "Apache 2.0 OR MIT"
bin = @["viletech"]
skipDirs = @["tests"]

requires "nim == 2.0.2"

proc cFlags(): string =
    return getEnv("VTEC_LIB_DIRS") & " " &
        "--cincludes:../engine/src " &
        "--clib:dumb " &
        "--clib:fluidsynth " &
        "--clib:GL --clib:GLU " &
        "--clib:mad " &
        "--clib:ogg " &
        "--clib:portmidi " &
        "--clib:SDL2-2.0 --clib:SDL2_image --clib:SDL2_mixer " &
        "--clib:vorbis --clib:vorbisfile " &
        "--clib:z " &
        "--clib:zip "

task build_d, "Debug Executable":
    when defined(windows):
        const output = "-o:../build/Debug/viletech.exe "
    else:
        const output = "-o:../build/Debug/viletech "

    exec("/usr/bin/cmake --build /home/jerome/Data/viletech-engine/build --config Debug --target all --")

    exec("nim --nimcache:../nimcache " &
        output &
        cFlags() &
        "cpp ./viletech.nim")

task build_r, "Release Executable":
    when defined(windows):
        const output = "-o:../build/Release/viletech.exe "
    else:
        const output = "-o:../build/Release/viletech "

    exec("/usr/bin/cmake --build /home/jerome/Data/viletech-engine/build --config Release --target all --")

    exec("nim --nimcache:../nimcache " &
        output &
        cFlags() &
        "-d:release cpp ./viletech.nim")

task test, "Run Test Suite":
    exec("testament run ./tests/all/t.nim")
