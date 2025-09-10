import 'dart:math';
import 'package:flutter/material.dart';

class PrayerProgressWidget extends StatefulWidget {
  final DateTime fajr;
  final DateTime isha;
  final List<DateTime> prayerTimes;

  const PrayerProgressWidget({
    super.key,
    required this.fajr,
    required this.isha,
    required this.prayerTimes,
  });

  @override
  State<PrayerProgressWidget> createState() => _PrayerProgressWidgetState();
}

class _PrayerProgressWidgetState extends State<PrayerProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final totalDuration = widget.isha.difference(widget.fajr).inMinutes;
    final passedDuration = now
        .difference(widget.fajr)
        .inMinutes
        .clamp(0, totalDuration);
    final targetProgress = passedDuration / totalDuration;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // animation duration
    );

    _animation = Tween<double>(
      begin: 0,
      end: targetProgress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return CustomPaint(
          size: const Size(300, 150), // Half circle
          painter: PrayerProgressPainter(
            progress: _animation.value,
            prayerTimes: widget.prayerTimes,
            fajr: widget.fajr,
            isha: widget.isha,
          ),
        );
      },
    );
  }
}

class PrayerProgressPainter extends CustomPainter {
  final double progress;
  final List<DateTime> prayerTimes;
  final DateTime fajr;
  final DateTime isha;

  PrayerProgressPainter({
    required this.progress,
    required this.prayerTimes,
    required this.fajr,
    required this.isha,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orangeAccent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 15;

    final back = Paint()
      ..color = Colors.deepPurple
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 15;

    final rect1 = Rect.fromLTWH(4, 4, size.width, size.height * 2);
    final rect2 = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final startAngle = pi; // Start from left
    final sweepAngle = pi; // Half circle

    // Background arc
    canvas.drawArc(rect1, startAngle, sweepAngle, false, back);
    canvas.drawArc(rect2, startAngle, sweepAngle * progress, false, paint);

    // Prayer dots
    for (var prayer in prayerTimes) {
      final t =
          prayer.difference(fajr).inMinutes / isha.difference(fajr).inMinutes;
      final angle = pi + pi * t;
      final dx = size.width / 2 + (size.width / 2) * cos(angle);
      final dy = size.height + (size.height) * sin(angle);
      canvas.drawCircle(
        Offset(dx + 2, dy + 1),
        7,
        Paint()..color = Colors.black26,
      );

      canvas.drawCircle(
        Offset(dx, dy),
        6,
        Paint()..color = Colors.deepPurpleAccent,
      );

    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
