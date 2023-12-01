const std = @import("std");

pub fn main() !void {
    var sum: u32 = 0;

    var buf: [1024]u8 = undefined;
    while (try std.io.getStdIn().reader().readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var first: ?u8 = null;
        var last: ?u8 = null;

        for (0..line.len) |i| {
            if (try_digit(line, i)) |di| {
                first = di;
                break;
            }
        }
        for (0..line.len) |i| {
            if (try_digit(line, line.len - i - 1)) |di| {
                last = di;
                break;
            }
        }

        const num = first.? * 10 + last.?;
        sum += num;
        // std.log.debug("{s}: {d}", .{ line, num });
    }

    std.log.info("WE WON: {d}", .{sum});
    // ONE: 54940
    // TWO: 54208
}

fn try_digit(str: []const u8, idx: usize) ?u8 {
    // PART TWO added this long check
    if (std.mem.startsWith(u8, str[idx..], "zero")) {
        return 0;
    } else if (std.mem.startsWith(u8, str[idx..], "one")) {
        return 1;
    } else if (std.mem.startsWith(u8, str[idx..], "two")) {
        return 2;
    } else if (std.mem.startsWith(u8, str[idx..], "three")) {
        return 3;
    } else if (std.mem.startsWith(u8, str[idx..], "four")) {
        return 4;
    } else if (std.mem.startsWith(u8, str[idx..], "five")) {
        return 5;
    } else if (std.mem.startsWith(u8, str[idx..], "six")) {
        return 6;
    } else if (std.mem.startsWith(u8, str[idx..], "seven")) {
        return 7;
    } else if (std.mem.startsWith(u8, str[idx..], "eight")) {
        return 8;
    } else if (std.mem.startsWith(u8, str[idx..], "nine")) {
        return 9;
    }

    // PART ONE
    if (std.ascii.isDigit(str[idx])) {
        return str[idx] - '0';
    } else {
        return null;
    }
}
