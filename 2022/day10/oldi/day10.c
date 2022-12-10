/**
 * Second attempt at solving the puzzle with C.
 * 
 * Status: Unsuccessful
 *
 * The language is really confusing. At this point, I found that Rust was easier to learn, but I might
 * be biased... Mind you, I've already touched some C code, so it's definetely not my first time here...
 */

#define __STDC_WANT_LIB_EXT1__ 1
#define _GNU_SOURCE

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Node {
  int x;
  int end_cycle;
  struct Node *prev;
  struct Node *next;
};

// NULL <- head <- some nodes... <- tail <- NULL
struct Node *head = NULL;
struct Node *tail = NULL;

// NULL <- *new_head* <- head <- some nodes... <- tail <- NULL
void enqueue(int x, int end_cycle) {
  struct Node *new_head = malloc(sizeof(struct Node));
  new_head->x = x;
  new_head->end_cycle = end_cycle;
  new_head->prev = NULL;
  new_head->next = NULL;

  if (head == NULL) {
    head = new_head;
    tail = new_head;
    return;
  }

  new_head->prev = head;
  head->next = new_head;
  head = new_head;
}

// NULL <- head <- some nodes... <- *new_tail* <- tail <- NULL
struct Node *dequeue() {
  if (tail == NULL) {
    perror("Tried to dequeue but there is to tail to dequeue...");
    return NULL;
  }

  struct Node *dequeued = tail;
  struct Node *new_tail = tail->next;
  new_tail->prev = NULL;
  tail->next = NULL;
  tail = new_tail;

  return dequeued;
}

int queue_empty() { return tail == NULL; }

int main() {
  FILE *fp;
  int error = fopen_s(&fp, "./day10.test", "r");

  if (error != 0) {
    perror("Failed to read file...\n");
    return 1;
  }

  uint32_t cycle_count = 0;
  uint32_t accumulated_x = 1; // accumulated x
  uint32_t x = 0;             // the "x" that is read from the buffer
  uint8_t queue_flag = 0;

  uint32_t base = 20;
  uint32_t base_offset = 40;
  uint32_t base_limit = 220;
  uint32_t signal_strength = 0;

  char *buffer;
  while (fgets(buffer, 100, fp)) {

    printf("%s", buffer);
  }

  fclose(fp);

  printf("Total signal strength: %d", signal_strength);

  return 0;
}
