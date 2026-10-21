class TicTacToeEngine {
  List<String> cells = List.filled(9, '');
  String turn = 'X', status = 'Player X starts';
  bool finished = false;
  static const wins = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];
  void play(int i) {
    if (finished || cells[i].isNotEmpty) return;
    cells[i] = turn;
    if (wins.any((line) => line.every((n) => cells[n] == turn))) {
      status = 'Player $turn wins!';
      finished = true;
    } else if (cells.every((c) => c.isNotEmpty)) {
      status = 'It’s a draw!';
      finished = true;
    } else {
      turn = turn == 'X' ? 'O' : 'X';
      status = 'Player $turn’s turn';
    }
  }

  void reset() {
    cells = List.filled(9, '');
    turn = 'X';
    status = 'Player X starts';
    finished = false;
  }
}
