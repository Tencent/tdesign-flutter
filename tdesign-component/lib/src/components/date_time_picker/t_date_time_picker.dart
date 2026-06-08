import 'package:flutter/material.dart';

import '../../util/context_extension.dart';
import 't_date_time_picker_column.dart';
import 't_date_time_picker_enums.dart';
import 't_date_time_picker_internal.dart';
import 't_date_time_picker_model.dart';
import 't_date_time_picker_wheel.dart';

export 't_date_time_picker_column.dart';
export 't_date_time_picker_enums.dart';
export 't_date_time_picker_internal.dart' show DateTimePickerRenderLabel;
export 't_date_time_picker_model.dart';

/// 日期/时间滚轮选择器。
///
/// 与 [`TCalendar`]、[`TPicker`] 为三个独立对外组件；本组件底层复用 [`TPicker`]
/// 滚轮能力（经内部 [`DateTimePickerWheel`]），与 [`TCalendar`] 无代码耦合。
///
/// 纯滚轮组件：不含工具栏、确认按钮或弹窗；选中变化通过 `onChange` 实时回调
///（无 `TPicker.onConfirm` 语义）。弹窗与确认请配合 `TPopup` 等自行组装。
///
/// `initialValue` 为非受控初始值；外部重置选中请变更 `initialValue` 或 `key`。
/// 与 `TPicker` 不同，本组件不提供受控 `value` 参数。
class TDateTimePicker extends StatefulWidget {
  TDateTimePicker({
    super.key,
    DateTimePickerMode? mode,
    this.renderLabel,
    this.start,
    this.end,
    this.steps,
    this.initialValue,
    this.showWeek = false,
    this.onChange,
    this.height,
    this.itemCount,
  }) : mode = mode ?? DateTimePickerMode(dateMode: DateMode.date);

  /// 滚轮列结构（必填）
  ///
  /// - **类型**：[DateTimePickerMode]，通过 [DateMode]、[TimeMode] 组合列
  /// - **默认**：未传时等价于 `DateTimePickerMode(dateMode: DateMode.date)`（年月日）
  /// - **变更语义**：列结构变化会重建滚轮并清空上次通知值
  final DateTimePickerMode mode;

  /// 自定义列展示文案
  ///
  /// - **回调参数**：`column` 为 [DateTimeColumn]，`value` 为列数值
  /// - **回退**：返回 null 时使用内置默认文案（含国际化单位后缀）
  final DateTimePickerRenderLabel? renderLabel;

  /// 可选范围下限
  ///
  /// - **类型**：[TDateTimePickerValue]，仅传当前 mode 涉及的字段即可
  /// - **语义**：超出范围的候选项会被裁剪；变更会触发列重建
  final TDateTimePickerValue? start;

  /// 可选范围上限
  ///
  /// - **类型**：[TDateTimePickerValue]，仅传当前 mode 涉及的字段即可
  /// - **语义**：超出范围的候选项会被裁剪；变更会触发列重建
  final TDateTimePickerValue? end;

  /// 各列选项步进
  ///
  /// - **类型**：[DateTimePickerSteps]；未配置的列步进为 1
  /// - **变更语义**：变更会触发列重建，保留当前选中时刻（在合法范围内 clamp）
  final DateTimePickerSteps? steps;

  /// 初始选中值（非受控）
  ///
  /// - **默认**：未传时使用当前系统时间
  /// - **语义**：非受控 —— 运行期变更会重建滚轮并同步到新初始值（与 [TPicker.initialValue] 的 initState-only 不同）
  /// - **重置**：配合 [Key] 强制重建，或直接变更本参数
  /// - **partial**：仅传当前 mode 涉及的字段，缺字段由内部 fallback 补齐
  final TDateTimePickerValue? initialValue;

  /// 日列是否在 label 后附加星期，默认 false
  ///
  /// - **生效范围**：仅 [DateTimeColumn.day] 列
  /// - **变更语义**：变更会触发列重建
  final bool showWeek;

  /// 选中值变化回调（滚动时实时触发，不代表用户已确认选择）
  ///
  /// - **触发时机**：滚轮选中变化且结果与上次通知值不同时
  /// - **返回值**：[TDateTimePickerValue]；不含的列字段为 null
  /// - **典型用法**：维护 draft 状态；弹窗场景配合 [TPopup] 确认后再提交
  final void Function(TDateTimePickerValue result)? onChange;

