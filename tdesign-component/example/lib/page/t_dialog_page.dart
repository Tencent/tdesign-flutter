import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// Dialog 弹窗示例页
class TDialogPage extends StatelessWidget {
  const TDialogPage({super.key});

  static const _description = '告知当前状态、信息和解决方法等内容。描述文案尽可能控制在三行内';

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于显示重要提示或请求用户完成关键操作。',
      exampleCodeGroup: 'dialog',
      padding: const EdgeInsets.symmetric(horizontal: 16),
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '反馈类对话框', builder: _feedbackDialogs),
            ExampleItem(desc: '确认类对话框', builder: _confirmDialogs),
            ExampleItem(desc: '输入类对话框', builder: _inputDialogs),
            ExampleItem(desc: '带图片的对话框', builder: _imageDialogs),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [ExampleItem(desc: '按钮布局与关闭按钮', builder: _buttonDialogs)],
        ),
        ExampleModule(
          title: '组件用法',
          children: [
            ExampleItem(desc: '命令调用', builder: _commandDialog),
            ExampleItem(desc: '自定义按钮', builder: _customActionDialog),
          ],
        ),
      ],
    );
  }

  Widget _scenarios(List<Widget> children) {
    return Column(
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) const SizedBox(height: 12),
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

  List<TDialogAction> _actions({bool destructive = false}) => [
    const TDialogAction(child: Text('取消'), result: false),
    TDialogAction(
      child: Text(destructive ? '警示操作' : '确定'),
      result: true,
      role: destructive
          ? TDialogActionRole.destructive
          : TDialogActionRole.primary,
    ),
  ];

  @ExampleCode(group: 'dialog')
  Widget _feedbackDialogs(BuildContext context) {
    return _scenarios([
      _trigger('反馈类-带标题', () {
        TDialog.show<void>(
          context,
          dialog: const TConfirmDialog(title: '对话框标题', content: _description),
        );
      }),
      _trigger('反馈类-无标题', () {
        TDialog.show<void>(
          context,
          dialog: const TConfirmDialog(content: _description),
        );
      }),
      _trigger('反馈类-纯标题', () {
        TDialog.show<void>(
          context,
          dialog: const TConfirmDialog(title: '对话框标题'),
        );
      }),
      _trigger('反馈类-内容超长', () {
        TDialog.show<void>(
          context,
          dialog: TDialog(
            title: const Text('对话框标题'),
            maxHeight: 456,
            content: Text(List.filled(12, '这里是辅助内容文案。').join()),
            actions: const [
              TDialogAction(
                child: Text('知道了'),
                role: TDialogActionRole.primary,
              ),
            ],
          ),
        );
      }),
    ]);
  }

  @ExampleCode(group: 'dialog')
  Widget _confirmDialogs(BuildContext context) {
    return _scenarios([
      _trigger('确认类-带标题', () {
        TDialog.show<bool>(
          context,
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
          dialog: TDialog(
            content: const Text(_description),
            actions: _actions(destructive: true),
          ),
        );
      }),
      _trigger('确认类-纯标题', () {
        TDialog.show<bool>(
          context,
          dialog: TDialog(title: const Text('对话框标题'), actions: _actions()),
        );
      }),
    ]);
  }

  @ExampleCode(group: 'dialog')
  Widget _buttonDialogs(BuildContext context) {
    return _scenarios([
      _trigger('文字按钮', () {
        TDialog.show<bool>(
          context,
          dialog: TDialog(
            title: const Text('对话框标题'),
            content: const Text(_description),
            actions: _actions(),
          ),
        );
      }),
      _trigger('水平基础按钮', () {
        TDialog.show<bool>(
          context,
          dialog: TDialog(
            content: const Text(_description),
            actions: _actions(),
          ),
        );
      }),
      _trigger('垂直基础按钮', () {
        TDialog.show<void>(
          context,
          dialog: TDialog(
            title: const Text('对话框标题'),
            content: const Text(_description),
            actionsWidget: _verticalButtons(context),
          ),
        );
      }),
      _trigger('多按钮', () {
        TDialog.show<String>(
          context,
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
      _trigger('带关闭按钮的对话框', () {
        TDialog.show<bool>(
          context,
          dialog: TDialog(
            title: const Text('对话框标题'),
            content: const Text(_description),
            showCloseButton: true,
            actions: _actions(destructive: true),
          ),
        );
      }),
    ]);
  }

  Widget _verticalButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TButton(
            variant: TButtonVariant.fill,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定'),
          ),
          const SizedBox(height: 12),
          TButton(
            variant: TButtonVariant.outline,
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'dialog')
  Widget _imageDialogs(BuildContext context) {
    return _scenarios([
      _trigger('图片置顶-带标题描述', () {
        _showImageDialog(
          context,
          imageOnTop: true,
          showTitle: true,
          showContent: true,
        );
      }),
      _trigger('图片置顶-无标题', () {
        _showImageDialog(
          context,
          imageOnTop: true,
          showTitle: false,
          showContent: true,
        );
      }),
      _trigger('图片置顶-纯标题', () {
        _showImageDialog(
          context,
          imageOnTop: true,
          showTitle: true,
          showContent: false,
        );
      }),
      _trigger('图片置顶-纯图片', () {
        _showImageDialog(
          context,
          imageOnTop: true,
          showTitle: false,
          showContent: false,
        );
      }),
      _trigger('图片居中-带标题描述', () {
        _showImageDialog(
          context,
          imageOnTop: false,
          showTitle: true,
          showContent: true,
        );
      }),
      _trigger('图片居中-纯标题', () {
        _showImageDialog(
          context,
          imageOnTop: false,
          showTitle: true,
          showContent: false,
        );
      }),
    ]);
  }

  void _showImageDialog(
    BuildContext context, {
    required bool imageOnTop,
    required bool showTitle,
    required bool showContent,
  }) {
    const image = Image(
      image: AssetImage('assets/img/image.png'),
      height: 140,
      width: double.infinity,
      fit: BoxFit.cover,
    );
    final title = showTitle
        ? const Text(
            '对话框标题',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              height: 26 / 18,
              fontWeight: FontWeight.w600,
            ),
          )
        : null;
    final description = showContent
        ? const Text(_description, textAlign: TextAlign.center)
        : null;
    final textContent = Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          if (title != null) title,
          if (title != null && description != null) const SizedBox(height: 8),
          if (!imageOnTop) ...[
            image,
            if (description != null) const SizedBox(height: 8),
          ],
          if (description != null) description,
        ],
      ),
    );
    TDialog.show<bool>(
      context,
      dialog: TDialog(
        contentPadding: EdgeInsets.zero,
        content: Column(
          children: [
            if (imageOnTop) image,
            if (showTitle || showContent) textContent,
          ],
        ),
        actions: _actions(),
      ),
    );
  }

  @ExampleCode(group: 'dialog')
  Widget _inputDialogs(BuildContext context) {
    return _scenarios([
      _trigger('输入类-无描述', () {
        TDialog.show<bool>(
          context,
          dialog: TDialog(
            title: const Text('带输入框对话框'),
            content: const TextField(
              decoration: InputDecoration(
                hintText: '输入12字文案',
                border: InputBorder.none,
              ),
            ),
            actions: _actions(),
          ),
        );
      }),
      _trigger('输入类-带描述', () {
        TDialog.show<bool>(
          context,
          dialog: TDialog(
            title: const Text('带输入框对话框'),
            content: const Column(
              children: [
                Text(_description),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: '输入12字文案',
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
            actions: _actions(),
          ),
        );
      }),
    ]);
  }

  @ExampleCode(group: 'dialog')
  Widget _commandDialog(BuildContext context) {
    return _trigger('命令行操作', () async {
      final confirmed = await TDialog.show<bool>(
        context,
        barrierDismissible: true,
        dialog: TDialog(
          title: const Text('弹窗标题'),
          content: const Text('告知当前状态、信息和解决方法等内容。'),
          actions: _actions(),
        ),
      );
      debugPrint(confirmed == true ? '点击了确定' : '点击了取消');
    });
  }

  @ExampleCode(group: 'dialog')
  Widget _customActionDialog(BuildContext context) {
    return _trigger('开放能力按钮', () async {
      final result = await TDialog.show<String>(
        context,
        dialog: const TDialog(
          title: Text('弹窗标题'),
          content: Text('通过现有操作项组合业务能力，无需增加跨端专用参数。'),
          actions: [
            TDialogAction(child: Text('取消'), result: 'cancel'),
            TDialogAction(
              result: 'share',
              role: TDialogActionRole.primary,
              child: Text('分享给朋友'),
            ),
          ],
        ),
      );
      debugPrint(result == 'share' ? '执行分享能力' : '取消操作');
    });
  }
}
