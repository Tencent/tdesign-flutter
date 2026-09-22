import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'input')
class InputSlotsExample extends StatelessWidget {
  const InputSlotsExample({super.key});

  Widget _buildSlots(BuildContext context) {
    final token = context.tTheme;

    return ColoredBox(
      color: token.bgColorPage,
      child: const Column(
        children: [
          TFormItem(
            leading: Icon(TIcons.app),
            label: '标签文字',
            verticalAlignment: TFormItemVerticalAlignment.center,
            child: TInput(borderless: true, hintText: '请输入文字'),
          ),
          SizedBox(height: 16),
          TInput(borderless: true, hintText: '请输入文字', prefix: Icon(TIcons.app)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSlots(context);
  }
}
