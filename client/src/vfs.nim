## VileTech's virtual file system, backed by the ZDFS library.

type VirtualFs* {.header: "<zdfs/filesystem.hpp>",
    importcpp: "zdfs::FileSystem".} = object

proc initVfs*(): VirtualFs {.importcpp: "zdfs::Filesystem(@)", constructor.}
