import 'package:flutter/foundation.dart';

import 't_date_time_picker_internal.dart';

// =============================================================================
// 枚举：列类型 / 日期·时间粒度
// =============================================================================

/// `TDateTimePicker` 内部可显示的列类型。
///
/// 标识某一列在数据语义上属于年/月/日/时/分/秒；由 [DateTimePickerMode.columns]
/// 解析得到，驱动内部 picker 数据生成。
///
/// **注意**：星期不再是独立列，而是通过 `TDateTimePicker.showWeek` 附加在
/// 日列的 label 后（如 "19日 周六"）。需要单独查询星期请用
/// `TDateTimePickerValue.toDateTime().weekday`。
enum DateTimeColumn {
  /// 年。
  year,

  /// 月（1–12）。
  month,

  /// 日（1–31，依据该年该月的实际天数）。
  day,

  /// 时（0–23）。
  hour,

  /// 分（0–59）。
  minute,

  /// 秒（0–59）。
  second,
}

/// 日期粒度，作为 [DateTimePickerMode.combined] 的 `date` 参数取值。
///
/// 与 TDesign mobile-vue mode 数组的第一项 `'year' / 'month' / 'date'` 对齐。
enum DateMode {
  /// 仅年。
  year,

  /// 年 + 月。
  month,

  /// 年 + 月 + 日。
  date,
}

/// 时间粒度，作为 [DateTimePickerMode.combined] 的 `time` 参数取值。
///
/// 与 TDesign mobile-vue mode 数组的第二项 `'hour' / 'minute' / 'second'` 对齐。
enum TimeMode {
  /// 仅时。
  hour,

  /// 时 + 分。
  minute,

  /// 时 + 分 + 秒。
  second,
}

// =============================================================================
// 模式：sealed 类型
// =============================================================================

/// `TDateTimePicker` 的列结构描述。
///
/// 内部实现位于 `t_date_time_picker_internal.dart`，**业务方只通过本类的
/// 静态常量或工厂构造**——不需要也不应该自行实现子类。
///
/// ## 快捷常量（与 TDesign mobile-vue 完全等价）
///
/// 默认全部含年月日；想去掉日期粒度请用 [combined]：
///
/// ```dart
/// DateTimePickerMode.year     // 1 列：年
/// DateTimePickerMode.month    // 2 列：年 + 月
/// DateTimePickerMode.date     // 3 列：年 + 月 + 日
/// DateTimePickerMode.hour     // 4 列：年 + 月 + 日 + 时
/// DateTimePickerMode.minute   // 5 列：年 + 月 + 日 + 时 + 分
/// DateTimePickerMode.second   // 6 列：年 + 月 + 日 + 时 + 分 + 秒
/// ```
///
/// ## 精确控制（combined 工厂）
///
/// 当需要「只时间不要日期」「只年月不要日」等组合时：
///
/// ```dart
/// // 只时分（等价 mobile-vue [null, 'minute']）
/// DateTimePickerMode.combined(time: TimeMode.minute)
///
/// // 只时分秒
/// DateTimePickerMode.combined(time: TimeMode.second)
///
/// // 年 + 月（等价 .month / mobile-vue ['month']）
/// DateTimePickerMode.combined(date: DateMode.month)
///
/// // 年月日 + 时分秒（等价 .second）
/// DateTimePickerMode.combined(date: DateMode.date, time: TimeMode.second)
/// ```
///
/// [combined] 中 `date` 与 `time` 至少其一非空。
abstract class DateTimePickerMode {
  const DateTimePickerMode();

  /// 仅年。
  static const DateTimePickerMode year = ShortcutMode(date: DateMode.year);

  /// 年 + 月。
  static const DateTimePickerMode month = ShortcutMode(date: DateMode.month);

  /// 年 + 月 + 日。
  static const DateTimePickerMode date = ShortcutMode(date: DateMode.date);

  /// 年 + 月 + 日 + 时。
  static const DateTimePickerMode hour =
      ShortcutMode(date: DateMode.date, time: TimeMode.hour);

