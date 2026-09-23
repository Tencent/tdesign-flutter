import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'dialog')
class CustomActionDialogExample extends StatelessWidget {
  const CustomActionDialogExample({super.key});

  Widget _customActionDialog(BuildContext context) {
    return _trigger('开放能力按钮', () async {
      final result = await TDialog.show<String>(
        context,
        barrierDismissible: true,
        dialog: const TDialog(
          title: Text('弹窗标题'),
          content: Text('通过现有操作项组合业务能力，无需增加跨端专用参数。'),
          actions: [
            TDialogAction(
              child: Text('取消'),
              result: 'cancel',
              variant: TButtonVariant.text,
            ),
            TDialogAction(
              result: 'share',
              role: TDialogActionRole.primary,
              variant: TButtonVariant.text,
              child: Text('分享给朋友'),
            ),
          ],
        ),
      );
      debugPrint(result == 'share' ? '执行分享能力' : '取消操作');
    });
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

  @override
  Widget build(BuildContext context) {
    return _customActionDialog(context);
  }
}
