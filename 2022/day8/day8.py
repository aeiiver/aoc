def main():
    with open(file="./day8.prod", mode="r") as file:
        tree_layout = [line.strip() for line in file]

    count = 2 * len(tree_layout) + 2 * (len(tree_layout) - 2)
    highest_scenic_score = 0

    for row in range(1, len(tree_layout) - 1):
        for col in range(1, len(tree_layout) - 1):
            count += 1 if is_visible(tree_layout, row, col) else 0
            highest_scenic_score = max(highest_scenic_score, scenic_score(tree_layout, row, col))

    print(count) # 1693
    print(highest_scenic_score) # 422059

def is_visible(tree_layout, row, col):
    tree = tree_layout[row][col]

    maxLeft = max([tree_layout[row][c] for c in range(0, col)])
    maxRight = max([tree_layout[row][c] for c in range(col + 1, len(tree_layout))])
    maxUp = max([tree_layout[r][col] for r in range(0, row)])
    maxDown = max([tree_layout[r][col] for r in range(row + 1, len(tree_layout))])
    
    return any(map(lambda t: tree > t, [maxLeft, maxRight, maxUp, maxDown]))

def scenic_score(tree_layout, row, col):
    tree = tree_layout[row][col]
    
    # without itertools, is the pain really there?

    visibleLefts = 0
    for c in range(col - 1, -1, -1):
        visibleLefts += 1
        if (tree_layout[row][c]) >= tree:
            break

    visibleRights = 0
    for c in range(col + 1, len(tree_layout)):
        visibleRights += 1
        if (tree_layout[row][c]) >= tree:
            break

    visibleUps = 0
    for r in range(row - 1, -1, -1):
        visibleUps += 1
        if (tree_layout[r][col]) >= tree:
            break

    visibleDowns = 0
    for r in range(row + 1, len(tree_layout)):
        visibleDowns += 1
        if (tree_layout[r][col]) >= tree:
            break

    return visibleLefts * visibleRights * visibleUps * visibleDowns

if __name__ == "__main__":
    main()
