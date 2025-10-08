import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final double percentage;
  final Color backgroundColor;
  final Color progressColor;
  final double height;
  final Duration duration;

  const CustomProgressBar({
    Key? key,
    required this.percentage,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.progressColor = Colors.blue,
    this.height = 6,
    this.duration = const Duration(milliseconds: 400),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth, // full width of the screen
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height),
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: duration,
            width: (percentage.clamp(0, 100) / 100) * screenWidth,
            decoration: BoxDecoration(
              color: progressColor,
              borderRadius: BorderRadius.circular(height),
            ),
          ),
        ],
      ),
    );
  }
}