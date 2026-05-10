import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../picker/no_wave_behavior.dart';
import '../picker/t_item_widget.dart';
import '../picker/t_picker_option.dart';
import '../picker/t_picker_value.dart';

/// 日期选择器数据模型（供 TCalendar 内部时间选择器使用）
///
/// 精简版，仅包含 TCalendar 时间选择器所需功能
class DatePickerModel {
  final bool useYear;
  final bool useMonth;
  final bool useDay;
  final bool useHour;
  final bool useMinute;
  final bool useSecond;
  final bool useWeekDay;

  /// 可选起始日期 [year, month, day, ...]
  final List<int>? dateStart;

  /// 可选结束日期
  final List<int>? dateEnd;

  /// 默认选中的日期 [year, month, day, hour, minute, second, ...]
  final List<int>? dateInitial;

  /// 过滤选项
  final List<int> Function(String key, List<int> items)? filterItems;

  DatePickerModel({
    this.useYear = true,
    this.useMonth = true,
    this.useDay = true,
    this.useHour = false,
    this.useMinute = false,
    this.useSecond = false,
    this.useWeekDay = false,
    this.dateStart,
    this.dateEnd,
    this.dateInitial,
    this.filterItems,
  });

  /// 获取年数据列表
  List<int> get years {
    final start = (dateStart != null && dateStart!.isNotEmpty) ? dateStart![0] : 1900;
    final end = (dateEnd != null && dateEnd!.isNotEmpty) ? dateEnd![0] : 2100;
    return List.generate(end - start + 1, (i) => start + i);
  }

  /// 获取月数据列表
  List<int> get months => List.generate(12, (i) => i + 1);

  /// 获取日数据列表
  List<int> days(int year, int month) {
    final daysInMonth = DateTime(year, month + 1).subtract(const Duration(days: 1)).day;
    return List.generate(daysInMonth, (i) => i + 1);
  }

  /// 获取时数据列表
  List<int> get hours => List.generate(24, (i) => i);

  /// 获取分数据列表
  List<int> get minutes => List.generate(60, (i) => i);

  /// 获取秒数据列表
  List<int> get seconds => List.generate(60, (i) => i);

  /// 获取星期数据列表
  List<String> get weekDays => ['一', '二', '三', '四', '五', '六', '日'];

  /// 所有列的 ScrollController
  late List<FixedExtentScrollController> controllers;
  late List<List> data;

  /// 命名控制器便捷访问（供 TCalendar 使用）
  FixedExtentScrollController get hourFixedExtentScrollController {
    int idx = 0;
    if (useYear) idx++;
    if (useMonth) idx++;
    if (useDay) idx++;
    return controllers[idx];
  }

  FixedExtentScrollController get minuteFixedExtentScrollController {
    int idx = 0;
    if (useYear) idx++;
    if (useMonth) idx++;
    if (useDay) idx++;
    if (useHour) idx++;
    return controllers[idx];
  }

  FixedExtentScrollController get secondFixedExtentScrollController {
    int idx = 0;
    if (useYear) idx++;
    if (useMonth) idx++;
    if (useDay) idx++;
    if (useHour) idx++;
    if (useMinute) idx++;
    return controllers[idx];
  }

  /// 初始化
  void init() {
    data = [];
    controllers = [];

    if (useYear) data.add(years);
    if (useMonth) data.add(months);
    if (useDay) data.add([31]); // 占位，下面会刷新
    if (useHour) data.add(hours);
    if (useMinute) data.add(minutes);
    if (useSecond) data.add(seconds);
    if (useWeekDay) data.add(weekDays);

    controllers = List.generate(
      data.length,
      (_) => FixedExtentScrollController(),
    );

    // 设置初始位置
    if (dateInitial != null) {
      final init = dateInitial!;
      for (var i = 0; i < init.length && i < controllers.length; i++) {
        if (data[i].isNotEmpty) {
          final idx = data[i].indexOf(init[i]);
          if (idx >= 0) controllers[i].jumpToItem(idx);
        }
      }
    }

    // 刷新日列数据（必须在 controllers 初始化之后，因为需要读取选中的年/月）
    if (useDay) _refreshDays();
  }

  /// 根据当前选中值刷新日列数据
  void _refreshDays() {
    final yearIdx = useYear ? controllers[0].selectedItem : 0;
    final monthIdx = useMonth ? controllers[1].selectedItem : 0;
    final year = useYear ? years[yearIdx] : DateTime.now().year;
    final month = useMonth ? months[monthIdx] : DateTime.now().month;
    data[2] = days(year, month);
  }

  /// 外部调用：当年/月变化时刷新后续列
  void refreshDataAndController(int changedColumn) {
    if (changedColumn == 0 && useMonth) {
      // 年变化 → 刷新月
      _refreshDays();
      if (controllers.length > changedColumn + 1) controllers[changedColumn + 1].jumpToItem(0);
    }
    if (changedColumn == 1 && useDay) {
      // 月变化 → 刷新日
      _refreshDays();
      if (controllers.length > changedColumn + 1) controllers[changedColumn + 1].jumpToItem(0);
    }
  }

  /// 获取当前选中值
  Map<String, int> get selected {
    final result = <String, int>{};
    var idx = 0;
    if (useYear && idx < data.length) {
      result['year'] = data[idx][controllers[idx].selectedItem];
      idx++;
    }
    if (useMonth && idx < data.length) {
      result['month'] = data[idx][controllers[idx].selectedItem];
      idx++;
    }
    if (useDay && idx < data.length) {
      result['day'] = data[idx][controllers[idx].selectedItem];
      idx++;
    }
    if (useHour && idx < data.length) {
      result['hour'] = data[idx][controllers[idx].selectedItem];
      idx++;
    }
    if (useMinute && idx < data.length) {
      result['minute'] = data[idx][controllers[idx].selectedItem];
      idx++;
    }
    if (useSecond && idx < data.length) {
      result['second'] = data[idx][controllers[idx].selectedItem];
      idx++;
    }
    return result;
  }
}
