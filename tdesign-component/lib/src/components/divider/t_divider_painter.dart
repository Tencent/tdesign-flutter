import 'dart:math';

import 'package:flutter/material.dart';

/// 横向虚线绘制器
///
/// 仅支持水平方向虚线绘制。竖线不支持虚线，跨端规范如此。
class DashedPainter extends CustomPainter {
  DashedPainter({
    required this.color,
    this.strokeWidth = 0.5,
    this.gap = 2,
    this.solidLength = 2,
  });

  /// 线条颜色
  final Color color;

  /// 线粗
  final double strokeWidth;

  /// 虚线间隙
  final double gap;

  /// 实线段长度
  final double solidLength;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final lineLength = size.width;
    final fixedCoordinate = size.height / 2;

    double currentPosition = 0;
    var drawSolid = true;

    while (currentPosition < lineLength) {
      final segmentLength = drawSolid ? solidLength : gap;
      final nextPosition = min(currentPosition + segmentLength, lineLength);

      if (drawSolid) {
        canvas.drawLine(
          Offset(currentPosition, fixedCoordinate),
          Offset(nextPosition, fixedCoordinate),
          paint,
        );
      }

      currentPosition = nextPosition;
      drawSolid = !drawSolid;
    }
  }

  @override
  bool shouldRepaint(DashedPainter oldDelegate) {
    return color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth ||
        gap != oldDelegate.gap ||
        solidLength != oldDelegate.solidLength;
  }
}
