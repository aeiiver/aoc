#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <deque>
#include <fstream>
#include <sstream>
#include <variant>
#include <vector>

struct Old {};

struct Add {
  std::variant<int, Old> operand;
};

struct Multiply {
  std::variant<int, Old> operand;
};

struct Test {
  int operand;
  int true_monkey;
  int false_monkey;
};

struct Monkey {
  std::deque<int> items;
  std::variant<Add, Multiply> operation;
  Test test;
  int inspect_count;
};

long monkey_op(std::variant<Add, Multiply> &op, int operand) {
  if (Add *add = std::get_if<Add>(&op)) {
    if (int *other = std::get_if<int>(&add->operand)) {
      return *other + operand;
    }
    if (std::holds_alternative<Old>(add->operand)) {
      return operand + operand;
    }
  }
  if (Multiply *mul = std::get_if<Multiply>(&op)) {
    if (int *other = std::get_if<int>(&mul->operand)) {
      return *other * operand;
    }
    if (std::holds_alternative<Old>(mul->operand)) {
      return (long)operand * operand;
    }
  }
  throw "Unreachable";
}

void split_str(const char *delim, char *str, std::vector<char *> &parts) {
  char *part = std::strtok(str, delim);
  while (part != NULL) {
    parts.push_back(part);
    part = strtok(NULL, delim);
  }
}

int main(int argc, char **argv) {
  std::vector<Monkey> monkeys = {};
  bool part_two = false;

  if (argc == 1) {
    std::printf("usage: %s <puzzle_file>\n", argv[0]);
    return 1;
  }
  if (argc > 2) {
    part_two = true;
  }
  char *puzzle_file = argv[1];

  std::ifstream ifs(puzzle_file);
  if (ifs.fail()) {
    std::printf("Failed to open file: %s\n", puzzle_file);
    return 1;
  }

  for (char buf[50]; !ifs.eof();) {
    // ignore the first line for each monkey
    ifs.getline(buf, sizeof buf);

    std::deque<int> items = {};
    {
      ifs.getline(buf, sizeof buf);
      std::string buf_str = std::string(buf).substr(sizeof "  Starting items:");

      std::vector<char *> buf_parts = {};
      split_str(", ", buf_str.data(), buf_parts);
      for (char *item : buf_parts) {
        items.push_back(std::atoi(item));
      }
    }

    std::variant<Add, Multiply> operation;
    {
      ifs.getline(buf, sizeof buf);
      std::string buf_str =
          std::string(buf).substr(sizeof "  Operation: new = old");

      std::string operation_str;
      std::string operand_str;
      std::istringstream(buf_str) >> operation_str >> operand_str;

      std::variant<int, Old> operand;
      if (operand_str.compare("old") == 0) {
        operand = Old{};
      } else {
        operand = std::stoi(operand_str);
      }

      if (operation_str.compare("+") == 0) {
        operation = Add{.operand = operand};
      } else if (operation_str.compare("*") == 0) {
        operation = Multiply{.operand = operand};
      } else {
        throw "Unhandled operator: " + operation_str;
      }
    }

    Test test = Test{};
    {
      ifs.getline(buf, sizeof buf);
      std::string buf_str =
          std::string(buf).substr(sizeof "  Test: divisible by");
      test.operand = std::stoi(buf_str);
    }
    int true_monkey;
    {
      ifs.getline(buf, sizeof buf);
      std::string buf_str =
          std::string(buf).substr(sizeof "    If true: throw to monkey");
      test.true_monkey = std::stoi(buf_str);
    }
    int false_monkey;
    {
      ifs.getline(buf, sizeof buf);
      std::string buf_str =
          std::string(buf).substr(sizeof "    If false: throw to monkey");
      test.false_monkey = std::stoi(buf_str);
    }

    monkeys.push_back(Monkey{
        .items = items,
        .operation = operation,
        .test = test,
        .inspect_count = 0,
    });

    // ignore empty line after the monkey entry
    ifs.getline(buf, sizeof buf);
  }

  int rounds = 20;
  int product_of_remainders = 1;
  if (part_two) {
    rounds = 10000;
    for (Monkey &m : monkeys) {
      product_of_remainders *= m.test.operand;
    }
  }

  {
    long worry;
    for (int i = 1; i <= rounds; ++i) {
      std::printf("======== %d ========\n", i);

      for (Monkey &m : monkeys) {
        while (!m.items.empty()) {
          worry = monkey_op(m.operation, m.items.front());
          m.items.pop_front();
          m.inspect_count++;

          if (part_two) {
            worry %= product_of_remainders;
          } else {
            worry = std::floor(worry / 3);
          }

          if (worry % m.test.operand == 0) {
            monkeys[m.test.true_monkey].items.push_back(worry);
          } else {
            monkeys[m.test.false_monkey].items.push_back(worry);
          }
        }
        std::printf("%d\n", m.inspect_count);
      }
    }
    std::putchar('\n');
  }

  std::sort(monkeys.begin(), monkeys.end(), [](Monkey &a, Monkey &b) {
    return a.inspect_count > b.inspect_count;
  });

  int first = monkeys[0].inspect_count;
  int second = monkeys[1].inspect_count;
  long business = (long)first * second;

  // part one: 121450
  // part two: 28244037010

  if (!part_two) {
    std::printf("Part one: %ld\n", business);
    std::printf("To see the answer for part two, run this program with one "
                "more argument.\n");
  } else {
    std::printf("Part two: %ld\n", business);
  }

  return 0;
}
