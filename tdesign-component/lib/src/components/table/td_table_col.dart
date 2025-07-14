import 'package:flutter/cupertino.dart';

enum TDTableColFixed { left, right, none }

enum TDTableColAlign { left, center, right }

typedef SelectableFunc = bool Function(int index, dynamic row);
typedef RowCheckFunc = bool Function(int index, dynamic row);

/// 表格列配置
class TDTableCol {
  TDTableCol({
    this.title,
    this.colKey,
    this.width,
    this.fixed = TDTableColFixed.none,
    this.ellipsis,
    this.ellipsisTitle,
    this.cellBuilder,
    this.align = TDTableColAlign.left,
    this.sortable = false,
    this.selection,
    this.selectable,
    this.checked,
  });

  /// 行是否显示复选框，自定义列时无效
  bool? selection;

  /// 表头标题
  String? title;

  /// 列取值字段
  String? colKey;

  /// 列宽
  double? width;

  /// 固定列
  TDTableColFixed? fixed;

  /// 列内容超出时是否省略
  bool? ellipsis;

  /// 列标题超出时显示省略内容
  bool? ellipsisTitle;

  /// 自定义列
  IndexedWidgetBuilder? cellBuilder;

  /// 列内容横向对齐方式
  TDTableColAlign? align;

  /// 是否可排序
  bool? sortable;

  /// 当前行CheckBox是否可选，仅selection：true有效
  SelectableFunc? selectable;

  /// 当前行是否选中
  RowCheckFunc? checked;

  double? get widthPx => width;
}