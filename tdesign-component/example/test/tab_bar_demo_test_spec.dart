import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_tab_bar_page.dart';

import 'demo_page_test_utils.dart';

const tabBarDemoPageTestSpec = DemoPageTestSpec(
  name: 'tab_bar',
  title: 'TabBar 底部标签栏',
  page: TTabBarPage(),
  expectedTexts: [
    '01 组件类型',
    '纯文本标签栏',
    '图标加文本标签栏',
    '纯图标标签栏',
    '双层级文本标签栏',
    '02 组件样式',
    '弱选中标签栏',
    '悬浮胶囊标签栏',
    '03 自定义',
    '自定义样式',
  ],
  componentType: TTabBar,
  expectedComponentCount: 9,
  supplementalCjkFontFamily: 'TabBar Golden CJK',
  supplementalCjkFontPath: 'test/fonts/TabBarGoldenCJK-Regular.otf',
);
