import 'package:flutter/material.dart';

import '../picker/t_picker.dart';
import '../picker/t_picker_items.dart';
import '../picker/t_picker_value.dart';
import 't_date_time_picker_enums.dart';
import 't_date_time_picker_internal.dart';
import 't_date_time_picker_model.dart';

export 't_date_time_picker_enums.dart';
export 't_date_time_picker_model.dart';

/// 日期/时间选择器。
class TDateTimePicker extends StatefulWidget {
  const TDateTimePicker({
    super.key,
    required this.mode,
    this.format,
    this.start,
    this.end,
    this.defaultValue,
    this.showWeek = false,
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

  /// 星期 label，下标 = weekday - 1（周一 … 周日），与 [showWeek] 日列文案一致。
  static const List<String> weekLabels = DateTimePickerSnapshot.weekLabels;

  /// 列结构（必填）。详见 [DateTimePickerMode]。
  final DateTimePickerMode mode;

  /// 自定义列 label（仅影响展示，不影响回调 value）；返回 null 用默认格式；format 引用变化会触发列重建，宜提到 State 字段。
  final String Function(DateTimeColumn column, int value)? format;

  /// 可选范围下界（闭区间）；null 时年列下界为打开时锚定年份 - 10（不随滚动漂移）。
  final DateTime? start;

  /// 可选范围上界（闭区间）；null 时年列上界为打开时锚定年份 + 10（不随滚动漂移）。
  final DateTime? end;

  /// 首次构建时的默认选中值；缺省为 DateTime.now；超出 [start, end] 会钳制；滚动后改此值需配合 Key 重建。
  final DateTime? defaultValue;

  /// 日列 label 是否附加星期（如 19日 周六）；仅影响展示，星期值用 toDateTime().weekday。
  final bool showWeek;

  /// 点击「取消」按钮的回调。
  final VoidCallback? onCancel;

  /// 选中值变化回调（滚动稳定后实时触发）；参数为 [TDateTimePickerValue]，仅含当前 mode 对应列；相同值不重复触发。
  final void Function(TDateTimePickerValue result)? onChange;

  /// 点击「确定」按钮的回调。
  final void Function(TDateTimePickerValue result)? onConfirm;

  /// 工具栏中部标题文本。
  final String? title;

  /// 工具栏中部自定义标题组件（优先级高于 [title]）。
  final Widget? titleWidget;

  /// 工具栏左侧插槽（Widget）；null 时使用 [TPicker] 默认取消文案。
  final Widget? cancel;

  /// 工具栏右侧插槽（Widget）；null 时使用 [TPicker] 默认确认文案。
  final Widget? confirm;

  /// 面板视窗高度（不含工具栏），默认 200。
  final double? height;

  /// 每屏可见条目数量，默认 5。
  final int? itemCount;

  @override
  State<TDateTimePicker> createState() => _TDateTimePickerState();
}

class _TDateTimePickerState extends State<TDateTimePicker> {
  /// **唯一**状态字段。所有派生信息（initial value / picker columns / 回调
  /// 结果）都从这里出发，杜绝旧设计「四字段并行」的脱节风险。
  late DateTimePickerSnapshot _snapshot;

  /// 上次传给 [TPicker] 的 items（深比较），用于避免列数据未变时触发全量重建。
  TPickerColumns? _cachedPickerColumns;

  /// 仅在 [_cachedPickerColumns] 结构变化时同步给 [TPicker.initialValue]，
  /// 避免滚动年份时因 initialValue 变化导致年列滚轮被重置。
  List<dynamic>? _pickerInitialValue;

  @override
  void initState() {
    super.initState();
    _snapshot = DateTimePickerSnapshot.initial(
      columns: widget.mode.columns,
      initial: widget.defaultValue,
      start: widget.start,
      end: widget.end,
    );
  }

  @override
  void didUpdateWidget(covariant TDateTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    final modeChanged = !_listEqualInt(
        oldWidget.mode.columns, widget.mode.columns);
    final defaultChanged = oldWidget.defaultValue != widget.defaultValue;
    final rangeChanged =
        oldWidget.start != widget.start || oldWidget.end != widget.end;
    final showWeekChanged = oldWidget.showWeek != widget.showWeek;
    final formatChanged = oldWidget.format != widget.format;

    if (!modeChanged &&
        !defaultChanged &&
        !rangeChanged &&
        !showWeekChanged &&
        !formatChanged) {
      return;
    }

    if (formatChanged &&
        !modeChanged &&
        !defaultChanged &&
        !rangeChanged &&
        !showWeekChanged) {
      _invalidatePickerCache();
      return;
    }

    if (modeChanged || defaultChanged) {
      _snapshot = DateTimePickerSnapshot.initial(
        columns: widget.mode.columns,
        initial: defaultChanged ? widget.defaultValue : _snapshot.current,
        start: widget.start,
        end: widget.end,
      );
      _invalidatePickerCache();
    } else {
      // 仅 range / showWeek / format 变化：保留 current，重新钳制；列 label
      // 由 build 内 toPickerColumns 按新 showWeek / format 生成。
      _snapshot = _snapshot.rebuildFor(
        columns: widget.mode.columns,
        start: widget.start,
        end: widget.end,
      );
      _invalidatePickerCache();
    }
  }

  void _invalidatePickerCache() {
    _cachedPickerColumns = null;
    _pickerInitialValue = null;
  }

  void _handleChange(TPickerValue pickerValue) {
    final rawValues = DateTimePickerSnapshot.coerceRawValues(
      pickerValue.values,
      expectedLength: _snapshot.columns.length,
    );
    final next = _snapshot.applySelection(
      rawValues: rawValues,
      start: widget.start,
      end: widget.end,
    );
    final selectionChanged = next != _snapshot;
    final pickerOutOfSync = !_listEqualInt(rawValues, next.values);
    final needsRebuild =
        next.needsColumnRebuildFrom(_snapshot, showWeek: widget.showWeek) ||
            pickerOutOfSync;

    if (!selectionChanged && !needsRebuild) {
      return;
    }

    _snapshot = next;

    if (selectionChanged) {
      widget.onChange?.call(next.toResult());
    }

    // 仅当列结构需要重建（年/月变化、含 showWeek 时日变化、或 picker 报值
    // 偏离归一化结果需要回弹）时才 setState；否则只静默更新内部 snapshot。
    if (needsRebuild) {
      setState(() {});
    }
  }

  void _handleConfirm(TPickerValue pickerValue) {
    final rawValues = DateTimePickerSnapshot.coerceRawValues(
      pickerValue.values,
      expectedLength: _snapshot.columns.length,
    );
    final next = _snapshot.applySelection(
      rawValues: rawValues,
      start: widget.start,
      end: widget.end,
    );
    if (next != _snapshot) {
      _snapshot = next;
    }
    widget.onConfirm?.call(_snapshot.toResult());
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
    final nextColumns = _snapshot.toPickerColumns(
      start: widget.start,
      end: widget.end,
      format: widget.format,
      showWeek: widget.showWeek,
    );
    if (_cachedPickerColumns == null ||
        _cachedPickerColumns != nextColumns) {
      _cachedPickerColumns = nextColumns;
      _pickerInitialValue = List<dynamic>.from(_snapshot.values);
    }
    return TPicker(
      // 外部输入（mode/start/end/defaultValue/showWeek/format）变化时强制重建
      // TPicker。内部 setState 不会改变 key，故联动刷新走 didUpdateWidget 路径。
      key: ValueKey<int>(
        Object.hash(
          Object.hashAll(widget.mode.columns),
          widget.start,
          widget.end,
          widget.defaultValue,
          widget.showWeek,
          widget.format,
        ),
      ),
      items: _cachedPickerColumns!,
      initialValue: _pickerInitialValue,
      title: widget.title,
      titleWidget: widget.titleWidget,
      cancel: _resolveSlot(widget.cancel),
      confirm: _resolveSlot(widget.confirm),
      height: widget.height ?? 200,
      itemCount: widget.itemCount ?? 5,
      onCancel: widget.onCancel,
      onChange: _handleChange,
      onConfirm: _handleConfirm,
    );
  }

  /// 工具栏插槽：返回自定义 [slot]，否则交给上层使用默认文案。
  static Widget? _resolveSlot(Widget? slot) {
    if (slot != null) {
      return slot;
    }
    return null;
  }
}
