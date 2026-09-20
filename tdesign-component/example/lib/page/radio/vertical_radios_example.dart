import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'radio')
class VerticalRadiosExample extends StatefulWidget {
  const VerticalRadiosExample({super.key});

  @override
  State<VerticalRadiosExample> createState() => _VerticalRadiosExampleState();
}

class _VerticalRadiosExampleState extends State<VerticalRadiosExample> {
  Widget _verticalRadios(BuildContext context) {
    return TRadioGroup<int>.options(
      value: _verticalValue,
      options: _options,
      onChanged: (value) {
        setState(() => _verticalValue = _verticalValue == value ? null : value);
      },
      showDivider: true,
    );
  }

  int? _verticalValue = 1;

  static const _options = [
    TRadioOption(value: 0, label: '单选'),
    TRadioOption(value: 1, label: '单选'),
    TRadioOption(value: 2, label: '单选单选单选单选单选单选单选单选单选单选单选单选单选单选'),
    TRadioOption(
      value: 3,
      label: '单选',
      subTitle: '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _verticalRadios(context);
  }
}
