#include <assert.h>
#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define die(...)                \
    do {                        \
        printf(__VA_ARGS__);    \
        exit(1);                \
    } while (0)

#define die_error(...) die("error: " __VA_ARGS__)

#define BOARD_SZ 5

typedef struct {
    int number;
    bool marked;
} BoardCell;

typedef struct {
    BoardCell data[BOARD_SZ][BOARD_SZ];
} Board;

void Board_print(Board *b)
{
    for (size_t r = 0; r < BOARD_SZ; ++r) {
        for (size_t c = 0; c < BOARD_SZ; ++c) {
            if (b->data[r][c].marked) {
                printf("[%2d]", b->data[r][c].number);
            } else {
                printf(" %2d ", b->data[r][c].number);
            }
        }
        putchar('\n');
    }
}

void Board_mark(Board *b, int n)
{
    for (size_t r = 0; r < BOARD_SZ; ++r) {
        for (size_t c = 0; c < BOARD_SZ; ++c) {
            if (b->data[r][c].number == n) {
                b->data[r][c].marked = true;
            }
        }
    }
}

bool Board_is_winning(Board *b)
{
    // horizontal lines
    for (size_t r = 0; r < BOARD_SZ; ++r) {
        bool res = true;
        for (size_t c = 0; c < BOARD_SZ; ++c) {
            res &= b->data[r][c].marked;
            if (!res) break;
        }
        if (res) return res;
    }

    // vertical lines
    for (size_t c = 0; c < BOARD_SZ; ++c) {
        bool res = true;
        for (size_t r = 0; r < BOARD_SZ; ++r) {
            res &= b->data[r][c].marked;
            if (!res) break;
        }
        if (res) return res;
    }

    return false;
}

int Board_unmarked_sum(Board *b)
{
    int sum = 0;
    for (size_t r = 0; r < BOARD_SZ; ++r) {
        for (size_t c = 0; c < BOARD_SZ; ++c) {
            if (!b->data[r][c].marked) {
                sum += b->data[r][c].number;
            }
        }
    }
    return sum;
}

void read_puzzle(FILE *fp, int *numbers, size_t nb_numbers, Board *boards, size_t nb_boards)
{
    char buf[1024];
    {
        fgets(buf, sizeof(buf), fp);
        const char *chp = buf;
        for (size_t i = 0; i < nb_numbers; ++i) {
            while (*chp == ' ') ++chp;
            numbers[i] = atoi(chp);
            while (*chp != ',') ++chp;
            ++chp;
        }
    }
    for (size_t i = 0; i < nb_boards; ++i) {
        char *line = fgets(buf, sizeof(buf), fp);
        if (!line) break;
        for (size_t r = 0; r < BOARD_SZ; ++r) {
            const char *chp = fgets(buf, sizeof(buf), fp);
            for (size_t c = 0; c < BOARD_SZ; ++c) {
                while (*chp == ' ') ++chp;
                boards[i].data[r][c].number = atoi(chp);
                boards[i].data[r][c].marked = false;
                while (*chp != ' ') ++chp;
            }
        }
    }
}

int main(int argc, char **argv)
{
    if (argc != 2) {
        die("usage: %s <PUZZLE_FILE>\n", argv[0]);
    }

    const char *path = argv[1];
    FILE *fp = fopen(path, "r");
    if (!fp) {
        die_error("failed to open puzzle file: %s\n", strerror(errno));
    }

    size_t nb_numbers = 1;
    for (;;) {
        char ch = fgetc(fp);
        if (ch == EOF) {
            die_error("expected numbers on first line but found EOF\n");
        } else if (ch == '\n') {
            break;
        } else if (ch == ',') {
            ++nb_numbers;
        }
    }

    size_t nb_boards;
    {
        size_t nb_lines = 1;
        for (;;) {
            char ch = fgetc(fp);
            if (ch == EOF) break;
            if (ch == '\n') ++nb_lines;
        }
        if (nb_lines == 0 || (nb_lines - 1) % 6 != 0) {
            die_error("expected a board after the numbers but found EOF\n");
        }
        rewind(fp);
        nb_boards = (nb_lines - 1) / 6;
    }

    int numbers[nb_numbers];
    Board boards[nb_boards];
    read_puzzle(fp, numbers, nb_numbers, boards, nb_boards);

    fclose(fp);

    printf("[Numbers]\n");
    for (size_t i = 0; i < nb_numbers; ++i) {
        printf("%d", numbers[i]);
        if (i < nb_numbers - 1) putchar(',');
    }

    putchar('\n');
    for (size_t i = 0; i < nb_boards; ++i) {
        printf("\n[Board %zu]\n", i);
        Board_print(&boards[i]);
    }

    size_t nb_winners = 0;
    size_t winners[nb_boards];
    size_t draws[nb_boards];
    {
        for (size_t ni = 0; ni < nb_numbers; ++ni) {
            printf("\nDrawn: %d\n", numbers[ni]);
            for (size_t bi = 0; bi < nb_boards; ++bi) {
                bool present = false;
                for (size_t wi = 0; wi < nb_winners; ++wi) {
                    if (winners[wi] == bi) present = true;
                }
                if (present) continue;

                Board_mark(&boards[bi], numbers[ni]);
                printf("\n[Board %zu]\n", bi);
                Board_print(&boards[bi]);

                if (Board_is_winning(&boards[bi])) {
                    winners[nb_winners] = bi;
                    draws[nb_winners] = numbers[ni];
                    ++nb_winners;
                    printf("\nBoard %zu won.\n", bi);
                }
            }
            if (nb_winners == nb_boards) break;
        }
        putchar('\n');
    }
    if (nb_winners == 0) {
        die("expected to find a winner but found none\n");
    }

    {
        size_t i = 0;
        int unmarked_sum = Board_unmarked_sum(&boards[winners[i]]);
        int last_drawn = draws[i];
        printf("[PART ONE] Winning board: %zu\n", winners[i]);
        printf("[PART ONE] Winner score: %d * %d = %d\n",
                unmarked_sum, last_drawn, unmarked_sum * last_drawn);
        // 50008
    }

    {
        size_t i = nb_winners - 1;
        int unmarked_sum = Board_unmarked_sum(&boards[winners[i]]);
        int last_drawn = draws[i];
        printf("[PART TWO] Last winning board: %zu\n", winners[i]);
        printf("[PART TWO] Last winner score: %d * %d = %d\n",
                unmarked_sum, last_drawn, unmarked_sum * last_drawn);
        // 17408
    }

    return 0;
}
