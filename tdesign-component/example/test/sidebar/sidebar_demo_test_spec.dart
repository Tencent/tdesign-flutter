import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/sidebar/sidebar_anchor_example.dart';
import 'package:tdesign_flutter_example/page/sidebar/sidebar_custom_example.dart';
import 'package:tdesign_flutter_example/page/sidebar/sidebar_icon_example.dart';
import 'package:tdesign_flutter_example/page/sidebar/sidebar_page.dart';
import 'package:tdesign_flutter_example/page/sidebar/sidebar_pagination_example.dart';

import '../demo_page_test_utils.dart';

class SideBarDemoScene {
  const SideBarDemoScene({
    required this.id,
    required this.label,
    required this.pageType,
    required this.pageSpecName,
  });

  final String id;
  final String label;
  final Type pageType;
  final String pageSpecName;
}

const sideBarDemoScenes = [
  SideBarDemoScene(
    id: 'anchor',
    label: '锚点用法',
    pageType: TSideBarAnchorPage,
    pageSpecName: 'sidebar_anchor',
  ),
  SideBarDemoScene(
    id: 'pagination',
    label: '切页用法',
    pageType: TSideBarPaginationPage,
    pageSpecName: 'sidebar_pagination',
  ),
  SideBarDemoScene(
    id: 'icon',
    label: '带图标侧边导航',
    pageType: TSideBarIconPage,
    pageSpecName: 'sidebar_icon',
  ),
  SideBarDemoScene(
    id: 'tag',
    label: '自定义样式',
    pageType: TSideBarCustomPage,
    pageSpecName: 'sidebar_tag',
  ),
];

const sideBarFunctionalOnlyCases = {'pagination_disabled': '禁用项点击后没有独立视觉结果'};

Set<String> expectedSideBarGoldenCases() => {
  for (final mode in ['light', 'dark']) 'sidebar:page:$mode',
  for (final scene in sideBarDemoScenes)
    for (final mode in ['light', 'dark']) ...{
      '${scene.id}:page:$mode',
      '${scene.id}:selected_item:$mode',
    },
};

const sidebarDemoPageTestSpec = DemoPageTestSpec(
  name: 'sidebar',
  title: 'SideBar 侧边栏',
  page: TSideBarPage(),
  componentType: TButton,
  expectedComponentCount: 5,
  supplementalCjkFontFamily: 'TDesign SideBar Golden CJK',
  supplementalCjkFontPath: 'test/fonts/SideBarGoldenCJK-Regular.otf',
  expectedTexts: [
    '用于内容分类后的展示切换。',
    '01 组件类型',
    '侧边导航用法',
    '锚点用法',
    '切页用法',
    '带图标侧边导航',
    '02 组件样式',
    '侧边导航样式',
    '非通栏选项样式',
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

const sidebarPaginationDemoTestSpec = DemoPageTestSpec(
  name: 'sidebar_pagination',
  title: 'SideBar 切页用法',
  page: TSideBarPaginationPage(),
  componentType: TSideBar,
  expectedComponentCount: 1,
  expectedTexts: ['选项', '标题'],
  supplementalCjkFontFamily: 'TDesign SideBar Golden CJK',
  supplementalCjkFontPath: 'test/fonts/SideBarGoldenCJK-Regular.otf',
  precacheAssetImages: ['assets/img/empty.png'],
);

const sidebarIconDemoTestSpec = DemoPageTestSpec(
  name: 'sidebar_icon',
  title: 'SideBar 带图标侧边导航',
  page: TSideBarIconPage(),
  componentType: TSideBar,
  expectedComponentCount: 1,
  expectedTexts: ['选项', '标题'],
  supplementalCjkFontFamily: 'TDesign SideBar Golden CJK',
  supplementalCjkFontPath: 'test/fonts/SideBarGoldenCJK-Regular.otf',
  precacheAssetImages: ['assets/img/empty.png'],
);
