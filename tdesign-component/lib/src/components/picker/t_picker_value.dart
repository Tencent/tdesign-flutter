import 'package:flutter/foundation.dart';

import 't_picker_option.dart';

/// onChange 回调返回的选中信息
///
/// ```dart
/// onChange: (v) => setState(() => _lastValue = v);
/// Text(_lastValue?.labels.join(' / ') ?? '');
/// ```
@immutable
class TPickerValue {
  TPickerValue({
    required this.selectedOptions,
    required this.indexes,
  });

  /// 每列选中的完整 option
  final List<TPickerOption> selectedOptions;

  /// 每列选中项的索引
  final List<int> indexes;

  /// 所有选中项的 value（提交表单用）
  ///
  /// 顺序与列顺序对应，可直接用于表单提交。
  /// 懒计算并缓存，生命周期内只计算一次。
  late final List<dynamic> values =
      List.unmodifiable(selectedOptions.map((o) => o.value));

  /// 所有选中项的 label（展示用）
  ///
  /// 顺序与列顺序对应，可直接用于 UI 展示。
  /// 懒计算并缓存，生命周期内只计算一次。
  late final List<String> labels =
      List.unmodifiable(selectedOptions.map((o) => o.label));

  @override
  String toString() =>
      'TPickerValue(labels: $labels, values: $values, indexes: $indexes)';
}
