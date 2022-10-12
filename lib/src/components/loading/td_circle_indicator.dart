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
    this.color,
    this.size = 20.0,
  }) : super(key: key);

  final Color? color;
  final double size;

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
    return Transform(
      transform: Matrix4.identity()..rotateZ(value),
      alignment: FractionalOffset.center,
      child: SizedBox.fromSize(
        size: Size.square(widget.size),
        child: Image.asset('assets/loading_blue.png',package: 'tdesign_flutter',),
      ),
    );
  }
}
