## Compiles the ZDFS library.

when defined(nimHasUsed):
    {.used.}

{.passc: "-I../zdfs/src".}
{.passc: "-I../zdfs/include".}

const zdfsRoot = "../zdfs"
const srcRoot = zdfsRoot & "/src"
const inclDir = zdfsRoot & "/include"

const bzip2Root = zdfsRoot & "/bzip2"
const lzmaRoot = zdfsRoot & "/lzma/C"
const minizRoot = zdfsRoot & "/miniz"
const utf8procRoot = zdfsRoot & "/utf8proc"

when defined(windows):
    error("MSVC compilation not yet supported")
else:
    const compileFlags =
        "-Dstricmp=strcasecmp -Dstrnicmp=strncasecmp -fPIC -I" & srcRoot &
        " -I" & inclDir &
        " -isystem " & bzip2Root &
        " -isystem " & lzmaRoot &
        " -isystem " & minizRoot &
        " -isystem " & utf8procRoot
    const cFlags = compileFlags & " --std=c17"
    const cxxFlags = compileFlags & " --std=c++20"

{.compile(bzip2Root & "/blocksort.c", cFlags).}
{.compile(bzip2Root & "/bzlib.c", cFlags).}
{.compile(bzip2Root & "/compress.c", cFlags).}
{.compile(bzip2Root & "/crctable.c", cFlags).}
{.compile(bzip2Root & "/decompress.c", cFlags).}
{.compile(bzip2Root & "/huffman.c", cFlags).}
{.compile(bzip2Root & "/randtable.c", cFlags).}

{.compile(lzmaRoot & "/7zAlloc.c", cFlags).}
{.compile(lzmaRoot & "/7zArcIn.c", cFlags).}
{.compile(lzmaRoot & "/7zBuf2.c", cFlags).}
{.compile(lzmaRoot & "/7zBuf.c", cFlags).}
{.compile(lzmaRoot & "/7zCrc.c", cFlags).}
{.compile(lzmaRoot & "/7zCrcOpt.c", cFlags).}
{.compile(lzmaRoot & "/7zDec.c", cFlags).}
{.compile(lzmaRoot & "/7zFile.c", cFlags).}
{.compile(lzmaRoot & "/7zStream.c", cFlags).}
{.compile(lzmaRoot & "/Alloc.c", cFlags).}
{.compile(lzmaRoot & "/Bcj2.c", cFlags).}
{.compile(lzmaRoot & "/Bcj2Enc.c", cFlags).}
{.compile(lzmaRoot & "/Bra86.c", cFlags).}
{.compile(lzmaRoot & "/Bra.c", cFlags).}
{.compile(lzmaRoot & "/CpuArch.c", cFlags).}
{.compile(lzmaRoot & "/Delta.c", cFlags).}
{.compile(lzmaRoot & "/DllSecur.c", cFlags).}
{.compile(lzmaRoot & "/LzFind.c", cFlags).}
{.compile(lzmaRoot & "/LzFindMt.c", cFlags).}
{.compile(lzmaRoot & "/LzFindOpt.c", cFlags).}
{.compile(lzmaRoot & "/Lzma2Dec.c", cFlags).}
{.compile(lzmaRoot & "/Lzma2DecMt.c", cFlags).}
{.compile(lzmaRoot & "/Lzma2Enc.c", cFlags).}
{.compile(lzmaRoot & "/LzmaDec.c", cFlags).}
{.compile(lzmaRoot & "/LzmaEnc.c", cFlags).}
{.compile(lzmaRoot & "/LzmaLib.c", cFlags).}
{.compile(lzmaRoot & "/MtCoder.c", cFlags).}
{.compile(lzmaRoot & "/MtDec.c", cFlags).}
{.compile(lzmaRoot & "/Ppmd7.c", cFlags).}
{.compile(lzmaRoot & "/Ppmd7Dec.c", cFlags).}
{.compile(lzmaRoot & "/Ppmd7Enc.c", cFlags).}
{.compile(lzmaRoot & "/Sha256.c", cFlags).}
{.compile(lzmaRoot & "/Sha256Opt.c", cFlags).}
{.compile(lzmaRoot & "/Sort.c", cFlags).}
{.compile(lzmaRoot & "/SwapBytes.c", cFlags).}
{.compile(lzmaRoot & "/Threads.c", cFlags).}
{.compile(lzmaRoot & "/Xz.c", cFlags).}
{.compile(lzmaRoot & "/XzCrc64.c", cFlags).}
{.compile(lzmaRoot & "/XzCrc64Opt.c", cFlags).}
{.compile(lzmaRoot & "/XzDec.c", cFlags).}
{.compile(lzmaRoot & "/XzEnc.c", cFlags).}
{.compile(lzmaRoot & "/XzIn.c", cFlags).}

{.compile(minizRoot & "/miniz.c", cFlags).}

{.compile(utf8procRoot & "/utf8proc.c", cFlags).}

{.compile(srcRoot & "/7z.cpp", cxxFlags).}
{.compile(srcRoot & "/ancientzip.cpp", cxxFlags).}
{.compile(srcRoot & "/critsec.cpp", cxxFlags).}
{.compile(srcRoot & "/decompress.cpp", cxxFlags).}
{.compile(srcRoot & "/directory.cpp", cxxFlags).}
{.compile(srcRoot & "/files.cpp", cxxFlags).}
{.compile(srcRoot & "/filesystem.cpp", cxxFlags).}
{.compile(srcRoot & "/findfile.cpp", cxxFlags).}
{.compile(srcRoot & "/grp.cpp", cxxFlags).}
{.compile(srcRoot & "/hog.cpp", cxxFlags).}
{.compile(srcRoot & "/lump.cpp", cxxFlags).}
{.compile(srcRoot & "/mvl.cpp", cxxFlags).}
{.compile(srcRoot & "/pak.cpp", cxxFlags).}
{.compile(srcRoot & "/resourcefile.cpp", cxxFlags).}
{.compile(srcRoot & "/rff.cpp", cxxFlags).}
{.compile(srcRoot & "/ssi.cpp", cxxFlags).}
{.compile(srcRoot & "/stringpool.cpp", cxxFlags).}
{.compile(srcRoot & "/unicode.cpp", cxxFlags).}
{.compile(srcRoot & "/wad.cpp", cxxFlags).}
{.compile(srcRoot & "/whres.cpp", cxxFlags).}
{.compile(srcRoot & "/zip.cpp", cxxFlags).}
