import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'slider')
class SliderSingleExample extends StatefulWidget {
  const SliderSingleExample({super.key});

  @override
  State<SliderSingleExample> createState() => _SliderSingleExampleState();
}

class _SliderSingleExampleState extends State<SliderSingleExample> {
  Widget _buildSingle(BuildContext context) => _panel(
    TSlider(
      key: const ValueKey('slider-single'),
      value: _single,
      min: 0,
      max: 100,
      onChanged: (value) => setState(() => _single = value),
    ),
  );

  Widget _panel(Widget child) =>
      Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: child);

  double _single = 23;

  @override
  Widget build(BuildContext context) {
    return _buildSingle(context);
  }
}
