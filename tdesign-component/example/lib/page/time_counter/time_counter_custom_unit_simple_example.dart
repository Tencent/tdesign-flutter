import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'timeCounter')
class TimeCounterCustomUnitSimpleExample extends StatelessWidget {
  const TimeCounterCustomUnitSimpleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildCustomUnitSimple(context);
  }
}

Widget _buildCustomUnitSimple(BuildContext context) {
  return const TTimeCounter(
    time: 96 * 60 * 1000,
    variant: TTimeCounterVariant.highlight,
    splitWithUnit: true,
  );
}
