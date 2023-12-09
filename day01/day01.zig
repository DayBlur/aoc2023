const std = @import("std");

pub fn main() !void {
    const p1 = part1(@embedFile("input.txt"));
    std.debug.print("Part 1: {d}\n", .{p1});
    const p2 = part2(@embedFile("input.txt"));
    std.debug.print("Part 2: {d}\n", .{p2});
}

pub fn part1(input: []const u8) usize {
    //var it = std.mem.split(u8, read_buf, "\r\n"); // only works with the single delimiter
    var it = std.mem.tokenize(u8, input, "\r\n");

    var sumval: usize = 0;
    while (it.next()) |line| {
        //std.debug.print("{s}\n", .{line});
        var minidx: usize = 2e9;
        var minval: usize = 0;
        var maxval: usize = 0;

        for (line, 0..) |c, i| {
            //std.debug.print("{d}:{c},", .{ i, c });
            if (c >= '0' and c <= '9') {
                if (i <= minidx) {
                    minidx = i;
                    minval = c - '0';
                }
                maxval = c - '0';
            }
        }
        const val = minval * 10 + maxval;
        sumval += val;
        //std.debug.print("{d}\n", .{val});
    }
    return sumval;
}

pub fn part2(input: []const u8) usize {
    var it = std.mem.tokenize(u8, input, "\r\n");

    var sumval: usize = 0;
    while (it.next()) |line| {
        var minidx: usize = 2e9;
        var minval: usize = 0;
        var maxidx: usize = 0;
        var maxval: usize = 0;
        const numstrs = [_][:0]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

        for (numstrs, 1..) |s, i| {
            var found = std.mem.indexOf(u8, line, s);
            if (found != null) {
                const idx = found.?;
                if (idx < minidx) {
                    minidx = idx;
                    minval = i;
                }
            }
            found = std.mem.lastIndexOf(u8, line, s);
            if (found != null) {
                const idx = found.?;
                if (idx >= maxidx) {
                    maxidx = idx;
                    maxval = i;
                }
            }

            var cc = '0' + @as(u8, @intCast(i));
            found = std.mem.indexOfScalar(u8, line, cc);
            if (found != null) {
                const idx = found.?;
                if (idx < minidx) {
                    minidx = idx;
                    minval = i;
                }
            }
            found = std.mem.lastIndexOfScalar(u8, line, cc);
            if (found != null) {
                const idx = found.?;
                if (idx >= maxidx) {
                    maxidx = idx;
                    maxval = i;
                }
            }
        }
        const val = minval * 10 + maxval;
        sumval += val;
    }
    return sumval;
}

test "test-part1" {
    const actual = part1(@embedFile("example.txt"));
    const expected: usize = 142;
    try std.testing.expectEqual(expected, actual);
}

test "test-part2" {
    const actual = part2(@embedFile("example2.txt"));
    const expected: usize = 281;
    try std.testing.expectEqual(expected, actual);
}
