import 'package:tdesign_flutter_example/page/t_picker_page.dart';

import 'demo_page_test_utils.dart';

const pickerDemoPageTestSpec = DemoPageTestSpec(
  name: 'picker',
  title: 'Picker 选择器',
  page: TPickerPage(),
  expectedTexts: [
    '用于一组预设数据中的选择。',
    '01 组件类型',
    '基础选择器',
    '选择时间',
    '选择地区',
    '02 组件样式',
    '是否带标题',
    '带标题选择器',
    '无标题选择器',
  ],
  useAlignmentCjkFont: true,
  supplementalCjkFontFamily: 'TDesign Picker Golden CJK',
  supplementalCjkFontPath: 'test/fonts/PickerGoldenCJK-Regular.otf',
);
