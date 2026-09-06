import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../base/example_widget.dart';
import '../annotation/example_code.dart';

class TTimeCounterPage extends StatelessWidget {
  const TTimeCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于实时展示倒计时数值。',
      exampleCodeGroup: 'timeCounter',
      children: const [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '时分秒', builder: _buildSimple),
            ExampleItem(desc: '带毫秒', builder: _buildMillisecondSimple),
            ExampleItem(desc: '带方形底', builder: _buildSquareSimple),
            ExampleItem(desc: '带圆形底', builder: _buildRoundSimple),
            ExampleItem(desc: '带单位', builder: _buildUnitSimple),
            ExampleItem(desc: '无底色带单位', builder: _buildCustomUnitSimple),
          ],
        ),
        ExampleModule(
          title: '组件尺寸',
          children: [
            ExampleItem(desc: '时分秒', builder: _buildDefaultSizes),
            ExampleItem(desc: '带毫秒', builder: _buildMillisecondSizes),
            ExampleItem(desc: '带方形底', builder: _buildSquareSizes),
            ExampleItem(desc: '带圆形底', builder: _buildRoundSizes),
            ExampleItem(desc: '带单位', builder: _buildUnitSizes),
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
  return const TTimeCounter(
    time: 96 * 60 * 1000,
    format: 'HH:mm:ss:SSS',
    showMillisecond: true,
  );
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
  return TTimeCounter(
    time: 96 * 60 * 1000,
    content: (time) {
      final duration = Duration(milliseconds: time);
      String twoDigits(int value) => value.toString().padLeft(2, '0');
      final countStyle = TextStyle(
        color: context.tTheme.errorNormalColor,
        fontSize: 18,
        height: 24 / 18,
        fontFamily: context.tTheme.numberFontFamily?.fontFamily,
        package: context.tTheme.numberFontFamily?.package,
      );
      final unitStyle = TextStyle(
        color: context.tTheme.textColorPrimary,
        fontSize: 10,
        height: 16 / 10,
      );
      Widget unit(String value) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: TText(value, style: unitStyle),
      );
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TText(twoDigits(duration.inHours), style: countStyle),
          unit('时'),
          TText(twoDigits(duration.inMinutes.remainder(60)), style: countStyle),
          unit('分'),
          TText(twoDigits(duration.inSeconds.remainder(60)), style: countStyle),
          unit('秒'),
        ],
      );
    },
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
        showMillisecond: true,
        size: TTimeCounterSize.small,
      ),
      SizedBox(height: 24),
      TTimeCounter(
        time: 96 * 60 * 1000,
        format: 'HH:mm:ss:SSS',
        showMillisecond: true,
      ),
      SizedBox(height: 24),
      TTimeCounter(
        time: 96 * 60 * 1000,
        format: 'HH:mm:ss:SSS',
        showMillisecond: true,
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
