import 'package:flutter_test/flutter_test.dart';
import 'package:retroplay_arcade/features/tic_tac_toe/domain/tic_tac_toe_engine.dart';
import 'package:retroplay_arcade/features/number_merge/domain/number_merge_engine.dart';

void main() {
  test('tic tac toe detects a row win', () {
    final game = TicTacToeEngine();
    game.play(0);
    game.play(3);
    game.play(1);
    game.play(4);
    game.play(2);
    expect(game.finished, isTrue);
    expect(game.status, 'Player X wins!');
  });

  test('number merge starts with two tiles', () {
    final game = NumberMergeEngine();
    expect(game.board.where((v) => v != 0).length, 2);
  });
}
