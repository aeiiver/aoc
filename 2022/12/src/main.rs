use std::collections::VecDeque;

#[derive(Clone, Copy, Debug, PartialEq)]
struct Position {
    x: usize,
    y: usize,
}

impl Position {
    fn translate(&self, dx: isize, dy: isize) -> Self {
        Self {
            x: (self.x as isize + dx) as usize,
            y: (self.y as isize + dy) as usize,
        }
    }
}

#[derive(Clone)]
struct Heightmap {
    data: Vec<Vec<char>>,
}

impl Heightmap {
    fn new(map: Vec<Vec<char>>) -> Self {
        Self { data: map }
    }

    fn height(&self) -> usize {
        self.data.len()
    }

    fn width(&self) -> usize {
        if self.data.is_empty() {
            return 0;
        }
        self.data.first().unwrap().len()
    }

    fn value_at(&self, pos: &Position) -> char {
        let value = self.raw_value_at(pos);
        match value {
            'S' => 'a',
            'E' => 'z',
            _ => value,
        }
    }

    fn raw_value_at(&self, pos: &Position) -> char {
        self.data[pos.y][pos.x]
    }
}

struct Search {
    map: Heightmap,
    compare: fn(char, char) -> bool,
}

impl Search {
    fn new(heightmap: Heightmap, compare: fn(char, char) -> bool) -> Self {
        Self {
            map: heightmap,
            compare,
        }
    }

    fn shortest_path(&self, start: &Position, target: char) -> Option<Vec<Position>> {
        let mut queue = VecDeque::new();
        let mut seen = vec![vec![false; self.map.width()]; self.map.height()];
        let mut prev = vec![vec![None; self.map.width()]; self.map.height()];
        let mut target_pos = None;

        queue.push_front(start.to_owned());
        seen[start.y][start.x] = true;

        while !queue.is_empty() {
            let pos = queue.pop_back().unwrap();
            if self.map.raw_value_at(&pos) == target {
                target_pos = Some(pos);
                break;
            }
            for neighbor in self.safe_neighbors(&pos) {
                if seen[neighbor.y][neighbor.x] {
                    continue;
                }
                prev[neighbor.y][neighbor.x].get_or_insert(pos.to_owned());
                queue.push_front(neighbor);
                seen[neighbor.y][neighbor.x] = true;
            }
        }

        target_pos?;
        let mut curr = target_pos.unwrap();
        let mut path = VecDeque::new();
        while let Some(pos) = prev[curr.y][curr.x] {
            curr = pos;
            path.push_front(curr);
        }

        Some(path.into())
    }

    fn safe_neighbors(&self, pos: &Position) -> Vec<Position> {
        let mut neighbors = vec![];

        let x_min = 0;
        let x_max = self.map.data[0].len() - 1;
        let y_min = 0;
        let y_max = self.map.data.len() - 1;

        // programming war crime instance be like
        //
        // this basically pushes a neighbor in the vector if it's not a border, although it's
        // clearly not wise to make it as a macro
        //
        // ok i'm here once again asking you to accept my apologies, as i know this isn't a good
        // fit, but please, i wanted to write a macro
        macro_rules! ask_for_direction_politely_and_give_up_if_not_ok {
            ($cond:expr,$vec:expr) => {
                if $cond {
                    let neighbor = pos.translate($vec.0, $vec.1);
                    if self.can_walk(pos, &neighbor) {
                        neighbors.push(neighbor);
                    }
                }
            };
        }
        ask_for_direction_politely_and_give_up_if_not_ok!(pos.x > x_min, (-1, 0)); // left
        ask_for_direction_politely_and_give_up_if_not_ok!(pos.x < x_max, (1, 0)); // right
        ask_for_direction_politely_and_give_up_if_not_ok!(pos.y > y_min, (0, -1)); // up
        ask_for_direction_politely_and_give_up_if_not_ok!(pos.y < y_max, (0, 1)); // down

        neighbors
    }

    fn can_walk(&self, from: &Position, to: &Position) -> bool {
        (self.compare)(self.map.value_at(from), self.map.value_at(to))
    }
}

fn main() {
    let mut start = None;
    let mut dest = None;
    let mut map = vec![];

    let input = include_str!("input-prod").lines().enumerate();
    for (y, line) in input {
        map.push(line.chars().collect::<Vec<char>>());
        line.char_indices().for_each(|(x, char)| match char {
            'S' => start = Some(Position { x, y }),
            'E' => dest = Some(Position { x, y }),
            _ => (),
        });
    }

    let start = start.expect("start was found during input read");
    let dest = dest.expect("dest was found during input read");
    let map = Heightmap::new(map.to_owned());

    // you can go any height down but only one height up
    let forward_search = Search::new(map.to_owned(), |from, to| {
        from >= to || (from as u32) + 1 == to as u32
    });

    // to reach the height you're at, you need to switch your perspective
    let backward_search = Search::new(map, |from, to| to >= from || (to as u32) + 1 == from as u32);

    // part one: 528
    let part_one = forward_search
        .shortest_path(&start, 'E')
        .expect("part one path was found during search")
        .len();
    println!("Part one: {}", part_one);

    // part two: 522
    let part_two = backward_search
        .shortest_path(&dest, 'a')
        .expect("part two path was found during search")
        .len();
    println!("Part two: {}", part_two);
}
