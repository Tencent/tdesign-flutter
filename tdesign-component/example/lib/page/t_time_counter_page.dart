import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/example_code.dart';

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
      children: const [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '时分秒',
              builder: _buildSimple,
              center: false,
              padding: _counterPadding,
            ),
            ExampleItem(
              desc: '带毫秒',
              builder: _buildMillisecondSimple,
              center: false,
              padding: _counterPadding,
            ),
            ExampleItem(
              desc: '带方形底',
              builder: _buildSquareSimple,
              center: false,
              padding: _counterPadding,
            ),
            ExampleItem(
              desc: '带圆形底',
              builder: _buildRoundSimple,
              center: false,
              padding: _counterPadding,
            ),
            ExampleItem(
              desc: '带单位',
              builder: _buildUnitSimple,
              center: false,
              padding: _counterPadding,
            ),
            ExampleItem(
              desc: '无底色带单位',
              builder: _buildCustomUnitSimple,
              center: false,
              padding: _counterPadding,
            ),
          ],
        ),
        ExampleModule(
          title: '组件尺寸',
          children: [
            ExampleItem(
              desc: '时分秒',
              builder: _buildDefaultSizes,
              center: false,
              padding: _counterPadding,
            ),
            ExampleItem(
              desc: '带毫秒',
              builder: _buildMillisecondSizes,
              center: false,
              padding: _counterPadding,
            ),
            ExampleItem(
              desc: '带方形底',
              builder: _buildSquareSizes,
              center: false,
              padding: _counterPadding,
            ),
            ExampleItem(
              desc: '带圆形底',
              builder: _buildRoundSizes,
              center: false,
              padding: _counterPadding,
            ),
            ExampleItem(
              desc: '带单位',
              builder: _buildUnitSizes,
              center: false,
              padding: _counterPadding,
            ),
          ],
        ),
      ],
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
