import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'slider')
class SliderCapsuleExample extends StatefulWidget {
  const SliderCapsuleExample({super.key});

  @override
  State<SliderCapsuleExample> createState() => _SliderCapsuleExampleState();
}

class _SliderCapsuleExampleState extends State<SliderCapsuleExample> {
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

  double _capsule = 30;

  RangeValues _capsuleRange = const RangeValues(40, 60);

  RangeValues _capsuleLabeledRange = const RangeValues(40, 60);

  static String _percent(double value) => '${value.round()}%';

  double _capsuleScale = 60;

  static String _integer(double value) => value.round().toString();

  RangeValues _capsuleScaleRange = const RangeValues(20, 80);

  @override
  Widget build(BuildContext context) {
    return _buildCapsule(context);
  }
}
