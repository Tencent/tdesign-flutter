import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_date_time_picker_page.dart';

import 'demo_page_test_utils.dart';

const dateTimePickerDemoPageTestSpec = DemoPageTestSpec(
  name: 'date_time_picker',
  title: 'DateTimePicker 时间选择器',
  page: TDateTimePickerPage(),
  expectedTexts: [
    '用于选择一个时间点或者一个时间段。',
    '01 组件类型',
    '年月日选择器',
    '年月选择器',
    '时分秒选择器',
    '时分选择器',
    '年月日时分秒选择器',
    '02 组件用法',
    '调整步数',
    '不使用 Popup',
  ],
  componentType: TDateTimePicker,
  expectedComponentCount: 1,
  useAlignmentCjkFont: true,
  supplementalCjkFontFamily: 'TDesign DateTimePicker Golden CJK',
  supplementalCjkFontPath: 'test/fonts/DateTimePickerGoldenCJK-Regular.otf',
);
