import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'message_styles_example.dart';
import 'message_types_example.dart';

@ExampleCodeManifest()
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
            ExampleItem(
              desc: '纯文字的通知',
              methodName: 'MessageTypesExample',
              builder: (_) => const MessageTypesExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(
              desc: '普通通知',
              methodName: 'MessageStylesExample',
              builder: (_) => const MessageStylesExample(),
            ),
          ],
        ),
      ],
    );
  }
}
