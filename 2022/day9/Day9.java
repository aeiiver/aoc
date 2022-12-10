import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * I am really sorry but Java had to come in my playground at some point...
 */
public class Day9 {

    public static void main(String[] args) throws Exception {

        Function<String, HeadMovement> lineToObj = line -> {
            String[] split = line.split(" ");
            return new HeadMovement(MovementType.valueOf(split[0]), Integer.valueOf(split[1]));
        };

        BufferedReader br = new BufferedReader(new FileReader("./day9.prod"));
        ArrayList<HeadMovement> headMoves = (ArrayList<HeadMovement>) br.lines().map(lineToObj)
                .collect(Collectors.toList());
        br.close();

        Solver solver = new Solver(headMoves);

        System.out.println(solver.solve(2)); // 6011
        System.out.println(solver.solve(10)); // 2419
    }

    private static enum MovementType {
        U(0, 1), D(0, -1), L(-1, 0), R(1, 0);

        private int dx;
        private int dy;

        private MovementType(int dx, int dy) {
            this.dx = dx;
            this.dy = dy;
        }
    }

    private static record HeadMovement(MovementType type, int distance) {
    }

    private static record Position(int x, int y) {
        @Override
        public int hashCode() {
            return 0;
        }

        @Override
        public boolean equals(Object obj) {
            return ((Position) obj).x == x && ((Position) obj).y == y;
        }

        @Override
        public String toString() {
            return String.format("(%d, %d)", x, y);
        }
    }

    private static class Knot {
        protected int x;
        protected int y;
        protected Optional<Knot> next;

        public Knot(int x, int y, Knot next) {
            this.x = x;
            this.y = y;
            this.next = (next == null) ? Optional.empty() : Optional.of(next);
        }

        public Position position() {
            return new Position(x, y);
        }

        public void movePosition(int dx, int dy) {
            x += dx;
            y += dy;
        }

        public void updatePosition() {
            if (next.isEmpty())
                return;

            Knot safeNext = next.get();
            int dx = safeNext.x - x;
            int dy = safeNext.y - y;

            if (Math.abs(dx) > 1 && dy == 0)
                x += Integer.signum(dx);

            else if (Math.abs(dy) > 1 && dx == 0) {
                y += Integer.signum(dy);
            }

            else if (Math.abs(dx) + Math.abs(dy) > 2) {
                x += Integer.signum(dx);
                y += Integer.signum(dy);
            }
        }
    }

    private static class Solver {
        ArrayList<HeadMovement> headMoves;

        public Solver(ArrayList<HeadMovement> headMoves) {
            this.headMoves = headMoves;
        }

        public int solve(int numberOfKnots) {
            ArrayDeque<Knot> knots = new ArrayDeque<>();
            HashSet<Position> visited = new HashSet<>();

            for (int step = 0; step < numberOfKnots; step++) {
                if (knots.isEmpty())
                    knots.add(new Knot(0, 0, null));
                else
                    knots.add(new Knot(0, 0, knots.getLast()));
            }
            visited.add(new Position(0, 0));

            Knot head = knots.getFirst();
            Knot tail = knots.getLast();

            headMoves.forEach(move -> {
                for (int step = 0; step < move.distance; step++) {
                    head.movePosition(move.type.dx, move.type.dy);
                    knots.stream().forEachOrdered(knot -> knot.updatePosition());
                    visited.add(tail.position());
                }
            });
            return visited.size();
        }
    }

}
