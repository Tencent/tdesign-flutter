import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'input')
class InputLayoutExample extends StatelessWidget {
  const InputLayoutExample({super.key});

  Widget _buildLayout(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TFormThemeData(layout: TFormLayout.vertical, labelGap: 8),
      ),
      child: const TFormItem(
        label: '标签文字',
        child: TInput(
          borderless: true,
          hintText: '请输入文字',
          suffix: Icon(TIcons.info_circle_filled),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildLayout(context);
  }
}