  /// 滚轮视窗高度（像素），默认 200
  final double? height;

  /// 每屏显示 item 数（奇数更利于中央高亮），默认 5
  final int? itemCount;

  @override
  State<TDateTimePicker> createState() => _TDateTimePickerState();
}

class _TDateTimePickerState extends State<TDateTimePicker> {
  late DateTimePickerSnapshot _snapshot;
  late int _wheelGeneration;

  TDateTimePickerValue? _lastNotifiedValue;

  @override
  void initState() {
    super.initState();
    _wheelGeneration = 0;
    _snapshot = _createSnapshot();
    _lastNotifiedValue = _snapshot.toResult();
  }

  DateTimePickerSnapshot _createSnapshot() {
    return DateTimePickerSnapshot.initial(
      columns: widget.mode.columns,
      initial: _resolveInitialDateTime(),
      start: _resolveBound(widget.start),
      end: _resolveBound(widget.end),
      steps: widget.steps,
    );
  }

  DateTime? _resolveBound(TDateTimePickerValue? bound) =>
      bound?.toDateTime(fallback: kDateTimePickerDefaultFallback);

  DateTime? _resolveInitialDateTime() =>
      widget.initialValue?.toDateTime(fallback: kDateTimePickerDefaultFallback);

  void _resetWheel({bool clearLastNotified = false}) {
    if (clearLastNotified) {
      _lastNotifiedValue = null;
    }
    _wheelGeneration++;
  }

  @override
  void didUpdateWidget(covariant TDateTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    final modeChanged =
        !_listEqualInt(oldWidget.mode.columns, widget.mode.columns);
    final initialChanged = oldWidget.initialValue != widget.initialValue;
    final rangeChanged =
        oldWidget.start != widget.start || oldWidget.end != widget.end;
    final stepsChanged = oldWidget.steps != widget.steps;
    final showWeekChanged = oldWidget.showWeek != widget.showWeek;
    final renderLabelChanged = oldWidget.renderLabel != widget.renderLabel;

    if (!modeChanged &&
        !initialChanged &&
        !rangeChanged &&
        !stepsChanged &&
        !showWeekChanged &&
        !renderLabelChanged) {
      return;
    }

    if (modeChanged || initialChanged) {
      _snapshot = DateTimePickerSnapshot.initial(
        columns: widget.mode.columns,
        initial: initialChanged ? _resolveInitialDateTime() : _snapshot.current,
        start: _resolveBound(widget.start),
        end: _resolveBound(widget.end),
        steps: widget.steps,
      );
      _resetWheel(clearLastNotified: true);
    } else {
      _snapshot = _snapshot.rebuildFor(
        columns: widget.mode.columns,
        start: _resolveBound(widget.start),
        end: _resolveBound(widget.end),
        steps: widget.steps,
      );
      _resetWheel();
    }
  }

  void _handleWheelChanged(
    DateTimePickerSnapshot snapshot,
    TDateTimePickerValue result,
  ) {
    // dateTimePicker: 滚动时仅同步 snapshot，不 setState；Wheel 自持 UI 状态。
    _snapshot = snapshot;
    if (_lastNotifiedValue != null && result == _lastNotifiedValue) {
      return;
    }
    _lastNotifiedValue = result;
    widget.onChange?.call(result);
  }

  static bool _listEqualInt(List<dynamic> a, List<dynamic> b) {
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

  @override
  Widget build(BuildContext context) {
    final labels = DateTimePickerLabels.fromResource(context.resource);
    final start = _resolveBound(widget.start);
    final end = _resolveBound(widget.end);
    return DateTimePickerWheel(
      key: ValueKey<Object>(
        Object.hash(
          _wheelGeneration,
          Object.hashAll(widget.mode.columns),
          widget.start,
          widget.end,
          widget.showWeek,
          widget.renderLabel,
          widget.steps,
          labels,
          Localizations.localeOf(context),
        ),
      ),
      snapshot: _snapshot,
      labels: labels,
      start: start,
      end: end,
      showWeek: widget.showWeek,
      steps: widget.steps,
      renderLabel: widget.renderLabel,
      height: widget.height ?? 200,
      itemCount: widget.itemCount ?? 5,
      onChanged: _handleWheelChanged,
    );
  }
}
