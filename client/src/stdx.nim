## Helpers which could reasonably be a part of the standard library.

import std/times

proc isEmpty*[T](sequence: seq[T]): bool =
    sequence.len() == 0

proc isEmpty*(str: string): bool =
    str.len() == 0

proc isEmpty*[TOpenArray: openArray | varargs](arr: TOpenArray): bool =
    arr.len() == 0

type FileIo* {.borrow: `.`.} = distinct File
    ## A `distinct File` with a destructor that closes the handle.

proc `=destroy`*(fio: FileIo) =
    close(fio.File)

type HoursMinSecs* = tuple[hours: int64, mins: int64, secs: int64]
    ## Note that minutes and seconds are both remainders, not totals.

proc elapsed*(time: Time): Duration =
    getTime() - time

proc hoursMinsSecs*(duration: Duration): HoursMinSecs =
    let mins = (duration.inSeconds() / 60).int64
    let hours = (mins / 60).int64
    let secs = duration.inSeconds() mod 60
    return (hours, mins, secs)
