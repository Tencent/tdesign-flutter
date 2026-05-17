import 'package:flutter/material.dart';

import '../picker/t_picker.dart';
import '../picker/t_picker_items.dart';
import '../picker/t_picker_value.dart';
import 't_date_time_picker_internal.dart';
import 't_date_time_picker_model.dart';

export 't_date_time_picker_model.dart';

/// 日期/时间选择器。
///
/// 基于 [TPicker] 的薄适配组件——仅持有一个 [DateTimePickerSnapshot] 单一
/// 真相源，所有 UI 渲染、滚轮交互、工具栏插槽完全委托给 [TPicker]。
///
/// 通过 [mode] 控制列结构（快捷模式或 [DateTimePickerMode.combined]），通过
/// [start] / [end] 限制各列可选范围，通过 [format] 自定义 label 显示。
///
/// ## 快速上手
///
/// ```dart
/// // 年月日
/// TDateTimePicker(
///   mode: DateTimePickerMode.date,
///   onConfirm: (v) {
///     final dt = v.toDateTime(); // → DateTime(2026, 5, 15)
///   },
/// )
///
/// // 只时分
/// TDateTimePicker(
///   mode: DateTimePickerMode.combined(time: TimeMode.minute),
///   onConfirm: (v) => print('${v.hour}:${v.minute}'),
/// )
///
/// // 年月日 + 显示星期
/// TDateTimePicker(
///   mode: DateTimePickerMode.date,
///   showWeek: true,                    // 日列 label 变为 "19日 周六"
///   onConfirm: (v) => print(v.toDateTime().weekday),
/// )
/// ```
///
/// ## 弹窗
///
/// 本组件**不内置弹窗**。需要从底部滑出时业务方自行包 `TSlidePopupRoute`：
///
/// ```dart
/// Navigator.of(context).push(TSlidePopupRoute(
///   slideTransitionFrom: SlideTransitionFrom.bottom,
///   builder: (ctx) => TDateTimePicker(
///     mode: DateTimePickerMode.date,
///     onCancel: () => Navigator.pop(ctx),
///     onConfirm: (v) {
///       setState(() => _date = v.toDateTime());
///       Navigator.pop(ctx);
///     },
///   ),
/// ));
/// ```
///
/// ## 与 TDesign mobile-vue API 对齐情况
///
/// 本组件在保持 Flutter 习惯的前提下尽量对齐 mobile-vue：
///
/// - `mode` 语义完全对齐（`year/month/date/hour/minute/second` + `combined`）；
/// - `start / end / showWeek / title / format / onCancel / onChange / onConfirm`
///   语义对齐；
/// - `defaultValue` 命名对齐 mobile-vue `defaultValue`（Flutter 习惯为
///   `initialValue`，此处优先对齐跨端语义）；
/// - `cancelText / confirmText` 命名对齐 mobile-vue `cancelBtn / confirmBtn`；
/// - 同时保留 `cancel / confirm` 高级 Widget 插槽（Flutter idiom）。
///
/// ## 可选范围 [start] / [end] 的语义
///
/// 用于限制各列**可选条目**，规则由 [DateTimePickerSnapshot.toPickerColumns] 实现。
/// 简言之：
///
/// - **年列**：`[start.year, end.year]`；缺省一侧时按默认偏移推算。
/// - **月/日/时/分/秒列**：仅在「当前年/日/时刻」与边界对齐时收紧，否则保持完整范围。
///
/// 组件内部会自动将选中值钳制到 `[start, end]` 闭区间内，因此任意确认结果都不会越界。
///
/// ## 非法范围
///
/// 当 `start.isAfter(end)` 时：debug 下触发 `assert`；release 下忽略 [end]，
/// 仅以 [start] 作为下界。
class TDateTimePicker extends StatefulWidget {
  /// 星期 label，下标 = `weekday - 1`，固定顺序「周一 … 周日」。
  ///
  /// 与 `showWeek` 显示的星期文案一致。业务方做自定义 label 或外部展示星期
  /// （如 cell 注脚）时可直接复用本常量，避免重复维护：
  ///
  /// ```dart
  /// final dt = value.toDateTime();
  /// final weekText = TDateTimePicker.weekLabels[dt.weekday - 1];
  /// ```
  static const List<String> weekLabels = DateTimePickerSnapshot.weekLabels;

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
    this.cancelText,
    this.confirm,
    this.confirmText,
    this.height,
    this.itemCount,
  });

  /// 列结构模式（必填）。详见 [DateTimePickerMode]。
  final DateTimePickerMode mode;

  /// 自定义列 label 文案。
  ///
  /// 仅影响显示（[TPickerOption.label]），不影响回调中的 value。返回 `null`
  /// 时使用默认格式（数字 + 中文单位，如 `"2026年"`、`"5月"`）。
  ///
  /// **性能提示**：每次 [format] 引用变化都会触发列重建；如在 `build` 内联
  /// 函数，请确保父级 rebuild 不频繁，或将 [format] 提到 `State` 字段以稳定引用。
  final String Function(DateTimeColumn column, int value)? format;

  /// 可选范围起始（闭区间下界）。
  ///
  /// `null` 时年列下界为「打开时锚定年份 − 10」（锚定于首次打开时的选中年，
  /// 不随滚动年份漂移）。
  final DateTime? start;

  /// 可选范围结束（闭区间上界）。
  ///
  /// `null` 时年列上界为「打开时锚定年份 + 10」（锚定于首次打开时的选中年，
  /// 不随滚动年份漂移）。
  final DateTime? end;

  /// 默认选中值（非受控属性，命名对齐 mobile-vue `defaultValue`）。
  ///
  /// 缺省时使用 [DateTime.now]。若超出 `[start, end]` 范围，会自动钳制到边界。
  /// 业务方想"受控"展示时，请使用 [Key] 强制重建 + 新 [defaultValue]。
  final DateTime? defaultValue;

  /// 是否在日列附加显示星期文字（如 `"19日 周六"`）。
  ///
  /// 仅影响**日列**的默认 label，对 value 无影响。`true` 时滚动日列会跟随
  /// 切换显示对应的星期。如需独立查询星期，请用 `toDateTime().weekday`。
  ///
  /// 与 TDesign mobile-vue `showWeek` 语义对齐。
  final bool showWeek;

  /// 点击「取消」按钮的回调。
  final VoidCallback? onCancel;

  /// 选中值变化回调（滚动稳定后实时触发）。
  ///
  /// 回调参数为 [TDateTimePickerValue]，仅当前 [mode] 涉及的列字段有值。
  /// 内部已对规范化值做去重，相同值不会重复触发。
  final void Function(TDateTimePickerValue result)? onChange;

  /// 点击「确定」按钮的回调。
  final void Function(TDateTimePickerValue result)? onConfirm;

  /// 工具栏中部标题文本。
  final String? title;

  /// 工具栏中部自定义标题组件（优先级高于 [title]）。
  final Widget? titleWidget;

  /// 工具栏左侧自定义插槽（Widget；优先级高于 [cancelText]）。
  final Widget? cancel;

  /// 工具栏左侧文字（命名对齐 mobile-vue `cancelBtn`）。
  ///
  /// 仅当 [cancel] 为 `null` 时生效。两者都为 `null` 时使用框架内置文案。
  final String? cancelText;

  /// 工具栏右侧自定义插槽（Widget；优先级高于 [confirmText]）。
  final Widget? confirm;

  /// 工具栏右侧文字（命名对齐 mobile-vue `confirmBtn`）。
  ///
  /// 仅当 [confirm] 为 `null` 时生效。两者都为 `null` 时使用框架内置文案。
  final String? confirmText;

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
      cancel: _resolveSlot(widget.cancel, widget.cancelText),
      confirm: _resolveSlot(widget.confirm, widget.confirmText),
      height: widget.height ?? 200,
      itemCount: widget.itemCount ?? 5,
      onCancel: widget.onCancel,
      onChange: _handleChange,
      onConfirm: _handleConfirm,
    );
  }

  /// 工具栏插槽优先级：自定义 [slot] > 文字 [text] > `null`（让上层用默认文案）。
  static Widget? _resolveSlot(Widget? slot, String? text) {
    if (slot != null) {
      return slot;
    }
    if (text != null) {
      return Text(text);
    }
    return null;
  }
}
