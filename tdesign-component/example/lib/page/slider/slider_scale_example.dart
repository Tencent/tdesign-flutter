import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'slider')
class SliderScaleExample extends StatefulWidget {
  const SliderScaleExample({super.key});

  @override
  State<SliderScaleExample> createState() => _SliderScaleExampleState();
}

class _SliderScaleExampleState extends State<SliderScaleExample> {
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

  Widget _panel(Widget child) =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: child);

  double _scale = 60;

  static String _integer(double value) => value.round().toString();

  Widget _subsection(BuildContext context, String text, {bool top = true}) =>
      Padding(
        padding: EdgeInsets.only(top: top ? 12 : 0, bottom: 8),
        child: TText(text, font: context.tTheme.fontBodyMedium),
      );

  RangeValues _scaleRange = const RangeValues(20, 60);

  @override
  Widget build(BuildContext context) {
    return _buildScale(context);
  }
}
