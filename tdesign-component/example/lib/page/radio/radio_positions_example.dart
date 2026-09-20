import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'radio')
class RadioPositionsExample extends StatefulWidget {
  const RadioPositionsExample({super.key});

  @override
  State<RadioPositionsExample> createState() => _RadioPositionsExampleState();
}

class _RadioPositionsExampleState extends State<RadioPositionsExample> {
  Widget _positions(BuildContext context) {
    return Column(
      children: [
        TRadioGroup<bool>(
          value: _leftSelected,
          onChanged: (_) => setState(() => _leftSelected = !_leftSelected),
          child: const TRadio<bool>(value: true, title: '单选'),
        ),
        SizedBox(height: context.tTheme.spacer16),
        TRadioGroup<bool>(
          value: _rightSelected,
          onChanged: (_) => setState(() => _rightSelected = !_rightSelected),
          child: const TRadio<bool>(
            value: true,
            title: '单选',
            contentDirection: TContentDirection.left,
          ),
        ),
      ],
    );
  }

  bool _leftSelected = true;

  bool _rightSelected = true;

  @override
  Widget build(BuildContext context) {
    return _positions(context);
  }
}
