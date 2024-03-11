## Distinct fixed-point decimal number types.

type
    Fx32* {.exportc.} = distinct int32
        ## A 32-bit fixed-point decimal number.

const fracBits* {.exportc.}: int64 = 16
const fracUnit* {.exportc.}: int64 = 1 shl fracBits

proc `+` *(a, b: Fx32): Fx32 {.borrow.}
proc `-` *(a, b: Fx32): Fx32 {.borrow.}

proc `*` *(a, b: Fx32): Fx32 =
    ((a * b).int64 shr fracBits).Fx32

proc `/` *(a, b: Fx32): Fx32 =
    if (a.int32.abs() shr 14) >= b.int32.abs():
        return (((a.int32 xor b.int32) shr 31) xor high(int32)).Fx32
    else:
        ((a.int64 shr fracBits) / b.int64).Fx32

proc `%` *(a, b: Fx32): Fx32 =
    if ((b.int32 and (b.int32 - 1)) > 0):
        let r = a.int32 mod b.int32;
        return if r < 0: r.Fx32 + b else: r.Fx32
    else:
        return (a.int32 and (b.int32 - 1)).Fx32

proc scale*(a, b, c: Fx32): Fx32 =
    return ((a.int64 * b.int64) / c.int64).Fx32
