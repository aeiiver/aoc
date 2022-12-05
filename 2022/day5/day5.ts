/**
 * Average experience: input parsing taking 80% of active dev time...
 * Like, why did I took so long to come up with something that I'm not proud of?
 */

// @ts-ignore / O sinful you do
import { readFileSync } from "node:fs";

let [linesForCrates, linesForMoves] = readFileSync("./day5.prod", "utf8")
  .split("\n\n")
  .map((bunchOfLines) => bunchOfLines.split("\n")) as [string[], string[]];

let stacksPartone: string[][] = [];
linesForCrates.slice(0, -1).forEach((line) => {
  let stackIdx = 0;
  let cratePos = 1;

  while (cratePos < line.length) {
    if (stacksPartone[stackIdx] === undefined) {
      stacksPartone[stackIdx] = [];
    }
    if (line[cratePos] != " ") {
      stacksPartone[stackIdx].unshift(line[cratePos]);
    }

    stackIdx++;
    cratePos += 4;
  }
});
// DEEP copy cool trick
let stacksParttwo: string[][] = JSON.parse(JSON.stringify(stacksPartone));

let moves = linesForMoves.map((line) => {
  let [crateCount, from, to] = line.match(/\d+/g)!.map((n) => parseInt(n, 10));
  return [crateCount, from - 1, to - 1];
});

// the least mutating code in the world
for (let [crateCount, from, to] of moves) {
  for (let i = 0; i < crateCount; ++i) {
    let moved = stacksPartone[from].pop();
    if (moved === undefined) break;
    stacksPartone[to].push(moved);
  }
}

// the least mutating code in the world
for (let [crateCount, from, to] of moves) {
  let buffer: string[] = [];

  for (let i = 0; i < crateCount; ++i) {
    let moved = stacksParttwo[from].pop();
    if (moved === undefined) break;
    buffer.push(moved);
  }

  for (let i = 0; i < buffer.length; +i) {
    stacksParttwo[to].push(buffer.pop()!);
  }
}

// FWSHSPJWM
console.log(
  // @ts-ignore
  stacksPartone.map((stack) => stack.at(-1)).join("")
);

// PWPWHGFZS
console.log(
  // @ts-ignore
  stacksParttwo.map((stack) => stack.at(-1)).join("")
);

// I feel impure to use this much mutating code
