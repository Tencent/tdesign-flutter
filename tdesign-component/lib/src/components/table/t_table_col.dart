import 'package:flutter/material.dart';

/// 固定列位置。
enum TTableColumnFixed {
  /// 固定在左侧。
  left,

  /// 固定在右侧。
  right,

  /// 跟随中间区域水平滚动。
  none,
}

/// 列内容对齐方式。
enum TTableColumnAlign {
  /// 左对齐。
  left,

  /// 居中对齐。
  center,

  /// 右对齐。
  right,
}

/// 单元格构建器。
typedef TTableCellBuilder<T> = Widget Function(
  BuildContext context,
  T row,
  int rowIndex,
);

/// 强类型表格列配置。
class TTableColumn<T> {
  const TTableColumn({
    required this.id,
    required this.header,
    required this.cellBuilder,
    this.width = 120,
    this.fixed = TTableColumnFixed.none,
    this.align = TTableColumnAlign.left,
    this.comparator,
  }) : assert(width > 0);

  /// 列唯一标识，用于受控排序。
  final String id;

  /// 表头内容。
  final Widget header;

  /// 单元格构建器。
  final TTableCellBuilder<T> cellBuilder;

  /// 列宽。
  final double width;

  /// 固定位置。
  final TTableColumnFixed fixed;

  /// 内容对齐方式。
  final TTableColumnAlign align;

  /// 排序比较器；为空时该列不可排序。
  final Comparator<T>? comparator;
}
