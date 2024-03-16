//! Imported headers from the dsda-doom C code.

pub const c = @cImport({
    @cInclude("SDL/i_main.h");
    @cInclude("d_main.h");
    @cInclude("lprintf.h");
});
