#!/usr/bin/env -S awk -vFS='' -f

# This solution is dirty. I gave up on making it look clean a long time ago

{
    for (c = 1; c <= NF; ++c) {
        map[NR, c] = $c
    }
}

END {
    for (c = 1; c <= NF; ++c) {
        o2_ones = 0
        o2_zeros = 0
        co2_ones = 0
        co2_zeros = 0

        for (r = 1; r <= NR; ++r) {
            if (o2_bads[r]) {
                printf "."
                continue
            }
            printf map[r, c]
            if (map[r, c]) o2_ones += 1
            else o2_zeros += 1
        }
        printf " | "
        for (r = 1; r <= NR; ++r) {
            if (co2_bads[r]) {
                printf "."
                continue
            }
            printf map[r, c]
            if (map[r, c]) co2_ones += 1
            else co2_zeros += 1
        }

        o2_keep = o2_ones >= o2_zeros
        co2_keep = co2_ones < co2_zeros
        printf "  =>  "
        printf "o2: "o2_ones" ones <=> "o2_zeros" zeros : KEEP "o2_keep" | "
        print "co2: "co2_ones" ones <=> "co2_zeros" zeros : KEEP "co2_keep

        for (r = 1; r <= NR; ++r) {
            if (o2_bads_count == NR - 1) break;
            if (!o2_bads[r] && map[r, c] != o2_keep) {
                o2_bads[r] = 1
                o2_bads_count += 1
            }
            if (o2_bads[r]) printf "#"
            else printf "."
        }
        printf " | "
        for (r = 1; r <= NR; ++r) {
            if (co2_bads_count == NR - 1) break;
            if (!co2_bads[r] && map[r, c] != co2_keep) {
                co2_bads[r] = 1
                co2_bads_count += 1
            }
            if (co2_bads[r]) printf "#"
            else printf "."
        }
        print ""
        print ""
    }

    for (r = 1; r <= NR; ++r) {
        if (!o2_bads[r]) {
            printf "^"
            o2_row = r
        } else
            printf " "
    }
    printf "   "
    for (r = 1; r <= NR; ++r) {
        if (!co2_bads[r]) {
            printf "^"
            co2_row = r
        } else
            printf " "
    }
    print ""

    o2 = 0
    printf "o2 read: "
    for (c = 1; c <= NF; ++c) {
        printf map[o2_row, c]
        o2 += 2**(NF-c) * map[o2_row, c]
    }
    print ""

    co2 = 0
    printf "co2 read: "
    for (c = 1; c <= NF; ++c) {
        printf map[co2_row, c]
        co2 += 2**(NF-c) * map[co2_row, c]
    }
    print ""
    print ""

    print "o2 = "o2
    print "co2 = "co2
    print "o2 * co2 = "o2 * co2
}

# 4481199
