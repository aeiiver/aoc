local input = "./input-prod"
local partone_overlaps = 0
local parttwo_overlaps = 0

for line in io.lines(input) do
    for lstart, lend, rstart, rend in (string.gmatch(line, "(.*)-(.*),(.*)-(.*)")) do
        local lstart = tonumber(lstart, 10)
        local lend = tonumber(lend, 10)
        local rstart = tonumber(rstart, 10)
        local rend = tonumber(rend, 10)

        -- partone
        -- yes, i'm literally checking if one range includes the other
        if (rstart <= lstart and lend <= rend) or (lstart <= rstart and rend <= lend) then
            partone_overlaps = partone_overlaps + 1
        end

        -- parttwo
        -- counting overlapping ranges <=> not counting non-overlapping ranges
        if not (rend < lstart) and not (lend < rstart) then
            parttwo_overlaps = parttwo_overlaps + 1
        end
    end
end

print(partone_overlaps) -- 542
print(parttwo_overlaps) -- 900
