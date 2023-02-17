import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';

class TDLoadingPainter extends CustomPainter {
  final Color color;
  final double width;

  TDLoadingPainter({required this.color, required this.width});

  final _paint = Paint()..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    var minLength = min(size.width, size.height);
    _paint.strokeWidth = width;
    _paint.shader = ui.Gradient.sweep(Offset(size.width / 2, size.height / 2),
        [const Color(0x01ffffff), color]);
    if (minLength == size.width) {
      canvas.drawArc(
          Rect.fromLTWH(
              0, (size.height - size.width) / 2, size.width, size.width),
          0,
          pi * 2,
          false,
          _paint);
    } else {
      canvas.drawArc(
          Rect.fromLTWH(
              (size.width - size.height) / 2, 0, size.height, size.height),
          0,
          pi * 2,
          false,
          _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
