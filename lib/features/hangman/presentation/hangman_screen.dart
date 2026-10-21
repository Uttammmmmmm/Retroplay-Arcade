import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class HangmanScreen extends StatefulWidget {
  const HangmanScreen({super.key});
  @override
  State<HangmanScreen> createState() => _HangmanScreenState();
}

class _HangmanScreenState extends State<HangmanScreen> {
  final words = ['FLUTTER', 'ARCADE', 'PIXEL', 'SNAKE', 'RETRO', 'PUZZLE'];
  late String word;
  final Set<String> guesses = {};
  int wrong = 0;
  @override
  void initState() {
    super.initState();
    _new();
  }

  void _new() {
    word = words[Random().nextInt(words.length)];
    guesses.clear();
    wrong = 0;
  }

  bool get won => word.split('').every(guesses.contains);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Hangman')),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(
              'Wrong guesses: $wrong / 6',
              style: const TextStyle(color: retroMuted),
            ),
            const SizedBox(height: 22),
            Text(
              word
                  .split('')
                  .map((c) => guesses.contains(c) ? c : '_')
                  .join(' '),
              style: const TextStyle(
                fontSize: 27,
                letterSpacing: 3,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
                      .split('')
                      .map(
                        (letter) => SizedBox(
                          width: 39,
                          height: 43,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed:
                                guesses.contains(letter) || wrong >= 6 || won
                                ? null
                                : () => setState(() {
                                    guesses.add(letter);
                                    if (!word.contains(letter)) wrong++;
                                  }),
                            child: Text(
                              letter,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            if (won)
              const Text(
                'You got it! 🎉',
                style: TextStyle(color: retroCyan, fontWeight: FontWeight.bold),
              ),
            if (wrong >= 6)
              Text('Word: $word', style: const TextStyle(color: retroDanger)),
            FilledButton(
              onPressed: () => setState(_new),
              child: const Text('New word'),
            ),
          ],
        ),
      ),
    ),
  );
}
