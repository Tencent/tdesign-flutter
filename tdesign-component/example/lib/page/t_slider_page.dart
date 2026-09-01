import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TSliderPage extends StatefulWidget {
  const TSliderPage({super.key});

  @override
  State<TSliderPage> createState() => _TSliderPageState();
}

class _TSliderPageState extends State<TSliderPage> {
  double _single = 23;
  RangeValues _range = const RangeValues(35, 65);
  double _labeled = 50;
  double _nonZero = 30;
  double _scale = 60;
  double _capsule = 30;
  double _vertical = 40;

  @override
  Widget build(BuildContext context) => ExamplePage(
    title: tTitle(),
    desc: '用于选择横轴上的数值、区间、档位。',
    exampleCodeGroup: 'slider',
    compactDemo: true,
    showTestModule: false,
    children: [
      ExampleModule(
        title: '组件类型',
        children: [
          ExampleItem(desc: '单游标滑块', builder: _buildSingle),
          ExampleItem(desc: '双游标滑块', builder: _buildRange),
          ExampleItem(desc: '带数值滑动选择器', builder: _buildLabeled),
          ExampleItem(desc: '起始非零滑动选择器', builder: _buildNonZero),
          ExampleItem(desc: '带刻度滑动选择器', builder: _buildScale),
        ],
      ),
      ExampleModule(
        title: '组件状态',
        children: [ExampleItem(desc: '滑块禁用状态', builder: _buildDisabled)],
      ),
      ExampleModule(
        title: '特殊样式',
        children: [ExampleItem(desc: '胶囊型滑块', builder: _buildCapsule)],
      ),
      ExampleModule(
        title: '垂直状态',
        children: [ExampleItem(builder: _buildVertical)],
      ),
    ],
  );

  @ExampleCode(group: 'slider')
  Widget _buildSingle(BuildContext context) => _panel(
    TSlider(
      key: const ValueKey('slider-single'),
      value: _single,
      min: 0,
      max: 100,
      onChanged: (value) => setState(() => _single = value),
    ),
  );

  @ExampleCode(group: 'slider')
  Widget _buildRange(BuildContext context) => _panel(
    TRangeSlider(
      key: const ValueKey('slider-range'),
      value: _range,
      min: 0,
      max: 100,
      onChanged: (value) => setState(() => _range = value),
    ),
  );

  @ExampleCode(group: 'slider')
  Widget _buildLabeled(BuildContext context) => _panel(
    TSlider(
      key: const ValueKey('slider-labeled'),
      value: _labeled,
      min: 0,
      max: 100,
      showThumbValue: true,
      thumbFormatter: _percent,
      onChanged: (value) => setState(() => _labeled = value),
    ),
  );

  @ExampleCode(group: 'slider')
  Widget _buildNonZero(BuildContext context) => _panel(
    TSlider(
      key: const ValueKey('slider-non-zero'),
      value: _nonZero,
      min: 20,
      max: 100,
      divisions: 4,
      showScaleValue: true,
      scaleFormatter: _integer,
      onChanged: (value) => setState(() => _nonZero = value),
    ),
  );

  @ExampleCode(group: 'slider')
  Widget _buildScale(BuildContext context) => _panel(
    TSlider(
      key: const ValueKey('slider-scale'),
      value: _scale,
      min: 0,
      max: 100,
      divisions: 5,
      showScaleValue: true,
      scaleFormatter: _integer,
      onChanged: (value) => setState(() => _scale = value),
    ),
  );

  @ExampleCode(group: 'slider')
  Widget _buildDisabled(BuildContext context) => const Column(
    children: [
      TSlider(key: ValueKey('slider-disabled'), value: 35, min: 0, max: 100),
      TRangeSlider(value: RangeValues(40, 60), min: 0, max: 100),
    ],
  );

  @ExampleCode(group: 'slider')
  Widget _buildCapsule(BuildContext context) => SliderTheme(
    data: SliderTheme.of(context).copyWith(
      trackHeight: 16,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
    ),
    child: _panel(
      TSlider(
        key: const ValueKey('slider-capsule'),
        value: _capsule,
        min: 0,
        max: 100,
        onChanged: (value) => setState(() => _capsule = value),
      ),
    ),
  );

  @ExampleCode(group: 'slider')
  Widget _buildVertical(BuildContext context) => SizedBox(
    height: 210,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RotatedBox(
          quarterTurns: 3,
          child: SizedBox(
            width: 180,
            child: TSlider(
              key: const ValueKey('slider-vertical'),
              value: _vertical,
              min: 0,
              max: 100,
              showThumbValue: true,
              thumbFormatter: _percent,
              onChanged: (value) => setState(() => _vertical = value),
            ),
          ),
        ),
        const RotatedBox(
          quarterTurns: 3,
          child: SizedBox(
            width: 180,
            child: TRangeSlider(
              value: RangeValues(20, 60),
              min: 0,
              max: 100,
              divisions: 5,
              showScaleValue: true,
            ),
          ),
        ),
      ],
    ),
  );

  static String _percent(double value) => '${value.round()}%';
  static String _integer(double value) => value.round().toString();

  Widget _panel(Widget child) =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: child);
}
