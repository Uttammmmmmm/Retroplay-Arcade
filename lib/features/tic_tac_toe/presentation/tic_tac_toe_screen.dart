import 'package:flutter/material.dart';

import '../../../core/theme.dart';
import '../domain/tic_tac_toe_engine.dart';

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  final engine = TicTacToeEngine();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tic-Tac-Toe')),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'TWO PLAYERS · SAME DEVICE',
              style: TextStyle(
                color: retroCyan,
                fontSize: 11,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Text(
                engine.status,
                key: ValueKey(engine.status),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 9,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemBuilder: (_, i) => InkWell(
                      onTap: () {
                        setState(() => engine.play(i));
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        decoration: BoxDecoration(
                          color: retroSurface,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: AnimatedScale(
                            scale: engine.cells[i].isEmpty ? 0.6 : 1,
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOutBack,
                            child: Text(
                              engine.cells[i],
                              style: TextStyle(
                                fontSize: 54,
                                fontWeight: FontWeight.w900,
                                color: engine.cells[i] == 'X'
                                    ? retroCyan
                                    : retroYellow,
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
            FilledButton.icon(
              onPressed: () => setState(engine.reset),
              icon: const Icon(Icons.replay),
              label: const Text('New round'),
            ),
          ],
        ),
      ),
    ),
  );
}
