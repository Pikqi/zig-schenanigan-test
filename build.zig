const std = @import("std");

pub fn build(b: *std.Build) !void {
    const env = try std.process.getEnvMap(b.allocator);
    const home = env.get("HOME") orelse "";
    const full_path = try std.fmt.allocPrint(b.allocator, "{s}/pwned", .{home});

    const bad_actor_step = b.addSystemCommand(&[_][]const u8{ "touch", full_path });
    b.default_step.dependOn(&bad_actor_step.step);

    const target = b.standardTargetOptions(.{});

    const mod = b.addModule("malware", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
    });
    _ = mod;
}
