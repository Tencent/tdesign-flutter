import 'package:flutter/material.dart';

import '../date_time_picker/t_date_time_picker_enums.dart';
import '../date_time_picker/t_date_time_picker_internal.dart';
import '../date_time_picker/t_date_time_picker_model.dart';

/// 日期选择器数据模型（供 TCalendar 内部时间选择器使用）
///
/// 列范围、闰月归一化与联动逻辑由 [DateTimePickerSnapshot] 统一计算。
/// 默认路径下 UI 由 [DateTimePickerWheel] 渲染；`useWeekDay` / [filterItems]
/// 非空时回退自绘滚轮。新代码请直接使用 [TDateTimePicker]。
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

  /// 过滤选项；非 null 时走自绘滚轮遗留路径。
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

  DateTimePickerSnapshot? _snapshot;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  /// 是否走自绘滚轮遗留路径（`useWeekDay` / [filterItems]）。
  bool get usesLegacyWheel => useWeekDay || filterItems != null;

  /// 当前快照；[usesLegacyWheel] 为 `false` 且 [init] 后可用。
  DateTimePickerSnapshot? get snapshot => _snapshot;

  DateTime? get rangeStart => _rangeStart;

  DateTime? get rangeEnd => _rangeEnd;

  /// 遗留路径：各列 ScrollController。
  late List<FixedExtentScrollController> controllers;

  /// 遗留路径：各列数据源。
  late List<List> data;

  /// 初始化
  void init() {
    data = [];
    controllers = [];

    if (usesLegacyWheel) {
      _initLegacyWheel();
      return;
    }

    final columns = _buildSnapshotColumns();
    if (columns.isEmpty) {
      return;
    }

    _rangeStart = _partsToDateTime(dateStart);
    _rangeEnd = _partsToDateTime(dateEnd);
    final initial = _partsToDateTime(dateInitial) ?? DateTime.now();

    _snapshot = DateTimePickerSnapshot.initial(
      columns: columns,
      initial: initial,
      start: _rangeStart,
      end: _rangeEnd,
    );
  }

  /// 滚轮选中变化时同步快照（[DateTimePickerWheel] 回调）。
  void applySnapshot(DateTimePickerSnapshot next) {
    _snapshot = next;
  }

  /// 遗留路径：当年/月变化时刷新后续列。
  void refreshDataAndController(int changedColumn) {
    if (!usesLegacyWheel) {
      return;
    }
    _refreshLegacyWheel(changedColumn);
  }

  /// 获取当前选中值
  Map<String, int> get selected {
    if (_snapshot != null) {
      return _resultToMap(_snapshot!.toResult());
    }
    return _selectedLegacy();
  }

  static Map<String, int> _resultToMap(TDateTimePickerValue result) {
    final map = <String, int>{};
    if (result.year != null) {
      map['year'] = result.year!;
    }
    if (result.month != null) {
      map['month'] = result.month!;
    }
    if (result.day != null) {
      map['day'] = result.day!;
    }
    if (result.hour != null) {
      map['hour'] = result.hour!;
    }
    if (result.minute != null) {
      map['minute'] = result.minute!;
    }
    if (result.second != null) {
      map['second'] = result.second!;
    }
    return map;
  }

  List<DateTimeColumn> _buildSnapshotColumns() {
    final cols = <DateTimeColumn>[];
    if (useYear) {
      cols.add(DateTimeColumn.year);
    }
    if (useMonth) {
      cols.add(DateTimeColumn.month);
    }
    if (useDay) {
      cols.add(DateTimeColumn.day);
    }
    if (useHour) {
      cols.add(DateTimeColumn.hour);
    }
    if (useMinute) {
      cols.add(DateTimeColumn.minute);
    }
    if (useSecond) {
      cols.add(DateTimeColumn.second);
    }
    return cols;
  }

  static DateTime? _partsToDateTime(List<int>? parts) {
    if (parts == null || parts.isEmpty) {
      return null;
    }
    return DateTime(
      parts.isNotEmpty ? parts[0] : 2000,
      parts.length > 1 ? parts[1] : 1,
      parts.length > 2 ? parts[2] : 1,
      parts.length > 3 ? parts[3] : 0,
      parts.length > 4 ? parts[4] : 0,
      parts.length > 5 ? parts[5] : 0,
    );
  }

  // ---------------------------------------------------------------------------
  // 遗留自绘滚轮（useWeekDay / filterItems）
  // ---------------------------------------------------------------------------

  static List<String> get _weekDays => ['一', '二', '三', '四', '五', '六', '日'];

  static String _columnFilterKey(DateTimeColumn column) => switch (column) {
        DateTimeColumn.year => 'year',
        DateTimeColumn.month => 'month',
        DateTimeColumn.day => 'day',
        DateTimeColumn.hour => 'hour',
        DateTimeColumn.minute => 'minute',
        DateTimeColumn.second => 'second',
      };

  List<int> _legacyYears() {
    final start =
        (dateStart != null && dateStart!.isNotEmpty) ? dateStart![0] : 1900;
    final end = (dateEnd != null && dateEnd!.isNotEmpty) ? dateEnd![0] : 2100;
    return List.generate(end - start + 1, (i) => start + i);
  }

  List<int> _legacyMonths() => List.generate(12, (i) => i + 1);

  List<int> _legacyDays(int year, int month) {
    final daysInMonth = DateTimePickerSnapshot.daysInMonth(year, month);
    return List.generate(daysInMonth, (i) => i + 1);
  }

  void _initLegacyWheel() {
    final columns = _buildSnapshotColumns();
    _rangeStart = _partsToDateTime(dateStart);
    _rangeEnd = _partsToDateTime(dateEnd);
    final initial = _partsToDateTime(dateInitial) ?? DateTime.now();

    if (columns.isNotEmpty && filterItems != null) {
      _snapshot = DateTimePickerSnapshot.initial(
        columns: columns,
        initial: initial,
        start: _rangeStart,
        end: _rangeEnd,
      );
      _rebuildLegacyDataFromSnapshot();
      return;
    }

    if (useYear) {
      data.add(_legacyYears());
    }
    if (useMonth) {
      data.add(_legacyMonths());
    }
    if (useDay) {
      data.add([31]);
    }
    if (useHour) {
      data.add(List.generate(24, (i) => i));
    }
    if (useMinute) {
      data.add(List.generate(60, (i) => i));
    }
    if (useSecond) {
      data.add(List.generate(60, (i) => i));
    }
    if (useWeekDay) {
      data.add(_weekDays);
    }

    controllers = List.generate(
      data.length,
      (_) => FixedExtentScrollController(),
    );

    if (dateInitial != null) {
      final init = dateInitial!;
      for (var i = 0; i < init.length && i < controllers.length; i++) {
        if (data[i].isNotEmpty && data[i].first is int) {
          final idx = (data[i] as List<int>).indexOf(init[i]);
          if (idx >= 0) {
            controllers[i].jumpToItem(idx);
          }
        }
      }
    }

    if (useDay) {
      _refreshLegacyDays();
    }
  }

  void _rebuildLegacyDataFromSnapshot() {
    final snap = _snapshot!;
    data = List.generate(snap.columns.length, (_) => <int>[]);
    controllers = [];
    for (var i = 0; i < snap.columns.length; i++) {
      final options = snap.columnOptionsAt(
        i,
        start: _rangeStart,
        end: _rangeEnd,
        labels: DateTimePickerLabels.defaults,
      );
      var values = options.map((o) => o.value as int).toList();
      values = filterItems!(_columnFilterKey(snap.columns[i]), values);
      data.add(values);
      var idx = values.indexOf(snap.values[i]);
      if (idx < 0) {
        idx = 0;
      }
      controllers.add(FixedExtentScrollController(initialItem: idx));
    }
  }

  void _refreshLegacyDays() {
    var dayCol = 0;
    if (useYear) {
      dayCol++;
    }
    if (useMonth) {
      dayCol++;
    }
    if (dayCol >= data.length) {
      return;
    }

    final years = _legacyYears();
    final yearIdx = useYear
        ? controllers[0].selectedItem.clamp(0, years.length - 1)
        : 0;
    final monthCol = useYear ? 1 : 0;
    final months = _legacyMonths();
    final monthIdx = useMonth
        ? controllers[monthCol].selectedItem.clamp(0, months.length - 1)
        : 0;
    final year = useYear ? years[yearIdx] : DateTime.now().year;
    final month = useMonth ? months[monthIdx] : DateTime.now().month;
    data[dayCol] = _legacyDays(year, month);
  }

  void _refreshLegacyWheel(int changedColumn) {
    if (filterItems != null && _snapshot != null) {
      final raw = <int>[];
      for (var i = 0; i < controllers.length; i++) {
        final colData = data[i] as List<int>;
        final idx =
            controllers[i].selectedItem.clamp(0, colData.length - 1);
        raw.add(colData[idx]);
      }
      final prev = _snapshot!;
      final next = prev.applySelection(
        rawValues: raw,
        start: _rangeStart,
        end: _rangeEnd,
      );
      if (next == prev) {
        return;
      }
      _snapshot = next;
      final rebuildIndices = next.columnIndicesWithChangedOptions(
        prev,
        start: _rangeStart,
        end: _rangeEnd,
      );
      for (final i in rebuildIndices) {
        final options = next.columnOptionsAt(
          i,
          start: _rangeStart,
          end: _rangeEnd,
          labels: DateTimePickerLabels.defaults,
        );
        var values = options.map((o) => o.value as int).toList();
        values = filterItems!(_columnFilterKey(next.columns[i]), values);
        data[i] = values;
        final target = next.values[i];
        var idx = values.indexOf(target);
        if (idx < 0) {
          idx = 0;
        }
        if (controllers[i].hasClients) {
          controllers[i].jumpToItem(idx);
        }
      }
      return;
    }

    if (changedColumn == 0 && useMonth) {
      _refreshLegacyDays();
      if (controllers.length > changedColumn + 1) {
        controllers[changedColumn + 1].jumpToItem(0);
      }
    }
    if (changedColumn == 1 && useDay) {
      _refreshLegacyDays();
      if (controllers.length > changedColumn + 1) {
        controllers[changedColumn + 1].jumpToItem(0);
      }
    }
  }

  Map<String, int> _selectedLegacy() {
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
