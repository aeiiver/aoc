use std::{collections::HashMap, str::Lines};

fn main() {
    let puzzle = include_str!("./day04.input.prod.txt").lines();
    println!("ONE: {:?}", one(puzzle.clone())); // 21959
    println!("TWO: {:?}", two(puzzle)); // 5132675
}

fn one(lines: Lines) -> u32 {
    lines.fold(0, |sum, line| {
        let (_, rest) = line.split_once(": ").unwrap();
        let (wins, nums) = rest.split_once(" | ").unwrap();
        let wins = wins.split_whitespace().collect::<Vec<&str>>();
        let nums = nums.split_whitespace();

        sum + nums.fold(0, |pts, num| {
            if wins.contains(&num) {
                if pts > 0 {
                    pts * 2
                } else {
                    1
                }
            } else {
                pts
            }
        })
    })
}

fn two(lines: Lines) -> u32 {
    let mut hash: HashMap<u32, u32> = HashMap::new();

    lines.fold(0, |sum, line| {
        let (id, rest) = line.split_once(": ").unwrap();
        let (wins, nums) = rest.split_once(" | ").unwrap();
        let id = id.strip_prefix("Card").unwrap().trim_start();
        let id = id.parse::<u32>().unwrap();
        let wins = wins.split_whitespace().collect::<Vec<&str>>();
        let nums = nums.split_whitespace();

        let nb_matches = nums.fold(0, |nb, num| match wins.iter().find(|win| win == &&num) {
            Some(_) => nb + 1,
            None => nb,
        });
        let nb_cards = *hash.get(&id).unwrap_or(&1);
        (1..=nb_matches).for_each(|i| {
            *hash.entry(id + i).or_insert(1) += nb_cards;
        });
        sum + nb_cards
    })
}
