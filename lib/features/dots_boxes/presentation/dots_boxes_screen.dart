import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../domain/dots_boxes_engine.dart';

class DotsBoxesScreen extends StatefulWidget {
  const DotsBoxesScreen({super.key});

  @override
  State<DotsBoxesScreen> createState() => _DotsBoxesScreenState();
}

class _DotsBoxesScreenState extends State<DotsBoxesScreen> {
  final e = DotsBoxesEngine();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Dots & Boxes'),
      actions: [
        IconButton(
          onPressed: () => setState(e.reset),
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _score('PLAYER 1', e.score1)),
                const SizedBox(width: 10),
                Expanded(child: _score('PLAYER 2', e.score2)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Player ${e.player}’s turn',
              style: const TextStyle(
                color: retroCyan,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Column(
                    children: List.generate(9, (ri) {
                      if (ri.isEven) {
                        final r = ri ~/ 2;
                        return Expanded(
                          child: Row(
                            children: List.generate(9, (ci) {
                              if (ci.isEven) {
                                return const Expanded(
                                  child: Center(
                                    child: CircleAvatar(
                                      radius: 5,
                                      backgroundColor: retroYellow,
                                    ),
                                  ),
                                );
                              }
                              final c = ci ~/ 2;
                              final key = e.h(r, c);
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(
                                    () => e.tap(key, [
                                      if (r > 0) e.boxEdges(r - 1, c),
                                      if (r < 4) e.boxEdges(r, c),
                                    ]),
                                  ),
                                  child: Center(
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: e.edges.contains(key)
                                            ? retroCyan
                                            : retroRaised,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      }
                      final r = ri ~/ 2;
                      return Expanded(
                        child: Row(
                          children: List.generate(9, (ci) {
                            if (ci.isEven) {
                              final c = ci ~/ 2;
                              final key = e.v(r, c);
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(
                                    () => e.tap(key, [
                                      if (c > 0) e.boxEdges(r, c - 1),
                                      if (c < 4) e.boxEdges(r, c),
                                    ]),
                                  ),
                                  child: Center(
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      width: 8,
                                      decoration: BoxDecoration(
                                        color: e.edges.contains(key)
                                            ? retroCyan
                                            : retroRaised,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            final c = ci ~/ 2;
                            final owner = e.boxes[e.boxEdges(r, c).join('|')];
                            return Expanded(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: owner == 1
                                      ? retroCyan.withValues(alpha: 0.25)
                                      : owner == 2
                                      ? retroYellow.withValues(alpha: 0.25)
                                      : retroSurface,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    owner == null ? '' : '$owner',
                                    style: TextStyle(
                                      color: owner == 1
                                          ? retroCyan
                                          : retroYellow,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            if (e.boxes.length == 16)
              Text(
                e.score1 == e.score2
                    ? 'Draw!'
                    : e.score1 > e.score2
                    ? 'Player 1 wins!'
                    : 'Player 2 wins!',
                style: const TextStyle(
                  color: retroYellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            FilledButton(
              onPressed: () => setState(e.reset),
              child: const Text('New game'),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _score(String l, int v) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: retroSurface,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l, style: const TextStyle(color: retroMuted, fontSize: 10)),
        Text(
          '$v',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
      ],
    ),
  );
}
