import 'dart:math' as math;
import 'package:flutter/material.dart';

class ConcentricProgress extends StatefulWidget {
  final double size;
  final double outerProgress;
  final double middleProgress;
  final double innerProgress;
  final double innermostProgress; // NEW

  final Color outerColor;
  final Color middleColor;
  final Color innerColor;
  final Color innermostColor; // NEW

  final List<double> strokeWidths; // [outer, middle, inner, innermost]
  final Duration duration;
  final Widget? centerWidget;

  const ConcentricProgress({
    Key? key,
    this.size = 200,
    required this.outerProgress,
    required this.middleProgress,
    required this.innerProgress,
    required this.innermostProgress, // NEW
    this.outerColor = Colors.blue,
    this.middleColor = Colors.orange,
    this.innerColor = Colors.green,
    this.innermostColor = Colors.purple, // NEW
    this.strokeWidths = const [14, 10, 6, 4], // NEW
    this.duration = const Duration(milliseconds: 600),
    this.centerWidget,
  })  : assert(strokeWidths.length == 4),
        super(key: key);

  @override
  State<ConcentricProgress> createState() => _ConcentricProgressState();
}

class _ConcentricProgressState extends State<ConcentricProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _outerAnim;
  late Animation<double> _middleAnim;
  late Animation<double> _innerAnim;
  late Animation<double> _innermostAnim; // NEW

  double _lastOuter = 0;
  double _lastMiddle = 0;
  double _lastInner = 0;
  double _lastInnermost = 0; // NEW

  @override
  void initState() {
    super.initState();
    _lastOuter = widget.outerProgress.clamp(0.0, 1.0);
    _lastMiddle = widget.middleProgress.clamp(0.0, 1.0);
    _lastInner = widget.innerProgress.clamp(0.0, 1.0);
    _lastInnermost = widget.innermostProgress.clamp(0.0, 1.0); // NEW

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _setupAnimations();
    _controller.forward();
  }

  void _setupAnimations() {
    _outerAnim = Tween<double>(begin: _lastOuter, end: widget.outerProgress.clamp(0.0, 1.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _middleAnim = Tween<double>(begin: _lastMiddle, end: widget.middleProgress.clamp(0.0, 1.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _innerAnim = Tween<double>(begin: _lastInner, end: widget.innerProgress.clamp(0.0, 1.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _innermostAnim = Tween<double>(begin: _lastInnermost, end: widget.innermostProgress.clamp(0.0, 1.0)) // NEW
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void didUpdateWidget(covariant ConcentricProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    _lastOuter = _outerAnim.value;
    _lastMiddle = _middleAnim.value;
    _lastInner = _innerAnim.value;
    _lastInnermost = _innermostAnim.value; // NEW

    _controller.duration = widget.duration;
    _controller.reset();

    _outerAnim = Tween<double>(begin: _lastOuter, end: widget.outerProgress.clamp(0.0, 1.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _middleAnim = Tween<double>(begin: _lastMiddle, end: widget.middleProgress.clamp(0.0, 1.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _innerAnim = Tween<double>(begin: _lastInner, end: widget.innerProgress.clamp(0.0, 1.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _innermostAnim = Tween<double>(begin: _lastInnermost, end: widget.innermostProgress.clamp(0.0, 1.0)) // NEW
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _ConcentricPainter(
              outerProgress: _outerAnim.value,
              middleProgress: _middleAnim.value,
              innerProgress: _innerAnim.value,
              innermostProgress: _innermostAnim.value, // NEW
              outerColor: widget.outerColor,
              middleColor: widget.middleColor,
              innerColor: widget.innerColor,
              innermostColor: widget.innermostColor, // NEW
              strokeWidths: widget.strokeWidths,
            ),
            child: Center(child: widget.centerWidget ?? const SizedBox.shrink()),
          );
        },
      ),
    );
  }
}

class _ConcentricPainter extends CustomPainter {
  final double outerProgress;
  final double middleProgress;
  final double innerProgress;
  final double innermostProgress; // NEW

  final Color outerColor;
  final Color middleColor;
  final Color innerColor;
  final Color innermostColor; // NEW

  final List<double> strokeWidths;

  _ConcentricPainter({
    required this.outerProgress,
    required this.middleProgress,
    required this.innerProgress,
    required this.innermostProgress, // NEW
    required this.outerColor,
    required this.middleColor,
    required this.innerColor,
    required this.innermostColor, // NEW
    required this.strokeWidths,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    const startAngle = -math.pi / 2;

    final maxPossibleRadius = (size.shortestSide / 2);
    final outerStroke = strokeWidths[0];
    final middleStroke = strokeWidths[1];
    final innerStroke = strokeWidths[2];
    final innermostStroke = strokeWidths[3]; // NEW

    const ringSpacing = 6.0;

    final outerRadius = maxPossibleRadius - outerStroke / 2;
    final middleRadius = outerRadius - (outerStroke / 2) - (middleStroke / 2) - ringSpacing;
    final innerRadius = middleRadius - (middleStroke / 2) - (innerStroke / 2) - ringSpacing;
    final innermostRadius = innerRadius - (innerStroke / 2) - (innermostStroke / 2) - ringSpacing; // NEW

    void drawArc(double radius, double progress, Color color, double stroke) {
      final paintBg = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = color.withOpacity(0.15)
        ..strokeCap = StrokeCap.round;

      final paintFg = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = color
        ..strokeCap = StrokeCap.round;

      final rect = Rect.fromCircle(center: center, radius: radius);
      canvas.drawArc(rect, 0, math.pi * 2, false, paintBg);
      final sweep = (progress.clamp(0.0, 1.0)) * math.pi * 2;
      if (sweep > 0.001) {
        canvas.drawArc(rect, startAngle, sweep, false, paintFg);
      }
    }

    drawArc(outerRadius, outerProgress, outerColor, outerStroke);
    drawArc(middleRadius, middleProgress, middleColor, middleStroke);
    drawArc(innerRadius, innerProgress, innerColor, innerStroke);
    drawArc(innermostRadius, innermostProgress, innermostColor, innermostStroke); // NEW
  }

  @override
  bool shouldRepaint(covariant _ConcentricPainter old) {
    return old.outerProgress != outerProgress ||
        old.middleProgress != middleProgress ||
        old.innerProgress != innerProgress ||
        old.innermostProgress != innermostProgress || // NEW
        old.outerColor != outerColor ||
        old.middleColor != middleColor ||
        old.innerColor != innerColor ||
        old.innermostColor != innermostColor; // NEW
  }
}