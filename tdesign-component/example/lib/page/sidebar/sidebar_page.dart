import 'package:flutter/material.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'icon_side_bar_example.dart';
import 'navigator_side_bar_example.dart';
import 'style_side_bar_example.dart';

@ExampleCodeManifest()
///
/// TSideBarPage演示
///
class TSideBarPage extends StatefulWidget {
  const TSideBarPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TSideBarPageState();
  }
}

class TSideBarPageState extends State<TSideBarPage> {
  @override
  Widget build(BuildContext context) {
    var current = buildWidget(context);
    return current;
  }

  Widget buildWidget(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      exampleCodeGroup: 'sideBar',
      desc: '用于内容分类后的展示切换。',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '侧边导航用法',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'NavigatorSideBarExample',
              builder: (_) => const NavigatorSideBarExample(),
            ),
            ExampleItem(
              desc: '带图标侧边导航',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'IconSideBarExample',
              builder: (_) => const IconSideBarExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '侧边导航样式',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'StyleSideBarExample',
              builder: (_) => const StyleSideBarExample(),
            ),
          ],
        ),
      ],
    );
  }
}
