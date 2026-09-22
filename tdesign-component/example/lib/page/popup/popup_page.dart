import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'application_popups_example.dart';
import 'base_popups_example.dart';

@ExampleCodeManifest()
/// Popup 弹出层示例页面
class TPopupPage extends StatelessWidget {
  const TPopupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '由其他控件触发，屏幕滑出或弹出一块自定义内容区域。',
      exampleCodeGroup: 'popup',
      itemMargin: const EdgeInsets.symmetric(horizontal: 16),
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础弹出层',
              key: const ValueKey('popup-base-examples'),
              methodName: 'BasePopupsExample',
              builder: (_) => const BasePopupsExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件示例',
          children: [
            ExampleItem(
              desc: '应用示例',
              key: const ValueKey('popup-application-examples'),
              methodName: 'ApplicationPopupsExample',
              builder: (_) => const ApplicationPopupsExample(),
            ),
          ],
        ),
      ],
    );
  }
}
