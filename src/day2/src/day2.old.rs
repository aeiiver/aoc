enum Shape {
    Rock = 1,
    Paper,
    Scissors,
}

enum WinCase {
    Lose = 0,
    Draw = 3,
    Win = 6,
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
                    _ => WinCase::Lose as i32,
                };
                let shape_score = match round.chars().nth(2) {
                    Some('X') => Shape::Rock as i32,
                    Some('Y') => Shape::Paper as i32,
                    Some('Z') => Shape::Scissors as i32,
                    _ => unreachable!(),
                };
                win_score + shape_score
            })
            .sum::<i32>()
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
                    Some('X') => (WinCase::Lose as i32) + shape_score(opponent_shape, 2),
                    Some('Y') => (WinCase::Draw as i32) + shape_score(opponent_shape, 0),
                    Some('Z') => (WinCase::Win as i32) + shape_score(opponent_shape, 1),
                    _ => unreachable!(),
                }
            })
            .sum::<i32>()
    );
}

fn shape_score(opponent_shape: Option<char>, offset: i32) -> i32 {
    (match opponent_shape {
        Some('A') => (Shape::Rock as i32) - 1,
        Some('B') => (Shape::Paper as i32) - 1,
        Some('C') => (Shape::Scissors as i32) - 1,
        _ => unreachable!(),
    } + offset)
        % 3
        + 1
}
