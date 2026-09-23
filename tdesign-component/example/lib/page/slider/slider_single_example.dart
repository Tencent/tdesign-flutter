import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';

@ExampleCode(group: 'slider')
class SliderSingleExample extends StatefulWidget {
  const SliderSingleExample({super.key});

  @override
  State<SliderSingleExample> createState() => _SliderSingleExampleState();
}

class _SliderSingleExampleState extends State<SliderSingleExample> {
  Widget _buildSingle(BuildContext context) => ColoredBox(
    color: context.tTheme.bgColorContainer,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TSlider(
        key: const ValueKey('slider-single'),
        value: _single,
        min: 0,
        max: 100,
        onChanged: (value) => setState(() => _single = value),
      ),
    ),
  );

  double _single = 25;

  @override
  Widget build(BuildContext context) {
    return _buildSingle(context);
  }
}
