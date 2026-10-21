import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class ReactionTapScreen extends StatefulWidget {
  const ReactionTapScreen({super.key});
  @override
  State<ReactionTapScreen> createState() => _ReactionTapScreenState();
}

class _ReactionTapScreenState extends State<ReactionTapScreen> {
  final random = Random();
  Timer? timer;
  bool waiting = false, ready = false;
  DateTime? started;
  String message = 'Tap Start, then wait for cyan';
  int? result;
  void start() {
    timer?.cancel();
    setState(() {
      waiting = true;
      ready = false;
      result = null;
      message = 'Wait for the color change…';
    });
    timer = Timer(Duration(milliseconds: 900 + random.nextInt(2600)), () {
      if (!mounted) return;
      setState(() {
        waiting = false;
        ready = true;
        started = DateTime.now();
        message = 'TAP NOW!';
      });
    });
  }

  void tap() {
    if (ready) {
      final ms = DateTime.now().difference(started!).inMilliseconds;
      setState(() {
        result = ms;
        ready = false;
        message = '$ms ms — try again!';
      });
    } else if (waiting) {
      timer?.cancel();
      setState(() {
        waiting = false;
        message = 'Too soon! False start.';
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Reaction Tap')),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GestureDetector(
                onTap: tap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ready
                        ? retroCyan
                        : waiting
                        ? retroDanger
                        : retroSurface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Icon(
                      ready ? Icons.bolt : Icons.touch_app,
                      size: 80,
                      color: retroText,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (result != null)
              Text(
                'Reaction: $result ms',
                style: const TextStyle(
                  color: retroYellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            FilledButton(onPressed: start, child: const Text('Start test')),
          ],
        ),
      ),
    ),
  );
}
