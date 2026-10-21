import 'dart:math';

import 'package:flutter/material.dart';

import '../theme.dart';

/// An animated crackers and confetti celebration effect that bursts and rains
/// down from the top of the screen when a level or match is completed.
class CrackersCelebration extends StatefulWidget {
  const CrackersCelebration({
    super.key,
    required this.play,
    this.duration = const Duration(milliseconds: 3800),
    this.onFinished,
  });

  final bool play;
  final Duration duration;
  final VoidCallback? onFinished;

  @override
  State<CrackersCelebration> createState() => _CrackersCelebrationState();
}

class _CrackersCelebrationState extends State<CrackersCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_CrackerParticle> _particles = [];
  final Random _random = Random();

  static const List<Color> _palette = [
    retroCyan,
    retroYellow,
    retroDanger,
    retroPurple,
    Color(0xFFFF85A1),
    Color(0xFFFFD166),
    Color(0xFF06D6A0),
    Color(0xFF118AB2),
    Color(0xFFF72585),
    Colors.white,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFinished?.call();
      }
    });

    if (widget.play) {
      _startCelebration();
    }
  }

  @override
  void didUpdateWidget(covariant CrackersCelebration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.play && !oldWidget.play) {
      _startCelebration();
    } else if (!widget.play && oldWidget.play) {
      _controller.stop();
    }
  }

  void _startCelebration() {
    _createParticles();
    _controller.forward(from: 0.0);
  }

  void _createParticles() {
    _particles.clear();

    // 3 distinct cracker burst origins near the top
    final burstOrigins = [0.22, 0.50, 0.78];

    for (int i = 0; i < 90; i++) {
      final originX =
          burstOrigins[i % burstOrigins.length] +
          (_random.nextDouble() - 0.5) * 0.14;
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 120 + _random.nextDouble() * 320;
      final color = _palette[_random.nextInt(_palette.length)];
      final isRibbon = i % 4 == 0;
      final isSparkle = i % 3 == 0;

      _particles.add(
        _CrackerParticle(
          originX: originX,
          originY: 0.04 + _random.nextDouble() * 0.10,
          vx: cos(angle) * speed,
          vy: -sin(angle).abs() * (speed * 0.8) - 40,
          gravity: 280 + _random.nextDouble() * 240,
          drag: 0.965,
          color: color,
          width: isRibbon
              ? 4.0
              : (isSparkle ? 5.0 : 8.0 + _random.nextDouble() * 4),
          height: isRibbon
              ? 16.0
              : (isSparkle ? 5.0 : 8.0 + _random.nextDouble() * 4),
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 12,
          wobbleSpeed: 4 + _random.nextDouble() * 6,
          isSparkle: isSparkle,
          delayFraction: (i % 3) * 0.08,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.isAnimating && _controller.value == 0) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: _CrackersPainter(
            particles: _particles,
            progress: _controller.value,
          ),
        ),
      ),
    );
  }
}

class _CrackerParticle {
  _CrackerParticle({
    required this.originX,
    required this.originY,
    required this.vx,
    required this.vy,
    required this.gravity,
    required this.drag,
    required this.color,
    required this.width,
    required this.height,
    required this.rotation,
    required this.rotationSpeed,
    required this.wobbleSpeed,
    required this.isSparkle,
    required this.delayFraction,
  });

  final double originX;
  final double originY;
  final double vx;
  final double vy;
  final double gravity;
  final double drag;
  final Color color;
  final double width;
  final double height;
  final double rotation;
  final double rotationSpeed;
  final double wobbleSpeed;
  final bool isSparkle;
  final double delayFraction;
}

class _CrackersPainter extends CustomPainter {
  _CrackersPainter({required this.particles, required this.progress});

  final List<_CrackerParticle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final tTotal = progress;

    for (final p in particles) {
      if (tTotal < p.delayFraction) continue;
      final localProgress =
          (tTotal - p.delayFraction) / (1.0 - p.delayFraction);
      if (localProgress <= 0 || localProgress >= 1.0) continue;

      final tSeconds = localProgress * 3.2;

      // Physics integration
      final currentX =
          size.width * p.originX +
          p.vx * tSeconds * pow(p.drag, tSeconds * 30) +
          sin(tSeconds * p.wobbleSpeed) * 14;

      final currentY =
          size.height * p.originY +
          p.vy * tSeconds +
          0.5 * p.gravity * tSeconds * tSeconds;

      if (currentY > size.height + 40 || currentY < -50) continue;

      // Fade out smoothly towards the end
      final alpha = (1.0 - pow(localProgress, 2.5)).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = p.color.withValues(alpha: alpha.toDouble())
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(currentX, currentY);
      canvas.rotate(p.rotation + p.rotationSpeed * tSeconds);

      if (p.isSparkle) {
        // Starburst sparkle particle with glowing center
        final sparkleRadius = p.width * (1.0 - 0.4 * sin(tSeconds * 12).abs());
        canvas.drawCircle(Offset.zero, sparkleRadius, paint);

        final glowPaint = Paint()
          ..color = p.color.withValues(alpha: (alpha * 0.4).toDouble())
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset.zero, sparkleRadius * 2.2, glowPaint);
      } else {
        // 3D fluttering confetti rectangle
        final wobbleScale = cos(tSeconds * p.wobbleSpeed);
        canvas.scale(1.0, wobbleScale);
        final rect = Rect.fromCenter(
          center: Offset.zero,
          width: p.width,
          height: p.height,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(2)),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _CrackersPainter oldDelegate) => true;
}
