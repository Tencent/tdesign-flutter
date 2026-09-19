import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_action_sheet_page.dart';

import 'demo_page_test_utils.dart';

const actionSheetDemoGoldenScenes = [
  (id: 'basic_list', trigger: '常规列表型'),
  (id: 'described_list', trigger: '带描述列表型'),
  (id: 'icon_list', trigger: '带图标列表型'),
  (id: 'badge_list', trigger: '带徽标列表型'),
  (id: 'basic_grid', trigger: '常规宫格型'),
  (id: 'described_grid', trigger: '带描述宫格型'),
  (id: 'paged_grid', trigger: '带翻页宫格型'),
  (id: 'badge_grid', trigger: '带徽标宫格型'),
  (id: 'scroll_grid', trigger: '多行滚动宫格型'),
  (id: 'described_scroll_grid', trigger: '带描述多行滚动宫格型'),
  (id: 'status_list', trigger: '列表型选项状态'),
  (id: 'center_list', trigger: '居中列表型'),
  (id: 'left_list', trigger: '左对齐列表型'),
];

Set<String> expectedActionSheetGoldenCases() => {
  for (final mode in ['light', 'dark']) ...{
    'page:initial:$mode',
    for (final scene in actionSheetDemoGoldenScenes) '${scene.id}:opened:$mode',
    'paged_grid:next_page:$mode',
    'scroll_grid:scrolled:$mode',
  },
};

const actionSheetDemoPageTestSpec = DemoPageTestSpec(
  name: 'action_sheet',
  title: 'ActionSheet 动作面板',
  page: TActionSheetPage(),
  expectedTexts: [
    '01 组件类型',
    '列表型动作面板',
    '常规列表型',
    '带描述列表型',
    '带图标列表型',
    '带徽标列表型',
    '常规宫格型',
    '带描述宫格型',
    '带翻页宫格型',
    '带徽标宫格型',
    '多行滚动宫格型',
    '带描述多行滚动宫格型',
    '宫格型动作面板',
    '02 组件状态',
    '列表型选项状态',
    '03 组件样式',
    '列表型对齐方式',
    '居中列表型',
    '左对齐列表型',
  ],
  componentType: TButton,
  expectedComponentCount: 13,
  useFeedbackGoldenFont: true,
  precacheAssetImages: [
    'assets/img/action_sheet_wechat.png',
    'assets/img/action_sheet_qq.png',
    'assets/img/action_sheet_doc.png',
    'assets/img/action_sheet_map.png',
    'assets/img/action_sheet_qq_music.png',
    'assets/img/action_sheet_allen.png',
    'assets/img/action_sheet_nick.png',
    'assets/img/action_sheet_jacky.png',
    'assets/img/action_sheet_eric.png',
    'assets/img/action_sheet_johnson.png',
  ],
);
