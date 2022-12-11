/**
 * Losing the game
 */

struct Monkey {
    id: u32,
    items: Vec<u32>,
    worry_op: Option<Box<dyn Fn(u32) -> u32>>,
    target_monkey: Option<Box<dyn Fn(u32) -> u32>>,
}

impl Monkey {
    fn new(id: u32) -> Monkey {
        Monkey {
            id,
            items: vec![],
            worry_op: Option::None,
            target_monkey: Option::None,
        }
    }
}

fn treat(inst: &str, monkeys: &mut Vec<Monkey>) {
    let monkey_inst = "Monkey";
    let init_inst = "  Starting items: ";
    let op_inst = "  Operation: new = old ";
    let test_inst = "  Test: divisible by ";
    let true_inst = "    If true: throw to monkey ";
    let false_inst = "    If false: throw to monkey ";

    if inst.starts_with(monkey_inst) {
        let id = inst[monkey_inst.len()..].parse::<u32>().expect("monkey id");
        monkeys.push(Monkey::new(id));
    } else if inst.starts_with(init_inst) {
        inst[init_inst.len()..].split(", ").for_each(|item| {
            monkeys
                .last_mut()
                .expect("latest pushed monkey")
                .items
                .push(item.parse::<u32>().unwrap())
        })
    } else if inst.starts_with(op_inst) {
        let (op, operand) = inst[op_inst.len()..]
            .split_once(" ")
            .expect("op, operand pair");
        operand = operand.parse::<u32>();
        let test: &'static dyn Fn(u32) -> u32 = if operand.contains("old") {
            &|item: u32| item + item
        } else {
            &|item: u32| item + operand.parse::<u32>().expect("operand number")
        };
        match op {
            "+" => monkeys
                .last_mut()
                .expect("latest pushed monkey")
                .worry_op
                .insert(Box::new(test)),
            "*" => monkeys
                .last_mut()
                .expect("latest pushed monkey")
                .worry_op
                .insert(if operand == "old" {
                    Box::new(|item: u32| item * item)
                } else {
                    Box::new(|item: u32| item * operand.parse::<u32>().expect("operand number"))
                }),
            _ => panic!("unexpected operand"),
        };
    };
}

fn main() {
    let mut monkeys: Vec<Monkey> = vec![];

    include_str!("./day11.test")
        .split("\n\n")
        .for_each(|inst| treat(&inst, &mut monkeys));
}
