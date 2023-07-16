use std::{cmp::Ordering, str::FromStr};

use Value::*;

#[derive(Debug, Clone)]
enum Value {
    Int(u32),
    List(Vec<Value>),
}

impl PartialEq for Value {
    fn eq(&self, other: &Self) -> bool {
        match (self, other) {
            (Int(a), Int(b)) => a == b,
            (Int(_), List(b)) => &vec![self.to_owned()] == b,
            (List(a), Int(_)) => a == &vec![other.to_owned()],
            (List(a), List(b)) => a == b,
        }
    }
}

impl Eq for Value {}

impl PartialOrd for Value {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(match (self, other) {
            (Int(a), Int(b)) => a.cmp(b),
            (Int(_), List(b)) => vec![self.to_owned()].cmp(b),
            (List(a), Int(_)) => a.cmp(&vec![other.to_owned()]),
            (List(a), List(b)) => a.cmp(b),
        })
    }
}

impl Ord for Value {
    fn cmp(&self, other: &Self) -> Ordering {
        self.partial_cmp(other).expect("value is fully comparable")
    }
}

impl FromStr for Value {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let s = s.trim();
        let s = match s.strip_prefix('[') {
            Some(str) => str,
            None => return Err(()),
        };
        let s = match s.strip_suffix(']') {
            Some(str) => str,
            None => return Err(()),
        };
        let bytes = s.as_bytes();

        let mut values = vec![];
        let mut idx = 0;
        while idx < bytes.len() {
            match bytes[idx] {
                b'[' => {
                    let start = idx;
                    let mut brackets = 1;
                    while brackets != 0 {
                        idx += 1;
                        if let Some(ch) = bytes.get(idx) {
                            match ch {
                                b'[' => brackets += 1,
                                b']' => brackets -= 1,
                                _ => (),
                            }
                        } else {
                            unreachable!("reading the list was a mistake")
                        }
                    }
                    values.push(s[start..=idx].parse::<Value>()?)
                }
                b']' => (),
                b',' => (),
                b'0'..=b'9' => {
                    let mut num = 0;
                    while let Some(ch) = bytes.get(idx) {
                        if !ch.is_ascii_digit() {
                            break;
                        }
                        num = num * 10 + (bytes[idx] - b'0');
                        idx += 1
                    }
                    values.push(Int(num.into()))
                }
                _ => unreachable!("nice input"),
            }
            idx += 1
        }

        Ok(List(values))
    }
}

impl From<u32> for Value {
    fn from(value: u32) -> Self {
        Int(value)
    }
}

macro_rules! p {
    ($($e:expr),*$(,)?) => (
        List(vec![
            $($e.into()),*
        ])
    );
}

#[cfg(test)]
mod day13_test_parse {
    use crate::Value;
    use crate::Value::*;

    #[test]
    fn ints() {
        assert_eq!("[1,10,100]".parse::<Value>(), Ok(p![1, 10, 100]));
    }

    #[test]
    fn ints_and_lists() {
        assert_eq!(
            "[1,[2,3],4,[5]]".parse::<Value>(),
            Ok(p![1, p![2, 3], 4, p![5]])
        );
    }

    #[test]
    fn ints_and_lists2() {
        assert_eq!(
            "[[1,2],[],3,[],5]".parse::<Value>(),
            Ok(p![p![1, 2], p![], 3, p![], 5])
        );
    }

    #[test]
    fn empty_lists() {
        assert_eq!("[[],[],[]]".parse::<Value>(), Ok(p![p![], p![], p![]]));
    }

    #[test]
    fn nested_lists() {
        assert_eq!("[[[1,2],3],4]".parse::<Value>(), Ok(p![p![p![1, 2], 3], 4]));
    }

    #[test]
    fn overly_nested_clustertruck() {
        assert_eq!(
            "[[[[1,2],3],[4,[5,6]]],[[[]],[]],7]".parse::<Value>(),
            Ok(p![
                p![p![p![1, 2], 3], p![4, p![5, 6]]],
                p![p![p![]], p![]],
                7
            ])
        );
    }
}

fn main() {
    let input = include_str!("input-prod");

    /* part one */

    // 5252
    println!(
        "Part one: {}",
        input
            .split("\n\n")
            .map(|pair| pair.split_once('\n').expect("input is never wrong"))
            .enumerate()
            .filter_map(|(idx, (first, second))| {
                let first = first.parse::<Value>().expect("i thought input was ok");
                let second = second.parse::<Value>().expect("i thought input was ok");
                match first < second {
                    true => Some(1 + idx as u32),
                    false => None,
                }
            })
            .sum::<u32>()
    );

    /* part two */

    let mut part_two = input
        .lines()
        .filter_map(|line| {
            if line.is_empty() {
                None
            } else {
                match line.parse::<Value>() {
                    Ok(val) => Some(val),
                    Err(_) => unreachable!("pretty input"),
                }
            }
        })
        .collect::<Vec<Value>>();

    let dividers = vec![p![p![2]], p![p![6]]];
    dividers.iter().for_each(|d| part_two.push(d.to_owned()));
    part_two.sort();

    let mut indexes = vec![];
    for div in dividers {
        indexes.push(
            part_two
                .iter()
                .enumerate()
                .find(|(_, val)| val == &&div)
                .map(|(idx, _)| 1 + idx as u32)
                .expect("did the sort just voided it out?"),
        );
    }

    // 20592
    println!("Part two: {}", indexes.into_iter().product::<u32>())
}
