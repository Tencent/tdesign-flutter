import 'package:flutter/material.dart';

import '../../util/context_extension.dart';
import 't_date_time_picker_enums.dart';
import 't_date_time_picker_internal.dart';
import 't_date_time_picker_model.dart';
import 't_date_time_picker_wheel.dart';

export 't_date_time_picker_enums.dart';
export 't_date_time_picker_model.dart';

/// 日期/时间选择器。
///
/// 纯滚轮 UI，无顶部取消/确定栏。滚轮中心项变化时通过 [onChange] 通知选中结果，
/// 与上次 [TDateTimePickerValue] 相同时不重复触发。弹窗场景的关闭与提交由
/// [TPopup] 或页面逻辑处理。
///
/// ```dart
/// TDateTimePicker(
///   mode: DateTimePickerMode(dateMode: DateMode.date),
///   initialValue: DateTime.now(),
///   onChange: (result) {},
/// )
/// ```
class TDateTimePicker extends StatefulWidget {
  /// 创建日期/时间选择器。
  ///
  /// [mode] 缺省为 `DateTimePickerMode(dateMode: DateMode.date)`。
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

  /// 列结构。
  final DateTimePickerMode mode;

  /// 自定义列 label，仅影响展示；返回 `null` 时使用 [TResourceDelegate] 默认文案。
  final DateTimePickerRenderLabel? renderLabel;

  /// 可选范围下界（闭区间）。
  ///
  /// 为 `null` 时年列下界为组件打开时锚定年份 − 10，且不随年列滚动漂移。
  /// 若 [start] 晚于 [end]，debug 下 assert，release 下忽略 [end]。
  final DateTime? start;

  /// 可选范围上界（闭区间）。
  ///
  /// 为 `null` 时年列上界为组件打开时锚定年份 + 10，且不随年列滚动漂移。
  /// 若 [start] 晚于 [end]，debug 下 assert，release 下忽略 [end]。
  final DateTime? end;

  /// 各列选项步进，如 `DateTimePickerSteps(minute: 5)`；未配置的列步进为 1。
  final DateTimePickerSteps? steps;

  /// 默认选中时间。
  ///
  /// 缺省为 [DateTime.now]；超出 [start]、[end] 时钳制到范围内。
  /// 用于首次展示或父组件更新时重置；滚动中的当前值请通过 [onChange] 获取，
  /// 勿将 [onChange] 的结果同步回本参数并触发父组件重建。
  final DateTime? initialValue;

  /// 是否在日列 label 附加星期（如 `19日 周六`），仅影响展示。
  ///
  /// 回调结果无星期字段，请用 [TDateTimePickerValue.toDateTime].weekday。
  final bool showWeek;

  /// 选中值变化回调。
  ///
  /// [TDateTimePickerValue] 仅包含当前 [mode] 中存在的列；
  /// 与上一次回调结果相同时不触发。
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
      initial: widget.initialValue,
      start: widget.start,
      end: widget.end,
      steps: widget.steps,
    );
  }

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
        initial: initialChanged ? widget.initialValue : _snapshot.current,
        start: widget.start,
        end: widget.end,
        steps: widget.steps,
      );
      _resetWheel(clearLastNotified: true);
    } else {
      _snapshot = _snapshot.rebuildFor(
        columns: widget.mode.columns,
        start: widget.start,
        end: widget.end,
        steps: widget.steps,
      );
      _resetWheel();
    }
  }

  void _handleWheelChanged(
    DateTimePickerSnapshot snapshot,
    TDateTimePickerValue result,
  ) {
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
      start: widget.start,
      end: widget.end,
      showWeek: widget.showWeek,
      steps: widget.steps,
      renderLabel: widget.renderLabel,
      height: widget.height ?? 200,
      itemCount: widget.itemCount ?? 5,
      onChanged: _handleWheelChanged,
    );
  }
}
