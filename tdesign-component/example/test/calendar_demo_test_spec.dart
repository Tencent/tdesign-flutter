import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_calendar_page.dart';

import 'demo_page_test_utils.dart';

const calendarDemoPageTestSpec = DemoPageTestSpec(
  name: 'calendar',
  title: 'Calendar 日历',
  page: TCalendarPage(),
  expectedTexts: [
    '按照日历形式展示数据或日期的容器。',
    '01 组件类型',
    '基础日历',
    '单个选择日历',
    '多个选择日历',
    '带单行描述的日历',
    '带双行描述的日历',
    '带翻页功能的日历',
    '可选择区间日期的日历',
    '2024-12-05',
    '2024-12-10',
    '02 组件样式',
    '国际化',
    '含不可选的日历',
    '不使用 Popup',
    '日历标题',
  ],
  componentType: TCalendar,
  expectedComponentCount: 1,
  useAlignmentCjkFont: true,
  supplementalCjkFontFamily: 'TDesign Calendar Golden CJK',
  supplementalCjkFontPath: 'test/fonts/CalendarGoldenCJK-Regular.otf',
);
