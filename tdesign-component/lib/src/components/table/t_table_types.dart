import 'package:flutter/foundation.dart' show immutable;

/// 表格选择模式。
enum TTableSelectionMode {
  /// 不显示选择列。
  none,

  /// 支持多行选择。
  multiple,
}

/// 排序方向。
enum TTableSortDirection {
  /// 升序。
  ascending,

  /// 降序。
  descending,
}

/// 受控排序值。
@immutable
class TTableSort {
  const TTableSort({required this.columnId, required this.direction});

  /// 排序列标识。
  final String columnId;

  /// 排序方向。
  final TTableSortDirection direction;

  @override
  bool operator ==(Object other) =>
      other is TTableSort &&
      other.columnId == columnId &&
      other.direction == direction;

  @override
  int get hashCode => Object.hash(columnId, direction);
}
