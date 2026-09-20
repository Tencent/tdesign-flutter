import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'timeCounter')
class TimeCounterSquareSimpleExample extends StatelessWidget {
  const TimeCounterSquareSimpleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSquareSimple(context);
  }
}

Widget _buildSquareSimple(BuildContext context) {
  return const TTimeCounter(
    time: 96 * 60 * 1000,
    variant: TTimeCounterVariant.square,
  );
}
