import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'textarea')
class TextareaVerticalExample extends StatelessWidget {
  const TextareaVerticalExample({super.key});

  Widget _buildVertical(BuildContext context) => const SizedBox(
    height: 128,
    child: TTextarea(
      label: '标签文字',
      hintText: '请输入文字',
      layout: TTextareaLayout.vertical,
      minLines: 2,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return _buildVertical(context);
  }
}
