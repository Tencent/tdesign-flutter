import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'timeCounter')
class TimeCounterMillisecondSizesExample extends StatelessWidget {
  const TimeCounterMillisecondSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildMillisecondSizes(context);
  }
}

Widget _buildMillisecondSizes(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TTimeCounter(
        time: 96 * 60 * 1000,
        format: 'HH:mm:ss:SSS',
        size: TTimeCounterSize.small,
      ),
      SizedBox(height: 24),
      TTimeCounter(time: 96 * 60 * 1000, format: 'HH:mm:ss:SSS'),
      SizedBox(height: 24),
      TTimeCounter(
        time: 96 * 60 * 1000,
        format: 'HH:mm:ss:SSS',
        size: TTimeCounterSize.large,
      ),
    ],
  );
}
