fn main() {
    let input = include_str!("./input-prod").lines();
    let mut dirs: Vec<u32> = vec![];
    let mut stack: Vec<u32> = vec![];

    for line in input {
        if line.starts_with("$ cd ") {
            let dir = &line["$ cd ".len()..];
            match dir {
                ".." => {
                    let popped = stack.pop().expect("input has no errors");
                    *stack.last_mut().expect("input has no errors") += popped;
                    dirs.push(popped);
                }
                _ => {
                    stack.push(0);
                }
            }
        } else if line.starts_with(|char: char| char.is_ascii_digit()) {
            let (size, _) = line.split_once(" ").expect("input has no errors");
            *stack.last_mut().expect("input has no errors") +=
                size.parse::<u32>().expect("input has no errors");
        }
    }

    while stack.len() > 0 {
        let popped = stack.pop().expect("no way :clueless:");
        let parent = stack.last_mut();
        // the very last item we pop has no parent
        match parent {
            Some(size) => *size += popped,
            None => (),
        }
        dirs.push(popped);
    }

    println!("{:?}", dirs);

    /* part one */
    let max_size = 100_000;
    let sum = dirs.iter().filter(|size| *size <= &max_size).sum::<u32>();

    // 1648397
    println!("{}", sum);

    /* part two */
    dirs.sort();
    let root_size = dirs.last().expect("directories were explored");
    let total_space = 70_000_000;
    let required_space = 30_000_000;
    let unused_space = total_space - root_size;
    let size_to_del = dirs
        .iter()
        .find(|size| unused_space + *size > required_space)
        .expect("directories were explored");

    // 1815525
    println!("{}", size_to_del);
}
