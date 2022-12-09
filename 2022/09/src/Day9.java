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
public class Day9 {
    private static final String PROBLEM_INPUT = "src/day9.prod";

    public static void main(String[] args) throws Exception {

        List<Move> headMoves;
        try (BufferedReader br = new BufferedReader(new FileReader(PROBLEM_INPUT))) {
            headMoves = br.lines().map(line -> {
                String[] split = line.split(" ");

                Direction direction = Direction.valueOf(split[0]);
                int distance = Integer.valueOf(split[1]);

                return new Move(direction, distance);
            })
                    .toList();
        }

        Solver solver = new Solver(headMoves);

        System.out.println(solver.solve(2)); // 6011
        System.out.println(solver.solve(10)); // 2419
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

            // horizontal movement
            if (Math.abs(dx) > 1 && dy == 0) {
                position = new Position(position.x + Integer.signum(dx), position.y);
            }
            // vertical movement
            else if (Math.abs(dy) > 1 && dx == 0) {
                position = new Position(position.x, position.y + Integer.signum(dy));
            }
            // diagonal movement
            else if (Math.abs(dx) + Math.abs(dy) > 2) {
                position = new Position(position.x + Integer.signum(dx), position.y + Integer.signum(dy));
            }
        }
    }

    private static class Solver {
        private List<Move> headMoves;

        public Solver(List<Move> headMoves) {
            this.headMoves = headMoves;
        }

        public int solve(int numberOfKnots) {
            Deque<Knot> knots = new ArrayDeque<>();
            Set<Position> visited = new HashSet<>();

            for (int step = 0; step < numberOfKnots; ++step) {
                if (knots.isEmpty())
                    knots.add(new Knot(0, 0, null));
                else
                    knots.add(new Knot(0, 0, knots.getLast()));
            }
            visited.add(new Position(0, 0));

            Knot head = knots.getFirst();
            Knot tail = knots.getLast();

            headMoves.forEach(move -> {
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
