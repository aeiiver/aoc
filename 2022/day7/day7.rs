#[derive(Debug)]
struct Node {
    name: String,
    size: u32,
}

fn main() {
    let output = include_str!("./day7.prod").lines();

    let mut stack: Vec<Node> = vec![Node {
        name: String::from("/"),
        size: 0 as u32,
    }];
    let mut dirs: Vec<Node> = vec![];

    for line in output {
        if line == "$ cd /" || line == "$ ls" {
            continue;
        }

        // looking at a cd command
        if line.chars().nth(0).unwrap() == '$' {
            let dir = &line[5..];

            if dir == ".." {
                let popped = stack.pop().unwrap();
                stack.last_mut().unwrap().size += popped.size;
                dirs.push(popped);
                continue;
            }

            stack.push(Node {
                name: dir.to_string(),
                size: 0,
            });
            continue;
        }

        if let Some((size, _)) = line.split_once(" ") {
            if size == "dir" {
                continue;
            }
            stack.last_mut().unwrap().size += size.parse::<u32>().unwrap();
        }
    }

    // emptying what's remaining on the stack
    while stack.len() > 0 {
        let popped = stack.pop().unwrap();
        let parent_unsafe = stack.last_mut();
        match parent_unsafe {
            Some(_) => parent_unsafe.unwrap().size += popped.size,
            None => (),
        }
        dirs.push(popped);
    }

    let pass_filter = 100_000;

    // 1648397
    println!(
        "{}",
        dirs.iter()
            .map(|node| node.size)
            .filter(|size| size <= &pass_filter)
            .sum::<u32>()
    );

    let total_space = 70_000_000;
    let required_space = 30_000_000;
    
    dirs.sort_by(|a, b| a.size.cmp(&b.size));
    let remaining_space = total_space - dirs.last().unwrap().size;

    // 1815525
    println!(
        "{}",
        if remaining_space >= required_space {
            dirs.last().unwrap().size
        } else {
            dirs.iter()
                .find(|node| remaining_space + node.size > required_space)
                .unwrap()
                .size
        }
    );
}
