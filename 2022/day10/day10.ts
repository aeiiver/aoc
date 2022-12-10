// @ts-ignore TS, stop it already...
import fs from "node:fs";

let instructions = fs
  .readFileSync("./day10.prod", { encoding: "UTF-8" })
  .split("\n")
  .map((line: string) => line.split(" ")) as string[][];

let ax = 1;
let cycle = 0;
let signalStrength = 0;

for (let instruction of instructions) {
  let opcode = instruction[0];
  let opCycle = 0;

  switch (opcode) {
    case "noop":
      opCycle = 1;
      break;
    case "addx":
      opCycle = 2;
      break;
  }

  for (let _ = 0; _ < opCycle; ++_) {
    cycle++; // Putting this little bad boy here took me hours to figure out...

    //#region Partone
    if (20 <= cycle && cycle <= 220 && (cycle + 20) % 40 === 0) {
      signalStrength += ax * cycle;
    }
    // console.log(cycle, ax, signalStrength, ax * cycle); // DEBUG
    //#endregion

    //#region Parttwo
    if (0 <= cycle && cycle <= 240) {
      let crtCursorPos = (cycle - 1) % 40;
      let spritePos = ax;
      let areAroundSameSpot = Math.abs(crtCursorPos - spritePos) < 2;
      // @ts-ignore Shhh TS... I'm using Bun!
      process.stdout.write(areAroundSameSpot ? "#" : ".");
      if (crtCursorPos == 39) console.log();
    }
    //#endregion
  }

  if (opcode === "addx") {
    ax += parseInt(instruction[1], 10);
  }
}

console.log("Signal strength:", signalStrength); // 16880

// Part two was done in the cycle for loop. Here's the output: RKAZAJBR
// Oh hell no, this is hard to read somehow...
/*

###..#..#..##..####..##....##.###..###..
#..#.#.#..#..#....#.#..#....#.#..#.#..#.
#..#.##...#..#...#..#..#....#.###..#..#.
###..#.#..####..#...####....#.#..#.###..
#.#..#.#..#..#.#....#..#.#..#.#..#.#.#..
#..#.#..#.#..#.####.#..#..##..###..#..#.

*/
