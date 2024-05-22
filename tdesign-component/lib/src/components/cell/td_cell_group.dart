import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

enum TDCellGroupTheme { defaultTheme, cardTheme }

/// 单元格组组件
class TDCellGroup extends StatefulWidget {
  const TDCellGroup({
    Key? key,
    this.bordered = false,
    this.theme = TDCellGroupTheme.defaultTheme,
    this.title,
    required this.cells,
    this.style,
  }) : super(key: key);

  /// 是否显示组边框
  final bool? bordered;

  /// 单元格组风格。可选项：default/card
  final TDCellGroupTheme? theme;

  /// 单元格组标题
  final String? title;

  /// 单元格列表
  final List<TDCell> cells;

  /// 自定义样式
  final TDCellStyle? style;

  @override
  _TDCellGroupState createState() => _TDCellGroupState();
}

class _TDCellGroupState extends State<TDCellGroup> {
  @override
  Widget build(BuildContext context) {
    var style = widget.style ?? TDCellStyle.cellGroupStyle(context);
    var spacer16 = TDTheme.of(context).spacer16;
    var itemCount = widget.cells.length;
    return Column(
      children: [
        if (widget.title != null)
          Padding(
            padding: EdgeInsets.only(
              left: spacer16,
              right: spacer16,
              top: TDTheme.of(context).spacer24,
              bottom: TDTheme.of(context).spacer8,
            ),
            child: Text(widget.title!),
          ),
        Container(
          decoration: (widget.bordered ?? false)
              ? BoxDecoration(border: _getBordered(style), borderRadius: _getBorderRadius())
              : null,
          padding: widget.theme == TDCellGroupTheme.cardTheme ? EdgeInsets.only(left: spacer16, right: spacer16) : null,
          child: ListView.separated(
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return widget.cells[index];
            },
            separatorBuilder: (context, index) {
              var bordered = (widget.cells[index].bordered ?? true) && itemCount > index + 1;
              return TDDivider(
                color: style.borderedColor,
                height: bordered ? 0.5 : 0,
                margin: EdgeInsets.only(left: TDTheme.of(context).spacer16),
              );
            },
          ),
        ),
      ],
    );
  }

  BoxBorder _getBordered(TDCellStyle style) {
    var color = style.groupBorderedColor ?? TDTheme.of(context).grayColor3;
    if (widget.theme == TDCellGroupTheme.cardTheme) {
      return Border.all(
        color: color,
        width: 1,
      );
    }
    return Border(
      top: BorderSide(color: color, width: 1),
      bottom: BorderSide(color: color, width: 1),
    );
  }

  BorderRadius? _getBorderRadius() {
    if (widget.theme == TDCellGroupTheme.cardTheme) {
      return BorderRadius.all(Radius.circular(TDTheme.of(context).radiusDefault));
    }
    return null;
  }
}
