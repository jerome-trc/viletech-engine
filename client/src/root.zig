const std = @import("std");

const c = @import("c.zig").c;
const gamemode = @import("mach").gamemode;

pub export fn enableGamemode() callconv(.C) void {
    gamemode.start();

    if (gamemode.isActive()) {
        _ = c.lprintf(c.LO_INFO, "GameMode is active.\n");
    }
}
