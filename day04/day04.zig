const std = @import("std");

const Card = struct { id: usize = 0, mine: std.ArrayList(usize), winning: std.ArrayList(usize) };
const Cards = std.ArrayList(Card);

pub fn main() !void {
    const cards = try parseCards(@embedFile("input.txt"));
    // for (cards.items) |card| {
    //     std.debug.print("{d}: {any} : {any}\n", .{ card.id, card.mine.items, card.winning.items });
    // }
    const p1 = part1(cards);
    std.debug.print("Part 1: {any}\n", .{p1});
    const p2 = part2(cards);
    std.debug.print("Part 2: {any}\n", .{p2});
}

pub fn parseCards(input: []const u8) !Cards {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var cards = Cards.init(allocator);
    var lines = std.mem.tokenize(u8, input, "\r\n");
    while (lines.next()) |line| {
        var lineparts = std.mem.tokenize(u8, line, ":|");
        var cardidstr = std.mem.trim(u8, lineparts.next().?[5..], " ");
        const cardid = try std.fmt.parseInt(usize, cardidstr, 10);
        var mine = std.ArrayList(usize).init(allocator);
        var winning = std.ArrayList(usize).init(allocator);
        var nums = std.mem.tokenize(u8, lineparts.next().?, " ");
        while (nums.next()) |n| {
            try mine.append(try std.fmt.parseInt(usize, n, 10));
        }
        nums = std.mem.tokenize(u8, lineparts.next().?, " ");
        while (nums.next()) |n| {
            try winning.append(try std.fmt.parseInt(usize, n, 10));
        }
        try cards.append(Card{ .id = cardid, .mine = mine, .winning = winning });
    }
    return cards;
}

pub fn part1(cards: Cards) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var sumval: usize = 0;
    for (cards.items) |c| {
        var matchcount: usize = 0;
        var set = std.AutoHashMap(usize, void).init(allocator);
        defer set.deinit();
        for (c.winning.items) |w| {
            try set.put(w, {});
        }
        for (c.mine.items) |m| {
            if (set.contains(m)) {
                if (matchcount == 0) {
                    matchcount += 1;
                } else {
                    matchcount *= 2;
                }
            }
        }
        sumval += matchcount;
    }
    return sumval;
}

pub fn part2(cards: Cards) !usize {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var zeros = std.ArrayList(usize).init(allocator);
    for (0..cards.items.len) |_| {
        try zeros.append(0);
    }
    var cardcounts = try zeros.clone();
    for (cards.items) |c| {
        var idx = c.id - 1;
        cardcounts.items[idx] += 1;
        var matchcount: usize = 0;
        var set = std.AutoHashMap(usize, void).init(allocator);
        defer set.deinit();
        for (c.winning.items) |w| {
            try set.put(w, {});
        }
        for (c.mine.items) |m| {
            if (set.contains(m)) {
                matchcount += 1;
                cardcounts.items[idx + matchcount] += cardcounts.items[idx];
            }
        }
    }
    var sumval: usize = 0;
    for (cardcounts.items) |c| {
        sumval += c;
    }
    return sumval;
}

test "test-part1" {
    const cards = try parseCards(@embedFile("example.txt"));
    const actual = try part1(cards);
    const expected: usize = 13;
    try std.testing.expectEqual(expected, actual);
}

test "test-part2" {
    const cards = try parseCards(@embedFile("example.txt"));
    const actual = try part2(cards);
    const expected: usize = 30;
    try std.testing.expectEqual(expected, actual);
}
