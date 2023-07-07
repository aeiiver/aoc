import { readFileSync } from "fs";

let [crateLines, moveLines] = readFileSync("./src/input-prod", "utf8")
  .split("\n\n")
  .map((lines) => lines.split("\n"));

let stacks = [] as unknown as [string[], string[]];
crateLines.forEach((line) => {
  let i = 0;
  let linePos = 1;

  while (linePos < line.length) {
    if (stacks[i] === undefined) {
      stacks[i] = [];
    }
    if (line[linePos] !== " ") {
      stacks[i].unshift(line[linePos]);
    }
    ++i;
    linePos += 4;
  }
});

// a little bit of unsafe deep copy
let stacks2 = JSON.parse(JSON.stringify(stacks)) as [string[], string[]];

let moves = moveLines.slice(0, -1).map((line) => {
  let [amount, from, to] = line.match(/\d+/g)!.map((n) => parseInt(n, 10));
  return [amount, from - 1, to - 1];
});

// the least mutating code in the world
for (let [amount, from, to] of moves) {
  for (let i = 0; i < amount; ++i) {
    // assuming the amount specified in the problem input is never wrong
    let moved = stacks[from].pop()!;
    stacks[to].push(moved);
  }
}

// the least mutating code in the world 2
for (let [amount, from, to] of moves) {
  let reverseStack = [] as string[];

  for (let i = 0; i < amount; ++i) {
    // assuming the amount specified in the problem input is never wrong
    let moved = stacks2[from].pop()!;
    reverseStack.push(moved);
  }

  for (let i = 0; i < reverseStack.length; +i) {
    stacks2[to].push(reverseStack.pop()!);
  }
}

// FWSHSPJWM
console.log(stacks.map((stack) => stack.at(-1)).join(""));

// PWPWHGFZS
console.log(stacks2.map((stack) => stack.at(-1)).join(""));
