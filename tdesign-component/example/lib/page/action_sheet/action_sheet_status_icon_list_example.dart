import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'action_sheet')
class ActionSheetStatusIconListExample extends StatelessWidget {
  const ActionSheetStatusIconListExample({super.key});

  Widget _statusIconList(BuildContext context) => _trigger(
    label: '列表型选项状态',
    onPressed: () => TActionSheet.showList(
      context,
      cancelText: 'Cancel',
      items: [
        const TActionSheetItem(
          value: 'move',
          label: 'Move',
          icon: Icon(TIcons.enter),
        ),
        TActionSheetItem(
          value: 'important',
          label: 'Mark as important',
          icon: Icon(TIcons.bookmark, color: context.tTheme.brandNormalColor),
          textStyle: TextStyle(color: context.tTheme.brandNormalColor),
        ),
        TActionSheetItem(
          value: 'unsubscribe',
          label: 'Unsubscribe',
          icon: Icon(TIcons.pin, color: context.tTheme.errorNormalColor),
          textStyle: TextStyle(color: context.tTheme.errorNormalColor),
        ),
        const TActionSheetItem(
          value: 'tasks',
          label: 'Add to Tasks',
          icon: Icon(TIcons.cloud_upload),
          disabled: true,
        ),
      ],
      onSelected: (item) => _showSelection(context, item),
    ),
  );

  Widget _trigger({required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: Text(label),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: onPressed,
      ),
    );
  }

  void _showSelection(BuildContext context, TActionSheetItem<String> item) {
    TToast.showText('已选择：${item.label}', context: context);
  }

  @override
  Widget build(BuildContext context) {
    return _statusIconList(context);
  }
}
