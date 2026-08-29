import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_dropdown_menu_page.dart';

import 'demo_page_test_utils.dart';

const dropdownMenuDemoPageTestSpec = DemoPageTestSpec(
  name: 'dropdown_menu',
  title: 'DropdownMenu 下拉菜单',
  page: TDropdownMenuPage(),
  expectedTexts: [
    '01 组件类型',
    '单选下拉菜单',
    '1 / 2 / 3 列多选',
    '自定义价格区间',
    '02 组件状态',
    '禁用菜单',
    '向上展开与自定义图标',
    '03 Flutter 额外能力',
    '横向滚动与禁用项',
    '局部主题与自动方向',
  ],
  componentType: TDropdownMenu,
  expectedComponentCount: 9,
);
