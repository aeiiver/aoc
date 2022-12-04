local function as_range(str)
    local b1, b2 = (string.gmatch(str, "(.*)-(.*)"))()
    return tonumber(b1, 10), tonumber(b2, 10)
end

local inputname = "./day4.prod"
local partone_overlaps = 0
local partwo_overlaps = 0

for line in io.lines(inputname) do
    for left, right in (string.gmatch(line, "(.*),(.*)")) do
        local l1, l2 = as_range(left)
        local r1, r2 = as_range(right)

        -- partone
        -- yes, i'm literally checking if one range includes the other
        if (r1 <= l1 and l2 <= r2) or (l1 <= r1 and r2 <= l2) then
            partone_overlaps = partone_overlaps + 1
        end

        -- parttwo
        -- counting overlapping ranges <=> not counting non-overlapping ranges
        if not (r2 < l1) and not (l2 < r1) then
            partwo_overlaps = partwo_overlaps + 1
        end
    end
end

print(partone_overlaps) -- 542
print(partwo_overlaps) -- 900
