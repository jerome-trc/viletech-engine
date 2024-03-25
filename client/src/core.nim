## Permeates the code base with state that is practically "global".

from std/paths import Path

import flecs

type
    Core* {.exportc.} = ref object
        ## Permeates the code base with state that is practically "global".
        loadOrder*: seq[Path]
        world*: flecs.World

proc `destroy=`*(this: Core) =
    assert(this.world.reset() == 0)
