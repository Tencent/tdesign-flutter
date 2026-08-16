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
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '纯文字的通知', builder: _buildTextMessage),
          ExampleItem(desc: '带图标的通知', builder: _buildIconMessage),
          ExampleItem(desc: '带关闭的通知', builder: _buildCloseMessage),
          ExampleItem(desc: '可滚动的通知', builder: _buildScrollMessage),
          ExampleItem(desc: '带按钮的通知', builder: _buildLinkMessage),
          ExampleItem(desc: '组件调用', builder: _buildComponentMessage),
        ]),
        ExampleModule(title: '组件风格', children: [
          ExampleItem(desc: '普通通知', builder: _buildInfoMessage),
          ExampleItem(desc: '成功通知', builder: _buildSuccessMessage),
          ExampleItem(desc: '警示通知', builder: _buildWarningMessage),
          ExampleItem(desc: '错误通知', builder: _buildErrorMessage),
        ]),
        ExampleModule(title: '关闭所有通知', children: [
          ExampleItem(desc: '打开多个通知', builder: _buildOpenAllMessage),
          ExampleItem(desc: '关闭所有通知', builder: _buildCloseAllMessage),
        ]),
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

  @ExampleCode(group: 'message')
  Widget _buildIconMessage(BuildContext context) {
    return _fullWidthButton(
      text: '带图标的通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条带图标的消息通知',
      ),
    );
  }

  @ExampleCode(group: 'message')
  Widget _buildCloseMessage(BuildContext context) {
    return _fullWidthButton(
      text: '带关闭的通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条带关闭的消息通知',
        duration: null,
        showCloseButton: true,
        link: const TMessageLink(name: '按钮'),
      ),
    );
  }

  @ExampleCode(group: 'message')
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

  @ExampleCode(group: 'message')
  Widget _buildLinkMessage(BuildContext context) {
    return _fullWidthButton(
      text: '带按钮的通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条带操作的消息通知',
        duration: null,
        link: const TMessageLink(name: '链接'),
      ),
    );
  }

  /// 记录「打开多个通知」返回的句柄，供「关闭所有通知」定向关闭。
  static final List<TMessageHandle> _handles = <TMessageHandle>[];

  @ExampleCode(group: 'message')
  Widget _buildComponentMessage(BuildContext context) {
    return const _DeclarativeMessageDemo();
  }

  @ExampleCode(group: 'message')
  Widget _buildInfoMessage(BuildContext context) {
    return _fullWidthButton(
      text: '普通通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条普通通知信息',
      ),
    );
  }

  @ExampleCode(group: 'message')
  Widget _buildSuccessMessage(BuildContext context) {
    return _fullWidthButton(
      text: '成功通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条成功的提示消息',
        variant: TMessageVariant.success,
      ),
    );
  }

  @ExampleCode(group: 'message')
  Widget _buildWarningMessage(BuildContext context) {
    return _fullWidthButton(
      text: '警示通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条需要用户关注到的警示通知',
        variant: TMessageVariant.warning,
      ),
    );
  }

  @ExampleCode(group: 'message')
  Widget _buildErrorMessage(BuildContext context) {
    return _fullWidthButton(
      text: '错误通知',
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条错误提示通知',
        variant: TMessageVariant.error,
      ),
    );
  }

  @ExampleCode(group: 'message')
  Widget _buildOpenAllMessage(BuildContext context) {
    return _fullWidthButton(
      text: '打开多个通知',
      onPressed: () {
        final themes = <TMessageVariant>[
          TMessageVariant.info,
          TMessageVariant.success,
          TMessageVariant.warning,
          TMessageVariant.error,
        ];
        for (var i = 0; i < themes.length; i++) {
          Future<void>.delayed(Duration(milliseconds: 300 * i), () {
            if (!context.mounted) {
              return;
            }
            final handle = TMessage.show(
              context: context,
              content: '第${i + 1}条通知',
              variant: themes[i],
            );
            _handles.add(handle);
          });
        }
      },
    );
  }

  @ExampleCode(group: 'message')
  Widget _buildCloseAllMessage(BuildContext context) {
    return _fullWidthButton(
      text: '关闭所有通知',
      onPressed: () {
        for (final handle in _handles) {
          handle.dismiss();
        }
        _handles.clear();
      },
    );
  }
}

/// 组件声明式调用示例：通过 [visible] 受控展示 / 隐藏消息。
class _DeclarativeMessageDemo extends StatefulWidget {
  const _DeclarativeMessageDemo();

  @override
  State<_DeclarativeMessageDemo> createState() => _DeclarativeMessageDemoState();
}

class _DeclarativeMessageDemoState extends State<_DeclarativeMessageDemo> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: Stack(
            children: [
              if (_visible)
                const TMessage(
                  content: '这是一条通过组件调用的消息通知',
                  offset: Offset.zero,
                  useSafeArea: false,
                  duration: null,
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: TButton(
            child: Text(_visible ? '隐藏消息' : '组件调用'),
            variant: TButtonVariant.outline,
            colorScheme: TButtonColorScheme.primary,
            onPressed: () => setState(() => _visible = !_visible),
          ),
        ),
      ],
    );
  }
}
