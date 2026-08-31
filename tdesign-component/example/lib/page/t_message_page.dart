import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// Message 消息通知示例页面
class TMessagePage extends StatelessWidget {
  const TMessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用于轻量级反馈或提示，不会打断用户操作。',
      exampleCodeGroup: 'message',
      padding: const EdgeInsets.symmetric(horizontal: 16),
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '消息通知内容为文本、带操作按钮', builder: _buildMessageTypes),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [ExampleItem(desc: '消息组件风格', builder: _buildMessageStyles)],
        ),
      ],
    );
  }

  Widget _fullWidthButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TButton(
        child: Text(text),
        variant: TButtonVariant.outline,
        colorScheme: TButtonColorScheme.primary,
        onPressed: onPressed,
      ),
    );
  }

  @ExampleCode(group: 'message')
  Widget _buildMessageTypes(BuildContext context) {
    return Column(
      children: [
        _buildTextMessage(context),
        const SizedBox(height: 16),
        _buildIconMessage(context),
        const SizedBox(height: 16),
        _buildCloseMessage(context),
        const SizedBox(height: 16),
        _buildScrollMessage(context),
        const SizedBox(height: 16),
        _buildLinkMessage(context),
        const SizedBox(height: 16),
        _buildComponentMessage(context),
      ],
    );
  }

  @ExampleCode(group: 'message')
  Widget _buildMessageStyles(BuildContext context) {
    return Column(
      children: [
        _buildInfoMessage(context),
        const SizedBox(height: 16),
        _buildSuccessMessage(context),
        const SizedBox(height: 16),
        _buildWarningMessage(context),
        const SizedBox(height: 16),
        _buildErrorMessage(context),
      ],
    );
  }

  Widget _buildTextMessage(BuildContext context) {
    return _fullWidthButton(
      text: '纯文字的通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条纯文字的消息通知',
        showIcon: false,
      ),
    );
  }

  Widget _buildIconMessage(BuildContext context) {
    return _fullWidthButton(
      text: '带图标的通知',
      onPressed: () => TMessage.show(context: context, content: '这是一条带图标的消息通知'),
    );
  }

  Widget _buildCloseMessage(BuildContext context) {
    return _fullWidthButton(
      text: '带关闭的通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条带关闭的消息通知',
        duration: null,
        showCloseButton: true,
        action: TLink(
          child: const Text('按钮'),
          colorScheme: TLinkColorScheme.primary,
          onPressed: () => TMessage.show(context: context, content: '已点击按钮'),
        ),
      ),
    );
  }

  Widget _buildScrollMessage(BuildContext context) {
    return _fullWidthButton(
      text: '可滚动的通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条较长的通知信息，这是一条较长的通知信息，这是一条较长的通知信息',
        showIcon: false,
        duration: null,
        marquee: const TMessageMarquee(repeat: true),
      ),
    );
  }

  Widget _buildLinkMessage(BuildContext context) {
    return _fullWidthButton(
      text: '带按钮的通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条带操作的消息通知',
        duration: null,
        action: TLink(
          child: const Text('链接'),
          colorScheme: TLinkColorScheme.primary,
          onPressed: () => TMessage.show(context: context, content: '已点击链接'),
        ),
      ),
    );
  }

  Widget _buildComponentMessage(BuildContext context) {
    return const _DeclarativeMessageDemo();
  }

  Widget _buildInfoMessage(BuildContext context) {
    return _fullWidthButton(
      text: '普通通知',
      onPressed: () => TMessage.show(context: context, content: '这是一条普通通知信息'),
    );
  }

  Widget _buildSuccessMessage(BuildContext context) {
    return _fullWidthButton(
      text: '成功通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条成功的提示消息',
        status: TMessageStatus.success,
      ),
    );
  }

  Widget _buildWarningMessage(BuildContext context) {
    return _fullWidthButton(
      text: '警示通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条需要用户关注到的警示通知',
        status: TMessageStatus.warning,
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    return _fullWidthButton(
      text: '错误通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条错误提示通知',
        status: TMessageStatus.error,
      ),
    );
  }
}

/// 组件声明式调用示例：通过 Widget 树插入 / 移除消息。
class _DeclarativeMessageDemo extends StatefulWidget {
  const _DeclarativeMessageDemo();

  @override
  State<_DeclarativeMessageDemo> createState() =>
      _DeclarativeMessageDemoState();
}

class _DeclarativeMessageDemoState extends State<_DeclarativeMessageDemo> {
  bool _showMessage = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(-16, 0),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 56,
            child: Stack(
              children: [
                if (_showMessage)
                  const TMessage(
                    content: '这是一条通过组件调用的消息通知',
                    offset: Offset.zero,
                    useSafeArea: false,
                    duration: null,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: TButton(
            child: Text(_showMessage ? '隐藏消息' : '组件调用'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () => setState(() => _showMessage = !_showMessage),
          ),
        ),
      ],
    );
  }
}
