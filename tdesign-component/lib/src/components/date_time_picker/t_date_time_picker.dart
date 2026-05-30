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
/// 纯滚轮 UI，无顶部取消/确定栏。选中值通过 [onChange] 实时通知；
/// 弹窗的关闭与是否「确定提交」由 [TPopup] 或页面逻辑处理。
///
/// **参数分工**
///
/// | 参数 | 作用 | 何时设置 |
/// |------|------|----------|
/// | [onChange] | 滚动时输出当前 [TDateTimePickerValue] | 需要知道选中值时 |
/// | [initialValue] | 打开/重建时滚轮初始位置 | 弹窗回显或指定首次默认值 |
///
/// **集成示例**
///
/// ```dart
/// TDateTimePickerValue? _selected;
///
/// // 弹窗：滚动即更新，关遮罩即生效
/// TPopup.show(
///   context,
///   child: TDateTimePicker(
///     mode: DateTimePickerMode(dateMode: DateMode.date),
///     initialValue: _selected?.toDateTime(), // 回显；首次为 null 则用 now
///     onChange: (v) => setState(() => _selected = v),
///   ),
/// );
///
/// // 内嵌：initialValue 仅首次挂载，之后靠 onChange 更新展示
/// TDateTimePicker(
///   initialValue: DateTime(2026, 5, 15),
///   onChange: (v) => _notifier.value = v,
/// );
/// ```
///
/// **注意**：勿将 [onChange] 结果写回 [initialValue] 并重建本组件，会导致滚轮跳动。
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

  /// dateTimePicker: 非受控初始选中时间。
  ///
  /// 仅决定「打开/重建时滚轮停在哪」，**不是**受控绑定；滚动中的当前值请用 [onChange]。
  ///
  /// **行为**
  /// - 缺省为 [DateTime.now]；超出 [start]、[end] 时钳制到范围内；
  /// - [mode] 或本参数变化时滚轮重置；仅 [start]/[end]/[steps]/[showWeek] 变化时保留选中；
  /// - **勿**将 [onChange] 结果写回本参数并 rebuild（滚轮会跳动）。
  ///
  /// **弹窗回显**
  ///
  /// ```dart
  /// initialValue: _selected?.toDateTime()
  /// ```
  ///
  /// [TDateTimePickerValue.toDateTime] 对 partial 值用 [TDateTimePickerValue.defaultFallback]
  /// 补齐缺字段；需自定义补齐规则时传 `toDateTime(fallback: ...)`。
  ///
  /// **首次打开**
  ///
  /// ```dart
  /// initialValue: DateTime(2026, 5, 15) // 或省略，默认 now
  /// ```
  final DateTime? initialValue;

  /// dateTimePicker: 是否在日列 label 附加星期（如 `19日 周六`），仅影响展示。
  ///
  /// [onChange] 结果无星期字段；需展示星期时用
  /// `result.toDateTime().weekday` 派生（partial 值默认补齐，见 [TDateTimePickerValue.defaultFallback]）。
  final bool showWeek;

  /// dateTimePicker: 滚轮中心项变化时的选中值回调。
  ///
  /// **触发时机**：用户滚动且中心选中项与上次不同时；挂载瞬间不触发。
  ///
  /// **返回值**：[TDateTimePickerValue] 仅含当前 [mode] 存在的列（partial）。
  /// 建议原样存入 state，用于 Cell 展示、弹窗回显（配合 [initialValue]）、提交时再 [TDateTimePickerValue.toDateTime]。
  ///
  /// ```dart
  /// // 弹窗滚动即 commit
  /// onChange: (v) => setState(() => _selected = v),
  ///
  /// // 确定/取消：只更新草稿，点确定再写入 _committed
  /// onChange: (v) => _draft = v,
  /// ```
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
      start: widget.start,
      end: widget.end,
      steps: widget.steps,
    );
  }

  /// dateTimePicker: 解析非受控初始选中
  DateTime? _resolveInitialDateTime() => widget.initialValue;

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
