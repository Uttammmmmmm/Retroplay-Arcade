import 'dart:math';

class NumberMergeEngine {
  final _random = Random();
  List<int> board = List.filled(16, 0);
  int score = 0;

  NumberMergeEngine() {
    reset();
  }

  void reset() {
    board = List.filled(16, 0);
    score = 0;
    _spawn();
    _spawn();
  }

  void _spawn() {
    final empty = [
      for (var i = 0; i < 16; i++)
        if (board[i] == 0) i,
    ];
    if (empty.isNotEmpty) {
      board[empty[_random.nextInt(empty.length)]] = _random.nextInt(10) == 0
          ? 4
          : 2;
    }
  }

  List<int> _merge(List<int> line) {
    final values = line.where((v) => v != 0).toList();
    final out = <int>[];
    var i = 0;
    while (i < values.length) {
      if (i + 1 < values.length && values[i] == values[i + 1]) {
        final v = values[i] * 2;
        out.add(v);
        score += v;
        i += 2;
      } else {
        out.add(values[i]);
        i++;
      }
    }
    while (out.length < 4) {
      out.add(0);
    }
    return out;
  }

  bool move(String direction) {
    final before = List<int>.from(board);
    for (var k = 0; k < 4; k++) {
      final ids = List<int>.generate(4, (j) {
        switch (direction) {
          case 'left':
            return k * 4 + j;
          case 'right':
            return k * 4 + 3 - j;
          case 'up':
            return j * 4 + k;
          default:
            return (3 - j) * 4 + k;
        }
      });
      final result = _merge(ids.map((i) => board[i]).toList());
      for (var j = 0; j < 4; j++) {
        board[ids[j]] = result[j];
      }
    }
    final changed = before.toString() != board.toString();
    if (changed) {
      _spawn();
    }
    return changed;
  }

  bool get gameOver {
    if (board.contains(0)) return false;
    for (var r = 0; r < 4; r++) {
      for (var c = 0; c < 4; c++) {
        final v = board[r * 4 + c];
        if (c < 3 && board[r * 4 + c + 1] == v) return false;
        if (r < 3 && board[(r + 1) * 4 + c] == v) return false;
      }
    }
    return true;
  }
}
