#!/usr/bin/env -S jq -nf

[foreach inputs as $cur (
    {};
    {prev: $cur} + if .prev == null then {}
                   elif .prev2 == null then {prev2: .prev}
                   elif .prev3 == null then {prev2: .prev, prev3: .prev2}
                   elif $cur + .prev + .prev2 > .prev + .prev2 + .prev3 then {prev2: .prev, prev3: .prev2, asc: (.asc + 1)}
                   else {prev2: .prev, prev3: .prev2, asc: .asc} end
)] | last.asc
# 1362
