import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'radio')
class DisabledRadiosExample extends StatelessWidget {
  const DisabledRadiosExample({super.key});

  Widget _disabledRadios(BuildContext context) {
    return const TRadioGroup<int>.options(
      value: 0,
      options: [
        TRadioOption(value: 0, label: '单选-已选'),
        TRadioOption(value: 1, label: '单选-未选'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _disabledRadios(context);
  }
}
