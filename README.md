# 滑块游戏

用下图表示8个滑块（0表示空位）

| 3 | 0 | 4 |
|---|---|---|
| 5 | 2 | 8 |
| 1 | 6 | 7 |

每一步只能将空位相邻的滑块移动到空位上。算法的目标是用尽可能少的步骤将滑块变为如下：

| 1 | 2 | 3 |
|---|---|---|
| 4 | 5 | 6 |
| 7 | 8 | 0 |

输出：

```
2 move up
6 move up
7 move left
8 move down
4 move down
2 move right
6 move up
5 move right
1 move up
7 move left
5 move down
4 move left
2 move down
6 move right
3 move right
1 move up
4 move left
2 move left
6 move down
3 move right
2 move up
5 move up
8 move left
```

## 遗留问题：

在A*算法中，采用曼哈顿距离估算预计距离，因此不一定是最短的路径。

但确实在向尽可能短的方向找，比普通的BFS要快得多。
