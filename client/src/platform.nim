proc setRelativeMouseMode(enabled: cint): cint {.importc: "SDL_SetRelativeMouseMode".}
proc getRelativeMouseState(x, y: var cint): uint32 {.importc: "SDL_GetRelativeMouseState".}

proc activateMouse*() {.exportc: "n_$1".} =
    let res = setRelativeMouseMode(true.cint)
    assert(res == 0)
    var x, y: cint
    discard getRelativeMouseState(x, y)

proc deactivateMouse*() {.exportc: "n_$1".} =
    let res = setRelativeMouseMode(false.cint)
    assert(res == 0)

proc windowIcon*(size: var int32): ptr uint8 {.exportc: "n_$1".} =
    ## Retrieve embedded window icon data.
    const bytes = staticRead("../../engine/ICONS/viletech.png")
    let b = cast[seq[uint8]](bytes)
    size = b.len.int32
    return b[0].addr
