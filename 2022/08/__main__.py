class Forest:
    def __init__(self, layout: list[list[int]]):
        self.layout = layout

    def rows(self) -> int:
        return len(self.layout)

    def cols(self) -> int:
        return len(self.layout[0])

    def is_visible(self, row: int, col: int) -> bool:
        if (
            row == 0
            or row == self.rows() - 1
            or col == 0
            or col == self.cols() - 1
        ):
            return True

        layout = self.layout
        maxLeft = max([layout[row][c] for c in range(0, col)])
        maxRight = max([layout[row][c] for c in range(col + 1, len(layout))])
        maxUp = max([layout[r][col] for r in range(0, row)])
        maxDown = max([layout[r][col] for r in range(row + 1, len(layout))])

        return (
            layout[row][col] > maxLeft
            or layout[row][col] > maxRight
            or layout[row][col] > maxUp
            or layout[row][col] > maxDown
        )

    def scenic_score(self, row: int, col: int) -> int:
        tree = self.layout[row][col]

        # come on, even without itertools, is the pain really there?

        visibleLefts = 0
        for c in range(col - 1, -1, -1):
            visibleLefts += 1
            other = self.layout[row][c]
            if other >= tree:
                break

        visibleRights = 0
        for c in range(col + 1, self.cols()):
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
        for r in range(row + 1, self.rows()):
            visibleDowns += 1
            other = self.layout[r][col]
            if other >= tree:
                break

        return visibleLefts * visibleRights * visibleUps * visibleDowns


def main():
    with open('./input-prod', mode='r') as fp:
        forest = Forest([line.strip() for line in fp])

    count = 0
    scenic_max = 0

    for row in range(forest.rows()):
        for col in range(forest.cols()):
            count += 1 if forest.is_visible(row, col) else 0
            scenic_max = max(scenic_max, forest.scenic_score(row, col))

    # 1693
    print(count)

    # 422059
    print(scenic_max)


if __name__ == '__main__':
    main()
