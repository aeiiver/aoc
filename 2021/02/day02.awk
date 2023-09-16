#!/usr/bin/env -S awk -f

BEGIN {
    hpos  = 0
    depth = 0

    aim    = 0
    depth2 = 0
}

/^forward / {
    hpos += $2

    depth2 += aim * $2
}

/^down / {
    depth += $2

    aim += $2
}

/^up / {
    depth -= $2

    aim -= $2
}

END {
    print "[Part one]: (x, y): ("hpos", " depth")"
    print "[Part one]: x * y = "hpos * depth
    # 1648020

    print "[Part two]: (x, y): ("hpos", " depth2")"
    print "[Part two]: x * y = "hpos * depth2
    # 1759818555
}
