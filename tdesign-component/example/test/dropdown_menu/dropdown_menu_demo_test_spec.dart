import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_dropdown_menu_page.dart';

import '../demo_page_test_utils.dart';

enum DropdownMenuGoldenPolicy { page, opened }

class DropdownMenuPublicScenario {
  const DropdownMenuPublicScenario({
    required this.id,
    required this.label,
    required this.enabled,
    required this.goldenPolicy,
    required this.expectedPanelText,
    required this.expectedPanelTextCount,
    this.goldenName,
  }) : assert(
         (goldenPolicy == DropdownMenuGoldenPolicy.opened) ==
             (goldenName != null),
       );

  final String id;
  final String label;
  final bool enabled;
  final DropdownMenuGoldenPolicy goldenPolicy;
  final String expectedPanelText;
  final int expectedPanelTextCount;
  final String? goldenName;
}

const dropdownMenuPublicScenarios = [
  DropdownMenuPublicScenario(
    id: 'product',
    label: '全部产品',
    enabled: true,
    goldenPolicy: DropdownMenuGoldenPolicy.opened,
    expectedPanelText: '最新产品',
    expectedPanelTextCount: 1,
    goldenName: 'single',
  ),
  DropdownMenuPublicScenario(
    id: 'sorter',
    label: '默认排序',
    enabled: true,
    goldenPolicy: DropdownMenuGoldenPolicy.opened,
    expectedPanelText: '价格从高到低',
    expectedPanelTextCount: 1,
    goldenName: 'sorter',
  ),
  DropdownMenuPublicScenario(
    id: 'single_column',
    label: '单列多选',
    enabled: true,
    goldenPolicy: DropdownMenuGoldenPolicy.opened,
    expectedPanelText: '选项名称',
    expectedPanelTextCount: 12,
    goldenName: 'single_column',
  ),
  DropdownMenuPublicScenario(
    id: 'double_column',
    label: '双列多选',
    enabled: true,
    goldenPolicy: DropdownMenuGoldenPolicy.opened,
    expectedPanelText: '选项名称',
    expectedPanelTextCount: 12,
    goldenName: 'double_column',
  ),
  DropdownMenuPublicScenario(
    id: 'triple_column',
    label: '三列多选',
    enabled: true,
    goldenPolicy: DropdownMenuGoldenPolicy.opened,
    expectedPanelText: '选项名称',
    expectedPanelTextCount: 12,
    goldenName: 'multiple',
  ),
  DropdownMenuPublicScenario(
    id: 'disabled_first',
    label: '禁用菜单',
    enabled: false,
    goldenPolicy: DropdownMenuGoldenPolicy.page,
    expectedPanelText: '',
    expectedPanelTextCount: 0,
  ),
  DropdownMenuPublicScenario(
    id: 'disabled_second',
    label: '禁用菜单',
    enabled: false,
    goldenPolicy: DropdownMenuGoldenPolicy.page,
    expectedPanelText: '',
    expectedPanelTextCount: 0,
  ),
];

const dropdownMenuDemoPageTestSpec = DemoPageTestSpec(
  useFeedbackGoldenFont: true,
  name: 'dropdown_menu',
  title: 'DropdownMenu 下拉菜单',
  page: TDropdownMenuPage(),
  expectedTexts: ['01 组件类型', '单选下拉菜单', '分栏下拉菜单', '02 组件状态', '禁用状态'],
  componentType: TDropdownMenu,
  expectedComponentCount: 3,
);
