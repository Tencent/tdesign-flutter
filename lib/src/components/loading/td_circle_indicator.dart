/*
 * Created by haozhicao@tencent.com on 6/28/22.
 * td_circle_indicator.dart
 * 
 */

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class TDCircleIndicator extends StatefulWidget {
  const TDCircleIndicator({
    Key? key,
    this.color = const Color(0xff0052d9),
    this.lineWidth = 3.0,
    this.size = 20.0,
  }) : super(key: key);

  final Color color;
  final double size;
  final double lineWidth;

  @override
  _TDCircleIndicatorState createState() => _TDCircleIndicatorState();
}

class _TDCircleIndicatorState extends State<TDCircleIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..addListener(() => setState(() {}))
      ..repeat();
    _animation1 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var value = (_animation1.value) * 2 * pi;
    return Center(
      child: Transform(
        transform: Matrix4.identity()..rotateZ(value),
        alignment: FractionalOffset.center,
        child: SizedBox.fromSize(
          size: Size.square(widget.size),
          child: CustomPaint(
            painter: _CirclePaint(color: widget.color, width: widget.lineWidth),
          ),
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
    _paint.strokeWidth = width;
    _paint.shader = ui.Gradient.sweep(Offset(size.width / 2, size.height / 2),
        [const Color(0x01ffffff), color]);
    canvas.drawArc(
        Rect.fromLTWH(0, 0, size.width, size.height), 0, pi * 2, false, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
