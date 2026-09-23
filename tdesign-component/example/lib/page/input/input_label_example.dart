import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'input')
class InputLabelExample extends StatelessWidget {
  const InputLabelExample({super.key});

  Widget _buildLabel(BuildContext context) => const TFormItem(
    label: '标签超长时最多十个字',
    verticalAlignment: TFormItemVerticalAlignment.center,
    child: TInput(borderless: true, hintText: '请输入文字'),
  );

  @override
  Widget build(BuildContext context) {
    return _buildLabel(context);
  }
}
