#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INST_DELIM " "

int main() {
  FILE *problem_input = fopen("day10.prod", "r");

  int acc = 1;
  int cycle_num = 0;

  // partone
  int sig_strength = 0;
  // parttwo
  char crt_display[1001];

  char *token;
  int opcycles;
  int is_addx;
  for (char line[101]; fgets(line, sizeof(line), problem_input) != NULL;) {
    is_addx = 0;

    // first token is an instruction
    token = strtok(line, INST_DELIM);

    if (strncmp(token, "noop", 4) == 0) {
      opcycles = 1;
    } else if (strncmp(token, "addx", 4) == 0) {
      opcycles = 2;
      is_addx = 1;
    } else {
      printf("Something is wrong...");
      fclose(problem_input);
      exit(1);
    }

    for (; opcycles > 0; --opcycles) {
      ++cycle_num;

      /* partone */
      if (20 <= cycle_num && cycle_num <= 220 && (cycle_num + 20) % 40 == 0) {
        sig_strength += acc * cycle_num;
      }

      // DEBUG
      // printf("[%d]: %d ~ %d, %d\n", cycle_num, acc, sig_strength,
      //        acc * cycle_num);

      /* parttwo */
      if (0 <= cycle_num && cycle_num <= 240) {
        // position of the crt cursor: (cycle_num - 1) % 40
        // position of the sprite: acc

        if (abs((cycle_num - 1) % 40 - acc) < 2) {
          strcat(crt_display, "#");
        } else {
          strcat(crt_display, ".");
        }
        if ((cycle_num - 1) % 40 == 39)
          strcat(crt_display, "\n");
      }
    }

    if (is_addx) {
      // second token is an operand
      token = strtok(NULL, INST_DELIM);
      acc += atoi(token);
    }
  }

  fclose(problem_input);

  // partone: 16880
  printf("Signal strength: %d\n", sig_strength);

  // parttwo: RKAZAJBR
  printf("CRT display:\n%s", crt_display);

  /*

  ###..#..#..##..####..##....##.###..###..
  #..#.#.#..#..#....#.#..#....#.#..#.#..#.
  #..#.##...#..#...#..#..#....#.###..#..#.
  ###..#.#..####..#...####....#.#..#.###..
  #.#..#.#..#..#.#....#..#.#..#.#..#.#.#..
  #..#.#..#.#..#.####.#..#..##..###..#..#.

  */

  return 0;
}
