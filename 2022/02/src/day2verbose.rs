enum WinScore {
    Lose = 0,
    Draw = 3,
    Win = 6,
}

enum ShapeScore {
    Rock = 1,
    Paper,
    Scissors,
}

fn shape_score(opponent_shape: Option<char>, offset: u32) -> u32 {
    (match opponent_shape {
        Some('A') => (ShapeScore::Rock as u32) - 1,
        Some('B') => (ShapeScore::Paper as u32) - 1,
        Some('C') => (ShapeScore::Scissors as u32) - 1,
        _ => unreachable!(),
    } + offset)
        % 3
        + 1
}

fn main() -> () {
    let input = include_str!("./day2.prod");

    // 15572
    println!(
        "{:?}",
        input
            .lines()
            .map(|round| {
                let win_score = match round {
                    "A Y" | "B Z" | "C X" => 6,
                    "A X" | "B Y" | "C Z" => 3,
                    _ => WinScore::Lose as u32,
                };
                let shape_score = match round.chars().nth(2) {
                    Some('X') => ShapeScore::Rock as u32,
                    Some('Y') => ShapeScore::Paper as u32,
                    Some('Z') => ShapeScore::Scissors as u32,
                    _ => unreachable!(),
                };
                win_score + shape_score
            })
            .sum::<u32>()
    );

    // 16098
    println!(
        "{:?}",
        input
            .lines()
            .map(|round| {
                let target_wincase = round.chars().nth(2);
                let opponent_shape = round.chars().nth(0);
                match target_wincase {
                    Some('X') => (WinScore::Lose as u32) + shape_score(opponent_shape, 2),
                    Some('Y') => (WinScore::Draw as u32) + shape_score(opponent_shape, 0),
                    Some('Z') => (WinScore::Win as u32) + shape_score(opponent_shape, 1),
                    _ => unreachable!(),
                }
            })
            .sum::<u32>()
    );
}
