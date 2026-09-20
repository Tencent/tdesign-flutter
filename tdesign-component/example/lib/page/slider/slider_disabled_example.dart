import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'slider')
class SliderDisabledExample extends StatelessWidget {
  const SliderDisabledExample({super.key});

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

  static String _percent(double value) => '${value.round()}%';

  static String _integer(double value) => value.round().toString();

  @override
  Widget build(BuildContext context) {
    return _buildDisabled(context);
  }
}
