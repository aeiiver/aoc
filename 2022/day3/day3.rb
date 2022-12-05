# frozen_string_literal: true

sacks = (File.read './day3.prod').split("\n")

# 7980
p(sacks.map.sum do |sack|
  mid = sack.size / 2
  the_item = sack[...mid].chars.intersection(sack[mid..].chars)[0]
  the_item.ord + 1 - (the_item.ord < 'a'.ord ? 'A'.ord - 26 : 'a'.ord)
end)

# 2881
p(sacks.each_slice(3).map.sum do |group|
  the_item = group[0].chars.intersection(group[1].chars).intersection(group[2].chars) [0]
  the_item.ord + 1 - (the_item.ord < 'a'.ord ? 'A'.ord - 26 : 'a'.ord)
end)
