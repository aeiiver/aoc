use std::collections::VecDeque;

#[derive(Debug)]
struct Position {
    x: usize,
    y: usize,
}
impl Position {
    fn new(x: usize, y: usize) -> Self {
        Self { x, y }
    }
}
impl Clone for Position {
    fn clone(&self) -> Self {
        Self {
            x: self.x.clone(),
            y: self.y.clone(),
        }
    }
}
impl PartialEq for Position {
    fn eq(&self, other: &Self) -> bool {
        self.x == other.x && self.y == other.y
    }
}

struct Heightmap {
    data: Vec<Vec<u8>>,
}
impl Heightmap {
    fn new(map: &Vec<Vec<u8>>) -> Self {
        Self { data: map.clone() }
    }

    fn height(&self, pos: &Position) -> u8 {
        let value = self.value(pos);
        if value == b'S' {
            b'a'
        } else if value == b'E' {
            b'z'
        } else {
            value
        }
    }

    fn value(&self, pos: &Position) -> u8 {
        self.data[pos.y][pos.x]
    }
}

struct Search {
    map: Heightmap,
    compare: fn(u8, u8) -> bool,
}
impl Search {
    fn new(heightmap: Heightmap, compare: fn(u8, u8) -> bool) -> Self {
        Self {
            map: heightmap,
            compare,
        }
    }

    fn shortest_path(&self, start: Position, target: u8) -> Option<Vec<Position>> {
        let mut paths = VecDeque::new();
        let mut visited = vec![];

        paths.push_front(vec![start]);

        while !paths.is_empty() {
            let path = paths.pop_back().unwrap();
            let pos = path.last().unwrap().clone();

            if visited.contains(&pos) {
                continue;
            }
            visited.push(pos.clone());

            if self.map.value(&pos) == target {
                return Some(path);
            }

            // println!("{:?}: {}", pos, self.value(&pos) as char); // DEBUG

            for neighbor in self.safe_neighbors(&pos) {
                let mut next_path = path.clone();
                next_path.push(neighbor);
                paths.push_front(next_path);
            }
        }

        None
    }

    fn safe_neighbors(&self, pos: &Position) -> Vec<Position> {
        let mut neighbors = vec![];

        let x_min = 0;
        let x_max = self.map.data.first().unwrap().len() - 1;
        let y_min = 0;
        let y_max = self.map.data.len() - 1;

        // programming war crime instance be like

        // this basically push a neighbor in the vector if it's not a border
        macro_rules! ask_for_direction_politely_and_give_up_if_needed {
            ($cond:expr,$vec:expr) => {
                if $cond {
                    let neighbor = Position::new(
                        ((pos.x as isize) + $vec.0) as usize,
                        ((pos.y as isize) + $vec.1) as usize,
                    );
                    if self.can_walk(pos, &neighbor) {
                        neighbors.push(neighbor);
                    }
                }
            };
        }
        ask_for_direction_politely_and_give_up_if_needed!(pos.x > x_min, (-1, 0)); // left
        ask_for_direction_politely_and_give_up_if_needed!(pos.x < x_max, (1, 0)); // right
        ask_for_direction_politely_and_give_up_if_needed!(pos.y > y_min, (0, -1)); // up
        ask_for_direction_politely_and_give_up_if_needed!(pos.y < y_max, (0, 1)); // down

        neighbors
    }

    fn can_walk(&self, from: &Position, to: &Position) -> bool {
        // we can go any height down but can only go one height up
        (self.compare)(self.map.height(&from), self.map.height(&to))
    }
}

fn main() {
    let mut heightmap = vec![];
    let mut start = Option::None;
    let mut destination = Option::None;

    let problem_input = include_str!("./day12.prod").lines().enumerate();
    for (y, line) in problem_input {
        heightmap.push(line.bytes().collect());

        if start.is_none() {
            line.char_indices().for_each(|(x, char)| {
                if char == 'S' {
                    let _ = start.insert(Position::new(x, y));
                }
            });
        }
        if destination.is_none() {
            line.char_indices().for_each(|(x, char)| {
                if char == 'E' {
                    let _ = destination.insert(Position::new(x, y));
                }
            });
        }
    }

    let start = start.expect("problem input should have a start point");
    let destination = destination.expect("problem input should have a destination point");

    let search_forwards = Search::new(Heightmap::new(&heightmap), |from, to| {
        from >= to || from + 1 == to
    });
    let search_backwards = Search::new(Heightmap::new(&heightmap), |from, to| {
        to >= from || to + 1 == from
    });

    // partone: 528
    let partone = search_forwards
        .shortest_path(start, b'E')
        .expect("path should exist")
        .len()
        - 1;
    println!("{:?}", partone);

    // parttwo: 522
    let parttwo = search_backwards
        .shortest_path(destination, b'a')
        .expect("path should exist")
        .len()
        - 1;
    println!("{:?}", parttwo);
}
