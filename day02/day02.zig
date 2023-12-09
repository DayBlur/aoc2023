const std = @import("std");

const Game = struct { id: usize = 0, rolls: std.ArrayList(@Vector(3, usize)) };
const Games = std.ArrayList(Game);

pub fn main() !void {
    const games = try parseGames(@embedFile("input.txt"));
    const p1 = part1(games);
    std.debug.print("Part 1: {any}\n", .{p1});
    const p2 = part2(games);
    std.debug.print("Part 2: {d}\n", .{p2});
}

pub fn parseGames(input: []const u8) !Games {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var games = Games.init(allocator);
    var lines = std.mem.tokenize(u8, input, "\r\n");
    while (lines.next()) |line| {
        var lineparts = std.mem.tokenize(u8, line, ":;");
        const gameid = try std.fmt.parseInt(usize, lineparts.next().?[5..], 10);
        const Rolls = std.ArrayList(@Vector(3, usize));
        var rolls = Rolls.init(allocator);
        while (lineparts.next()) |roll| {
            var colors = std.mem.tokenize(u8, roll, ", ");
            var rgb = @Vector(3, usize){ 0, 0, 0 };
            while (colors.next()) |countstr| {
                var color = colors.next().?;
                var count = try std.fmt.parseInt(usize, countstr, 10);
                if (std.mem.eql(u8, color, "red")) {
                    rgb[0] = count;
                } else if (std.mem.eql(u8, color, "green")) {
                    rgb[1] = count;
                } else if (std.mem.eql(u8, color, "blue")) {
                    rgb[2] = count;
                }
            }
            try rolls.append(rgb);
        }
        try games.append(Game{ .id = gameid, .rolls = rolls });
    }
    return games;
}

pub fn part1(games: Games) usize {
    var sumval: usize = 0;
    const maxcubes = @Vector(3, usize){ 12, 13, 14 };
    for (games.items) |game| {
        for (game.rolls.items) |rgb| {
            if (@reduce(.Or, rgb > maxcubes)) break;
        } else {
            sumval += game.id;
        }
    }
    return sumval;
}

pub fn part2(games: Games) usize {
    var sumval: usize = 0;
    for (games.items) |game| {
        var maxrgb = @Vector(3, usize){ 0, 0, 0 };
        for (game.rolls.items) |rgb| {
            maxrgb = @max(maxrgb, rgb);
        }
        sumval += @reduce(.Mul, maxrgb);
    }
    return sumval;
}

test "test-part1" {
    const games = try parseGames(@embedFile("example.txt"));
    const actual = part1(games);
    const expected: usize = 8;
    try std.testing.expectEqual(expected, actual);
}

test "test-part2" {
    const games = try parseGames(@embedFile("example.txt"));
    const actual = part2(games);
    const expected: usize = 2286;
    try std.testing.expectEqual(expected, actual);
}
