import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 私有组件类，用于展示环形进度条
class TDProgressCircular extends StatelessWidget {
  final double _value;
  final double strokeWidth;
  final Color backgroundColor;
  final Animation<Color> valueColor;
  final double circleRadius;

  const TDProgressCircular({
    Key? key,
    required double value,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.valueColor,
    required this.circleRadius,
  })  : _value = value,
        super(key: key);

  double get value => _value.clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: circleRadius * 2,
      height: circleRadius * 2,
      child: CustomPaint(
        painter: _TDProgressCircularPainter(
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
          circleRadius: circleRadius,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _TDProgressCircularPainter extends CustomPainter {
  final double value;
  final Color backgroundColor;
  final Animation<Color> valueColor;
  final double circleRadius;
  final double strokeWidth;

  _TDProgressCircularPainter({
    required this.value,
    required this.backgroundColor,
    required this.valueColor,
    required this.circleRadius,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.width / 2;
    final radius = center - strokeWidth / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final valuePaint = Paint()
      ..color = valueColor.value
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(center, center), radius, backgroundPaint);

    final sweepAngle = 2 * math.pi * value;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(center, center), radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
