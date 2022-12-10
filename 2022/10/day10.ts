// @ts-ignore TS, stop it already...
import { readFileSync } from "node:fs";

let instructions = (
  readFileSync("./day10.prod", { encoding: "utf-8" }) as string
)
  .split("\n")
  .map((line) => line.split(" ")) as string[][];

// pop final newline
instructions.pop();

let acc = 1;
let cycleNum = 0;

// partone
let signalStrength = 0;
//parttwo
let crtDisplay = "";

for (let inst of instructions) {
  let opcode = inst[0];
  let opcycles = 0;

  if (opcode == "noop") {
    opcycles = 1;
  } else if (opcode == "addx") {
    opcycles = 2;
  } else {
    console.log("Something is wrong...");
    break;
  }

  for (; opcycles > 0; --opcycles) {
    // it took me hours to figure out i had to put
    // this little bad boy specifically here
    ++cycleNum;

    //#region partone
    if (20 <= cycleNum && cycleNum <= 220 && (cycleNum + 20) % 40 === 0) {
      signalStrength += acc * cycleNum;
    }
    // console.log(cycleNum, acc, signalStrength, acc * cycleNum); // DEBUG
    //#endregion

    //#region parttwo
    if (0 <= cycleNum && cycleNum <= 240) {
      let crtCursorPos = (cycleNum - 1) % 40;
      let spritePos = acc;
      let areAroundSameSpot = Math.abs(crtCursorPos - spritePos) < 2;

      crtDisplay += areAroundSameSpot ? "#" : ".";
      if (crtCursorPos == 39) crtDisplay += "\n";
    }
    //#endregion
  }

  if (opcode === "addx") {
    let operand = inst[1];
    acc += parseInt(operand, 10);
  }
}

// partone: 16880
console.log("Signal strength: " + signalStrength);

// parttwo: RKAZAJBR
console.log(crtDisplay.trimEnd());

/*

###..#..#..##..####..##....##.###..###..
#..#.#.#..#..#....#.#..#....#.#..#.#..#.
#..#.##...#..#...#..#..#....#.###..#..#.
###..#.#..####..#...####....#.#..#.###..
#.#..#.#..#..#.#....#..#.#..#.#..#.#.#..
#..#.#..#.#..#.####.#..#..##..###..#..#.

*/
