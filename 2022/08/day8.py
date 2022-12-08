class Forest:
    def __init__(self, layout: list[list[int]]):
        self.layout = layout

    def size(self) -> int:
        # the forest is a square
        return len(self.layout)

    def is_visible(self, row: int, col: int) -> bool:
        tree = self.layout[row][col]

        maxLeft = max([self.layout[row][c] for c in range(0, col)])
        maxRight = max([self.layout[row][c]
                        for c in range(col + 1, len(self.layout))])
        maxUp = max([self.layout[r][col] for r in range(0, row)])
        maxDown = max([self.layout[r][col]
                       for r in range(row + 1, len(self.layout))])

        return any(map(lambda t: tree > t, [maxLeft, maxRight, maxUp, maxDown]))

    def scenic_score(self, row: int, col: int) -> int:
        tree = self.layout[row][col]

        # even without itertools, is the pain really there?

        visibleLefts = 0
        for c in range(col - 1, -1, -1):
            visibleLefts += 1
            other = self.layout[row][c]
            if other >= tree:
                break

        visibleRights = 0
        for c in range(col + 1, self.size()):
            visibleRights += 1
            other = self.layout[row][c]
            if other >= tree:
                break

        visibleUps = 0
        for r in range(row - 1, -1, -1):
            visibleUps += 1
            other = self.layout[r][col]
            if other >= tree:
                break

        visibleDowns = 0
        for r in range(row + 1, self.size()):
            visibleDowns += 1
            other = self.layout[r][col]
            if other >= tree:
                break

        return visibleLefts * visibleRights * visibleUps * visibleDowns


def main():
    with open(file="./day8.prod", mode="r") as file:
        forest = Forest([line.strip() for line in file])

    # this initial value is the amount of trees already visible from the outside
    count = 2 * forest.size() + 2 * (forest.size() - 2)
    highest_scenic_score = 0

    # loop through the inside of the forest, hence these ranges
    for row in range(1, forest.size() - 1):
        for col in range(1, forest.size() - 1):
            count += 1 if forest.is_visible(row, col) else 0
            highest_scenic_score = max(
                highest_scenic_score, forest.scenic_score(row, col))

    print(count)  # 1693
    print(highest_scenic_score)  # 422059


if __name__ == "__main__":
    main()
