import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'input')
class InputStatusExample extends StatelessWidget {
  const InputStatusExample({super.key});

  Widget _buildStatus(BuildContext context) {
    final token = context.tTheme;
    return Column(
      children: [
        TFormItem(
          label: '标签文字',
          errorText: '错误提示',
          verticalAlignment: TFormItemVerticalAlignment.center,
          child: Theme(
            data: Theme.of(context).mergeExtension(
              TInputThemeData(clearIconColor: token.errorNormalColor),
            ),
            child: const TInput(
              borderless: true,
              initialValue: '已输入内容',
              status: TInputStatus.error,
              clearButtonMode: TInputClearButtonMode.always,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildDisabled(context),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDisabled(BuildContext context) => const TFormItem(
    label: '标签文字',
    child: TInput(borderless: true, initialValue: '不可编辑文字', enabled: false),
  );

  @override
  Widget build(BuildContext context) {
    return _buildStatus(context);
  }
}
