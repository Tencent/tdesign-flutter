import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_dropdown_menu_page.dart';

import 'demo_page_test_utils.dart';

const dropdownMenuDemoPageTestSpec = DemoPageTestSpec(
  useFeedbackGoldenFont: true,
  name: 'dropdown_menu',
  title: 'DropdownMenu 下拉菜单',
  page: TDropdownMenuPage(),
  expectedTexts: ['01 组件类型', '单选下拉菜单', '分栏下拉菜单', '02 组件状态', '禁用状态'],
  componentType: TDropdownMenu,
  expectedComponentCount: 3,
);
