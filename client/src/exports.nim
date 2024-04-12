## Generating C bindings.

when defined(nimHasUsed):
    {.used.}

import bindgen

import ./[actor, core, flecs, platform]
import ../[wasmtime]

exportConsts:
    baseScreenWidth

exportEnums:
    Flavor

exportFlagsets:
    SpaceFlag

exportObject CCore:
    discard

exportOpaque:
    WasmEngine
    World

exportProcs:
    activateMouse
    deactivateMouse

writeBindings("../build", "viletech.nim", "n", pragmaOnce = true)
