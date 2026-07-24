import 'package:flutter/material.dart';

import '../../util/context_extension.dart';
import '../picker/t_picker_theme_data.dart';
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
/// 纯滚轮组件，不包含工具栏、确认按钮或弹窗。
/// [value] 与 [onChanged] 构成严格受控状态；[onChanged] 为 null 时禁用。
class TDateTimePicker extends StatefulWidget {
  TDateTimePicker({
    super.key,
    required this.value,
    DateTimePickerMode? mode,
    this.renderLabel,
    this.start,
    this.end,
    this.steps,
    this.showWeek = false,
    this.onChanged,
  }) : mode = mode ?? DateTimePickerMode(dateMode: DateMode.date);

  /// 受控选中值。
  final TDateTimePickerValue value;

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

  /// 日列是否在 label 后附加星期，默认 false
  ///
  /// - **生效范围**：仅 [DateTimeColumn.day] 列
  /// - **变更语义**：变更会触发列重建
  final bool showWeek;

  /// 选中值变化回调（滚动时实时触发，不代表用户已确认选择）
  ///
  /// - **触发时机**：滚轮选中变化且结果与上次通知值不同时
  /// - **返回值**：[TDateTimePickerValue]；不含的列字段为 null
  /// - **典型用法**：维护业务侧受控状态
  final void Function(TDateTimePickerValue result)? onChanged;

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
      initial: _resolveValue(),
      start: _resolveBound(widget.start),
      end: _resolveBound(widget.end),
      steps: widget.steps,
    );
  }

  DateTime? _resolveBound(TDateTimePickerValue? bound) =>
      bound?.toDateTime(fallback: kDateTimePickerDefaultFallback);

  DateTime _resolveValue() =>
      widget.value.toDateTime(fallback: kDateTimePickerDefaultFallback);

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
    final valueChanged = oldWidget.value != widget.value;
    final rangeChanged =
        oldWidget.start != widget.start || oldWidget.end != widget.end;
    final stepsChanged = oldWidget.steps != widget.steps;
    final showWeekChanged = oldWidget.showWeek != widget.showWeek;
    final renderLabelChanged = oldWidget.renderLabel != widget.renderLabel;

    if (!modeChanged &&
        !valueChanged &&
        !rangeChanged &&
        !stepsChanged &&
        !showWeekChanged &&
        !renderLabelChanged) {
      return;
    }

    final controlledValueDiverged =
        valueChanged && widget.value != _snapshot.toResult();
    if (modeChanged || controlledValueDiverged) {
      _snapshot = DateTimePickerSnapshot.initial(
        columns: widget.mode.columns,
        initial: controlledValueDiverged ? _resolveValue() : _snapshot.current,
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
    widget.onChanged?.call(result);
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
    final pickerTheme = Theme.of(context).extension<TPickerThemeData>();
    final labels = DateTimePickerLabels.fromResource(context.resource);
    final start = _resolveBound(widget.start);
    final end = _resolveBound(widget.end);
    final picker = DateTimePickerWheel(
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
      height: pickerTheme?.height ?? 200,
      itemCount: pickerTheme?.itemCount ?? 5,
      onChanged: _handleWheelChanged,
    );
    final isDisabled = widget.onChanged == null;
    return Semantics(
      enabled: !isDisabled,
      child: AnimatedOpacity(
        opacity: isDisabled ? 0.5 : 1,
        duration: const Duration(milliseconds: 150),
        child: AbsorbPointer(absorbing: isDisabled, child: picker),
      ),
    );
  }
}
