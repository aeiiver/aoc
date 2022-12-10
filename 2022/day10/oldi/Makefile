CC = gcc
OUT = ./day10.out

run: day10
	$(OUT)

debug: day10_debug
	gdb $(OUT)

day10_debug: day10.o
	$(CC) -o $(OUT) -g ./day10.o

day10: day10.o
	$(CC) -o $(OUT) ./day10.o

day10.o: day10.c
	$(CC) -c ./day10.c

clean:
	rm *.o *.out
