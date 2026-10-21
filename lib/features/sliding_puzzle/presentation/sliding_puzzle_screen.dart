import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class SlidingPuzzleScreen extends StatefulWidget {
  const SlidingPuzzleScreen({super.key});

  @override
  State<SlidingPuzzleScreen> createState() => _SlidingPuzzleScreenState();
}

class _SlidingPuzzleScreenState extends State<SlidingPuzzleScreen> {
  List<int> tiles = [];
  int moves = 0;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  void _reset() {
    tiles = List.generate(16, (i) => (i + 1) % 16);
    tiles.shuffle(Random());
    moves = 0;
  }

  void tap(int i) {
    final empty = tiles.indexOf(0);
    final r = i ~/ 4;
    final c = i % 4;
    final er = empty ~/ 4;
    final ec = empty % 4;
    if ((r - er).abs() + (c - ec).abs() != 1) return;
    setState(() {
      tiles[empty] = tiles[i];
      tiles[i] = 0;
      moves++;
    });
  }

  bool get solved =>
      List.generate(16, (i) => (i + 1) % 16).toString() == tiles.toString();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Sliding Puzzle')),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text('Moves: $moves', style: const TextStyle(color: retroMuted)),
            const SizedBox(height: 18),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    itemCount: 16,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 7,
                          mainAxisSpacing: 7,
                        ),
                    itemBuilder: (_, i) => InkWell(
                      onTap: () => tap(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: tiles[i] == 0 ? retroBg : retroSurface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: retroCyan.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            tiles[i] == 0 ? '' : '${tiles[i]}',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              color: retroYellow,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (solved)
              const Text(
                'Puzzle solved! 🎉',
                style: TextStyle(color: retroCyan, fontWeight: FontWeight.bold),
              ),
            FilledButton(
              onPressed: () => setState(_reset),
              child: const Text('Shuffle again'),
            ),
          ],
        ),
      ),
    ),
  );
}
