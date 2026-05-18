import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

export 't_date_time_picker_model.dart';

/// 时间选择器
///
/// 基于 `TPicker` 的组合组件，仅负责日期/时间数据的列生成和回调转换，
/// 所有 UI 渲染和滚轮交互完全委托给 `TPicker`。
///
/// 通过 [mode] 控制列结构，支持快捷模式和数组精确模式。
///
/// 快捷模式：
/// ```dart
/// TDateTimePicker(
///   mode: DateTimePickerMode.date,
///   onConfirm: (v) => print(v.year), // 2026
/// )
/// ```
///
/// 数组模式（年月日 + 时分）：
/// ```dart
/// TDateTimePicker(
///   mode: DateTimePickerMode.array(['date', 'minute']),
///   onConfirm: (v) => print(v.toDateTime()),
/// )
/// ```
///
/// 附带星期列：
/// ```dart
/// TDateTimePicker(
///   mode: DateTimePickerMode.array(['date', 'week']),
///   onConfirm: (v) {
///     print(v.day);   // 16
///     print(v.week);  // 1（周一）
///     // week 列为只读显示，随 day 变化自动联动，不可独立滚动选择
///   },
/// )
/// ```
class TDateTimePicker extends StatefulWidget {
  const TDateTimePicker({
    super.key,
    required this.mode,
    this.format,
    this.start,
    this.end,
    this.initialValue,
    this.onCancel,
    this.onChange,
    this.onConfirm,
    this.title,
    this.titleWidget,
    this.cancel,
    this.confirm,
    this.height,
    this.itemCount,
  });

  /// 列结构模式（必填）
  ///
  /// 决定显示哪些列（年/月/日/时/分/秒/星期），参见 [DateTimePickerMode]。
  final DateTimePickerMode mode;

  /// 自定义列显示文案
  ///
  /// 仅影响显示（[TPickerOption.label]），不影响回调数据。
  /// 传入 `null` 时使用默认格式（数字 + 中文单位，如 "2026年"、"5月"）。
  ///
  /// ```dart
  /// format: (column, value) {
  ///   if (column == DateTimeColumn.month) {
  ///     return value.toString().padLeft(2, '0');
  ///   }
  ///   return '$value';
  /// }
  /// ```
  final String Function(DateTimeColumn column, int value)? format;

  /// 可选范围起始日期
  ///
  /// 当传 `null` 时，年列默认起始为「当前年 -
  /// [DateTimePickerDataHelper.defaultYearOffset]」（默认 10 年前）。
  ///
  /// 月、日、时、分、秒列在跨年/跨月时不会被裁剪。
  final DateTime? start;

  /// 可选范围结束日期
  ///
  /// 当传 `null` 时，年列默认结束为「当前年 +
  /// [DateTimePickerDataHelper.defaultYearOffset]」（默认 10 年后）。
  ///
  /// 月、日、时、分、秒列在跨年/跨月时不会被裁剪。
  final DateTime? end;

  /// 初始选中值
  final DateTime? initialValue;

  /// 点击取消时触发
  final VoidCallback? onCancel;

  /// 选中值变化回调（滚动实时触发）
  ///
  /// 回调参数为 [TDateTimePickerValue]，仅包含当前 [mode] 下涉及的列，
  /// 其余字段为 `null`。
  final void Function(TDateTimePickerValue result)? onChange;

  /// 点击确认时触发
  ///
  /// 回调参数为 [TDateTimePickerValue]，仅包含当前 [mode] 下涉及的列，
  /// 其余字段为 `null`。
  ///
  /// 通过 [TDateTimePickerValue.toDateTime] 可将结果重组为 `DateTime`：
  /// ```dart
  /// onConfirm: (v) {
  ///   final dt = v.toDateTime();
  /// },
  /// ```
  final void Function(TDateTimePickerValue result)? onConfirm;

  /// 工具栏标题文字
  final String? title;

  /// 自定义标题组件（优先级高于 [title]）
  final Widget? titleWidget;

  /// 工具栏左侧自定义插槽
  final Widget? cancel;

  /// 工具栏右侧自定义插槽
  final Widget? confirm;

  /// 面板视窗高度
  final double? height;

  /// 每屏显示条目数量
  final int? itemCount;

  @override
  State<TDateTimePicker> createState() => _TDateTimePickerState();
}

