#!/usr/bin/env -S jq -Rnf

[
    inputs
    | split(" -> ")
    | map(split(",")
    | {x: (.[0] | tonumber), y: (.[1] | tonumber)})
    | select(.[0].x == .[1].x or .[0].y == .[1].y)
    | reduce . as $pt (
        []; . + (
            $pt
            | (.[0].x - .[1].x | abs) as $dx
            | (.[0].y - .[1].y | abs) as $dy
            | if $dx != 0 then (
                .
                | .[0].y as $y
                | sort_by(.x)
                | [range(.[0].x; .[0].x + $dx + 1) | {x: ., y: $y}]
            ) else (
                .
                | .[0].x as $x
                | sort_by(.y)
                | [range(.[0].y; .[0].y + $dy + 1) | {x: $x, y: .}]
            ) end
        )
    )
    | .[]
    | "\(.x), \(.y)"
]
| group_by(.)
| map(select(length > 1) | length)
| length

# 7644
