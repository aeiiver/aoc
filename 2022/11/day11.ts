// @ts-ignore
import { readFileSync } from "node:fs";

type monkey = {
  id: number;
  items: number[];
  inspections: number;
  worryOp?: Function;
  moduloOp?: Function;
  trueMonkey?: number;
  falseMonkey?: number;
};
let monkeys = [] as monkey[];

// @ts-ignore
let mostRecentMonkey = () => monkeys.at(-1) as monkey;

let monkey_inst = "Monkey";
let init_inst = "  Starting items: ";
let op_inst = "  Operation: new = old ";
let test_inst = "  Test: divisible by ";
let true_inst = "    If true: throw to monkey ";
let false_inst = "    If false: throw to monkey ";

(readFileSync("./day11.test", { encoding: "UTF-8" }) as string)
  .split("\n\n")
  .forEach((insts) => {
    insts.split("\n").forEach((inst) => {
      if (inst.startsWith(monkey_inst)) {
        monkeys.push({
          id: parseInt(inst.substring(monkey_inst.length), 10),
          items: [],
          inspections: 0,
        });
      } else if (inst.startsWith(init_inst)) {
        inst
          .substring(init_inst.length)
          .split(", ")
          .forEach((item) => {
            mostRecentMonkey().items.push(parseInt(item, 10));
          });
      } else if (inst.startsWith(op_inst)) {
        let [op, operand] = inst.substring(op_inst.length).split(" ");
        if (operand == "old") {
          mostRecentMonkey().worryOp = {
            "+": (item: number) => item + item,
            "*": (item: number) => item * item,
          }[op];
        } else {
          let operandAsNum = parseInt(operand, 10);
          mostRecentMonkey().worryOp = {
            "+": (item: number) => item + operandAsNum,
            "*": (item: number) => item * operandAsNum,
          }[op];
        }
      } else if (inst.startsWith(test_inst)) {
        let divisor = parseInt(inst.substring(test_inst.length), 10);
        mostRecentMonkey().moduloOp = (item) => item % divisor;
      } else if (inst.startsWith(true_inst)) {
        mostRecentMonkey().trueMonkey = parseInt(
          inst.substring(true_inst.length),
          10
        );
      } else if (inst.startsWith(false_inst)) {
        mostRecentMonkey().falseMonkey = parseInt(
          inst.substring(false_inst.length),
          10
        );
      }
    });
  });

for (let round = 0; round < 10000; ++round) {
  console.log("round", round);

  monkeys.forEach((monk) => {
    monk.items.forEach((item) => {
      monk.inspections++;

      // partone
      // let worryAsFuLvl = monk.worryOp!(item);
      // let relievedLvl = Math.floor(worryAsFuLvl / 3);
      // let remainder = monk.moduloOp!(relievedLvl);
      // let nextMonkeyIdx = remainder == 0 ? monk.trueMonkey! : monk.falseMonkey!;
      // monkeys[nextMonkeyIdx]?.items.push(relievedLvl);

      // parttwo
      let remainder = monk.moduloOp!(item);
      let worryAsFuLvl = monk.worryOp!(remainder);
      let relievedLvl = monk.moduloOp!(worryAsFuLvl);
      let nextMonkeyIdx =
        relievedLvl == 0 ? monk.trueMonkey! : monk.falseMonkey!;
      monkeys[nextMonkeyIdx]?.items.push(item);

      /**
       * After each monkey inspects an item but before it tests your worry level,
       * your relief that the monkey's inspection didn't damage the item causes your
       * worry level to be divided by three and *rounded down* to the nearest integer.
       *
       * >< I think I need to read better because I unironically missed that "rounded down",
       * and was rounding using "Math.round" instead of "Math.floor"...
       */
      // DEBUG
      // console.log(`    Monkey ${monk.id} inspects item ${item}`);
      // console.log(`    Worry: ${item} => ${worryAsFu}`);
      // console.log(`    Bored ${relieved}`);
      // console.log(`    ${relieved} divisible: ${test}`);
      // console.log(`    Throws ${relieved} at ${nextMonkeyIdx}`);
      // console.log();
    });
    monk.items.length = 0;
  });
}

// 121450
console.log(
  monkeys
  // .sort((a, b) => b.inspections - a.inspections)
  // .slice(0, 2)
  // .reduce((acc, curr) => acc * curr.inspections, 1)
);
