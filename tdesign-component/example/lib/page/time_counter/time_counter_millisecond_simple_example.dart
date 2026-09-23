import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'timeCounter')
class TimeCounterMillisecondSimpleExample extends StatelessWidget {
  const TimeCounterMillisecondSimpleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildMillisecondSimple(context);
  }
}

Widget _buildMillisecondSimple(BuildContext context) {
  return const TTimeCounter(time: 96 * 60 * 1000, format: 'HH:mm:ss:SSS');
}
