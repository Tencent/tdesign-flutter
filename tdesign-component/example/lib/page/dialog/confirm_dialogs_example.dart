import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'dialog')
class ConfirmDialogsExample extends StatelessWidget {
  const ConfirmDialogsExample({super.key});

  Widget _confirmDialogs(BuildContext context) {
    return _scenarios(context, [
      _trigger('确认类-带标题', () {
        TDialog.show<bool>(
          context,
          barrierDismissible: true,
          dialog: TDialog(
            title: const Text('对话框标题'),
            content: const Text(_description),
            actions: _actions(),
          ),
        );
      }),
      _trigger('确认类-无标题', () {
        TDialog.show<bool>(
          context,
          barrierDismissible: true,
          dialog: TDialog(
            content: const Text(_description),
            actions: _actions(),
          ),
        );
      }),
      _trigger('确认类-纯标题', () {
        TDialog.show<bool>(
          context,
          barrierDismissible: true,
          dialog: TDialog(title: const Text('对话框标题'), actions: _actions()),
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

  static const _description = '告知当前状态、信息和解决方法，等内容。描述尽可能控制在三行内。';

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

  @override
  Widget build(BuildContext context) {
    return _confirmDialogs(context);
  }
}
