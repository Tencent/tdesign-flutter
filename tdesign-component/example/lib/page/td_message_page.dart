import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';

class TDMessagePage extends StatefulWidget {
  const TDMessagePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDMessagePageState();
}

class _TDMessagePageState extends State<TDMessagePage> {
  final _commonContent = '这是一条普通的通知信息';
  final longContent = '这是一条普通的通知信息看，这是一条普通的通知信息，这是一条普通的通知信息';

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
        title: tdTitle(),
        backgroundColor: Colors.white,
        desc: '用于轻量级反馈或提示，不会打断用户操作。',
        exampleCodeGroup: 'message',
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(desc: '纯文字的通知', builder: _buildPlainTextMessage),
            ExampleItem(desc: '带图标的通知', builder: _buildIconTextMessage),
            ExampleItem(desc: '带关闭的通知', builder: _buildMessageWithCloseButton),
            ExampleItem(desc: '可滚动的通知', builder: _buildRollingMessage),
            ExampleItem(desc: '带按钮的通知', builder: _buildLinkMessage),
          ]),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(desc: '普通通知', builder: _buildInfoMessage),
            ExampleItem(desc: '成功通知', builder: _buildSuccessMessage),
            ExampleItem(desc: '警示通知', builder: _buildWarningMessage),
            ExampleItem(desc: '错误通知', builder: _buildErrorMessage),
          ]),
        ]);
  }

  @Demo(group: 'message')
  Widget _buildPlainTextMessage(BuildContext context) {
    return TDButton(
      isBlock: true,
      text: '纯文字的通知',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      width: 450,
      theme: TDButtonTheme.primary,
      onTap: () {
        TDMessage.showMessage(
          context: context,
          content: _commonContent,
          visible: true,
          icon: false,
          theme: MessageTheme.info,
          duration: 3000,
          onDurationEnd: () {
            print('message end');
          },
        );
      },
    );
  }

  @Demo(group: 'message')
  Widget _buildIconTextMessage(BuildContext context) {
    return TDButton(
        isBlock: true,
        text: '带图标的通知',
        size: TDButtonSize.large,
        type: TDButtonType.outline,
        width: 450,
        theme: TDButtonTheme.primary,
        onTap: () {
          TDMessage.showMessage(
            context: context,
            content: _commonContent,
            visible: true,
            icon: true,
            theme: MessageTheme.info,
            duration: 3000,
          );
        });
  }

  @Demo(group: 'message')
  Widget _buildMessageWithCloseButton(BuildContext context) {
    return TDButton(
        isBlock: true,
        text: '带关闭的通知',
        size: TDButtonSize.large,
        type: TDButtonType.outline,
        width: 450,
        theme: TDButtonTheme.primary,
        onTap: () {
          TDMessage.showMessage(
            context: context,
            visible: true,
            icon: true,
            content: _commonContent,
            theme: MessageTheme.info,
            duration: 300000,
            closeBtn: true,
            link: MessageLink(name: '按钮', uri: Uri.parse('www.example.com')),
            onCloseBtnClick: () {
              print('Close button clicked!');
            },
          );
        });
  }

  @Demo(group: 'message')
  Widget _buildRollingMessage(BuildContext context) {
    return TDButton(
        isBlock: true,
        text: '可滚动的通知',
        size: TDButtonSize.large,
        type: TDButtonType.outline,
        width: 450,
        theme: TDButtonTheme.primary,
        onTap: () {
          TDMessage.showMessage(
              context: context,
              visible: true,
              icon: false,
              marquee: MessageMarquee(speed: 5000, loop: 1, delay: 300),
              content: longContent,
              theme: MessageTheme.info,
              duration: 8000,
              onCloseBtnClick: () {
                print('Close button clicked!');
              });
        });
  }

  @Demo(group: 'message')
  Widget _buildLinkMessage(BuildContext context) {
    return TDButton(
        isBlock: true,
        text: '带按钮的通知',
        size: TDButtonSize.large,
        type: TDButtonType.outline,
        width: 450,
        theme: TDButtonTheme.primary,
        onTap: () {
          TDMessage.showMessage(
              context: context,
              visible: true,
              icon: true,
              content: _commonContent,
              theme: MessageTheme.info,
              duration: 3000,
              link: '按钮',
              onLinkClick: () {
                print('link clicked!');
              });
        });
  }

  @Demo(group: 'message')
  Widget _buildInfoMessage(BuildContext context) {
    return TDButton(
      isBlock: true,
      text: '普通通知',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      width: 450,
      theme: TDButtonTheme.primary,
      onTap: () {
        TDMessage.showMessage(
          context: context,
          visible: true,
          icon: true,
          content: _commonContent,
          theme: MessageTheme.info,
          duration: 3000,
        );
      },
    );
  }

  @Demo(group: 'message')
  Widget _buildSuccessMessage(BuildContext context) {
    return TDButton(
      isBlock: true,
      text: '成功通知',
      size: TDButtonSize.large,
      type: TDButtonType.outline,
      width: 450,
      theme: TDButtonTheme.primary,
      onTap: () {
        TDMessage.showMessage(
          context: context,
          visible: true,
          icon: true,
          content: _commonContent,
          theme: MessageTheme.success,
          duration: 3000,
        );
      },
    );
  }

  @Demo(group: 'message')
  Widget _buildWarningMessage(BuildContext context) {
    return TDButton(
        isBlock: true,
        text: '警示通知',
        size: TDButtonSize.large,
        type: TDButtonType.outline,
        width: 450,
        theme: TDButtonTheme.primary,
        onTap: () {
          TDMessage.showMessage(
            context: context,
            visible: true,
            icon: true,
            content: _commonContent,
            theme: MessageTheme.warning,
            duration: 3000,
          );
        });
  }

  @Demo(group: 'message')
  Widget _buildErrorMessage(BuildContext context) {
    return TDButton(
        isBlock: true,
        text: '错误通知',
        size: TDButtonSize.large,
        type: TDButtonType.outline,
        width: 450,
        theme: TDButtonTheme.primary,
        onTap: () {
          TDMessage.showMessage(
            context: context,
            visible: true,
            icon: true,
            content: _commonContent,
            theme: MessageTheme.error,
            duration: 3000,
          );
        });
  }
}
