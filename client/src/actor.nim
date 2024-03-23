## ECS components for actors (traditionally "map objects" or "things").

from fixed import Fx32

type
    Angle* {.exportc.} = distinct uint32

proc `+` *(a, b: Angle): Angle {.borrow.}
proc `-` *(a, b: Angle): Angle {.borrow.}
proc `*` *(a, b: Angle): Angle {.borrow.}
proc `div` *(a, b: Angle): Angle {.borrow.}

type
    SpaceFlag* {.size: sizeof(uint64).} = enum
        ecsfDropoff
        ecsfFloat
        ecsfSolid
        ecsfShootable
    SpaceFlags* = set[SpaceFlag]

proc toBits*(v: SpaceFlags): uint64 = cast[uint64](v)
proc toSpaceFlags*(v: uint64): SpaceFlags = cast[SpaceFlags](v)

type
    FxSpace* = tuple
        flags: SpaceFlags
        x, y, z: Fx32
        prev_x, prev_y, prev_z: Fx32
        vel_x, vel_y, vel_z: Fx32
        angle, pitch: Angle
        radius, height: Fx32
        friction: int32
        solid: bool
    Health* = tuple
        current: int32
    Rendered* = tuple
        alpha: float32
    Special* = tuple
        tid: int16
        special: int32
        args: array[5, int32]
