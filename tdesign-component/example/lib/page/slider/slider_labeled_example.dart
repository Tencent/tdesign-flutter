import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'slider')
class SliderLabeledExample extends StatefulWidget {
  const SliderLabeledExample({super.key});

  @override
  State<SliderLabeledExample> createState() => _SliderLabeledExampleState();
}

class _SliderLabeledExampleState extends State<SliderLabeledExample> {
  Widget _buildLabeled(BuildContext context) {
    return _panel(
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
  }

  Widget _panel(Widget child) =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: child);

  double _labeled = 35;

  static String _percent(double value) => '${value.round()}%';

  @override
  Widget build(BuildContext context) {
    return _buildLabeled(context);
  }
}
