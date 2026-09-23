import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';

@ExampleCode(group: 'slider')
class SliderCapsuleExample extends StatefulWidget {
  const SliderCapsuleExample({
    super.key,
    this.type = SliderCapsuleExampleType.single,
  });

  final SliderCapsuleExampleType type;

  @override
  State<SliderCapsuleExample> createState() => _SliderCapsuleExampleState();
}

class _SliderCapsuleExampleState extends State<SliderCapsuleExample> {
  Widget _buildCapsule(BuildContext context) {
    return switch (widget.type) {
      SliderCapsuleExampleType.single => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: TSlider(
          key: const ValueKey('slider-capsule'),
          value: _capsule,
          min: 0,
          max: 100,
          variant: TSliderVariant.capsule,
          onChanged: (value) => setState(() => _capsule = value),
        ),
      ),
      SliderCapsuleExampleType.range => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: TRangeSlider(
          key: const ValueKey('slider-capsule-range'),
          value: _capsuleRange,
          min: 0,
          max: 100,
          variant: TSliderVariant.capsule,
          onChanged: (value) => setState(() => _capsuleRange = value),
        ),
      ),
      SliderCapsuleExampleType.labeledRange => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            const TText('0'),
            Expanded(
              child: TRangeSlider(
                key: const ValueKey('slider-capsule-labeled-range'),
                value: _capsuleLabeledRange,
                min: 0,
                max: 100,
                variant: TSliderVariant.capsule,
                showThumbValue: true,
                thumbFormatter: _integer,
                onChanged: (value) =>
                    setState(() => _capsuleLabeledRange = value),
              ),
            ),
            const TText('100'),
          ],
        ),
      ),
      SliderCapsuleExampleType.scale => Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: TSlider(
          key: const ValueKey('slider-capsule-scale'),
          value: _capsuleScale,
          min: 0,
          max: 100,
          divisions: 5,
          variant: TSliderVariant.capsule,
          showScaleValue: true,
          scaleFormatter: _integer,
          onChanged: (value) => setState(() => _capsuleScale = value),
        ),
      ),
      SliderCapsuleExampleType.scaleRange => Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: TRangeSlider(
          key: const ValueKey('slider-capsule-scale-range'),
          value: _capsuleScaleRange,
          min: 0,
          max: 100,
          divisions: 5,
          variant: TSliderVariant.capsule,
          showScaleValue: true,
          scaleFormatter: _integer,
          onChanged: (value) => setState(() => _capsuleScaleRange = value),
        ),
      ),
    };
  }

  double _capsule = 25;

  RangeValues _capsuleRange = const RangeValues(40, 60);

  RangeValues _capsuleLabeledRange = const RangeValues(40, 60);

  double _capsuleScale = 60;

  static String _integer(double value) => value.round().toString();

  RangeValues _capsuleScaleRange = const RangeValues(20, 80);

  @override
  Widget build(BuildContext context) {
    return _buildCapsule(context);
  }
}

enum SliderCapsuleExampleType { single, range, labeledRange, scale, scaleRange }
