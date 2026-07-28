import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// TSlider 示例页。
class TSliderPage extends StatefulWidget {
  const TSliderPage({super.key});

  @override
  State<TSliderPage> createState() => _TSliderPageState();
}

class _TSliderPageState extends State<TSliderPage> {
  double singleValue = 35;
  RangeValues rangeValue = const RangeValues(20, 70);
  double advancedValue = 65;
  RangeValues advancedRange = const RangeValues(25, 80);
  double themedValue = 50;
  String singleEventText = '拖动滑块查看 onChangeStart / onChangeEnd';
  String rangeEventText = '拖动范围滑块查看生命周期回调';

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于选择横轴上的数值或区间。',
      exampleCodeGroup: 'slider',
      children: [
        ExampleModule(
          title: '基础类型',
          children: [
            ExampleItem(desc: '单值滑块', builder: _buildSingle),
            ExampleItem(desc: '范围滑块（整数步进）', builder: _buildRange),
          ],
        ),
        ExampleModule(
          title: '能力组合',
          children: [
            ExampleItem(desc: '单值：拇指值与刻度值', builder: _buildAdvanced),
            ExampleItem(desc: '范围：拇指值与刻度值', builder: _buildAdvancedRange),
          ],
        ),
        ExampleModule(
          title: '状态与主题',
          children: [
            ExampleItem(desc: '禁用状态', builder: _buildDisabled),
            ExampleItem(desc: '全局与局部主题', builder: _buildTheme),
          ],
        ),
      ],
      test: const [],
    );
  }

  @ExampleCode(group: 'slider')
  Widget _buildSingle(BuildContext context) => _withValueLabel(
        context,
        label: '当前值：${singleValue.toStringAsFixed(0)}',
        child: TSlider(
          value: singleValue,
          min: 0,
          max: 100,
          onChanged: (next) => setState(() => singleValue = next),
        ),
      );

  @ExampleCode(group: 'slider')
  Widget _buildRange(BuildContext context) => _withValueLabel(
        context,
        label:
            '当前范围：${rangeValue.start.toStringAsFixed(0)} - ${rangeValue.end.toStringAsFixed(0)}',
        child: TRangeSlider(
          value: rangeValue,
          min: 0,
          max: 100,
          divisions: 100,
          onChanged: (next) => setState(() => rangeValue = next),
        ),
      );

  @ExampleCode(group: 'slider')
  Widget _buildAdvanced(BuildContext context) => _withValueLabel(
        context,
        label: singleEventText,
        child: TSlider(
          value: advancedValue,
          min: 0,
          max: 100,
          divisions: 5,
          showThumbValue: true,
          thumbFormatter: _formatPercent,
          showScaleValue: true,
          scaleFormatter: _formatPercent,
          onChanged: (next) => setState(() => advancedValue = next),
          onChangeStart: (_) =>
              setState(() => singleEventText = 'onChangeStart'),
          onChangeEnd: (_) => setState(() => singleEventText = 'onChangeEnd'),
        ),
      );

  @ExampleCode(group: 'slider')
  Widget _buildAdvancedRange(BuildContext context) => _withValueLabel(
        context,
        label: rangeEventText,
        child: TRangeSlider(
          value: advancedRange,
          min: 0,
          max: 100,
          divisions: 5,
          showThumbValue: true,
          thumbFormatter: _formatPercent,
          showScaleValue: true,
          scaleFormatter: _formatPercent,
          onChanged: (next) => setState(() => advancedRange = next),
          onChangeStart: (_) =>
              setState(() => rangeEventText = '范围 onChangeStart'),
          onChangeEnd: (_) => setState(() => rangeEventText = '范围 onChangeEnd'),
        ),
      );

  @ExampleCode(group: 'slider')
  Widget _buildDisabled(BuildContext context) => const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TSlider(value: 40, min: 0, max: 100),
          TRangeSlider(
            value: RangeValues(20, 70),
            min: 0,
            max: 100,
          ),
        ],
      );

  @ExampleCode(group: 'slider')
  Widget _buildTheme(BuildContext context) {
    final decoration = TSliderThemeData(
      decoration: BoxDecoration(
        color: context.tTheme.bgColorSecondaryContainer,
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
    );
    return Theme(
      data: Theme.of(context).mergeExtension(decoration),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: context.tTheme.successNormalColor,
          thumbColor: context.tTheme.successNormalColor,
          trackHeight: 6,
        ),
        child: TSlider(
          value: themedValue,
          min: 0,
          max: 100,
          divisions: 5,
          showScaleValue: true,
          scaleFormatter: _formatPercent,
          onChanged: (next) => setState(() => themedValue = next),
        ),
      ),
    );
  }

  String _formatPercent(double value) => '${value.toInt()}%';

  Widget _withValueLabel(
    BuildContext context, {
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(height: 8),
        TText(
          label,
          textColor: context.tTheme.textColorPlaceholder,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
