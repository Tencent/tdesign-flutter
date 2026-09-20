import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import '../../l10n/app_localizations.dart';
import 'calendar_described_example.dart';
import 'calendar_double_described_example.dart';
import 'calendar_inline_example.dart';
import 'calendar_limited_example.dart';
import 'calendar_localized_example.dart';
import 'calendar_multiple_example.dart';
import 'calendar_range_example.dart';
import 'calendar_single_example.dart';
import 'calendar_switch_mode_example.dart';

@ExampleCodeManifest()
/// TCalendar 演示。
class TCalendarPage extends StatefulWidget {
  const TCalendarPage({super.key, this.referenceDate});

  /// 内嵌示例的参考日期，默认使用设计稿中的 2023-03-10。
  final DateTime? referenceDate;

  @override
  State<TCalendarPage> createState() => _TCalendarPageState();
}

class _TCalendarPageState extends State<TCalendarPage> {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '按照日历形式展示数据或日期的容器。',
      exampleCodeGroup: 'calendar',
      compactDemo: true,
      // Figma Demo 页面底色；深色模式继续使用当前主题。
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF6F6F6)
          : context.tTheme.bgColorPage,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(
              desc: '基础日历',
              methodName: 'CalendarSingleExample',
              builder: (_) => const CalendarSingleExample(),
            ),
            ExampleItem(
              desc: '',
              methodName: 'CalendarMultipleExample',
              builder: (_) => const CalendarMultipleExample(),
            ),
            ExampleItem(
              desc: '带单行描述的日历',
              methodName: 'CalendarDescribedExample',
              builder: (_) => const CalendarDescribedExample(),
            ),
            ExampleItem(
              desc: '带双行描述的日历',
              methodName: 'CalendarDoubleDescribedExample',
              builder: (_) => const CalendarDoubleDescribedExample(),
            ),
            ExampleItem(
              desc: '带翻页功能的日历',
              methodName: 'CalendarSwitchModeExample',
              builder: (_) => const CalendarSwitchModeExample(),
            ),
            ExampleItem(
              desc: '可选择区间日期的日历',
              methodName: 'CalendarRangeExample',
              builder: (_) => const CalendarRangeExample(),
            ),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(
              desc: '国际化',
              methodName: 'CalendarLocalizedExample',
              builder: (_) => const CalendarLocalizedExample(),
            ),
            ExampleItem(
              desc: '含不可选的日历',
              methodName: 'CalendarLimitedExample',
              builder: (_) => const CalendarLimitedExample(),
            ),
            ExampleItem(
              desc: '不使用 Popup',
              methodName: 'CalendarInlineExample',
              builder: (_) =>
                  CalendarInlineExample(referenceDate: widget.referenceDate),
            ),
          ],
        ),
      ],
    );
  }
}
