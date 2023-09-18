#!/usr/bin/env -S jq -Rnf

[
    inputs
    | split(" -> ")
    | map(split(",")
    | {x: (.[0] | tonumber), y: (.[1] | tonumber)})
    | reduce . as $pt (
        []; . + (
            $pt
            | sort_by(.x)
            | sort_by(.y)
            | (.[0].x - .[1].x | abs) as $dx
            | (.[0].y - .[1].y | abs) as $dy
            | (if (.[1].x - .[0].x) > 0 then 1 else -1 end) as $xdir
            | (if (.[1].y - .[0].y) > 0 then 1 else -1 end) as $ydir
            | .[0].x as $x
            | .[0].y as $y
            | [range($x; $x + $dx*$xdir + $xdir; $xdir)] as $xs
            | [range($y; $y + $dy*$ydir + $ydir; $ydir)] as $ys
            | [
                ($xs | if length == 1 then $ys | map($xs[0]) else $xs end),
                ($ys | if length == 1 then $xs | map($ys[0]) else $ys end)
            ]
            | transpose
            | map({x: .[0], y: .[1]})
        )
    )
    | .[]
    | "\(.x), \(.y)"
]
| group_by(.)
| map(select(length > 1) | length)
| length

# 18627
