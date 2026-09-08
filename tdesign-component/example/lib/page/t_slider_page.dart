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
  double _labeled = 35;
  RangeValues _labeledRange = const RangeValues(40, 60);
  double _nonZero = 30;
  double _scale = 60;
  RangeValues _scaleRange = const RangeValues(20, 60);
  double _capsule = 30;
  RangeValues _capsuleRange = const RangeValues(40, 60);
  RangeValues _capsuleLabeledRange = const RangeValues(40, 60);
  double _capsuleScale = 60;
  RangeValues _capsuleScaleRange = const RangeValues(20, 80);
  double _vertical = 35;
  RangeValues _verticalScaleRange = const RangeValues(20, 60);
  double _verticalCapsule = 35;
  RangeValues _verticalCapsuleScaleRange = const RangeValues(20, 80);

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
  Widget _buildLabeled(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _panel(
          TSlider(
            key: const ValueKey('slider-labeled'),
            value: _labeled,
            min: 0,
            max: 100,
            showThumbValue: true,
            thumbFormatter: _percent,
            onChanged: (value) => setState(() => _labeled = value),
          ),
        ),
        _subsection(context, '带数值双游标滑块'),
        Row(
          children: [
            const TText('0%'),
            Expanded(
              child: TRangeSlider(
                key: const ValueKey('slider-labeled-range'),
                value: _labeledRange,
                min: 0,
                max: 100,
                showThumbValue: true,
                thumbFormatter: _percent,
                onChanged: (value) => setState(() => _labeledRange = value),
              ),
            ),
            const TText('100%'),
          ],
        ),
      ],
    );
  }

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
  Widget _buildScale(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _panel(
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
        ),
        _subsection(context, '带刻度双游标滑块'),
        _panel(
          TRangeSlider(
            key: const ValueKey('slider-scale-range'),
            value: _scaleRange,
            min: 0,
            max: 100,
            divisions: 5,
            showScaleValue: true,
            scaleFormatter: _integer,
            onChanged: (value) => setState(() => _scaleRange = value),
          ),
        ),
      ],
    );
  }

  @ExampleCode(group: 'slider')
  Widget _buildDisabled(BuildContext context) => const Column(
    children: [
      TSlider(key: ValueKey('slider-disabled'), value: 35, min: 0, max: 100),
      SizedBox(height: 16),
      Row(
        children: [
          TText('0%'),
          Expanded(
            child: TRangeSlider(
              key: ValueKey('slider-disabled-labeled-range'),
              value: RangeValues(40, 60),
              min: 0,
              max: 100,
              showThumbValue: true,
              thumbFormatter: _percent,
            ),
          ),
          TText('100%'),
        ],
      ),
      SizedBox(height: 16),
      TRangeSlider(
        key: ValueKey('slider-disabled-scale-range'),
        value: RangeValues(20, 60),
        min: 0,
        max: 100,
        divisions: 5,
        showScaleValue: true,
        scaleFormatter: _integer,
      ),
    ],
  );

  @ExampleCode(group: 'slider')
  Widget _buildCapsule(BuildContext context) {
    final capsuleTheme = SliderTheme.of(context).copyWith(
      trackHeight: 16,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 8),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
    );

    Widget capsule(Widget slider) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SliderTheme(data: capsuleTheme, child: slider),
    );

    return Column(
      children: [
        capsule(
          TSlider(
            key: const ValueKey('slider-capsule'),
            value: _capsule,
            min: 0,
            max: 100,
            onChanged: (value) => setState(() => _capsule = value),
          ),
        ),
        capsule(
          TRangeSlider(
            key: const ValueKey('slider-capsule-range'),
            value: _capsuleRange,
            min: 0,
            max: 100,
            onChanged: (value) => setState(() => _capsuleRange = value),
          ),
        ),
        capsule(
          TRangeSlider(
            key: const ValueKey('slider-capsule-labeled-range'),
            value: _capsuleLabeledRange,
            min: 0,
            max: 100,
            showThumbValue: true,
            thumbFormatter: _percent,
            onChanged: (value) => setState(() => _capsuleLabeledRange = value),
          ),
        ),
        capsule(
          TSlider(
            key: const ValueKey('slider-capsule-scale'),
            value: _capsuleScale,
            min: 0,
            max: 100,
            divisions: 5,
            showScaleValue: true,
            scaleFormatter: _integer,
            onChanged: (value) => setState(() => _capsuleScale = value),
          ),
        ),
        capsule(
          TRangeSlider(
            key: const ValueKey('slider-capsule-scale-range'),
            value: _capsuleScaleRange,
            min: 0,
            max: 100,
            divisions: 5,
            showScaleValue: true,
            scaleFormatter: _integer,
            onChanged: (value) => setState(() => _capsuleScaleRange = value),
          ),
        ),
      ],
    );
  }

  @ExampleCode(group: 'slider')
  Widget _buildVertical(BuildContext context) {
    final capsuleTheme = SliderTheme.of(context).copyWith(
      trackHeight: 16,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 8),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
    );

    Widget verticalSlider({
      required Widget slider,
      String? thumbLabel,
      double? normalizedValue,
      bool showMarks = false,
      Key? labelKey,
      Key? marksKey,
    }) {
      return SizedBox(
        height: 210,
        child: Center(
          child: SizedBox(
            width: 100,
            height: 200,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 8,
                  top: 0,
                  child: SizedBox(
                    width: 48,
                    height: 200,
                    child: RotatedBox(quarterTurns: 3, child: slider),
                  ),
                ),
                if (showMarks)
                  Positioned(
                    left: 58,
                    top: 24,
                    bottom: 24,
                    child: Column(
                      key: marksKey,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        TText('100'),
                        TText('80'),
                        TText('60'),
                        TText('40'),
                        TText('20'),
                        TText('0'),
                      ],
                    ),
                  ),
                if (thumbLabel != null && normalizedValue != null)
                  Positioned(
                    left: 58,
                    top: 16 + (1 - normalizedValue) * 152,
                    child: TText(thumbLabel, key: labelKey),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _subsection(context, '单游标垂直滑块', top: false),
        verticalSlider(
          slider: TSlider(
            key: const ValueKey('slider-vertical'),
            value: _vertical,
            min: 0,
            max: 100,
            onChanged: (value) => setState(() => _vertical = value),
          ),
          thumbLabel: _percent(_vertical),
          normalizedValue: _vertical / 100,
          labelKey: const ValueKey('slider-vertical-label'),
        ),
        _subsection(context, '带刻度的双游标垂直滑块'),
        verticalSlider(
          slider: TRangeSlider(
            key: const ValueKey('slider-vertical-scale-range'),
            value: _verticalScaleRange,
            min: 0,
            max: 100,
            divisions: 5,
            onChanged: (value) => setState(() => _verticalScaleRange = value),
          ),
          showMarks: true,
          marksKey: const ValueKey('slider-vertical-scale-labels'),
        ),
        _subsection(context, '胶囊型垂直滑块'),
        verticalSlider(
          slider: SliderTheme(
            data: capsuleTheme,
            child: TSlider(
              key: const ValueKey('slider-vertical-capsule'),
              value: _verticalCapsule,
              min: 0,
              max: 100,
              onChanged: (value) => setState(() => _verticalCapsule = value),
            ),
          ),
          thumbLabel: _percent(_verticalCapsule),
          normalizedValue: _verticalCapsule / 100,
          labelKey: const ValueKey('slider-vertical-capsule-label'),
        ),
        _subsection(context, '带刻度的胶囊型垂直滑块'),
        verticalSlider(
          slider: SliderTheme(
            data: capsuleTheme,
            child: TRangeSlider(
              key: const ValueKey('slider-vertical-capsule-scale-range'),
              value: _verticalCapsuleScaleRange,
              min: 0,
              max: 100,
              divisions: 5,
              onChanged: (value) =>
                  setState(() => _verticalCapsuleScaleRange = value),
            ),
          ),
          showMarks: true,
          marksKey: const ValueKey('slider-vertical-capsule-scale-labels'),
        ),
      ],
    );
  }

  static String _percent(double value) => '${value.round()}%';
  static String _integer(double value) => value.round().toString();

  Widget _panel(Widget child) =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: child);

  Widget _subsection(BuildContext context, String text, {bool top = true}) =>
      Padding(
        padding: EdgeInsets.only(top: top ? 12 : 0, bottom: 8),
        child: TText(text, font: context.tTheme.fontBodyMedium),
      );
}
