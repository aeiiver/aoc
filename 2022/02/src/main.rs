fn main() {
    let input = include_bytes!("./input-prod");

    // 15572
    println!(
        "{:?}",
        input
            .split(|&byte| byte == b'\n')
            .take_while(|round| !round.is_empty())
            .map(|round| {
                let abc = round[0] - b'A';
                let xyz = round[2] - b'X';
                let win_score = [3, 0, 6][(3 + abc - xyz).rem_euclid(3) as usize];
                let shape_score = (xyz + 1) as u32;
                win_score + shape_score
            })
            .sum::<u32>()
    );

    // 16098
    println!(
        "{:?}",
        input
            .split(|&byte| byte == b'\n')
            .take_while(|round| !round.is_empty())
            .map(|round| {
                let abc = round[0] - b'A';
                let xyz = round[2] - b'X';
                let win_score = [0, 3, 6][xyz as usize] as u32;
                let shape_score = ((abc + [2, 0, 1][xyz as usize]).rem_euclid(3) + 1) as u32;
                win_score + shape_score
            })
            .sum::<u32>()
    );
}
