import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'input')
class InputAlignExample extends StatelessWidget {
  const InputAlignExample({super.key});

  Widget _buildAlign(BuildContext context) => const Column(
    children: [
      TFormItem(
        label: '左对齐',
        child: TInput(borderless: true, hintText: '请输入文字'),
      ),
      SizedBox(height: 16),
      TFormItem(
        label: '居中',
        child: TInput(
          borderless: true,
          hintText: '请输入文字',
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(height: 16),
      TFormItem(
        label: '右对齐',
        child: TInput(
          borderless: true,
          hintText: '请输入文字',
          textAlign: TextAlign.end,
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return _buildAlign(context);
  }
}
