import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TMessagePage extends StatelessWidget {
  const TMessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '命令式展示轻量级反馈消息。',
      exampleCodeGroup: 'message',
      children: [
        ExampleModule(title: '组件状态', children: [
          ExampleItem(desc: '普通消息', builder: (context) => _button(context, TMessageVariant.info)),
          ExampleItem(desc: '成功消息', builder: (context) => _button(context, TMessageVariant.success)),
          ExampleItem(desc: '警告消息', builder: (context) => _button(context, TMessageVariant.warning)),
          ExampleItem(desc: '错误消息', builder: (context) => _button(context, TMessageVariant.error)),
          ExampleItem(desc: '跑马灯消息', builder: _marquee),
        ]),
      ],
    );
  }

  Widget _button(BuildContext context, TMessageVariant variant) {
    return TButton(
      child: const Text('显示消息'),
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条通知信息',
        variant: variant,
        showCloseButton: true,
        link: const TMessageLink(name: '查看详情'),
        onLinkPressed: () {},
      ),
    );
  }

  @Demo(group: 'message')
  Widget _marquee(BuildContext context) {
    return TButton(
      child: const Text('显示跑马灯'),
      onPressed: () => TMessage.show(
        context: context,
        content: '这是一条较长的通知信息',
        marquee: const TMessageMarquee(repeat: true),
      ),
    );
  }
}
