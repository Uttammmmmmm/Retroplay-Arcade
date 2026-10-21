import 'dart:math';

class SnakeEngine {
  SnakeEngine({this.size = 18}) {
    reset();
  }
  final int size;
  late List<Point<int>> snake;
  late Point<int> food;
  Point<int> direction = const Point(1, 0);
  int score = 0;
  bool gameOver = false;
  void reset() {
    snake = [
      Point(size ~/ 2, size ~/ 2),
      Point(size ~/ 2 - 1, size ~/ 2),
      Point(size ~/ 2 - 2, size ~/ 2),
    ];
    direction = const Point(1, 0);
    food = Point(size * 2 ~/ 3, size ~/ 2);
    score = 0;
    gameOver = false;
  }

  void turn(Point<int> next) {
    if (next.x == -direction.x && next.y == -direction.y) return;
    direction = next;
  }

  void tick() {
    if (gameOver) return;
    final head = Point(
      snake.first.x + direction.x,
      snake.first.y + direction.y,
    );
    final eats = head == food;
    final collisionBody = eats ? snake : snake.take(snake.length - 1).toList();
    if (head.x < 0 ||
        head.y < 0 ||
        head.x >= size ||
        head.y >= size ||
        collisionBody.contains(head)) {
      gameOver = true;
      return;
    }
    snake = [head, ...snake];
    if (!eats) {
      snake.removeLast();
      return;
    }
    score += 10;
    final free = <Point<int>>[];
    for (var y = 0; y < size; y++) {
      for (var x = 0; x < size; x++) {
        final p = Point(x, y);
        if (!snake.contains(p)) free.add(p);
      }
    }
    if (free.isNotEmpty) food = free[Random().nextInt(free.length)];
  }
}
