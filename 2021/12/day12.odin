package main

import "core:fmt"
import "core:log"
import "core:os"
import "core:slice"
import "core:strings"

Cave :: struct {
	name: string,
	kind: CaveKind,
}

CaveKind :: enum {
	Start,
	End,
	Big,
	Small,
}

Cave_new :: proc(name: string) -> (cave: Cave) {
	cave.name = name

	switch name {
	case "start":
		cave.kind = .Start
	case "end":
		cave.kind = .End
	case:
		switch name[0] {
		case 'A' ..= 'Z':
			cave.kind = .Big
		case 'a' ..= 'z':
			cave.kind = .Small
		}
	}

	return cave
}

Puzzle :: struct {
	caves: map[Cave][dynamic]Cave,
	start: Cave,
	end:   Cave,
}

Parse_parse :: proc(data: []u8) -> (puzzle: Puzzle, err: string) {
	lines, err2 := strings.split_lines(string(data))
	if err2 != nil {
		return {}, fmt.aprintf("Failed to split []u8 data into string lines: %v\n", err2)
	}

	for line in lines[:len(lines) - 1] {
		names, err := strings.split(line, "-")
		if err != nil {
			return {}, fmt.aprintf("Failed to split string line string cave names: %v\n", err)
		}

		left, right := Cave_new(names[0]), Cave_new(names[1])
		if left not_in puzzle.caves do puzzle.caves[left] = {}
		if right not_in puzzle.caves do puzzle.caves[right] = {}
		append(&puzzle.caves[left], right)
		append(&puzzle.caves[right], left)

		if puzzle.start == {} {
			if left.kind == .Start {
				puzzle.start = left
			} else if right.kind == .Start {
				puzzle.start = right
			}
		} else if puzzle.end == {} {
			if left.kind == .End {
				puzzle.end = left
			} else if right.kind == .End {
				puzzle.end = right
			}
		}
	}

	return puzzle, ""
}

Puzzle_print_info :: proc(puzzle: ^Puzzle) {
	fmt.printf("Start: %v\n", puzzle.start)
	fmt.printf("End: %v\n", puzzle.end)
	fmt.printf("Caves:\n")
	for key, vals in puzzle.caves {
		fmt.printf("  - %v\n", key)
	}
	fmt.printf("Adjacency:\n")
	for key, vals in puzzle.caves {
		fmt.printf("  - %v: ", key.name)
		for val in vals {
			fmt.printf("%v, ", val.name)
		}
		fmt.printf("\n")
	}
}

PartKind :: enum {
	One,
	Two,
}

Puzzle_paths :: proc(puzzle: ^Puzzle, mode: PartKind) -> (paths: [dynamic][dynamic]Cave) {
	Path :: struct {
		caves: [dynamic]Cave,
		seen:  map[Cave]u8,
		twice: Maybe(Cave),
	}

	will_explore: [dynamic]Path
	switch mode {
	case .One:
		will_explore = {{{puzzle.start}, {puzzle.start = 1}, nil}}
	case .Two:
		will_explore = {}
		for ca in puzzle.caves {
			if ca.kind == .Small {
				twic := Path{{puzzle.start}, {puzzle.start = 1}, ca}
				append(&will_explore, twic)
			}
		}
	}

	for len(will_explore) > 0 {
		path := pop(&will_explore)
		cur := path.caves[len(path.caves) - 1]

		if cur.kind == .End {
			append(&paths, path.caves)
			continue
		}
		path.seen[cur] -= 1

		for adj in puzzle.caves[cur] {
			if adj in path.seen && path.seen[adj] == 0 do continue

			new_path := Path{}
			for ca in path.caves do append(&new_path.caves, ca)
			append(&new_path.caves, adj)
			for se in path.seen {
				new_path.seen[se] = path.seen[se]
			}
			if adj.kind == .Small {
				switch mode {
				case .One:
					new_path.seen[adj] = path.seen[adj] or_else 1
				case .Two:
					if adj == path.twice {
						new_path.seen[adj] = path.seen[adj] or_else 2
					} else {
						new_path.seen[adj] = path.seen[adj] or_else 1
					}
				}
			}
			new_path.twice = path.twice

			append(&will_explore, new_path)
		}
	}

	// I don't know how to unique-ify the paths, so here's a dirty hack
	the_paths := [dynamic][dynamic]Cave{}
	dirty_hack := map[string]bool{}
	for pa in paths {
		st := ""
		for ca in pa {
			st = strings.concatenate({st, fmt.aprintf("%v,", ca)})
		}
		if st not_in dirty_hack {
			dirty_hack[st] = true
			append(&the_paths, pa)
		}
	}

	return the_paths
}

main :: proc() {
	FILE: string : "./puzzle/input.realreal.txt"

	context.logger = log.create_console_logger()

	data, ok := os.read_entire_file_from_filename(FILE)
	if !ok do log.panicf("Failed to read file '%s'\n", FILE)

	puzzle, err := Parse_parse(data)
	if err != {} do log.panicf("Failed to parse puzzle: %v\n", err)

	Puzzle_print_info(&puzzle)
	fmt.println()

	fmt.printf("Part one: %d\n", len(Puzzle_paths(&puzzle, .One)))
	// 3421
	fmt.printf("Part two: %d\n", len(Puzzle_paths(&puzzle, .Two)))
	// 84870
}
