part of 't_date_time_picker_internal.dart';

/// 自定义滚轮列展示文案；返回 null 时使用默认文案。
typedef DateTimePickerRenderLabel = String? Function(
  /// 当前列，见 `DateTimeColumn`。
  DateTimeColumn column,

  /// 列数值。
  int value,
);

/// `TDateTimePickerValue.toDateTime` 未传 fallback 时的缺省补齐值。
@internal
final kDateTimePickerDefaultFallback = DateTime(2000, 1, 1);

// =============================================================================
// DateTimePickerMode 的内部子类实现（@internal）
// =============================================================================
//
// 业务方通过 `DateTimePickerMode(dateMode: ..., timeMode: ...)` 访问；
// `CombinedMode` 不应直接构造。整个文件 **不被 umbrella 导出**。

/// `TDateTimePicker` 各列默认 label 的文案配置（@internal）。
///
/// build 时由 `fromResource` 从 `TResourceDelegate` 生成；缺省文案见
/// `TResourceManager.defaultDelegate`（`_DefaultResourceDelegate`）。
@internal
@immutable
class DateTimePickerLabels {
  const DateTimePickerLabels({
    required this.unitSuffix,
    required this.weekLabels,
  });

  /// 未注入 `TResourceManager.setResourceBuilder` 时的 label（派生自 `_DefaultResourceDelegate`）。
  static final DateTimePickerLabels defaults =
      DateTimePickerLabels.fromResource(TResourceManager.defaultDelegate);

  final Map<DateTimeColumn, String> unitSuffix;
  final List<String> weekLabels;

  factory DateTimePickerLabels.fromResource(TResourceDelegate resource) {
    return DateTimePickerLabels(
      unitSuffix: {
        DateTimeColumn.year: resource.yearLabel,
        DateTimeColumn.month: resource.monthLabel,
        DateTimeColumn.day: resource.dateLabel,
        DateTimeColumn.hour: resource.hours,
        DateTimeColumn.minute: resource.minutes,
        DateTimeColumn.second: resource.seconds,
      },
      weekLabels: _weekLabelsFromResource(resource),
    );
  }

  String formatColumn(DateTimeColumn column, int value) =>
      '$value${unitSuffix[column]}';

  String weekdayLabel(int weekday) => weekLabels[weekday - 1];

  static List<String> _weekLabelsFromResource(TResourceDelegate resource) {
    String label(String shortName) {
      if (shortName.length == 1 && resource.weeksLabel.isNotEmpty) {
        return '${resource.weeksLabel}$shortName';
      }
      return shortName;
    }

    return [
      label(resource.monday),
      label(resource.tuesday),
      label(resource.wednesday),
      label(resource.thursday),
      label(resource.friday),
      label(resource.saturday),
      label(resource.sunday),
    ];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateTimePickerLabels &&
          mapEquals(unitSuffix, other.unitSuffix) &&
          listEquals(weekLabels, other.weekLabels);

  @override
  int get hashCode => Object.hash(
      Object.hashAll(unitSuffix.entries), Object.hashAll(weekLabels));
}

/// `DateTimePickerMode(...)` 工厂返回值。
@internal
@immutable
class CombinedMode implements DateTimePickerMode {
  const CombinedMode({this.date, this.time});

  final DateMode? date;
  final TimeMode? time;

  List<DateTimeColumn> get columns => _expand(date, time);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CombinedMode && date == other.date && time == other.time;

  @override
  int get hashCode => Object.hash(date, time);
}

/// 包内读取 `DateTimePickerMode` 展开后的列列表。
@internal
extension DateTimePickerModeColumns on DateTimePickerMode {
  List<DateTimeColumn> get columns => (this as CombinedMode).columns;
}

/// 把日期粒度 + 时间粒度展开成 `DateTimeColumn` 序列。
List<DateTimeColumn> _expand(DateMode? date, TimeMode? time) {
  final cols = <DateTimeColumn>[];
  switch (date) {
    case DateMode.year:
      cols.add(DateTimeColumn.year);
    case DateMode.month:
      cols
        ..add(DateTimeColumn.year)
        ..add(DateTimeColumn.month);
    case DateMode.date:
      cols
        ..add(DateTimeColumn.year)
        ..add(DateTimeColumn.month)
        ..add(DateTimeColumn.day);
    case null:
      break;
  }
  switch (time) {
    case TimeMode.hour:
      cols.add(DateTimeColumn.hour);
    case TimeMode.minute:
      cols
        ..add(DateTimeColumn.hour)
        ..add(DateTimeColumn.minute);
    case TimeMode.second:
      cols
        ..add(DateTimeColumn.hour)
        ..add(DateTimeColumn.minute)
        ..add(DateTimeColumn.second);
    case null:
      break;
  }
  assert(
    cols.isNotEmpty,
    'DateTimePickerMode: dateMode 与 timeMode 不能同时为 null',
  );
  return List<DateTimeColumn>.unmodifiable(cols);
}
