import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'timeCounter')
class TimeCounterSquareSizesExample extends StatelessWidget {
  const TimeCounterSquareSizesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSquareSizes(context);
  }
}

Widget _buildSquareSizes(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TTimeCounter(
        time: 96 * 60 * 1000,
        size: TTimeCounterSize.small,
        variant: TTimeCounterVariant.square,
      ),
      SizedBox(height: 24),
      TTimeCounter(time: 96 * 60 * 1000, variant: TTimeCounterVariant.square),
      SizedBox(height: 24),
      TTimeCounter(
        time: 96 * 60 * 1000,
        size: TTimeCounterSize.large,
        variant: TTimeCounterVariant.square,
      ),
    ],
  );
}
