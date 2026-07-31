import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// Dialog 弹窗示例页面
class TDialogPage extends StatelessWidget {
  const TDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于显示重要提示或请求用户完成关键操作。',
      exampleCodeGroup: 'dialog',
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '单操作确认弹窗', builder: _buildConfirmDialog),
          ExampleItem(desc: '双操作弹窗', builder: _buildActionDialog),
          ExampleItem(desc: '危险操作弹窗', builder: _buildDangerDialog),
        ]),
        ExampleModule(title: '内容与状态', children: [
          ExampleItem(desc: '自定义内容', builder: _buildCustomContentDialog),
          ExampleItem(desc: '长内容滚动', builder: _buildLongContentDialog),
          ExampleItem(desc: '带关闭按钮', builder: _buildCloseDialog),
          ExampleItem(desc: '点击蒙层关闭', builder: _buildBarrierDismissDialog),
        ]),
      ],
    );
  }

  @ExampleCode(group: 'dialog')
  Widget _buildConfirmDialog(BuildContext context) {
    return _trigger(
      text: '单操作确认弹窗',
      onPressed: () {
        TDialog.show<bool>(
          context,
          dialog: const TConfirmDialog(
            title: '弹窗标题',
            content: '告知当前状态、信息和解决方法',
          ),
        );
      },
    );
  }

  @ExampleCode(group: 'dialog')
  Widget _buildActionDialog(BuildContext context) {
    return _trigger(
      text: '双操作弹窗',
      onPressed: () async {
        final confirmed = await TDialog.show<bool>(
          context,
          dialog: const TDialog(
            title: Text('提交修改？'),
            content: Text('提交后将立即同步给团队成员。'),
            actions: [
              TDialogAction(child: Text('取消'), result: false),
              TDialogAction(
                child: Text('确认'),
                result: true,
                role: TDialogActionRole.primary,
              ),
            ],
          ),
        );
        debugPrint('Dialog result: $confirmed');
      },
    );
  }

  @ExampleCode(group: 'dialog')
  Widget _buildDangerDialog(BuildContext context) {
    return _trigger(
      text: '危险操作弹窗',
      onPressed: () {
        TDialog.show<bool>(
          context,
          dialog: const TDialog(
            title: Text('删除项目？'),
            content: Text('删除后无法恢复，请谨慎操作。'),
            actions: [
              TDialogAction(child: Text('取消'), result: false),
              TDialogAction(
                child: Text('删除'),
                result: true,
                role: TDialogActionRole.destructive,
              ),
            ],
          ),
        );
      },
    );
  }

  @ExampleCode(group: 'dialog')
  Widget _buildCustomContentDialog(BuildContext context) {
    return _trigger(
      text: '自定义内容',
      onPressed: () {
        TDialog.show<void>(
          context,
          dialog: const TDialog(
            title: Text('选择通知方式'),
            content: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.email_outlined),
                  title: Text('邮件通知'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.sms_outlined),
                  title: Text('短信通知'),
                ),
              ],
            ),
            actions: [
              TDialogAction(
                child: Text('完成'),
                role: TDialogActionRole.primary,
              ),
            ],
          ),
        );
      },
    );
  }

  @ExampleCode(group: 'dialog')
  Widget _buildLongContentDialog(BuildContext context) {
    return _trigger(
      text: '长内容滚动',
      onPressed: () {
        TDialog.show<void>(
          context,
          dialog: TDialog(
            title: const Text('服务说明'),
            maxHeight: 320,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                18,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    '${index + 1}. 这是一段需要滚动阅读的服务说明，'
                    '请确认你已了解相关规则和注意事项。',
                  ),
                ),
              ),
            ),
            actions: const [
              TDialogAction(
                child: Text('知道了'),
                role: TDialogActionRole.primary,
              ),
            ],
          ),
        );
      },
    );
  }

  @ExampleCode(group: 'dialog')
  Widget _buildCloseDialog(BuildContext context) {
    return _trigger(
      text: '带关闭按钮',
      onPressed: () {
        TDialog.show<void>(
          context,
          dialog: const TDialog(
            title: Text('弹窗标题'),
            content: Text('可通过右上角按钮关闭。'),
            showCloseButton: true,
          ),
        );
      },
    );
  }

  @ExampleCode(group: 'dialog')
  Widget _buildBarrierDismissDialog(BuildContext context) {
    return _trigger(
      text: '点击蒙层关闭',
      onPressed: () {
        TDialog.show<void>(
          context,
          barrierDismissible: true,
          dialog: const TDialog(
            title: Text('点击外部区域即可关闭'),
            content: Text('适合非关键提示或可随时取消的辅助信息。'),
          ),
        );
      },
    );
  }

  Widget _trigger({
    required String text,
    required VoidCallback onPressed,
  }) {
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
}
