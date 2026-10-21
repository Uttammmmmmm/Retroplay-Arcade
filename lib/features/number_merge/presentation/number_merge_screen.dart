import 'package:flutter/material.dart';

import '../../../core/storage/local_game_storage.dart';
import '../../../core/theme.dart';
import '../domain/number_merge_engine.dart';

class NumberMergeScreen extends StatefulWidget {
  const NumberMergeScreen({super.key, required this.storage});

  final LocalGameStorage storage;

  @override
  State<NumberMergeScreen> createState() => _NumberMergeScreenState();
}

class _NumberMergeScreenState extends State<NumberMergeScreen> {
  late NumberMergeEngine e;
  int best = 0;
  Offset? start;

  @override
  void initState() {
    super.initState();
    e = NumberMergeEngine();
    best = widget.storage.bestScore('number_merge');
  }

  void move(String d) async {
    setState(() => e.move(d));
    await widget.storage.saveBestScore('number_merge', e.score);
    if (mounted) {
      setState(() => best = widget.storage.bestScore('number_merge'));
    }
  }

  Color tile(int v) =>
      ({
        0: retroSurface,
        2: const Color(0xFFEEE8DA),
        4: const Color(0xFFE5D8B8),
        8: const Color(0xFFFFB86B),
        16: const Color(0xFFFF9566),
        32: retroDanger,
        64: const Color(0xFFDF5C86),
        128: retroYellow,
        256: const Color(0xFFE8BC4D),
        512: const Color(0xFFB89CFF),
        1024: retroPurple,
        2048: retroCyan,
      })[v] ??
      retroPurple;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Number Merge')),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _score('SCORE', e.score)),
                const SizedBox(width: 10),
                Expanded(child: _score('BEST', best)),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'Swipe to merge matching tiles',
              style: TextStyle(color: retroMuted),
            ),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GestureDetector(
                    onPanStart: (d) => start = d.localPosition,
                    onPanEnd: (d) {
                      if (start == null) return;
                      final delta = d.localPosition - start!;
                      if (delta.dx.abs() > delta.dy.abs()) {
                        move(delta.dx > 0 ? 'right' : 'left');
                      } else {
                        move(delta.dy > 0 ? 'down' : 'up');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: retroRaised,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 16,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 7,
                              mainAxisSpacing: 7,
                            ),
                        itemBuilder: (_, i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeOutBack,
                          decoration: BoxDecoration(
                            color: tile(e.board[i]),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Center(
                            child: Text(
                              e.board[i] == 0 ? '' : '${e.board[i]}',
                              style: TextStyle(
                                fontSize: e.board[i] >= 1024 ? 17 : 23,
                                fontWeight: FontWeight.w900,
                                color: e.board[i] <= 4 && e.board[i] != 0
                                    ? retroBg
                                    : retroText,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (e.gameOver)
              const Text(
                'No moves left!',
                style: TextStyle(
                  color: retroYellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            FilledButton.icon(
              onPressed: () => setState(() => e.reset()),
              icon: const Icon(Icons.replay),
              label: const Text('New game'),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _score(String l, int v) => Container(
    padding: const EdgeInsets.all(13),
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
