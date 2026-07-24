import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

/// Dialog 弹窗示例页面
class TDialogPage extends StatelessWidget {
  const TDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于显示重要提示信息，用户必须点击按钮才能关闭。',
      exampleCodeGroup: 'dialog',
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '确认弹窗', builder: _buildConfirmDialog),
          ExampleItem(desc: '文字按钮弹窗', builder: _buildTextButtonDialog),
        ]),
        ExampleModule(title: '组件状态', children: [
          ExampleItem(desc: '带标题弹窗', builder: _buildWithTitle),
          ExampleItem(desc: '无标题弹窗', builder: _buildNoTitle),
          ExampleItem(desc: '带关闭按钮', builder: _buildWithClose),
        ]),
      ],
    );
  }

  @Demo(group: 'dialog')
  Widget _buildConfirmDialog(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('确认弹窗'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const TConfirmDialog(
              title: '弹窗标题',
              content: '告知当前状态、信息和解决方法',
            ),
          );
        },
      ),
    );
  }

  @Demo(group: 'dialog')
  Widget _buildTextButtonDialog(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('文字按钮弹窗'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const TConfirmDialog(
              title: '弹窗标题',
              content: '告知当前状态、信息和解决方法',
              buttonStyle: TDialogButtonStyle.text,
            ),
          );
        },
      ),
    );
  }

  @Demo(group: 'dialog')
  Widget _buildWithTitle(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('带标题弹窗'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => TConfirmDialog(
              title: '弹窗标题',
              content: '告知当前状态、信息和解决方法，等内容较长时换行展示',
              buttonText: '知道了',
              onPressed: () => Navigator.pop(context),
            ),
          );
        },
      ),
    );
  }

  @Demo(group: 'dialog')
  Widget _buildNoTitle(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('无标题弹窗'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const TConfirmDialog(
              content: '告知当前状态、信息和解决方法',
            ),
          );
        },
      ),
    );
  }

  @Demo(group: 'dialog')
  Widget _buildWithClose(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: const Text('带关闭按钮'),
        size: TButtonSize.large,
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const TConfirmDialog(
              title: '弹窗标题',
              content: '告知当前状态、信息和解决方法',
              showCloseButton: true,
            ),
          );
        },
      ),
    );
  }
}
