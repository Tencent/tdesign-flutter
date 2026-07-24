import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// 选择器子项构建器。
typedef TPickerItemBuilder = Widget? Function(
  BuildContext context,
  TPickerOption option,
  int columnIndex,
  int itemIndex,
  double distance,
);

/// 选择器选项。
@immutable
class TPickerOption {
  const TPickerOption({
    /// 展示文案。
    required this.label,

    /// 业务值。
    required this.value,

    /// 是否禁用。
    this.disabled = false,

    /// 联动模式下的子选项。
    this.children = const [],
  });

  /// 展示文案。
  final String label;

  /// 业务值。
  final Object? value;

  /// 是否禁用。
  final bool disabled;

  /// 联动模式下的子选项。
  final List<TPickerOption> children;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TPickerOption &&
          label == other.label &&
          value == other.value &&
          disabled == other.disabled &&
          listEquals(children, other.children);

  @override
  int get hashCode =>
      Object.hash(label, value, disabled, Object.hashAll(children));

  @override
  String toString() => 'TPickerOption($label, $value)';
}

/// 选择器数据源。
@immutable
sealed class TPickerItems {
  const TPickerItems();
}

/// 互不联动的多列数据源。
@immutable
class TPickerColumns extends TPickerItems {
  const TPickerColumns(
    /// 各列选项。
    this.columns,
  );

  /// 各列选项。
  final List<List<TPickerOption>> columns;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! TPickerColumns || columns.length != other.columns.length) {
      return false;
    }
    for (var index = 0; index < columns.length; index++) {
      if (!listEquals(columns[index], other.columns[index])) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(columns.map(Object.hashAll));
}

/// 由 [TPickerOption.children] 描述层级关系的联动数据源。
@immutable
class TPickerLinked extends TPickerItems {
  const TPickerLinked(
    /// 根选项。
    this.options,
  );

  /// 根选项。
  final List<TPickerOption> options;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TPickerLinked && listEquals(options, other.options);

  @override
  int get hashCode => Object.hashAll(options);
}

/// 各列当前选中项的只读快照。
@immutable
class TPickerValue {
  const TPickerValue({
    /// 各列选中的完整选项。
    required this.selectedOptions,

    /// 各列选中索引。
    required this.indexes,
  });

  /// 各列选中的完整选项。
  final List<TPickerOption> selectedOptions;

  /// 各列选中索引。
  final List<int> indexes;

  /// 各列业务值。
  List<Object?> get values =>
      List.unmodifiable(selectedOptions.map((option) => option.value));

  /// 各列展示文案。
  List<String> get labels =>
      List.unmodifiable(selectedOptions.map((option) => option.label));

  @override
  String toString() =>
      'TPickerValue(labels: $labels, values: $values, indexes: $indexes)';
}
