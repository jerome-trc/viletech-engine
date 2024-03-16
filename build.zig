const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "ratdoom",
        .root_source_file = .{ .path = "client/src/root.zig" },
        .target = target,
        .optimize = optimize,
    });

    lib.bundle_compiler_rt = true;
    lib.linkLibC();
    lib.linkLibCpp();

    lib.addIncludePath(.{ .path = this_dir ++ "/prboom2/src" });

    const mach_dep = b.dependency("mach", .{
        .target = target,
        .optimize = optimize,
    });

    lib.root_module.addImport("mach", mach_dep.module("mach"));

    b.installArtifact(lib);
}

const this_dir = struct {
    fn f() []const u8 {
        return comptime std.fs.path.dirname(@src().file) orelse ".";
    }
}.f();
