import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'dialog')
class ButtonDialogsExample extends StatefulWidget {
  const ButtonDialogsExample({super.key});

  @override
  State<ButtonDialogsExample> createState() => _ButtonDialogsExampleState();
}

class _ButtonDialogsExampleState extends State<ButtonDialogsExample> {
  Widget _buttonDialogs(BuildContext context) {
    return _scenarios(context, [
      _statusScenario(
        context,
        '文字按钮',
        _trigger('文字按钮', () {
          TDialog.show<bool>(
            context,
            barrierDismissible: true,
            dialog: TDialog(
              title: const Text('对话框标题'),
              content: const Text(_description),
              actions: _actions(variant: TButtonVariant.text),
            ),
          );
        }),
      ),
      _statusScenario(
        context,
        '水平基础按钮',
        _trigger('水平基础按钮', () {
          TDialog.show<bool>(
            context,
            barrierDismissible: true,
            dialog: TDialog(
              content: const Text(_description),
              actions: _actions(),
            ),
          );
        }),
      ),
      _statusScenario(
        context,
        '垂直基础按钮',
        _trigger('垂直基础按钮', () {
          TDialog.show<bool>(
            context,
            barrierDismissible: true,
            dialog: TDialog(
              title: const Text('对话框标题'),
              content: const Text(_description),
              actionsWidget: _verticalButtons(context),
            ),
          );
        }),
      ),
      _statusScenario(
        context,
        '多按钮',
        _trigger('多按钮', () {
          TDialog.show<String>(
            context,
            barrierDismissible: true,
            dialog: const TDialog(
              title: Text('对话框标题'),
              content: Text(_description),
              actions: [
                TDialogAction(child: Text('次要按钮'), result: 'secondary-1'),
                TDialogAction(child: Text('次要按钮'), result: 'secondary-2'),
                TDialogAction(
                  child: Text('主要按钮'),
                  result: 'primary',
                  role: TDialogActionRole.primary,
                ),
              ],
            ),
          );
        }),
      ),
      _statusScenario(
        context,
        '带关闭按钮的对话框',
        _trigger('带关闭按钮的对话框', () {
          TDialog.show<bool>(
            context,
            barrierDismissible: true,
            dialog: TDialog(
              title: const Text('对话框标题'),
              content: const Text(_description),
              showCloseButton: true,
              actions: _actions(destructive: true),
            ),
          );
        }),
      ),
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

  Widget _statusScenario(BuildContext context, String label, Widget trigger) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TText(
          label,
          font: context.tTheme.fontBodyMedium,
          textColor: context.tTheme.textColorSecondary,
        ),
        SizedBox(height: context.tTheme.spacer16),
        trigger,
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

  Widget _verticalButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.tTheme.spacer24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TButton(
            variant: TButtonVariant.fill,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定'),
          ),
          SizedBox(height: context.tTheme.spacer12),
          TButton(
            variant: TButtonVariant.fill,
            colorScheme: TButtonColorScheme.light,
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buttonDialogs(context);
  }
}
