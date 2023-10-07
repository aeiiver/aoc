#!/usr/bin/env php
<?php

class Point
{
    public readonly int $x;
    public readonly int $y;

    public function __construct(int $x, int $y)
    {
        $this->x = $x;
        $this->y = $y;
    }
}

class Puzzle
{
    const PUZZLE_FILE = 'input.real.txt';

    private array $data;
    private array $orig;

    public function __construct()
    {
        $this->data = file(self::PUZZLE_FILE);
        if (! $this->data) {
            exit('failed to read puzzle file');
        }

        foreach ($this->data as &$line) {
            $line = str_split(trim($line));
            foreach ($line as &$octo) {
                $octo = (int)$octo;
            }
        }
        $this->orig = $this->data;
    }

    public function one(): int
    {
        $this->reset();

        $nb_flashes = 0;

        echo "[Initial]\n";
        $this->print();

        for ($step = 1; $step <= 100; ++$step) {
            $nb_flashes += $this->flash_step();

            printf("\n[Step %d / %d]\n", $step, $nb_flashes);
            $this->print();
        }
        return $nb_flashes;
    }

    public function two(): int
    {
        $this->reset();

        echo "[Initial]\n";
        $this->print();

        for ($step = 1;; ++$step) {
            if ($this->flash_step() == $this->size() ** 2) {
                break;
            }
            printf("\n[Step %d]\n", $step);
            $this->print();
        }

        printf("\n[SYNC %d]\n", $step);
        $this->print();

        return $step;
    }

    public function print(): void
    {
        foreach ($this->data as $line) {
            foreach ($line as $octo) {
                echo $octo;
            }
            echo "\n";
        }
    }

    private function reset(): void
    {
        $this->data = $this->orig;
    }

    private function flash_step(): int
    {
        $nb_flashes = 0;
        $will_flash = [];
        $flashed = [];

        for ($y = 0; $y < $this->size(); ++$y) {
            for ($x = 0; $x < $this->size(); ++$x) {
                $this->data[$y][$x] += 1;

                if ($this->data[$y][$x] > 9) {
                    $pt = new Point($x, $y);
                    $will_flash[] = $pt;
                    $flashed[] = $pt;
                }
            }
        }
        while (count($will_flash) > 0) {
            $pt = array_shift($will_flash);
            $this->data[$pt->y][$pt->x] = 0;
            $nb_flashes += 1;

            foreach ($this->neighbors($pt) as $n) {
                if (!in_array($n, $flashed)) {
                    $this->data[$n->y][$n->x] += 1;
                }
                if ($this->data[$n->y][$n->x] > 9 && !in_array($n, $flashed)) {
                    $will_flash[] = $n;
                    $flashed[] = $n;
                }
            }
        }
        return $nb_flashes;
    }

    private function neighbors(Point $pt): array
    {
        $neighbors = [];
        if ($pt->x > 0) { $neighbors[] = new Point($pt->x - 1, $pt->y);
        }
        if ($pt->x < $this->size() - 1) { $neighbors[] = new Point($pt->x + 1, $pt->y);
        }
        if ($pt->y > 0) { $neighbors[] = new Point($pt->x, $pt->y - 1);
        }
        if ($pt->y < $this->size() - 1) { $neighbors[] = new Point($pt->x, $pt->y + 1);
        }
        if ($pt->x > 0                 && $pt->y > 0) { $neighbors[] = new Point($pt->x - 1, $pt->y - 1);
        }
        if ($pt->x < $this->size() - 1 && $pt->y > 0) { $neighbors[] = new Point($pt->x + 1, $pt->y - 1);
        }
        if ($pt->x > 0                 && $pt->y < $this->size() - 1) { $neighbors[] = new Point($pt->x - 1, $pt->y + 1);
        }
        if ($pt->x < $this->size() - 1 && $pt->y < $this->size() - 1) { $neighbors[] = new Point($pt->x + 1, $pt->y + 1);
        }
        return $neighbors;
    }

    private function size(): int
    {
        return count($this->data);
    }
}

$puzzle = new Puzzle();

echo "\nOne: " . $puzzle->one() . "\n";
// 1686
echo "\nTwo: " . $puzzle->two() . "\n";
// 360
