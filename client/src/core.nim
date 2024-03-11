## Permeates the code base with state that is practically "global".

from std/paths import Path

from entt import nil

type
    Core* {.exportc.} = ref object
        ## Permeates the code base with state that is practically "global".
        loadOrder*: seq[Path]
        registry*: entt.Registry
