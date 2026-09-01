import 'package:tdesign_flutter_example/page/t_tree_select_page.dart';

import 'demo_page_test_utils.dart';

const treeSelectDemoPageTestSpec = DemoPageTestSpec(
  name: 'tree_select',
  title: 'TreeSelect 树形选择器',
  page: TTreeSelectPage(),
  expectedTexts: [
    '用于多层级数据的逐级选择。',
    '01 组件类型',
    '基础树形选择器',
    '多选树形选择器',
    '02 组件状态',
    '树形选择器-三列',
  ],
  useAlignmentCjkFont: true,
  supplementalCjkFontFamily: 'TDesign TreeSelect Golden CJK',
  supplementalCjkFontPath: 'test/fonts/TreeSelectGoldenCJK-Regular.otf',
);
