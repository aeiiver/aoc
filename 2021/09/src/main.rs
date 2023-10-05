#[derive(PartialEq, Clone, Copy, Debug)]
struct Point {
    x: usize,
    y: usize,
}

struct Map<'a> {
    data: Vec<&'a [u8]>,
}

impl<'a> Map<'a> {
    fn new(s: &'a str) -> Self {
        Self {
            data: s.lines().map(|l| l.as_bytes()).collect::<Vec<&'a [u8]>>(),
        }
    }

    fn rows(&self) -> usize {
        self.data.len()
    }

    fn cols(&self) -> usize {
        self.data[0].len()
    }

    fn at(&self, p: &Point) -> u8 {
        self.data[p.y][p.x]
    }

    fn neighbors(&self, p: &Point) -> Vec<Point> {
        let mut ns = vec![];
        if p.x > 0 {
            ns.push(Point { x: p.x - 1, y: p.y });
        }
        if p.x < self.data[0].len() - 1 {
            ns.push(Point { x: p.x + 1, y: p.y });
        }
        if p.y > 0 {
            ns.push(Point { x: p.x, y: p.y - 1 });
        }
        if p.y < self.data.len() - 1 {
            ns.push(Point { x: p.x, y: p.y + 1 });
        }
        ns
    }

    fn low_points(&self) -> Vec<Point> {
        let mut lowpts = vec![];

        for y in 0..self.rows() {
            for x in 0..self.cols() {
                let here = Point { x, y };
                let nbrs = self.neighbors(&here);

                if nbrs.iter().any(|p| self.at(p) <= self.at(&here)) {
                    continue;
                }
                lowpts.push(Point { x, y });
            }
        }
        lowpts
    }

    fn one(&self) -> u32 {
        self.low_points()
            .iter()
            .map(|p| (self.at(p) - b'0' + 1) as u32)
            .sum::<u32>()
    }

    fn basins(&self) -> Vec<Vec<Point>> {
        let mut basins = vec![];

        for lp in self.low_points() {
            let mut stack = vec![Point { x: lp.x, y: lp.y }];
            let mut seen = vec![Point { x: lp.x, y: lp.y }];

            while let Some(pop) = stack.pop() {
                for n in self.neighbors(&pop) {
                    if seen.contains(&n) || self.at(&n) == b'9' {
                        continue;
                    }
                    stack.push(n);
                    seen.push(n);
                }
            }
            basins.push(seen);
        }
        basins
    }

    fn two(&self) -> u32 {
        let mut sizes = self
            .basins()
            .into_iter()
            .map(|b| b.len() as u32)
            .collect::<Vec<u32>>();
        sizes.sort_by(|a, b| b.cmp(a));
        sizes.iter().take(3).product::<u32>()
    }
}

fn main() {
    let puzzle = include_str!("./input.real.txt");
    let map = Map::new(puzzle);

    println!("One: {}", map.one());
    // One: 537
    println!("Two: {}", map.two());
    // Two: 1142757
}
