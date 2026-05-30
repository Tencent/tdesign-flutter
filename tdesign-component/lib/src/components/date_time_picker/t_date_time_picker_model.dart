import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 't_date_time_picker_enums.dart';
import 't_date_time_picker_internal.dart';

// =============================================================================
// 模式
// =============================================================================

/// 列结构模式。
///
/// 通过 [DateMode]、[TimeMode] 组合列，至少传其一。相同列配置在 `==` / `hashCode`
/// 上相等。
///
/// ```dart
/// DateTimePickerMode(dateMode: DateMode.date) // 年月日
/// DateTimePickerMode(timeMode: TimeMode.minute) // 时分
/// DateTimePickerMode(dateMode: DateMode.date, timeMode: TimeMode.minute)
/// ```
abstract class DateTimePickerMode {
  @internal
  const DateTimePickerMode.forImplementation();

  /// 组合列结构。
  ///
  /// [dateMode]、[timeMode] 至少传其一，列按 date → time 顺序拼接。
  factory DateTimePickerMode({DateMode? dateMode, TimeMode? timeMode}) {
    assert(
      dateMode != null || timeMode != null,
      'DateTimePickerMode: dateMode 与 timeMode 不能同时为 null',
    );
    return CombinedMode(date: dateMode, time: timeMode);
  }

  /// 按显示顺序展开的列列表。
  List<DateTimeColumn> get columns;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateTimePickerMode && listEquals(columns, other.columns);

  @override
  int get hashCode => Object.hashAll(columns);
}

// =============================================================================
// 回调结果
// =============================================================================

/// [TDateTimePicker.onChange] 回调结果。
///
/// 字段为 `null` 表示当前 [DateTimePickerMode] 不含该列（partial 值）。
///
/// **与 [TDateTimePicker.initialValue] 的分工**
/// - [onChange]：滚动过程中「当前选中了什么」，应原样存入 state；
/// - [initialValue]：打开/重建时「滚轮从哪开始」，仅读一次，勿写回。
///
/// **典型用法**
///
/// ```dart
/// TDateTimePickerValue? _selected;
///
/// // 1. 存值（弹窗滚动即生效）
/// onChange: (v) => setState(() => _selected = v),
///
/// // 2. 页面展示（读非 null 字段，不必 toDateTime）
/// Text('${_selected?.year}-${_selected?.month}'),
///
/// // 3. 弹窗再次打开时回显滚轮
/// initialValue: _selected?.toDateTime(),
///
/// // 4. 提交后端（六元组完整）
/// if (_selected!.isComplete) api.save(_selected!.toDateTime());
///
/// // 5. 提交 partial 且需 DateTime（自定义补齐语义）
/// api.save(_selected!.toDateTime(fallback: DateTime(1970, 1, 1)));
/// ```
@immutable
class TDateTimePickerValue {
  /// 创建选择结果。
  const TDateTimePickerValue({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
  });

  /// 选中的年；当前 mode 不含该列时为 `null`。
  final int? year;

  /// 选中的月（1–12）；当前 mode 不含该列时为 `null`。
  final int? month;

  /// 选中的日（1–31）；当前 mode 不含该列时为 `null`。
  final int? day;

  /// 选中的时（0–23）；当前 mode 不含该列时为 `null`。
  final int? hour;

  /// 选中的分（0–59）；当前 mode 不含该列时为 `null`。
  final int? minute;

  /// 选中的秒（0–59）；当前 mode 不含该列时为 `null`。
  final int? second;

  /// dateTimePickerValue: 年/月/日/时/分/秒均已选中时为 `true`。
  ///
  /// 为 `true` 时 [toDateTime] 可直接构造完整 [DateTime]，无需 [fallback]。
  bool get isComplete =>
      year != null &&
      month != null &&
      day != null &&
      hour != null &&
      minute != null &&
      second != null;

  /// dateTimePickerValue: [toDateTime] 未传 [fallback] 时使用的默认补齐值。
  ///
  /// 固定为 `2000-01-01 00:00:00`（1 月 1 日），避免用「今天」作日字段导致月份溢出。
  /// 仅用于弹窗回显、派生 weekday 等「不关心缺字段语义」的场景；
  /// 业务提交若 fallback 有特定含义，请显式传入 [toDateTime] 的 [fallback]。
  static final DateTime defaultFallback = DateTime(2000, 1, 1);

  /// dateTimePickerValue: 将 partial 选中结果重组为 [DateTime]。
  ///
  /// **补齐规则**
  /// - 非 null 字段取自本值；
  /// - null 字段取自 [fallback]；[fallback] 为 `null` 时用 [defaultFallback]；
  /// - [isComplete] 为 `true` 时忽略 [fallback]，直接构造六元组。
  ///
  /// **用法示例**
  ///
  /// ```dart
  /// // 弹窗回显（默认补齐，最常用）
  /// initialValue: _selected?.toDateTime()
  ///
  /// // 仅年月 mode：2026-05 → 2026-05-01 00:00:00
  /// const TDateTimePickerValue(year: 2026, month: 5).toDateTime()
  ///
  /// // 自定义补齐（如业务表示「当月 15 号 12 点」）
  /// v.toDateTime(fallback: DateTime(1970, 1, 15, 12, 0))
  ///
  /// // 六元组完整，直接转换
  /// v.toDateTime()
  /// ```
  DateTime toDateTime({DateTime? fallback}) {
    if (isComplete) {
      return DateTime(year!, month!, day!, hour!, minute!, second!);
    }
    final resolved = fallback ?? defaultFallback;
    return DateTime(
      year ?? resolved.year,
      month ?? resolved.month,
      day ?? resolved.day,
      hour ?? resolved.hour,
      minute ?? resolved.minute,
      second ?? resolved.second,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TDateTimePickerValue &&
          year == other.year &&
          month == other.month &&
          day == other.day &&
          hour == other.hour &&
          minute == other.minute &&
          second == other.second;

  @override
  int get hashCode => Object.hash(year, month, day, hour, minute, second);

  @override
  String toString() =>
      'TDateTimePickerValue(year: $year, month: $month, day: $day, '
      'hour: $hour, minute: $minute, second: $second)';
}
