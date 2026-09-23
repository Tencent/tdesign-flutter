import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'button_dialogs_example.dart';
import 'command_dialog_example.dart';
import 'confirm_dialogs_example.dart';
import 'custom_action_dialog_example.dart';
import 'feedback_dialogs_example.dart';
import 'image_dialogs_example.dart';
import 'input_dialogs_example.dart';

@ExampleCodeManifest()
/// Dialog 弹窗示例页
class TDialogPage extends StatelessWidget {
  const TDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于显示重要提示或请求用户进行重要操作，一种打断当前操作的模态视图。',
      exampleCodeGroup: 'dialog',
      itemMargin: EdgeInsets.symmetric(horizontal: context.tTheme.spacer16),
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '反馈类对话框',
              methodName: 'FeedbackDialogsExample',
              builder: (_) => const FeedbackDialogsExample(),
            ),
            ExampleItem(
              desc: '确认类对话框',
              methodName: 'ConfirmDialogsExample',
              builder: (_) => const ConfirmDialogsExample(),
            ),
            ExampleItem(
              desc: '输入类对话框',
              methodName: 'InputDialogsExample',
              builder: (_) => const InputDialogsExample(),
            ),
            ExampleItem(
              desc: '带图片的对话框',
              methodName: 'ImageDialogsExample',
              builder: (_) => const ImageDialogsExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '',
              methodName: 'ButtonDialogsExample',
              builder: (_) => const ButtonDialogsExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件用法',
          children: [
            ExampleItem(
              desc: '命令调用',
              methodName: 'CommandDialogExample',
              builder: (_) => const CommandDialogExample(),
            ),
            ExampleItem(
              desc: '自定义按钮',
              methodName: 'CustomActionDialogExample',
              builder: (_) => const CustomActionDialogExample(),
            ),
          ],
        ),
      ],
    );
  }
}
