import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'textarea')
class TextareaVerticalExample extends StatelessWidget {
  const TextareaVerticalExample({super.key});

  Widget _buildVertical(BuildContext context) => const SizedBox(
    height: 162,
    child: TTextarea(
      label: '标签文字',
      hintText: '预设长文本预设长文本',
      layout: TTextareaLayout.vertical,
      minLines: 2,
      maxLength: 500,
      indicator: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return _buildVertical(context);
  }
}
