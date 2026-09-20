import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'timeCounter')
class TimeCounterDefaultSizesExample extends StatelessWidget {
  const TimeCounterDefaultSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildDefaultSizes(context);
  }
}

Widget _buildDefaultSizes(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TTimeCounter(time: 96 * 60 * 1000, size: TTimeCounterSize.small),
      SizedBox(height: 24),
      TTimeCounter(time: 96 * 60 * 1000),
      SizedBox(height: 24),
      TTimeCounter(time: 96 * 60 * 1000, size: TTimeCounterSize.large),
    ],
  );
}
