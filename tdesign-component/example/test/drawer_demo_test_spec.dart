import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_drawer_page.dart';

import 'demo_page_test_utils.dart';

enum DrawerDemoGoldenStrategy { opened }

class DrawerDemoScene {
  const DrawerDemoScene({
    required this.id,
    required this.label,
    required this.goldenStrategy,
  });

  final String id;
  final String label;
  final DrawerDemoGoldenStrategy goldenStrategy;
}

const drawerDemoScenes = [
  DrawerDemoScene(
    id: 'basic',
    label: '基础抽屉',
    goldenStrategy: DrawerDemoGoldenStrategy.opened,
  ),
  DrawerDemoScene(
    id: 'icon',
    label: '带图标抽屉',
    goldenStrategy: DrawerDemoGoldenStrategy.opened,
  ),
  DrawerDemoScene(
    id: 'small_title',
    label: '小标题抽屉',
    goldenStrategy: DrawerDemoGoldenStrategy.opened,
  ),
  DrawerDemoScene(
    id: 'large_title',
    label: '大标题抽屉',
    goldenStrategy: DrawerDemoGoldenStrategy.opened,
  ),
  DrawerDemoScene(
    id: 'left',
    label: '左侧抽屉',
    goldenStrategy: DrawerDemoGoldenStrategy.opened,
  ),
  DrawerDemoScene(
    id: 'right',
    label: '右侧抽屉',
    goldenStrategy: DrawerDemoGoldenStrategy.opened,
  ),
  DrawerDemoScene(
    id: 'footer',
    label: '带底部插槽',
    goldenStrategy: DrawerDemoGoldenStrategy.opened,
  ),
];

Set<String> expectedDrawerGoldenCases() => {
  for (final mode in ['light', 'dark']) ...{
    'drawer:page:$mode',
    'basic:pressed:$mode',
  },
  for (final scene in drawerDemoScenes)
    for (final mode in ['light', 'dark'])
      '${scene.id}:${scene.goldenStrategy.name}:$mode',
};

const drawerDemoPageTestSpec = DemoPageTestSpec(
  name: 'drawer',
  title: 'Drawer 抽屉',
  page: TDrawerPage(),
  expectedTexts: [
    '01 组件类型',
    '基础抽屉',
    '带图标抽屉',
    '02 组件样式',
    '带标题样式',
    '小标题抽屉',
    '大标题抽屉',
    '抽屉方向',
    '左侧抽屉',
    '右侧抽屉',
    '带底部插槽样式',
    '带底部插槽',
  ],
  componentType: TButton,
  expectedComponentCount: 7,
  useFeedbackGoldenFont: true,
  supplementalCjkFontFamily: 'Drawer Golden CJK',
  supplementalCjkFontPath: 'test/fonts/DrawerGoldenCJK-Regular.otf',
  goldenAtPhoneViewport: true,
  phoneViewportHeight: 1024,
);
