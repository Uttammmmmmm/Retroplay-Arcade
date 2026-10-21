import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme.dart';

class PongScreen extends StatefulWidget {
  const PongScreen({super.key});

  @override
  State<PongScreen> createState() => _PongScreenState();
}

class _PongScreenState extends State<PongScreen> {
  double ballX = 0.5;
  double ballY = 0.5;
  double vx = 0.012;
  double vy = 0.016;
  double paddle = 0.5;
  double enemy = 0.5;
  int player = 0;
  int cpu = 0;
  Timer? timer;
  bool playing = false;

  void start() {
    timer?.cancel();
    setState(() {
      ballX = 0.5;
      ballY = 0.5;
      vx = 0.012;
      vy = 0.016;
      playing = true;
    });
    timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!mounted || !playing) return;
      setState(() {
        ballX += vx;
        ballY += vy;
        if (ballY < 0.03 || ballY > 0.97) vy = -vy;
        if (ballX < 0.08 && (ballY - paddle).abs() < 0.18) vx = vx.abs();
        if (ballX > 0.92 && (ballY - enemy).abs() < 0.18) vx = -vx.abs();
        enemy += (ballY - enemy).clamp(-0.012, 0.012);
        if (ballX < 0) {
          cpu++;
          _resetBall();
        }
        if (ballX > 1) {
          player++;
          _resetBall();
        }
      });
    });
  }

  void _resetBall() {
    ballX = 0.5;
    ballY = 0.5;
    vx = Random().nextBool() ? 0.012 : -0.012;
    vy = Random().nextBool() ? 0.016 : -0.016;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Pong')),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '$player   —   $cpu',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GestureDetector(
                onVerticalDragUpdate: (d) => setState(
                  () => paddle = (paddle + d.delta.dy / 400).clamp(0.12, 0.88),
                ),
                child: LayoutBuilder(
                  builder: (context, c) => CustomPaint(
                    size: Size(c.maxWidth, c.maxHeight),
                    painter: _PongPainter(ballX, ballY, paddle, enemy),
                  ),
                ),
              ),
            ),
            const Text(
              'Drag vertically to move your paddle',
              style: TextStyle(color: retroMuted),
            ),
            FilledButton(
              onPressed: playing
                  ? () {
                      timer?.cancel();
                      setState(() => playing = false);
                    }
                  : start,
              child: Text(playing ? 'Pause' : 'Start game'),
            ),
          ],
        ),
      ),
    ),
  );
}

class _PongPainter extends CustomPainter {
  _PongPainter(this.x, this.y, this.p, this.e);
  final double x, y, p, e;

  @override
  void paint(Canvas c, Size s) {
    final bg = Paint()..color = retroSurface;
    c.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & s, const Radius.circular(14)),
      bg,
    );
    final line = Paint()
      ..color = retroMuted.withValues(alpha: 0.3)
      ..strokeWidth = 2;
    for (double yy = 0; yy < s.height; yy += 18) {
      c.drawLine(Offset(s.width / 2, yy), Offset(s.width / 2, yy + 9), line);
    }
    final cyanPaint = Paint()..color = retroCyan;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(10, p * s.height - s.height * 0.09, 9, s.height * 0.18),
        const Radius.circular(5),
      ),
      cyanPaint,
    );
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          s.width - 19,
          e * s.height - s.height * 0.09,
          9,
          s.height * 0.18,
        ),
        const Radius.circular(5),
      ),
      Paint()..color = retroYellow,
    );
    c.drawCircle(
      Offset(x * s.width, y * s.height),
      8,
      Paint()..color = retroText,
    );
  }

  @override
  bool shouldRepaint(covariant _PongPainter old) => true;
}
