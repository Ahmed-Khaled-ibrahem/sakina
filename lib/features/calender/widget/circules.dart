import 'dart:math' as math;
import 'package:flutter/material.dart';

class ConcentricProgress extends StatefulWidget {
  final double size;
  final double outerProgress; // 0.0 .. 1.0
  final double middleProgress;
  final double innerProgress;
  final Color outerColor;
  final Color middleColor;
  final Color innerColor;
  final List<double> strokeWidths; // [outer, middle, inner]
  final Duration duration;
  final Widget? centerWidget;

  const ConcentricProgress({
    Key? key,
    this.size = 200,
    required this.outerProgress,
    required this.middleProgress,
    required this.innerProgress,
    this.outerColor = Colors.blue,
    this.middleColor = Colors.orange,
    this.innerColor = Colors.green,
    this.strokeWidths = const [14, 10, 6],
    this.duration = const Duration(milliseconds: 600),
    this.centerWidget,
  })  : assert(strokeWidths.length == 3),
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

  double _lastOuter = 0;
  double _lastMiddle = 0;
  double _lastInner = 0;

  @override
  void initState() {
    super.initState();
    _lastOuter = widget.outerProgress.clamp(0.0, 1.0);
    _lastMiddle = widget.middleProgress.clamp(0.0, 1.0);
    _lastInner = widget.innerProgress.clamp(0.0, 1.0);

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
  }

  @override
  void didUpdateWidget(covariant ConcentricProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    // store last values so animation starts from previous state
    _lastOuter = _outerAnim.value;
    _lastMiddle = _middleAnim.value;
    _lastInner = _innerAnim.value;

    _controller.duration = widget.duration;
    _controller.reset();

    _outerAnim =
        Tween<double>(begin: _lastOuter, end: widget.outerProgress.clamp(0.0, 1.0))
            .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _middleAnim =
        Tween<double>(begin: _lastMiddle, end: widget.middleProgress.clamp(0.0, 1.0))
            .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _innerAnim =
        Tween<double>(begin: _lastInner, end: widget.innerProgress.clamp(0.0, 1.0))
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
    // center widget sits on top of the paints
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
              outerColor: widget.outerColor,
              middleColor: widget.middleColor,
              innerColor: widget.innerColor,
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
  final Color outerColor;
  final Color middleColor;
  final Color innerColor;
  final List<double> strokeWidths;

  _ConcentricPainter({
    required this.outerProgress,
    required this.middleProgress,
    required this.innerProgress,
    required this.outerColor,
    required this.middleColor,
    required this.innerColor,
    required this.strokeWidths,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    // We'll draw arcs from -90 degrees (top) clockwise
    const startAngle = -math.pi / 2;

    // max radius is constrained by size and stroke widths so arcs don't overlap
    final maxPossibleRadius = (size.shortestSide / 2);
    final outerStroke = strokeWidths[0];
    final middleStroke = strokeWidths[1];
    final innerStroke = strokeWidths[2];

    // spacing between rings
    const ringSpacing = 6.0;

    // outer radius
    final outerRadius = maxPossibleRadius - outerStroke / 2;
    // middle inside outer
    final middleRadius = outerRadius - (outerStroke / 2) - (middleStroke / 2) - ringSpacing;
    final innerRadius = middleRadius - (middleStroke / 2) - (innerStroke / 2) - ringSpacing;

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
      // background full circle (faint)
      canvas.drawArc(rect, 0, math.pi * 2, false, paintBg);
      // foreground arc for progress (clamped 0..1)
      final sweep = (progress.clamp(0.0, 1.0)) * math.pi * 2;
      if (sweep > 0.001) {
        canvas.drawArc(rect, startAngle, sweep, false, paintFg);
      }
    }

    // draw outer -> middle -> inner
    drawArc(outerRadius, outerProgress, outerColor, outerStroke);
    drawArc(middleRadius, middleProgress, middleColor, middleStroke);
    drawArc(innerRadius, innerProgress, innerColor, innerStroke);
  }

  @override
  bool shouldRepaint(covariant _ConcentricPainter old) {
    return old.outerProgress != outerProgress ||
        old.middleProgress != middleProgress ||
        old.innerProgress != innerProgress ||
        old.outerColor != outerColor ||
        old.middleColor != middleColor ||
        old.innerColor != innerColor;
  }
}
