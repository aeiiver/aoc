package main

import (
	"bytes"
	"fmt"
	"os"
	"strconv"
)

const (
	matRock = '#'
	matAir  = '.'
	matSrc  = '+'
	matSand = 'o'
)

func noErr[T any](value T, err error) T {
	if err != nil {
		fmt.Printf("error: %s\n", err.Error())
		os.Exit(1)
	}
	return value
}

const (
	dirUp    = iota
	dirDown  = iota
	dirLeft  = iota
	dirRight = iota
)

type point struct {
	x, y uint32
}

type pointDiff struct {
	dx, dy     uint32
	xdir, ydir int
}

func diffPoint(a, b point) pointDiff {
	var dx, dy uint32
	var xdir, ydir int

	if a.x > b.x {
		dx = a.x - b.x
		xdir = 1
	} else {
		dx = b.x - a.x
		xdir = -1
	}
	if a.y > b.y {
		dy = a.y - b.y
		ydir = 1
	} else {
		dy = b.y - a.y
		ydir = -1
	}

	return pointDiff{
		dx:   dx,
		dy:   dy,
		xdir: xdir,
		ydir: ydir,
	}
}

type path struct {
	points []point
}

type scanMap struct {
	xMin, xMax uint32
	yMin, yMax uint32
	xSrc, ySrc uint32
	data       [][]uint32
}

func (sm *scanMap) print() {
	fmt.Print(" ")
	for i := 0; i <= int(sm.xMax-sm.xMin); i += 1 {
		fmt.Printf("%2d", i)
	}
	fmt.Println()
	for ri, r := range sm.data {
		fmt.Printf("%2d", ri)
		for _, c := range r {
			fmt.Printf("%2c", c)
		}
		fmt.Println()
	}
}

func parse(puzzle []byte) (scanMap, error) {
	var xMin, xMax uint32
	var yMax uint32

	paths := []path{}
	lines := bytes.Split(puzzle, []byte{'\n'})
	lines = lines[:len(lines)-1]
	first_iter := true

	for _, line := range lines {
		p := path{points: []point{}}
		pts := bytes.Split(line, []byte{' ', '-', '>', ' '})

		for _, pt := range pts {
			xy := bytes.Split(pt, []byte{','})
			x := uint32(noErr(strconv.Atoi(string(xy[0]))))
			y := uint32(noErr(strconv.Atoi(string(xy[1]))))

			p.points = append(p.points, point{x: x, y: y})

			if first_iter {
				xMin, xMax = x, x
				yMax = y
				first_iter = false
			} else {
				xMin, xMax = min(xMin, x), max(xMax, x)
				yMax = max(yMax, y)
			}
		}
		paths = append(paths, p)
	}

	data := make([][]uint32, yMax+1)
	for r := range data {
		data[r] = make([]uint32, xMax-xMin+1)
		for c := range data[r] {
			data[r][c] = matAir
		}
	}

	data[0][500-xMin] = matSrc

	for _, p := range paths {
		prev := p.points[0]
		for _, pt := range p.points[1:] {
			d := diffPoint(pt, prev)
			if d.dx > 0 {
				for i := 0; i <= int(d.dx); i += 1 {
					nx := int(prev.x) + (i * d.xdir) - int(xMin)
					if nx < 0 || nx >= int(xMax) {
						continue
					}
					data[pt.y][nx] = matRock
				}
			} else {
				for i := 0; i < int(d.dy); i += 1 {
					data[int(prev.y)+(i*d.ydir)][int(pt.x)-int(xMin)] = matRock
				}
			}
			prev = pt
		}
	}

	sm := scanMap{
		xMin: xMin,
		xMax: xMax,
		yMin: 0,
		yMax: yMax,
		xSrc: 500 - xMin,
		ySrc: 0,
		data: data,
	}

	return sm, nil
}

func fallSand(sm scanMap) int {
	step := 0
fall:
	for ; ; step += 1 {
		x := sm.xSrc
		y := sm.ySrc
		for {
			if x <= 0 || x > sm.xMax-sm.xMin || y > sm.yMax-sm.yMin {
				break fall
			}
			if sm.data[y+1][x] == matAir {
				y += 1
				continue
			}
			if sm.data[y+1][x-1] == matAir {
				x -= 1
				y += 1
				continue
			}
			if sm.data[y+1][x+1] == matAir {
				x += 1
				y += 1
				continue
			}
			break
		}
		sm.data[y][x] = matSand

		fmt.Printf("\n[State %d]\n", step)
		sm.print()
	}
	fmt.Println()
	return step
}

func main() {
	if len(os.Args) != 2 {
		fmt.Printf("usage: %s <FILE>\n", os.Args[0])
		os.Exit(1)
	}

	path := os.Args[1]
	puzzle := noErr(os.ReadFile(path))

	scanMap := noErr(parse(puzzle))
	fmt.Println("[Scan map]")
	scanMap.print()

	steps := fallSand(scanMap)
	fmt.Printf("Part one fall steps: %d\n", steps)
}
