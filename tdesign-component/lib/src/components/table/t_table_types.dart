import 'package:flutter/foundation.dart' show immutable;

import 't_table_col.dart';

/// 返回行数据的稳定唯一标识。
typedef TTableRowKey<T> = Object Function(T row);

/// 单元格跨度构建器。
///
/// 仅为未被其他合并区域覆盖的逻辑单元格调用。该回调会在组件构建期间执行，
/// 应保持同步且无副作用。
typedef TTableCellSpanBuilder<T> =
    TTableCellSpan? Function(TTableCellContext<T> context);

/// 单元格点击回调。
typedef TTableCellTap<T> = void Function(TTableCellContext<T> context);

/// 表格逻辑单元格上下文。
@immutable
class TTableCellContext<T> {
  const TTableCellContext({
    required this.row,
    required this.rowIndex,
    required this.column,
    required this.columnIndex,
  });

  /// 当前行数据。
  final T row;

  /// 当前行在排序后可见数据中的索引。
  final int rowIndex;

  /// 当前列配置。
  final TTableColumn<T> column;

  /// 当前列在 `TTable.columns` 中的索引。
  final int columnIndex;
}

/// 单元格跨越的逻辑行列数。
@immutable
class TTableCellSpan {
  const TTableCellSpan({this.rowSpan = 1, this.columnSpan = 1})
    : assert(rowSpan > 0),
      assert(columnSpan > 0);

  /// 跨越的逻辑行数，默认为 `1`。
  final int rowSpan;

  /// 跨越的逻辑列数，默认为 `1`。
  final int columnSpan;
}

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
