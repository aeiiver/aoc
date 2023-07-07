package nuts.deez;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * I am really sorry but Java had to come in my playground at some point...
 * Single file programming with Java was a bad idea...
 */
public class App {
    private static final String INPUT = "./src/main/java/nuts/deez/input-prod";

    public static void main(String[] args) throws Exception {
        List<Move> moves;

        try (BufferedReader reader = new BufferedReader(new FileReader(INPUT))) {
            moves = reader
                    .lines()
                    .map(line -> {
                        String[] chunks = line.split(" ");
                        Direction direction = Direction.valueOf(chunks[0]);
                        int distance = Integer.valueOf(chunks[1]);
                        return new Move(direction, distance);
                    })
                    .toList();
        }

        Day09 day09 = new Day09(moves);

        System.out.println(day09.solve(2)); // 6011
        System.out.println(day09.solve(10)); // 2419
    }

    private static enum Direction {
        U(0, 1), D(0, -1), L(-1, 0), R(1, 0);

        private int dx;
        private int dy;

        private Direction(int dx, int dy) {
            this.dx = dx;
            this.dy = dy;
        }
    }

    // I heard you liked using structs...
    private static record Move(Direction direction, int distance) {
    }

    private static record Position(int x, int y) {
    }

    private static class Knot {
        private Position position;
        private Knot next;

        public Knot(int x, int y, Knot next) {
            this.position = new Position(x, y);
            this.next = next;
        }

        public Knot(int x, int y) {
            this.position = new Position(x, y);
            this.next = null;
        }

        public Position position() {
            return position;
        }

        public void move(Direction direction) {
            position = new Position(position.x() + direction.dx, position.y() + direction.dy);
        }

        public void update() {
            if (next == null)
                return;

            int dx = next.position.x - position.x;
            int dy = next.position.y - position.y;

            // Horizontal
            if (Math.abs(dx) > 1 && dy == 0) {
                position = new Position(position.x + Integer.signum(dx), position.y);
            }
            // Vertical
            else if (Math.abs(dy) > 1 && dx == 0) {
                position = new Position(position.x, position.y + Integer.signum(dy));
            }
            // Diagonal
            else if (Math.abs(dx) + Math.abs(dy) > 2) {
                position = new Position(position.x + Integer.signum(dx), position.y + Integer.signum(dy));
            }
        }
    }

    private static class Day09 {
        private List<Move> moves;

        public Day09(List<Move> moves) {
            this.moves = moves;
        }

        public int solve(int numberOfKnots) {
            Deque<Knot> knots = new ArrayDeque<>();
            Set<Position> visited = new HashSet<>();

            visited.add(new Position(0, 0));
            knots.add(new Knot(0, 0));
            for (int step = 1; step < numberOfKnots; ++step) {
                knots.add(new Knot(0, 0, knots.getLast()));
            }

            Knot head = knots.getFirst();
            Knot tail = knots.getLast();

            moves.forEach(move -> {
                for (int step = 0; step < move.distance; ++step) {
                    head.move(move.direction);
                    knots.stream().forEach(knot -> knot.update());
                    visited.add(tail.position());
                }
            });
            return visited.size();
        }
    }
}
