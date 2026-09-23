import 'package:flutter/widgets.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/navbar/navbar_page.dart';

import '../demo_page_test_utils.dart';

class NavBarDemoScene {
  const NavBarDemoScene({required this.id, required this.key});

  final String id;
  final Key key;
}

const navBarDemoScenes = [
  NavBarDemoScene(id: 'base', key: Key('navbar-demo-scene-base')),
  NavBarDemoScene(id: 'left_multi', key: Key('navbar-demo-scene-left-multi')),
  NavBarDemoScene(id: 'right_multi', key: Key('navbar-demo-scene-right-multi')),
  NavBarDemoScene(id: 'search', key: Key('navbar-demo-scene-search')),
  NavBarDemoScene(id: 'image', key: Key('navbar-demo-scene-image')),
  NavBarDemoScene(
    id: 'title_center',
    key: Key('navbar-demo-scene-title-center'),
  ),
  NavBarDemoScene(id: 'title_left', key: Key('navbar-demo-scene-title-left')),
  NavBarDemoScene(
    id: 'title_normal',
    key: Key('navbar-demo-scene-title-normal'),
  ),
  NavBarDemoScene(id: 'title_below', key: Key('navbar-demo-scene-title-below')),
  NavBarDemoScene(
    id: 'custom_color',
    key: Key('navbar-demo-scene-custom-color'),
  ),
];

const expectedNavBarFunctionalActions = {
  'left_multi:close',
  'left_multi:more',
  'right_multi:home',
  'right_multi:more',
  'search:home',
  'search:more',
  'image:home',
  'image:more',
  'title_center:home',
  'title_center:more',
  'title_left:home',
  'title_left:more',
  'title_normal:home',
  'title_normal:more',
  'title_below:back',
  'title_below:home',
  'title_below:more',
  'custom_color:back',
  'custom_color:home',
  'custom_color:more',
};

Set<String> expectedNavBarGoldenCases() => {
  for (final mode in ['light', 'dark']) ...{
    'navbar:page:$mode',
    'search:entered:$mode',
    'toast:close:$mode',
    'toast:home:$mode',
    'toast:more:$mode',
    'toast:back:$mode',
  },
};

const navbarDemoPageTestSpec = DemoPageTestSpec(
  name: 'navbar',
  title: 'NavBar 导航栏',
  page: TNavBarPage(),
  componentType: TNavBar,
  expectedComponentCount: 11,
  supplementalCjkFontFamily: 'TDesign NavBar Golden CJK',
  supplementalCjkFontPath: 'test/fonts/NavBarGoldenCJK-Regular.otf',
  expectedTexts: [
    '用于不同页面之间切换或者跳转，位于内容区的上方，系统状态栏的下方。',
    '01 组件类型',
    '基础H5导航栏',
    '带搜索导航栏',
    '搜索预设文案',
    '带图片导航栏',
    '02 组件样式',
    '标题对齐',
    '标题尺寸',
    '自定义颜色',
  ],
  precacheAssetImages: ['assets/img/t_brand.png'],
);
