use anyhow::Result;

/*
 * Note to me:
 *      I probably should start from scratch
 *      because this isn't fresh in my head
 *  
 *      Well no shit 
 */

fn main() -> Result<()> {
    /*
     * Part one:
     *
     * Find the indexes (1-based) of the ordered pair of packets.
     * Return the sum of all these indexes.
     */
    println!(
        "{:?}",
        include_str!("./day13.test")
            .split("\n\n")
            .enumerate()
            .map(|(idx, pair)| {
                let (left, right) = pair.split_once("\n").expect("A pair of packets");
                let mut left_idx: usize = 0;
                let mut right_idx: usize = 0;
                let mut lefts: Vec<Vec<u8>> = vec![];
                let mut rights: Vec<Vec<u8>> = vec![];

                println!();
                loop {
                    if left_idx >= left.len() || compare(&lefts, &rights) {
                        return idx;
                    }
                    if right_idx >= right.len() || compare(&lefts, &rights) {
                        return 0;
                    }
                    nested_match(&left, &mut left_idx, &mut lefts);
                    nested_match(&right, &mut right_idx, &mut rights);
                    println!();
                    println!("{:?}", lefts);
                    println!("{:?}", rights);
                }
            })
            .filter(|idx| idx > &0)
            .collect::<Vec<usize>>()
    );

    Ok(())
}

fn compare(lefts: &Vec<Vec<u8>>, rights: &Vec<Vec<u8>>) -> bool {
    if lefts.len() > 0
        && lefts.last().unwrap().len() > 0
        && rights.len() > 0
        && rights.last().unwrap().len() > 0
        && lefts.last().unwrap().last().unwrap() < rights.last().unwrap().last().unwrap()
    {
        return true;
    }
    false
}

fn nested_match(side: &str, idx: &mut usize, stack: &mut Vec<Vec<u8>>) {
    let char = side.chars().nth(*idx).expect("A character");
    match char {
        '[' => {
            stack.push(vec![]);
            *idx += 1;
        }
        ']' => {
            stack.pop();
            *idx += 1;
        }
        ',' => *idx += 1,
        _ => stack
            .last_mut()
            .expect("The latest pushed list")
            .push(parse_number(&side, idx)),
    }
}

fn parse_number(s: &str, i: &mut usize) -> u8 {
    let mut number: String = String::new();

    let mut digit = s.chars().nth(*i).expect("A digit");
    while '0' <= digit && digit <= '9' {
        number.push(digit);
        *i += 1;
        digit = s
            .chars()
            .nth(i.to_owned())
            .expect("A char that may be a digit");
    }

    number.parse::<u8>().expect("A number")
}
