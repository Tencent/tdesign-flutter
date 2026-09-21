import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

@ExampleCode(group: 'slider')
class SliderScaleRangeExample extends StatefulWidget {
  const SliderScaleRangeExample({super.key});

  @override
  State<SliderScaleRangeExample> createState() =>
      _SliderScaleRangeExampleState();
}

class _SliderScaleRangeExampleState extends State<SliderScaleRangeExample> {
  RangeValues _value = const RangeValues(20, 60);

  static String _integer(double value) => value.round().toString();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TRangeSlider(
        key: const ValueKey('slider-scale-range'),
        value: _value,
        min: 0,
        max: 100,
        divisions: 5,
        showScaleValue: true,
        scaleFormatter: _integer,
        onChanged: (value) => setState(() => _value = value),
      ),
    );
  }
}
