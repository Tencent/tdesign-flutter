import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_navbar_page.dart';

import 'demo_page_test_utils.dart';

const navbarDemoPageTestSpec = DemoPageTestSpec(
  name: 'navbar',
  title: 'NavBar 导航栏',
  page: TNavBarPage(),
  componentType: TNavBar,
  expectedComponentCount: 11,
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
