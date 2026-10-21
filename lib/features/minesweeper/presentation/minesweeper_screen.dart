import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class MinesweeperScreen extends StatefulWidget {
  const MinesweeperScreen({super.key});

  @override
  State<MinesweeperScreen> createState() => _MinesweeperScreenState();
}

class _MinesweeperScreenState extends State<MinesweeperScreen> {
  static const n = 8, mines = 10;
  late List<bool> mine, revealed, flagged;
  bool over = false, won = false;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    mine = List.filled(n * n, false);
    revealed = List.filled(n * n, false);
    flagged = List.filled(n * n, false);
    final ids = List<int>.generate(n * n, (i) => i)..shuffle(Random());
    for (final i in ids.take(mines)) {
      mine[i] = true;
    }
    over = false;
    won = false;
  }

  int around(int i) {
    final r = i ~/ n, c = i % n;
    var count = 0;
    for (var dr = -1; dr <= 1; dr++) {
      for (var dc = -1; dc <= 1; dc++) {
        final rr = r + dr, cc = c + dc;
        if (rr >= 0 && rr < n && cc >= 0 && cc < n && mine[rr * n + cc]) {
          count++;
        }
      }
    }
    return count;
  }

  void reveal(int i) {
    if (over || revealed[i] || flagged[i]) return;
    setState(() {
      revealed[i] = true;
      if (mine[i]) {
        over = true;
      } else if (List.generate(
        n * n,
        (j) => j,
      ).where((j) => !mine[j] && !revealed[j]).isEmpty) {
        over = true;
        won = true;
      }
    });
  }

  String _cellText(int i) {
    if (revealed[i]) {
      if (mine[i]) return '✹';
      final a = around(i);
      return a == 0 ? '' : '$a';
    }
    return flagged[i] ? '⚑' : '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Minesweeper'),
      actions: [
        IconButton(
          onPressed: () => setState(_reset),
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(
              over
                  ? (won ? 'Board cleared!' : 'Boom! Try again.')
                  : 'Tap to reveal · Long-press to flag',
              style: TextStyle(
                color: over ? retroYellow : retroMuted,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    itemCount: n * n,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: n,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                    itemBuilder: (_, i) => GestureDetector(
                      onTap: () => reveal(i),
                      onLongPress: () =>
                          setState(() => flagged[i] = !flagged[i]),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 130),
                        decoration: BoxDecoration(
                          color: revealed[i]
                              ? (mine[i] ? retroDanger : retroRaised)
                              : retroSurface,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            _cellText(i),
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: around(i) == 1 ? retroCyan : retroYellow,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            FilledButton(
              onPressed: () => setState(_reset),
              child: const Text('New board'),
            ),
          ],
        ),
      ),
    ),
  );
}
