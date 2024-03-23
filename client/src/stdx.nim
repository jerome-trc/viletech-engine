## Helpers which could reasonably be a part of the standard library.

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
