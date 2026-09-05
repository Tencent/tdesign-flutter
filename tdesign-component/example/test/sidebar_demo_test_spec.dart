import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/sidebar/t_sidebar_page.dart';
import 'package:tdesign_flutter_example/page/sidebar/t_sidebar_page_anchor.dart';
import 'package:tdesign_flutter_example/page/sidebar/t_sidebar_page_custom.dart';

import 'demo_page_test_utils.dart';

const sidebarDemoPageTestSpec = DemoPageTestSpec(
  name: 'sidebar',
  title: 'SideBar 侧边栏',
  page: TSideBarPage(),
  componentType: TButton,
  expectedComponentCount: 4,
  supplementalCjkFontFamily: 'TDesign SideBar Golden CJK',
  supplementalCjkFontPath: 'test/fonts/SideBarGoldenCJK-Regular.otf',
  expectedTexts: [
    '用于信息分类后的展示切换或锚点，位于页面左侧。',
    '01 组件类型',
    '侧边导航用法',
    '锚点用法',
    '切页用法',
    '带图标侧边导航',
    '02 组件样式',
    '侧边导航样式',
    '自定义样式',
  ],
);

const sidebarAnchorDemoTestSpec = DemoPageTestSpec(
  name: 'sidebar_anchor',
  title: 'SideBar 锚点用法',
  page: TSideBarAnchorPage(),
  componentType: TSideBar,
  expectedComponentCount: 1,
  expectedTexts: ['选项', '标题'],
  supplementalCjkFontFamily: 'TDesign SideBar Golden CJK',
  supplementalCjkFontPath: 'test/fonts/SideBarGoldenCJK-Regular.otf',
  precacheAssetImages: ['assets/img/empty.png'],
);

const sidebarTagDemoTestSpec = DemoPageTestSpec(
  name: 'sidebar_tag',
  title: 'SideBar 自定义样式',
  page: TSideBarCustomPage(),
  componentType: TSideBar,
  expectedComponentCount: 1,
  expectedTexts: ['选项', '标题'],
  supplementalCjkFontFamily: 'TDesign SideBar Golden CJK',
  supplementalCjkFontPath: 'test/fonts/SideBarGoldenCJK-Regular.otf',
  precacheAssetImages: ['assets/img/empty.png'],
);
