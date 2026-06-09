import 'package:flutter/foundation.dart';

import 'picker_option.dart';

/// onChange 回传的各列选中快照
@immutable
class TPickerValue {
  TPickerValue({
    required this.selectedOptions,
    required this.indexes,
  });

  /// 每列选中的完整 [TPickerOption]
  final List<TPickerOption> selectedOptions;

  /// 每列选中项索引
  final List<int> indexes;

  /// 各列选中项的 value（提交表单用，懒计算）
  late final List<dynamic> values =
      List.unmodifiable(selectedOptions.map((o) => o.value));

  /// 各列选中项的 label（展示用，懒计算）
  late final List<String> labels =
      List.unmodifiable(selectedOptions.map((o) => o.label));

  @override
  String toString() =>
      'TPickerValue(labels: $labels, values: $values, indexes: $indexes)';
}
