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
/// 纯滚轮组件：不含工具栏、确认按钮或弹窗；选中变化通过 `onChange` 实时回调
///（无 `TPicker.onConfirm` 语义）。弹窗与确认请配合 `TPopup` 等自行组装。
///
/// `initialValue` 为非受控初始值；外部重置选中请变更 `initialValue` 或 `key`。
/// 与 `TPicker` 不同，本组件不提供受控 `value` 参数。
class TDateTimePicker extends StatefulWidget {
  /// 创建日期/时间选择器。
  ///
  /// `mode` 默认年月日；`height` 默认 200；`itemCount` 默认 5。
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

  /// 滚轮列结构；通过 `DateTimePickerMode` 组合 `DateMode`、`TimeMode`，默认年月日。
  final DateTimePickerMode mode;

  /// 自定义列展示文案；`column` 为 `DateTimeColumn`，`value` 为数值，返回 null 用默认文案。
  final DateTimePickerRenderLabel? renderLabel;

  /// 可选范围下限，类型同 `initialValue`。
  final TDateTimePickerValue? start;

  /// 可选范围上限，类型同 `initialValue`。
  final TDateTimePickerValue? end;

  /// 各列选项步进。
  final DateTimePickerSteps? steps;

  /// 初始选中值（非受控）；缺省为当前时间。
  final TDateTimePickerValue? initialValue;

  /// 日列是否显示星期，默认 false。
  final bool showWeek;

  /// 选中值变化回调（滚动实时触发，无确认语义），返回 `TDateTimePickerValue`。
  final void Function(TDateTimePickerValue result)? onChange;

  /// 滚轮视窗高度，默认 200。
  final double? height;

  /// 每屏可见条目数，默认 5。
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
        initial: initialChanged
            ? _resolveInitialDateTime()
            : _snapshot.current,
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
