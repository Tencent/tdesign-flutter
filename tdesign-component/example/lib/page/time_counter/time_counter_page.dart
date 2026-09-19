import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

part 'time_counter_size.dart';
part 'time_counter_type.dart';

const _counterPadding = EdgeInsets.symmetric(horizontal: 16);

class TTimeCounterPage extends StatelessWidget {
  const TTimeCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于实时展示计时数值，支持正向计时与倒计时。',
      exampleCodeGroup: 'timeCounter',
      showTestModule: false,
      children: [_timeCounterTypeModule, _timeCounterSizeModule],
    );
  }
}

@ExampleCode(group: 'timeCounter')
Widget _buildSimple(BuildContext context) {
  return const TTimeCounter(time: 96 * 60 * 1000);
}

@ExampleCode(group: 'timeCounter')
Widget _buildMillisecondSimple(BuildContext context) {
  return const TTimeCounter(time: 96 * 60 * 1000, format: 'HH:mm:ss:SSS');
}

@ExampleCode(group: 'timeCounter')
Widget _buildSquareSimple(BuildContext context) {
  return const TTimeCounter(
    time: 96 * 60 * 1000,
    variant: TTimeCounterVariant.square,
  );
}

@ExampleCode(group: 'timeCounter')
Widget _buildRoundSimple(BuildContext context) {
  return const TTimeCounter(
    time: 96 * 60 * 1000,
    variant: TTimeCounterVariant.round,
  );
}

@ExampleCode(group: 'timeCounter')
Widget _buildUnitSimple(BuildContext context) {
  return const TTimeCounter(
    time: 96 * 60 * 1000,
    variant: TTimeCounterVariant.round,
    splitWithUnit: true,
  );
}

@ExampleCode(group: 'timeCounter')
Widget _buildCustomUnitSimple(BuildContext context) {
  return const TTimeCounter(
    time: 96 * 60 * 1000,
    variant: TTimeCounterVariant.highlight,
    splitWithUnit: true,
  );
}

@ExampleCode(group: 'timeCounter')
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

@ExampleCode(group: 'timeCounter')
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

@ExampleCode(group: 'timeCounter')
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

@ExampleCode(group: 'timeCounter')
Widget _buildRoundSizes(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TTimeCounter(
        time: 96 * 60 * 1000,
        size: TTimeCounterSize.small,
        variant: TTimeCounterVariant.round,
      ),
      SizedBox(height: 24),
      TTimeCounter(time: 96 * 60 * 1000, variant: TTimeCounterVariant.round),
      SizedBox(height: 24),
      TTimeCounter(
        time: 96 * 60 * 1000,
        size: TTimeCounterSize.large,
        variant: TTimeCounterVariant.round,
      ),
    ],
  );
}

@ExampleCode(group: 'timeCounter')
Widget _buildUnitSizes(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TTimeCounter(
        time: 96 * 60 * 1000,
        size: TTimeCounterSize.small,
        variant: TTimeCounterVariant.round,
        splitWithUnit: true,
      ),
      SizedBox(height: 24),
      TTimeCounter(
        time: 96 * 60 * 1000,
        variant: TTimeCounterVariant.round,
        splitWithUnit: true,
      ),
      SizedBox(height: 24),
      TTimeCounter(
        time: 96 * 60 * 1000,
        size: TTimeCounterSize.large,
        variant: TTimeCounterVariant.round,
        splitWithUnit: true,
      ),
    ],
  );
}
