/**
 * Average experience: input parsing taking 80% of active dev time...
 * Like, why did I took so long to come up with something that I'm not proud of?
 */

// @ts-ignore / O sinful you do
import { readFileSync } from "node:fs";

let [crateLines, moveLines] = (readFileSync("./day5.prod", "utf8") as string)
  .split("\n\n")
  .map((lines) => lines.split("\n")) as [string[], string[]];

let stacksPartone = [] as unknown as [string[], string[]];
crateLines.slice(0, -1).forEach((line) => {
  let stackIdx = 0;

  // reading the crates from left to right, top to bottom,
  // so we unshift to build the stacks
  for (let cratePos = 1; cratePos < line.length; cratePos += 4) {
    if (stacksPartone[stackIdx] === undefined) {
      stacksPartone[stackIdx] = [];
    }
    if (line[cratePos] != " ") {
      stacksPartone[stackIdx].unshift(line[cratePos]);
    }
    ++stackIdx;
  }
});
// a little bit of unsafe deep copy
let stacksParttwo = JSON.parse(JSON.stringify(stacksPartone)) as [
  string[],
  string[]
];

let moves = moveLines.map((line) => {
  let [amount, from, to] = line.match(/\d+/g)!.map((n) => parseInt(n, 10));
  return [amount, from - 1, to - 1];
});

// the least mutating code in the world
for (let [amount, from, to] of moves) {
  for (let i = 0; i < amount; ++i) {
    // assuming the amount specified in the problem input is right
    let moved = stacksPartone[from].pop()!;
    stacksPartone[to].push(moved);
  }
}

// the least mutating code in the world
for (let [amount, from, to] of moves) {
  let reverseStack: string[] = [];

  for (let i = 0; i < amount; ++i) {
    // assuming the amount specified in the problem input is right
    let moved = stacksParttwo[from].pop()!;
    reverseStack.push(moved);
  }

  for (let i = 0; i < reverseStack.length; +i) {
    stacksParttwo[to].push(reverseStack.pop()!);
  }
}

// FWSHSPJWM
console.log(
  // @ts-ignore / 'at' target lib
  stacksPartone.map((stack) => stack.at(-1)).join("")
);

// PWPWHGFZS
console.log(
  // @ts-ignore / 'at' target lib
  stacksParttwo.map((stack) => stack.at(-1)).join("")
);

// I feel impure to use this much mutating code,
// but it gets the job done
