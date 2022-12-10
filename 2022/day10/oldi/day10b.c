/**
 * First attempt at solving the puzzle in C.
 * 
 * Status: Unsuccessful
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
  FILE *fp = fopen("./day10.test", "r");

  if (fp == NULL) {
    perror("Failed to read file...\n");
    return 1;
  }

  uint32_t cycle_count = 0;
  uint32_t ax = 1;   // accumulated x
  uint32_t x = 0;    // the "x" that is read from the buffer
  uint8_t x_dec = 0; // set to 2 and decrement till to allow writing x to ax

  uint32_t base = 20;
  uint32_t base_inc = 40;
  uint32_t base_limit = 220;
  uint32_t sig_strength = 0;

  char *buf;
  while (fgets(buf, 100, fp)) {

    printf("[%d] ax %d | buf %s", cycle_count, ax, buf);

    // split line with space
    char *tok = strtok(buf, " ");
    while (tok) {

      // System reporting
      printf("[%d] r %s ", cycle_count, tok);
      if (base <= cycle_count && cycle_count <= base_limit &&
          (cycle_count + base) % base_inc == 0) {
        sig_strength += cycle_count * ax;
        printf("<sig = %d | total = %d>\n", cycle_count * ax, sig_strength);
      }

      if (strcmp(tok, "noop")) {
        // Nothing to do...
      }
      if (strcmp(tok, "addx")) {
        x_dec = 1;
      }

      if (x_dec > 0) {
        x_dec = 0;
        x = strtol(tok, NULL, 10);
        ax += x;
      }

      tok = strtok(NULL, " ");
      cycle_count++;
    }

    printf("\n");
  }

  fclose(fp);

  printf("Total signal strength: %d", sig_strength);

  return 0;
}
