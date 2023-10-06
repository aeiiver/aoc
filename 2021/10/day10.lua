local closing = {
    ['('] = ')',
    ['['] = ']',
    ['{'] = '}',
    ['<'] = '>',
}

local puzzle = io.lines('input.real.txt')
local corrupted = {}
local imcomplete = {}

for line in puzzle do
    local stack = {}

    for i = 1, #line do
        local chr = line:sub(i, i)
        io.write(chr)

        if closing[chr] ~= nil then
            -- chr is opening
            table.insert(stack, 1, closing[chr])
        else
            -- chr is closing
            if chr ~= stack[1] then
                table.insert(corrupted, chr)
                io.write(' CORRUPTED')
                break
            end
            table.remove(stack, 1)
        end

        if i == #line and #stack > 0 then
            table.insert(imcomplete, { left = stack })
            io.write(' IMCOMPLETE')
            break
        end
    end

    io.write('\n')
end

local syntax_err_scores = {
    [')'] = 3,
    [']'] = 57,
    ['}'] = 1197,
    ['>'] = 25137,
}
local errsum = 0;
for _, chr in ipairs(corrupted) do
    errsum = errsum + syntax_err_scores[chr]
end
print(errsum)
-- 318099

local chr_scores = {
    [')'] = 1,
    [']'] = 2,
    ['}'] = 3,
    ['>'] = 4,
}
for _, line in ipairs(imcomplete) do
    line.score = 0
    for _, clos in ipairs(line.left) do
        line.score = line.score * 5 + chr_scores[clos]
    end
end
table.sort(imcomplete, function(a, b) return a.score > b.score end)
print(imcomplete[math.ceil(#imcomplete / 2)].score)
-- 2389738699
