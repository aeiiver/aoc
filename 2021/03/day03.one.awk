#!/usr/bin/env -S awk -f

{
    nf = split($1, fields, "")
    for (i = 1; i <= nf; ++i) {
        map[i] += int(fields[i]) ? 1 : -1
    }
}

END {
    for (i = 1; i <= nf; ++i) {
        gamma += 2^(nf-i) * (map[i] > 0 ? 1 : 0)
    }
    epsilon = (2^nf - 1) - gamma

    print "Gamma: " gamma
    print "Epsilon: " epsilon
    print "Part one: " gamma * epsilon
}

# 3320834
