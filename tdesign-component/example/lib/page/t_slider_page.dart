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
  double value = 35;
  RangeValues range = const RangeValues(20, 70);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于选择横轴上的数值或区间。',
      exampleCodeGroup: 'slider',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '单值', builder: _buildSingle),
            ExampleItem(desc: '范围', builder: _buildRange),
            ExampleItem(desc: '离散刻度', builder: _buildDivisions),
          ],
        ),
        ExampleModule(
          title: '状态与主题',
          children: [
            ExampleItem(desc: '禁用', builder: _buildDisabled),
            ExampleItem(desc: 'Material Theme', builder: _buildMaterialTheme),
            ExampleItem(desc: '外层装饰', builder: _buildDecoration),
          ],
        ),
      ],
      test: const [],
    );
  }

  @ExampleCode(group: 'slider')
  Widget _buildSingle(BuildContext context) => _withValueLabel(
        context,
        label: '当前值：${value.toStringAsFixed(0)}',
        child: TSlider(
          value: value,
          min: 0,
          max: 100,
          onChanged: (next) => setState(() => value = next),
        ),
      );

  @ExampleCode(group: 'slider')
  Widget _buildRange(BuildContext context) => _withValueLabel(
        context,
        label:
            '当前范围：${range.start.toStringAsFixed(0)} - ${range.end.toStringAsFixed(0)}',
        child: TRangeSlider(
          value: range,
          min: 0,
          max: 100,
          onChanged: (next) => setState(() => range = next),
        ),
      );

  @ExampleCode(group: 'slider')
  Widget _buildDivisions(BuildContext context) => _withValueLabel(
        context,
        label: '当前刻度：${value.toStringAsFixed(0)}',
        child: TSlider(
          value: value,
          min: 0,
          max: 100,
          divisions: 5,
          onChanged: (next) => setState(() => value = next),
        ),
      );

  @ExampleCode(group: 'slider')
  Widget _buildDisabled(BuildContext context) => const TSlider(
        value: 40,
        min: 0,
        max: 100,
      );

  @ExampleCode(group: 'slider')
  Widget _buildMaterialTheme(BuildContext context) => SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: context.tTheme.successNormalColor,
          thumbColor: context.tTheme.successNormalColor,
          trackHeight: 6,
        ),
        child: TSlider(
          value: value,
          min: 0,
          max: 100,
          onChanged: (next) => setState(() => value = next),
        ),
      );

  @ExampleCode(group: 'slider')
  Widget _buildDecoration(BuildContext context) => Theme(
        data: Theme.of(context).mergeExtension(
          TSliderThemeData(
            decoration: BoxDecoration(
              color: context.tTheme.bgColorSecondaryContainer,
              borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
            ),
          ),
        ),
        child: TRangeSlider(
          value: range,
          min: 0,
          max: 100,
          onChanged: (next) => setState(() => range = next),
        ),
      );

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
