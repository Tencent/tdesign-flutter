import 'dart:math';

import 'package:flutter/material.dart';

/// 虚线控件
class DashedWidget extends StatelessWidget {
  const DashedWidget({
    Key? key,
    this.color = Colors.black,
    this.gap = 2,
    this.solidLength = 2,
    this.width,
    this.height,
    this.direction = Axis.horizontal,
  }) : super(key: key);

  final Color color;
  final double gap;
  final double solidLength;
  final double? width;
  final double? height;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.horizontal) {
      return SizedBox(
        width: width ?? MediaQuery.of(context).size.width,
        height: height,
        child: CustomPaint(
          painter: DashedPainter(
              color: color,
              strokeWidth: height ?? 1,
              direction: direction),
        ),
      );
    } else {
      return SizedBox(
        width: width,
        height: height ?? MediaQuery.of(context).size.height,
        child: CustomPaint(
          painter: DashedPainter(
              color: color, strokeWidth: width ?? 1, direction: direction),
        ),
      );
    }
  }
}

/// 绘制虚线自定义控件
class DashedPainter extends CustomPainter {
  DashedPainter(
      {this.color = Colors.black,
      this.strokeWidth = 1,
      this.gap = 2,
      this.solidLength = 2,
      this.direction = Axis.horizontal});

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
    var start = const Offset(0, 0);
    Offset end;
    if (direction == Axis.horizontal) {
      end = Offset(size.width, 0);
    } else {
      // 不能为0，防止除0错误
      end = Offset(0.00001, size.height);
    }
    var path = getDashedPath(start, end);

    canvas.drawPath(path, paint);
  }

  Path getDashedPath(Offset start, Offset end) {
    var size = Size(end.dx - start.dx, end.dy - start.dy);
    var path = Path();
    path.moveTo(start.dx, start.dy);
    var shouldDraw = true;
    var currentOffset = Offset(start.dx, start.dy);

    var radians = atan(size.height / size.width);

    var gapDx =
        cos(radians) * gap < 0 ? cos(radians) * gap * -1 : cos(radians) * gap;

    var gapDy =
        sin(radians) * gap < 0 ? sin(radians) * gap * -1 : sin(radians) * gap;

    var solidDx = cos(radians) * solidLength < 0
        ? cos(radians) * solidLength * -1
        : cos(radians) * solidLength;

    var solidDy = sin(radians) * solidLength < 0
        ? sin(radians) * solidLength * -1
        : sin(radians) * solidLength;

    double _getDx() {
      return shouldDraw ? solidDx : gapDx;
    }

    double _getDy() {
      return shouldDraw ? solidDy : gapDy;
    }

    while (currentOffset.dx <= end.dx && currentOffset.dy <= end.dy) {
      shouldDraw
          ? path.lineTo(
              currentOffset.dx.toDouble(), currentOffset.dy.toDouble())
          : path.moveTo(
              currentOffset.dx.toDouble(), currentOffset.dy.toDouble());
      currentOffset = Offset(
        currentOffset.dx + _getDx(),
        currentOffset.dy + _getDy(),
      );
      shouldDraw = !shouldDraw;
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
