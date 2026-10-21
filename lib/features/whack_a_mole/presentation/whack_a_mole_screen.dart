import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class WhackAMoleScreen extends StatefulWidget {
  const WhackAMoleScreen({super.key});

  @override
  State<WhackAMoleScreen> createState() => _WhackAMoleScreenState();
}

class _WhackAMoleScreenState extends State<WhackAMoleScreen> {
  final random = Random();
  int active = -1;
  int score = 0;
  int seconds = 30;
  Timer? timer;
  bool playing = false;

  void start() {
    timer?.cancel();
    setState(() {
      score = 0;
      seconds = 30;
      playing = true;
      _next();
    });
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        seconds--;
        _next();
        if (seconds <= 0) {
          playing = false;
          timer?.cancel();
          active = -1;
        }
      });
    });
  }

  void _next() {
    active = random.nextInt(9);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Whack-a-Mole')),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Score $score',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '$seconds s',
                  style: const TextStyle(
                    color: retroYellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: playing && i == active
                      ? () {
                          setState(() {
                            score++;
                            _next();
                          });
                        }
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    decoration: BoxDecoration(
                      color: retroSurface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: i == active ? retroYellow : retroRaised,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: AnimatedScale(
                        scale: i == active ? 1.0 : 0.55,
                        duration: const Duration(milliseconds: 160),
                        child: Text(
                          i == active ? '🐹' : '',
                          style: const TextStyle(fontSize: 43),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            FilledButton(
              onPressed: playing ? null : start,
              child: Text(playing ? 'Game running' : 'Start 30-second round'),
            ),
            if (!playing && seconds == 0)
              Text(
                'Time! Final score: $score',
                style: const TextStyle(
                  color: retroYellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
