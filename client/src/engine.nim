## Fundamental facts about the engine, such as what game and IWAD are being used.

const baseScreenWidth*: int = 320

type
    Flavor* {.pure.} = enum
        shareware
        registered
        commercial
        retail
        indeterminate
