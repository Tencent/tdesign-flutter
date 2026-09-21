import 'package:tdesign_flutter_example/page/cascader/cascader_page.dart';

import 'demo_page_test_utils.dart';

const cascaderDemoPageTestSpec = DemoPageTestSpec(
  name: 'cascader',
  title: 'Cascader 级联选择器',
  page: TCascaderPage(),
  expectedTexts: [
    '用于多层级数据的逐级选择。',
    '01 组件类型',
    '垂直级联选择器',
    '垂直级联选择器-带字母定位',
    '水平级联选择器',
    '水平级联选择器-带字母定位',
    '02 组件样式',
    '带标题级联选择器',
    '无标题级联选择器',
    '选择地区',
    '广东 深圳 南山区 粤海街道',
  ],
  useAlignmentCjkFont: true,
  supplementalCjkFontFamily: 'TDesign Cascader Golden CJK',
  supplementalCjkFontPath: 'test/fonts/CascaderGoldenCJK-Regular.otf',
);
