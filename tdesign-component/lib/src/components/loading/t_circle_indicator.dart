/*
 * Created by haozhicao@tencent.com on 6/28/22.
 * t_circle_indicator.dart
 * 
 */

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';

class TCircleIndicator extends StatefulWidget {
  const TCircleIndicator({
    Key? key,
    this.color,
    this.size = 20.0,
    this.lineWidth = 3.0,
    this.duration = 1000,
  }) : super(key: key);

  final Color? color;
  final double size;
  final double lineWidth;
  final int duration;

  @override
  _TCircleIndicatorState createState() => _TCircleIndicatorState();
}

class _TCircleIndicatorState extends State<TCircleIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration))
      ..addListener(() => setState(() {}))
      ..repeat();
    _animation1 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear)));
  }

  @override
  void didUpdateWidget(covariant TCircleIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = Duration(milliseconds: widget.duration);
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var value = (_animation1.value) * 2 * pi;
    var paintColor = widget.color ?? context.tTheme.brandNormalColor;
    return Transform(
      transform: Matrix4.identity()..rotateZ(value),
      alignment: FractionalOffset.center,
      child: SizedBox.fromSize(
        size: Size.square(widget.size),
        child: CustomPaint(
          painter: _CirclePaint(color: paintColor, width: widget.lineWidth),
        ),
      ),
    );
  }
}

class _CirclePaint extends CustomPainter {
  final Color color;
  final double width;

  _CirclePaint({required this.color, required this.width});

  final _paint = Paint()..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    var minLength = min(size.width, size.height);
    _paint.strokeWidth = width;
    _paint.shader = ui.Gradient.sweep(Offset(size.width / 2, size.height / 2),
        [const Color(0x01ffffff), color]);
    if (minLength == size.width) {
      // strokeWidth是居中位置的，需要减去width/2，使其向内绘制
      canvas.drawArc(
          Rect.fromLTWH(width / 2, (size.height - size.width) / 2 + width / 2,
              size.width - width, size.width - width),
          0,
          pi * 2,
          false,
          _paint);
    } else {
      canvas.drawArc(
          Rect.fromLTWH((size.width - size.height) / 2 + width / 2, width / 2,
              size.height - width, size.height - width),
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
