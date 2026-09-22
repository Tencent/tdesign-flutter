import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'textarea')
class TextareaMaxLengthExample extends StatelessWidget {
  const TextareaMaxLengthExample({super.key});

  Widget _buildMaxLength(BuildContext context) => const SizedBox(
    height: 128,
    child: TTextarea(
      label: '标签文字',
      hintText: '请输入文字',
      minLines: 2,
      maxLength: 500,
      indicator: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return _buildMaxLength(context);
  }
}
