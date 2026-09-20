import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'textarea')
class TextareaDisabledExample extends StatelessWidget {
  const TextareaDisabledExample({super.key});

  Widget _buildDisabled(BuildContext context) => const SizedBox(
    height: 128,
    child: TTextarea(
      label: '标签文字',
      hintText: '请输入文字',
      initialValue: '不可编辑文字',
      enabled: false,
      minLines: 2,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return _buildDisabled(context);
  }
}
