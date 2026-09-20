import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';
import 'date_time_picker_date_example.dart';
import 'date_time_picker_date_time_example.dart';
import 'date_time_picker_minute_example.dart';
import 'date_time_picker_month_day_example.dart';
import 'date_time_picker_month_example.dart';
import 'date_time_picker_second_example.dart';
import 'date_time_picker_title_example.dart';
import 'date_time_picker_week_example.dart';
import 'date_time_picker_without_title_example.dart';

@ExampleCodeManifest()
class TDateTimePickerPage extends StatefulWidget {
  const TDateTimePickerPage({super.key});

  @override
  State<TDateTimePickerPage> createState() => _TDateTimePickerPageState();
}

class _TDateTimePickerPageState extends State<TDateTimePickerPage> {
  @override
  Widget build(BuildContext context) => ExamplePage(
    title: tTitle(),
    desc: '用于选择一个时间点或者一个时间段。',
    exampleCodeGroup: 'date-time-picker',
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
            desc: '年月日选择器',
            methodName: 'DateTimePickerDateExample',
            builder: (_) => const DateTimePickerDateExample(),
          ),
          ExampleItem(
            desc: '年月选择器',
            methodName: 'DateTimePickerMonthExample',
            builder: (_) => const DateTimePickerMonthExample(),
          ),
          ExampleItem(
            desc: '月日选择器',
            methodName: 'DateTimePickerMonthDayExample',
            builder: (_) => const DateTimePickerMonthDayExample(),
          ),
          ExampleItem(
            desc: '时分秒选择器',
            methodName: 'DateTimePickerSecondExample',
            builder: (_) => const DateTimePickerSecondExample(),
          ),
          ExampleItem(
            desc: '时分选择器',
            methodName: 'DateTimePickerMinuteExample',
            builder: (_) => const DateTimePickerMinuteExample(),
          ),
          ExampleItem(
            desc: '年月日时分秒选择器',
            methodName: 'DateTimePickerDateTimeExample',
            builder: (_) => const DateTimePickerDateTimeExample(),
          ),
          ExampleItem(
            desc: '年月日带星期选择器',
            methodName: 'DateTimePickerWeekExample',
            builder: (_) => const DateTimePickerWeekExample(),
          ),
        ],
      ),
      ExampleModule(
        title: '组件样式',
        children: [
          ExampleItem(
            desc: '是否带标题',
            methodName: 'DateTimePickerTitleExample',
            builder: (_) => const DateTimePickerTitleExample(),
          ),
          ExampleItem(
            desc: '',
            methodName: 'DateTimePickerWithoutTitleExample',
            builder: (_) => const DateTimePickerWithoutTitleExample(),
          ),
        ],
      ),
    ],
  );

  /// 核心组合片段：调用方使用 [TCell] 作为触发器，用 [TPopup] 组合标题栏
  /// 与纯滚轮 [TDateTimePicker]。滚动只更新草稿，确认时再通过 [onConfirm]
  /// 写回调用方状态，取消不会提交。
  ///
  /// 核心片段省略应用壳；导入 flutter/material.dart 和
  /// package:tdesign_flutter/tdesign_flutter.dart，在 StatefulWidget 的 State
  /// 中放置本方法。父级持有已确认的值，例如：
  /// ```dart
  /// var selected = const TDateTimePickerValue(year: 2022, month: 8, day: 10);
  /// // 在 build 中调用；取消保持 selected，确认后 setState 更新触发器文案。
  /// _cell(context, 'date', DateTimePickerMode(dateMode: DateMode.date),
  ///   value: selected, onConfirm: (next) => setState(() => selected = next));
  /// ```
  ///
  /// 九个入口使用同一组合，按下列实际配置提供 id、mode 和初始 value：
  /// - date：dateMode: DateMode.date；year: 2022, month: 8, day: 10。
  /// - month：dateMode: DateMode.month；year: 2022, month: 8。
  /// - month-day：dateMode: DateMode.monthDay；month: 8, day: 10，不传 year。
  /// - second：timeMode: TimeMode.second；hour: 12, minute: 50, second: 23。
  /// - minute：timeMode: TimeMode.minute；hour: 12, minute: 50。
  /// - date-time：dateMode: DateMode.date, timeMode: TimeMode.second；
  ///   year: 2022, month: 8, day: 10, hour: 12, minute: 50, second: 23。
  /// - week：同 date，showWeek: true。
  /// - title：同 date，title: '带标题时间选择器'。
  /// - without-title：同 date，title: '无标题时间选择器', showTitle: false。
  /// value 均构造为 TDateTimePickerValue；每个入口由父级单独持有选择值。
  /// title 是触发器文案；弹层标题为“选择时间”，showTitle 控制其显示。
  /// 不传的 showWeek 为 false、showTitle 为 true，title 为“选择时间”。
}
