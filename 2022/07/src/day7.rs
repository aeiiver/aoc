#[derive(Debug)]
struct Node {
    _name: String,
    size: u32,
}

impl Node {
    fn new(name: String, size: u32) -> Self {
        Self { _name: name, size }
    }
}

fn main() {
    let shell_output = include_str!("./day7.prod").lines();

    let mut cd_stack: Vec<Node> = vec![Node::new(String::from("/"), 0)];
    let mut dirs: Vec<Node> = vec![];

    // reading the lines
    for line in shell_output {
        // we're not interested into these
        if line == "$ cd /" || line == "$ ls" {
            continue;
        }

        // looking at a cd command
        if line.chars().nth(0).unwrap() == '$' {
            // 5 is the length of "$ cd "
            let dir = &line[5..];

            if dir != ".." {
                cd_stack.push(Node::new(dir.to_string(), 0));
                continue;
            }

            let popped = cd_stack.pop().unwrap();
            cd_stack.last_mut().unwrap().size += popped.size;
            dirs.push(popped);
            continue;
        }

        if let Some((size, _)) = line.split_once(" ") {
            if size == "dir" {
                continue;
            }
            cd_stack.last_mut().unwrap().size += size.parse::<u32>().unwrap();
        }
    }

    // emptying what's remaining on the stack
    while cd_stack.len() > 0 {
        let popped = cd_stack.pop().unwrap();
        let parent = cd_stack.last_mut();
        match parent {
            Some(v) => v.size += popped.size,
            None => (),
        }
        dirs.push(popped);
    }

    /* part one */

    let pass_filter = 100_000;

    // 1648397
    println!(
        "{}",
        dirs.iter()
            .map(|node| node.size)
            .filter(|size| size <= &pass_filter)
            .sum::<u32>()
    );

    /* part two */

    let total_space = 70_000_000;
    let required_space = 30_000_000;

    dirs.sort_by(|a, b| a.size.cmp(&b.size));
    let remaining_space = total_space - dirs.last().unwrap().size;

    let final_size = if remaining_space >= required_space {
        dirs.last().unwrap().size
    } else {
        dirs.iter()
            .find(|node| remaining_space + node.size > required_space)
            .unwrap()
            .size
    };

    // 1815525
    println!("{}", final_size);
}