  /// 年 + 月 + 日 + 时 + 分。
  static const DateTimePickerMode minute =
      ShortcutMode(date: DateMode.date, time: TimeMode.minute);

  /// 年 + 月 + 日 + 时 + 分 + 秒。
  static const DateTimePickerMode second =
      ShortcutMode(date: DateMode.date, time: TimeMode.second);

  /// 自定义日期/时间粒度组合。
  ///
  /// - [date] / [time] 至少其一非空，否则触发 `assert`。
  /// - `date` 控制是否含「年 / 年月 / 年月日」；
  /// - `time` 控制是否含「时 / 时分 / 时分秒」；
  /// - 两者都给则按 date → time 顺序拼接。
  factory DateTimePickerMode.combined({DateMode? date, TimeMode? time}) {
    assert(
      date != null || time != null,
      'DateTimePickerMode.combined: date 与 time 不能同时为 null',
    );
    return CombinedMode(date: date, time: time);
  }

  /// 解析为按显示顺序的 [DateTimeColumn] 列表。
  ///
  /// 内部数据层使用的唯一输入。
  List<DateTimeColumn> get columns;
}

// =============================================================================
// 回调结果
// =============================================================================

/// `TDateTimePicker` 的回调结果。
///
/// 字段全部为 nullable——`null` 表示**当前 [DateTimePickerMode] 不包含该列**，
/// 而非「用户选择了 null」。星期信息不作为独立字段提供，请通过
/// `toDateTime().weekday` 获取。
///
/// ## 示例
///
/// ```dart
/// TDateTimePicker(
///   mode: DateTimePickerMode.date,
///   onConfirm: (v) {
///     print(v.year);              // 例如 2025
///     print(v.month);             // 例如 6
///     print(v.day);               // 例如 15
///     print(v.hour);              // null（date 模式不含时分秒）
///     print(v.toDateTime());      // DateTime(2025, 6, 15)
///     print(v.toDateTime().weekday); // 7 (= 周日)
///   },
/// )
/// ```
@immutable
class TDateTimePickerValue {
  /// 直接以字段构造（通常由 `TDateTimePicker` 内部产生，业务侧多用于测试）。
  const TDateTimePickerValue({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
  });

  /// 选中的年。模式不含 [DateTimeColumn.year] 时为 `null`。
  final int? year;

  /// 选中的月（1–12）。模式不含 [DateTimeColumn.month] 时为 `null`。
  final int? month;

  /// 选中的日（1–31）。模式不含 [DateTimeColumn.day] 时为 `null`。
  final int? day;

  /// 选中的时（0–23）。模式不含 [DateTimeColumn.hour] 时为 `null`。
  final int? hour;

  /// 选中的分（0–59）。模式不含 [DateTimeColumn.minute] 时为 `null`。
  final int? minute;

  /// 选中的秒（0–59）。模式不含 [DateTimeColumn.second] 时为 `null`。
  final int? second;

  /// 将选中结果重组为 [DateTime]。
  ///
  /// 缺失字段（即模式不包含的列）使用 [fallback] 的对应字段补齐，[fallback] 为
  /// `null` 时使用 [DateTime.now]。
  ///
  /// ## ⚠️ 字段溢出陷阱（必读）
  ///
  /// Dart 的 [DateTime] 构造器对越界字段会**静默溢出**：
  ///
  /// ```dart
  /// // v = TDateTimePickerValue(year: 2026, month: 2), day == null
  /// // 假设今日为 5 月 31 日：
  /// v.toDateTime();                         // → DateTime(2026, 3, 3) ⚠️
  /// v.toDateTime(fallback: DateTime(2000)); // → DateTime(2026, 2, 1) ✅
  /// ```
  ///
  /// 复用上次结果时请显式传入安全 [fallback]（如 `DateTime(2000, 1, 1)`），
  /// 让所有缺失字段稳定取最小合法值。
  DateTime toDateTime({DateTime? fallback}) {
    final fb = fallback ?? DateTime.now();
    return DateTime(
      year ?? fb.year,
      month ?? fb.month,
      day ?? fb.day,
      hour ?? fb.hour,
      minute ?? fb.minute,
      second ?? fb.second,
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
