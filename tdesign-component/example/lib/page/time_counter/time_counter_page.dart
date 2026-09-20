import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'time_counter_custom_unit_simple_example.dart';
import 'time_counter_default_sizes_example.dart';
import 'time_counter_millisecond_simple_example.dart';
import 'time_counter_millisecond_sizes_example.dart';
import 'time_counter_round_simple_example.dart';
import 'time_counter_round_sizes_example.dart';
import 'time_counter_simple_example.dart';
import 'time_counter_square_simple_example.dart';
import 'time_counter_square_sizes_example.dart';
import 'time_counter_unit_simple_example.dart';
import 'time_counter_unit_sizes_example.dart';

const _counterPadding = EdgeInsets.symmetric(horizontal: 16);

@ExampleCodeManifest()
class TTimeCounterPage extends StatelessWidget {
  const TTimeCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于实时展示计时数值，支持正向计时与倒计时。',
      exampleCodeGroup: 'timeCounter',
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '时分秒',
              center: false,
              padding: _counterPadding,
              methodName: 'TimeCounterSimpleExample',
              builder: (_) => const TimeCounterSimpleExample(),
            ),
            ExampleItem(
              desc: '带毫秒',
              center: false,
              padding: _counterPadding,
              methodName: 'TimeCounterMillisecondSimpleExample',
              builder: (_) => const TimeCounterMillisecondSimpleExample(),
            ),
            ExampleItem(
              desc: '带方形底',
              center: false,
              padding: _counterPadding,
              methodName: 'TimeCounterSquareSimpleExample',
              builder: (_) => const TimeCounterSquareSimpleExample(),
            ),
            ExampleItem(
              desc: '带圆形底',
              center: false,
              padding: _counterPadding,
              methodName: 'TimeCounterRoundSimpleExample',
              builder: (_) => const TimeCounterRoundSimpleExample(),
            ),
            ExampleItem(
              desc: '带单位',
              center: false,
              padding: _counterPadding,
              methodName: 'TimeCounterUnitSimpleExample',
              builder: (_) => const TimeCounterUnitSimpleExample(),
            ),
            ExampleItem(
              desc: '无底色带单位',
              center: false,
              padding: _counterPadding,
              methodName: 'TimeCounterCustomUnitSimpleExample',
              builder: (_) => const TimeCounterCustomUnitSimpleExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件尺寸',
          children: [
            ExampleItem(
              desc: '时分秒',
              center: false,
              padding: _counterPadding,
              methodName: 'TimeCounterDefaultSizesExample',
              builder: (_) => const TimeCounterDefaultSizesExample(),
            ),
            ExampleItem(
              desc: '带毫秒',
              center: false,
              padding: _counterPadding,
              methodName: 'TimeCounterMillisecondSizesExample',
              builder: (_) => const TimeCounterMillisecondSizesExample(),
            ),
            ExampleItem(
              desc: '带方形底',
              center: false,
              padding: _counterPadding,
              methodName: 'TimeCounterSquareSizesExample',
              builder: (_) => const TimeCounterSquareSizesExample(),
            ),
            ExampleItem(
              desc: '带圆形底',
              center: false,
              padding: _counterPadding,
              methodName: 'TimeCounterRoundSizesExample',
              builder: (_) => const TimeCounterRoundSizesExample(),
            ),
            ExampleItem(
              desc: '带单位',
              center: false,
              padding: _counterPadding,
              methodName: 'TimeCounterUnitSizesExample',
              builder: (_) => const TimeCounterUnitSizesExample(),
            ),
          ],
        ),
      ],
    );
  }
}
