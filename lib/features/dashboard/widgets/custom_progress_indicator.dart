import 'dart:math';
import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double value;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  const CustomProgressIndicator({
    Key? key,
    required this.value,
    required this.color,
    required this.backgroundColor,
    this.strokeWidth = 5.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CircleProgressPainter(
        progress: value,
        progressColor: color,
        backgroundColor: backgroundColor,
        strokeWidth: strokeWidth,
      ),
      child: Center(
        child: Text(
          '${(value * 100).toInt()}%',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  CircleProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - strokeWidth / 2;

    // Dibuja el fondo del círculo
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Dibuja el progreso
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Comenzar desde arriba
      2 * pi * progress, // Calcular el ángulo en base al progreso
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}