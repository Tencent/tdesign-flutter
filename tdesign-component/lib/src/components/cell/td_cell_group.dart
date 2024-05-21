
import 'package:flutter/material.dart';

import 'td_cell.dart';

enum TDCellGroupTheme { defaultTheme, cardTheme }

/// 单元格组组件
class TDCellGroup extends StatefulWidget {
  const TDCellGroup({
    Key? key,
    this.bordered = false,
    this.theme = TDCellGroupTheme.defaultTheme,
    this.title,
    required this.cells,
  }) : super(key: key);

  /// 是否显示组边框
  final bool? bordered;
  /// 单元格组风格。可选项：default/card
  final TDCellGroupTheme? theme;
  /// 单元格组标题
  final String? title;
  /// 单元格列表
  final List<TDCell> cells;

  @override
  _TDCellGroupState createState() => _TDCellGroupState();
}

class _TDCellGroupState extends State<TDCellGroup> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.cells.length,
      itemBuilder: (context, index) {
        return widget.cells[index];
      },
    );
  }
}