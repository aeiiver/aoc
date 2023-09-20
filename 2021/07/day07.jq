#!/usr/bin/env -S jq -nRf

inputs
| split(",")
| map(tonumber)
| . as $crabs
| max as $max

| [foreach [range (0; $max + 1)][] as $i (
    0; reduce $crabs[] as $c (
        0;
        . + ($c - $i | abs)
    )
)]
| min
| . as $one
# 336131

| [foreach [range (0; $max + 1)][] as $i (
    0; reduce $crabs[] as $c (
        0;
        . + ($c - $i | abs | . * (. + 1) / 2)
    )
)]
| min
| . as $two
# 92676646

| {
    "one": $one,
    "two": $two,
}
