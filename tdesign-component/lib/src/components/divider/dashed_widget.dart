import 'dart:math';

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

/// 虚线控件
class DashedWidget extends StatelessWidget {
  const DashedWidget({
    Key? key,
    this.color,
    this.gap = 2,
    this.solidLength = 2,
    this.width,
    this.height = 0.5,
    this.direction = Axis.horizontal,
  })  : assert(gap > 0, 'gap 必须大于 0'),
        assert(solidLength > 0, 'solidLength 必须大于 0'),
        super(key: key);

  final Color? color;
  final double gap;
  final double solidLength;
  final double? width;
  final double height;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.horizontal) {
      return SizedBox(
        width: width ?? MediaQuery.of(context).size.width,
        height: height,
        child: CustomPaint(
          painter: DashedPainter(
              color: color ?? TDTheme.of(context).componentStrokeColor,
              strokeWidth: height,
              direction: direction),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height ?? MediaQuery.of(context).size.height,
      child: CustomPaint(
        painter: DashedPainter(
            color: color ?? TDTheme.of(context).componentStrokeColor,
            strokeWidth: width ?? 1,
            direction: direction),
      ),
    );
  }
}

/// 绘制虚线自定义控件
class DashedPainter extends CustomPainter {
  DashedPainter({
    required this.color,
    this.strokeWidth = 1,
    this.gap = 2,
    this.solidLength = 2,
    this.direction = Axis.horizontal,
  });

  final Color color;
  final double strokeWidth;
  final double gap;
  final double solidLength;
  final Axis direction;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    _drawDashedLine(canvas, paint, size);
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Size size) {
    final isHorizontal = direction == Axis.horizontal;
    final lineLength = isHorizontal ? size.width : size.height;
    final fixedCoordinate = (isHorizontal ? size.height : size.width) / 2;

    double currentPosition = 0;
    var drawSolid = true;

    while (currentPosition < lineLength) {
      final segmentLength = drawSolid ? solidLength : gap;
      final nextPosition = min(currentPosition + segmentLength, lineLength);

      if (drawSolid) {
        final start = isHorizontal
            ? Offset(currentPosition, fixedCoordinate)
            : Offset(fixedCoordinate, currentPosition);
        final end = isHorizontal
            ? Offset(nextPosition, fixedCoordinate)
            : Offset(fixedCoordinate, nextPosition);
        canvas.drawLine(start, end, paint);
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
        solidLength != oldDelegate.solidLength ||
        direction != oldDelegate.direction;
  }
}
