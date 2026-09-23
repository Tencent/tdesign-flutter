import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'input')
class InputActionExample extends StatelessWidget {
  const InputActionExample({super.key});

  Widget _buildAction(BuildContext context) {
    const suffixIcon = Icon(TIcons.info_circle_filled);
    const avatarIcon = Icon(TIcons.user_avatar);
    return Column(
      children: [
        const TFormItem(
          label: '标签文字',
          verticalAlignment: TFormItemVerticalAlignment.center,
          child: TInput(
            borderless: true,
            hintText: '请输入文字',
            suffix: suffixIcon,
          ),
        ),
        const SizedBox(height: 16),
        TFormItem(
          label: '标签文字',
          verticalAlignment: TFormItemVerticalAlignment.center,
          child: const TInput(borderless: true, hintText: '请输入文字'),
          extra: TButton(
            size: TButtonSize.extraSmall,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () {},
            child: const Text('操作按钮'),
          ),
        ),
        const SizedBox(height: 16),
        const TFormItem(
          label: '标签文字',
          verticalAlignment: TFormItemVerticalAlignment.center,
          child: TInput(
            borderless: true,
            hintText: '请输入文字',
            suffix: avatarIcon,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildAction(context);
  }
}
