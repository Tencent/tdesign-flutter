import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'dialog')
class InputDialogsExample extends StatefulWidget {
  const InputDialogsExample({super.key});

  @override
  State<InputDialogsExample> createState() => _InputDialogsExampleState();
}

class _InputDialogsExampleState extends State<InputDialogsExample> {
  Widget _inputDialogs(BuildContext context) {
    return _scenarios(context, [
      _trigger('输入类-无描述', () {
        TDialog.show<bool>(
          context,
          barrierDismissible: true,
          dialog: TDialog(
            title: const Text('带输入框对话框'),
            content: _dialogInput(context, topPadding: context.tTheme.spacer8),
            actions: _actions(variant: TButtonVariant.text),
          ),
        );
      }),
      _trigger('输入类-带描述', () {
        TDialog.show<bool>(
          context,
          barrierDismissible: true,
          dialog: TDialog(
            title: const Text('带输入框对话框'),
            content: Column(
              children: [
                const Text(_description),
                SizedBox(height: context.tTheme.spacer16),
                _dialogInput(context),
              ],
            ),
            actions: _actions(variant: TButtonVariant.text),
          ),
        );
      }),
    ]);
  }

  Widget _scenarios(BuildContext context, List<Widget> children) {
    return Column(
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) SizedBox(height: context.tTheme.spacer16),
          children[index],
        ],
      ],
    );
  }

  Widget _trigger(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }

  Widget _dialogInput(BuildContext context, {double topPadding = 0}) {
    final token = context.tTheme;
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Theme(
        data: Theme.of(context).mergeExtension(
          TInputThemeData(
            clearButtonMode: TInputClearButtonMode.focused,
            contentPadding: EdgeInsets.symmetric(
              horizontal: token.spacer16,
              vertical: token.spacer12,
            ),
            borderRadius: 4,
            backgroundColor: token.bgColorPage,
          ),
        ),
        child: const TInput(
          borderless: true,
          hintText: '输入12文案',
          clearButtonMode: TInputClearButtonMode.focused,
        ),
      ),
    );
  }

  List<TDialogAction> _actions({
    bool destructive = false,
    TButtonVariant? variant,
    TButtonColorScheme? primaryColorScheme,
  }) => [
    TDialogAction(variant: variant, child: const Text('取消'), result: false),
    TDialogAction(
      child: Text(destructive ? '警示操作' : '确定'),
      result: true,
      variant: variant,
      colorScheme: primaryColorScheme,
      role: destructive
          ? TDialogActionRole.destructive
          : TDialogActionRole.primary,
    ),
  ];

  static const _description = '告知当前状态、信息和解决方法，等内容。描述尽可能控制在三行内。';

  @override
  Widget build(BuildContext context) {
    return _inputDialogs(context);
  }
}
