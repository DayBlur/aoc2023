const std = @import("std");

const MapRow = std.ArrayList(u8);
const Map = std.ArrayList(MapRow);
const Bounds = std.ArrayList(@Vector(4, usize)); // top, left, bottom, right

pub fn main() !void {
    const map = try parseMap(@embedFile("input.txt"));
    // for (map.items) |row| {
    //     std.debug.print("{s}\n", .{row.items});
    // }
    const p1 = part1(map);
    std.debug.print("Part 1: {any}\n", .{p1});
    const p2 = part2(map);
    std.debug.print("Part 2: {any}\n", .{p2});
}

pub fn parseMap(input: []const u8) !Map {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var map = Map.init(allocator);
    var lines = std.mem.tokenize(u8, input, "\r\n");
    var rowlen: usize = 0;
    var emptyrow: MapRow = undefined;
    while (lines.next()) |line| {
        if (rowlen == 0) {
            rowlen = line.len + 2;
            emptyrow = try MapRow.initCapacity(allocator, rowlen);
            for (0..rowlen) |_| {
                try emptyrow.append('.');
            }
            try map.append(emptyrow);
        }
        var row = try MapRow.initCapacity(allocator, line.len + 2);
        try row.append('.');
        for (line) |c| {
            try row.append(c);
        }
        try row.append('.');
        try map.append(row);
    }
    try map.append(emptyrow);
    return map;
}

pub fn findIntBounds(map: Map) !Bounds {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var bounds = Bounds.init(allocator);

    for (map.items, 0..) |row, j| {
        var start: usize = 0;
        var end: usize = 0;
        for (row.items, 0..) |c, i| {
            if (std.ascii.isDigit(c)) {
                if (start == 0) {
                    start = i;
                }
                end = i + 1;
            } else {
                if (start != 0) {
                    try bounds.append(@Vector(4, usize){ j, start, j, end });
                    start = 0;
                    end = 0;
                }
            }
        }
    }
    return bounds;
}

pub fn findSymsInBound(map: Map, bound: @Vector(4, usize)) !std.ArrayList(@Vector(2, usize)) {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var syms = std.ArrayList(@Vector(2, usize)).init(allocator);

    for (bound[0]..bound[2] + 1) |j| {
        var row = map.items[j].items;
        for (bound[1]..bound[3]) |i| {
            if (row[i] != '.' and !std.ascii.isDigit(row[i])) {
                try syms.append(@Vector(2, usize){ j, i });
            }
        }
    }
    return syms;
}

pub fn part1(map: Map) !usize {
    var sumval: usize = 0;
    var bounds = try findIntBounds(map);
    const expand = @Vector(4, i32){ -1, -1, 1, 1 };
    for (bounds.items) |bound| {
        const partno = try std.fmt.parseInt(usize, map.items[bound[0]].items[bound[1]..bound[3]], 10);
        // mixing usize and i32 is not fun
        var newbound = @as(@Vector(4, i32), @intCast(bound)) + expand;
        var newbound2 = @as(@Vector(4, usize), @intCast(newbound));
        var syms = try findSymsInBound(map, newbound2);
        if (syms.items.len > 0) {
            sumval += partno;
        }
    }
    return sumval;
}

pub fn part2(map: Map) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const numrows = map.items.len;
    const numcols = map.items[0].items.len;
    var sumval: usize = 0;
    var ratios = try std.ArrayList(usize).initCapacity(allocator, numrows * numcols);
    var gearcount = try std.ArrayList(usize).initCapacity(allocator, numrows * numcols);
    for (0..numrows * numcols) |_| {
        try ratios.append(1);
        try gearcount.append(0);
    }
    var bounds = try findIntBounds(map);
    for (bounds.items) |bound| {
        const partno = try std.fmt.parseInt(usize, map.items[bound[0]].items[bound[1]..bound[3]], 10);
        var newbound = @Vector(4, usize){ bound[0] - 1, bound[1] - 1, bound[2] + 1, bound[3] + 1 };
        var syms = try findSymsInBound(map, newbound);
        for (syms.items) |s| {
            var idx = s[0] * numcols + s[1];
            gearcount.items[idx] += 1;
            ratios.items[idx] *= partno;
        }
    }
    for (ratios.items, gearcount.items) |r, g| {
        if (g == 2) {
            sumval += r;
        }
    }
    return sumval;
}

test "test-part1" {
    const map = try parseMap(@embedFile("example.txt"));
    const actual = try part1(map);
    const expected: usize = 4361;
    try std.testing.expectEqual(expected, actual);
}

test "test-part2" {
    const map = try parseMap(@embedFile("example.txt"));
    const actual = try part2(map);
    const expected: usize = 467835;
    try std.testing.expectEqual(expected, actual);
}
