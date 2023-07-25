/*
 * Created by haozhicao@tencent.com on 6/28/22.
 * td_point_indicator.dart
 * 
 */

import 'dart:math' as math;
import 'package:flutter/material.dart';

class TDPointBounceIndicator extends StatefulWidget {
  const TDPointBounceIndicator({
    Key? key,
    this.color,
    this.size = 20.0,
    this.duration = 1400,
    this.controller,
  }) : super(key: key);

  final Color? color;
  final double size;
  final int duration;
  final AnimationController? controller;

  @override
  _TDPointBounceIndicatorState createState() => _TDPointBounceIndicatorState();
}

class _TDPointBounceIndicatorState extends State<TDPointBounceIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(
            vsync: this, duration: Duration(milliseconds: widget.duration)))
      ..repeat();
  }

  @override
  void didUpdateWidget(covariant TDPointBounceIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = Duration(milliseconds: widget.duration);
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size(widget.size * 3.5, widget.size),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (i) {
            return ScaleTransition(
              scale: DelayTween(begin: 0.0, end: 1.0, delay: i * .2)
                  .animate(_controller),
              child: SizedBox.fromSize(
                  size: Size.square(widget.size * 0.5), child: _itemBuilder(i)),
            );
          }),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) {
    return DecoratedBox(
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle));
  }
}

class DelayTween extends Tween<double> {
  DelayTween({double? begin, double? end, required this.delay})
      : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) =>
      super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
