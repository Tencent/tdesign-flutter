import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_action_sheet_page.dart';

import 'demo_page_test_utils.dart';

const actionSheetDemoPageTestSpec = DemoPageTestSpec(
  name: 'action_sheet',
  title: 'ActionSheet 动作面板',
  page: TActionSheetPage(),
  expectedTexts: [
    '01 组件类型',
    '常规列表型',
    '带描述列表型',
    '带图标列表型',
    '常规宫格型',
    '带描述宫格型',
    '带翻页宫格型',
    '02 组件状态',
    '列表型选项状态',
    '03 组件样式',
    '居中列表型',
    '左对齐列表型',
  ],
  componentType: TButton,
  expectedComponentCount: 9,
);
