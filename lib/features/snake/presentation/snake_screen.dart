import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/storage/local_game_storage.dart';
import '../../../core/theme.dart';
import '../domain/snake_engine.dart';

class SnakeScreen extends StatefulWidget {
  const SnakeScreen({super.key, required this.storage});
  final LocalGameStorage storage;
  @override
  State<SnakeScreen> createState() => _SnakeScreenState();
}

class _SnakeScreenState extends State<SnakeScreen> {
  final engine = SnakeEngine();
  Timer? timer;
  bool running = false;
  int best = 0;
  @override
  void initState() {
    super.initState();
    best = widget.storage.bestScore('snake');
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void start() {
    timer?.cancel();
    setState(() {
      engine.reset();
      running = true;
    });
    timer = Timer.periodic(const Duration(milliseconds: 155), (_) async {
      if (!mounted || !running) return;
      setState(engine.tick);
      if (engine.gameOver) {
        timer?.cancel();
        running = false;
        await widget.storage.saveBestScore('snake', engine.score);
        if (mounted) setState(() => best = widget.storage.bestScore('snake'));
      }
    });
  }

  void pause() {
    setState(() => running = !running);
    if (running) {
      timer?.cancel();
      timer = Timer.periodic(const Duration(milliseconds: 155), (_) async {
        if (!mounted || !running) return;
        setState(engine.tick);
        if (engine.gameOver) {
          timer?.cancel();
          running = false;
          await widget.storage.saveBestScore('snake', engine.score);
          if (mounted) setState(() => best = widget.storage.bestScore('snake'));
        }
      });
    } else {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Snake Classic'),
      actions: [
        IconButton(
          onPressed: pause,
          icon: Icon(running ? Icons.pause : Icons.play_arrow),
        ),
      ],
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _score('SCORE', engine.score)),
                const SizedBox(width: 10),
                Expanded(child: _score('BEST', best)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF071B1A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: retroCyan),
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: engine.size * engine.size,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 18,
                          ),
                      itemBuilder: (_, i) {
                        final p = Point(i % engine.size, i ~/ engine.size);
                        final head = engine.snake.first == p;
                        final isSnake = engine.snake.contains(p);
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 80),
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: isSnake
                                ? (head ? retroYellow : retroCyan)
                                : p == engine.food
                                ? retroDanger
                                : const Color(0xFF102A28),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (!running)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  engine.gameOver
                      ? 'Game over · ${engine.score} points'
                      : 'Tap Start to play',
                  style: const TextStyle(
                    color: retroYellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  onPressed: () =>
                      setState(() => engine.turn(const Point(-1, 0))),
                  icon: const Icon(Icons.arrow_left),
                ),
                Column(
                  children: [
                    IconButton.filledTonal(
                      onPressed: () =>
                          setState(() => engine.turn(const Point(0, -1))),
                      icon: const Icon(Icons.arrow_upward),
                    ),
                    IconButton.filledTonal(
                      onPressed: () =>
                          setState(() => engine.turn(const Point(0, 1))),
                      icon: const Icon(Icons.arrow_downward),
                    ),
                  ],
                ),
                IconButton.filledTonal(
                  onPressed: () =>
                      setState(() => engine.turn(const Point(1, 0))),
                  icon: const Icon(Icons.arrow_right),
                ),
              ],
            ),
            FilledButton.icon(
              onPressed: start,
              icon: const Icon(Icons.replay),
              label: const Text('Start / Restart'),
            ),
          ],
        ),
      ),
    ),
  );
  Widget _score(String label, int value) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: retroSurface,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: retroMuted, fontSize: 10)),
        Text(
          '$value',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
      ],
    ),
  );
}
