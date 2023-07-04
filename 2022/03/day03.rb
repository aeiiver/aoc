# frozen_string_literal: true

rucksacks = (File.read './day03-prod').split("\n")

# 7980
p(rucksacks.map.sum do |sack|
  mid = sack.size / 2
  item = sack[...mid].chars.intersection(sack[mid..].chars)[0].ord
  item + 1 - (item < 'a'.ord ? 'A'.ord - 26 : 'a'.ord)
end)

# 2881
p(rucksacks.each_slice(3).map.sum do |group|
  item = group[0].chars
    .intersection(group[1].chars)
    .intersection(group[2].chars)
    .first.ord
  item + 1 - (item < 'a'.ord ? 'A'.ord - 26 : 'a'.ord)
end)