class _TDateTimePickerState extends State<TDateTimePicker> {
  late List<DateTimeColumn> _columns;
  late DateTime _current;
  late TPickerColumns _pickerColumns;
  late List<dynamic> _initialValue;

  /// 上一次 onChange 的 values（用于判断年/月是否变化）
  List<dynamic> _lastValues = const [];

  @override
  void initState() {
    super.initState();
    _columns = widget.mode.columns;
    _current = widget.initialValue ?? DateTime.now();
    _pickerColumns = _buildPickerColumns();
    _initialValue = DateTimePickerDataHelper.buildInitialValue(
      columns: _columns,
      value: _current,
    );
    _lastValues = List.of(_initialValue);
  }

  @override
  void didUpdateWidget(covariant TDateTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    final modeChanged = !_columnsEqual(
      oldWidget.mode.columns,
      widget.mode.columns,
    );
    final initialValueChanged = oldWidget.initialValue != widget.initialValue;
    final rangeChanged =
        oldWidget.start != widget.start || oldWidget.end != widget.end;
    final formatChanged = oldWidget.format != widget.format;

    if (!modeChanged && !initialValueChanged && !rangeChanged && !formatChanged) {
      return;
    }

    if (modeChanged) {
      _columns = widget.mode.columns;
    }
    if (modeChanged || initialValueChanged) {
      _current = widget.initialValue ?? DateTime.now();
      _initialValue = DateTimePickerDataHelper.buildInitialValue(
        columns: _columns,
        value: _current,
      );
      _lastValues = List.of(_initialValue);
    }
    _pickerColumns = _buildPickerColumns();
  }

  TPickerColumns _buildPickerColumns() {
    return DateTimePickerDataHelper.buildColumns(
      columns: _columns,
      start: widget.start,
      end: widget.end,
      current: _current,
      format: widget.format,
    );
  }

  TDateTimePickerValue _toResult(TPickerValue pickerValue) {
    return DateTimePickerDataHelper.toResult(
      columns: _columns,
      values: pickerValue.values,
    );
  }

  void _handleChange(TPickerValue pickerValue) {
    final newValues = pickerValue.values;

    // 检查是否需要联动刷新（年/月变化 → 日列天数变化；日变化 → 星期变化）
    if (DateTimePickerDataHelper.needsRefresh(
          _columns,
          _lastValues,
          newValues,
        ) ||
        _needsWeekRefresh(newValues)) {
      _current = DateTimePickerDataHelper.resolveCurrentDateTime(
        columns: _columns,
        values: newValues,
        fallback: _current,
      );
      setState(() {
        _pickerColumns = _buildPickerColumns();
        // 更新 initialValue 以保持 TPicker 的选中位置
        _initialValue = DateTimePickerDataHelper.buildInitialValue(
          columns: _columns,
          value: _current,
        );
      });
    }

    _lastValues = List.of(newValues);
    widget.onChange?.call(_toResult(pickerValue));
  }

  /// 检查是否需要刷新星期列（日列变化时星期也需要更新）
  bool _needsWeekRefresh(List<dynamic> newValues) {
    if (!_columns.contains(DateTimeColumn.week)) {
      return false;
    }
    for (var i = 0; i < _columns.length && i < _lastValues.length && i < newValues.length; i++) {
      final col = _columns[i];
      if ((col == DateTimeColumn.year ||
              col == DateTimeColumn.month ||
              col == DateTimeColumn.day) &&
          _lastValues[i] != newValues[i]) {
        return true;
      }
    }
    return false;
  }

  void _handleConfirm(TPickerValue pickerValue) {
    widget.onConfirm?.call(_toResult(pickerValue));
  }

  @override
  Widget build(BuildContext context) {
    return TPicker(
      items: _pickerColumns,
      initialValue: _initialValue,
      title: widget.title,
      titleWidget: widget.titleWidget,
      cancel: widget.cancel,
      confirm: widget.confirm,
      height: widget.height ?? 200,
      itemCount: widget.itemCount ?? 5,
      onCancel: widget.onCancel,
      onChange: _handleChange,
      onConfirm: _handleConfirm,
    );
  }

  static bool _columnsEqual(
      List<DateTimeColumn> a, List<DateTimeColumn> b) {
    if (identical(a, b)) {
      return true;
    }
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }
}
