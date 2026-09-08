import 'package:tdesign_flutter_example/page/t_cascader_page.dart';

import 'demo_page_test_utils.dart';

const cascaderDemoPageTestSpec = DemoPageTestSpec(
  name: 'cascader',
  title: 'Cascader 级联选择器',
  page: TCascaderPage(),
  expectedTexts: [
    '用于多层级数据的逐级选择。',
    '01 类型',
    '地址',
    '请选择地址',
    '选项卡风格',
    '02 进阶',
    '带初始值',
    '天津市/天津市/蓟州区',
    '自定义 keys',
    '使用次级标题',
    '选择任意一项',
    '支持搜索',
  ],
  useAlignmentCjkFont: true,
  supplementalCjkFontFamily: 'TDesign Cascader Golden CJK',
  supplementalCjkFontPath: 'test/fonts/CascaderGoldenCJK-Regular.otf',
);
