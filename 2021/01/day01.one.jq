#!/usr/bin/env -S jq -nf

[foreach inputs as $cur (
    {};
    {prev: $cur} + if .prev == null then {}
                   elif $cur > .prev then {asc: (.asc + 1)}
                   else {asc: .asc} end
)] | last.asc
# 1387
