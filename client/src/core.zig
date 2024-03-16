//! State that gets weaved throughout the entire engine.

const std = @import("std");

pub const Core = extern struct {
    fn new() @This() {
        return Core{};
    }

    fn deinit(self: @This()) void {
        _ = self;
    }
};
