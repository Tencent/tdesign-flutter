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
    '甘肃省',
    '广东省',
    '贵州省',
    '海南省',
    '河北省',
    '黑龙江省',
    '汕头市',
    '汕尾市',
    '韶关市',
    '深圳市',
    '阳江市',
    '云浮市',
    '龙华区',
    '罗湖区',
    '南山区',
    '坪山区',
    '其它区',
    '盐田区',
  ],
  useAlignmentCjkFont: true,
  supplementalCjkFontFamily: 'TDesign TreeSelect Golden CJK',
  supplementalCjkFontPath: 'test/fonts/TreeSelectGoldenCJK-Regular.otf',
);
