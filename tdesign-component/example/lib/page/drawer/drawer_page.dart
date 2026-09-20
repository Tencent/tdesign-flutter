import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'drawer_base_simple_example.dart';
import 'drawer_bottom_simple_example.dart';
import 'drawer_icon_simple_example.dart';
import 'drawer_placement_simple_example.dart';
import 'drawer_title_simple_example.dart';

@ExampleCodeManifest()
class TDrawerPage extends StatelessWidget {
  const TDrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      desc: '用作一组平行关系页面/内容的切换器，相较于 Tab，同屏可展示更多的选项数量。',
      exampleCodeGroup: 'drawer',
      navBarKey: navBarkey,
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础抽屉',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'DrawerBaseSimpleExample',
              builder: (_) => const DrawerBaseSimpleExample(),
            ),
            ExampleItem(
              desc: '带图标抽屉',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'DrawerIconSimpleExample',
              builder: (_) => const DrawerIconSimpleExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '带标题样式',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'DrawerTitleSimpleExample',
              builder: (_) => const DrawerTitleSimpleExample(),
            ),
            ExampleItem(
              desc: '抽屉方向',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'DrawerPlacementSimpleExample',
              builder: (_) => const DrawerPlacementSimpleExample(),
            ),
            ExampleItem(
              desc: '带底部插槽样式',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              methodName: 'DrawerBottomSimpleExample',
              builder: (_) => const DrawerBottomSimpleExample(),
            ),
          ],
        ),
      ],
    );
  }
}
