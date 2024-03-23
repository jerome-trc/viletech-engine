## Generating C bindings.

when defined(nimHasUsed):
    {.used.}

import bindgen

import ./[actor, core, engine, flecs, platform]

exportConsts:
    baseScreenWidth

exportEnums:
    Flavor

exportFlagsets:
    SpaceFlag

exportObject Core:
    discard

exportOpaque:
    World

exportProcs:
    activateMouse
    deactivateMouse

writeBindings("../build", "viletech.nim", "n", pragmaOnce = true)
