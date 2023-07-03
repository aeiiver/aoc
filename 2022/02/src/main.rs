fn main() {
    let input = include_bytes!("./input-prod");

    // 15572
    println!(
        "{:?}",
        input
            .split(|&byte| byte == b'\n')
            .map(|round| {
                let abc = (round[0] - b'A') as i8;
                let xyz = (round[2] - b'X') as i8;
                // win_score                                     shape_score
                ([3, 0, 6][(abc - xyz).rem_euclid(3) as usize] + xyz + 1) as u32
            })
            .sum::<u32>()
    );

    // 16098
    println!(
        "{:?}",
        input
            .split(|&b| b == b'\n')
            .map(|round| {
                let abc = round[0] - b'A';
                let xyz = round[2] - b'X';
                // (abc + offset) = shape_score                      win_score
                ((abc + [2, 0, 1][xyz as usize]).rem_euclid(3) + 1 + [0, 3, 6][xyz as usize]) as u32
            })
            .sum::<u32>()
    );
}
