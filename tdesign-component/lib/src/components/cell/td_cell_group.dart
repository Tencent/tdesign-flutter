import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 'td_cell_inherited.dart';

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
    this.titleWidget,
  }) : super(key: key);

  /// 是否显示组边框
  final bool? bordered;

  /// 单元格组风格。可选项：default/card
  final TDCellGroupTheme? theme;

  /// 单元格组标题
  final String? title;

  /// 单元格组标题组件
  final Widget? titleWidget;

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
    var style = widget.style ?? TDCellStyle.cellStyle(context);
    var spacer16 = TDTheme.of(context).spacer16;
    var itemCount = widget.cells.length;
    var radius = _getBorderRadius();
    return TDCellInherited(
      style: style,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null || widget.titleWidget != null)
            Container(
              width: double.infinity,
              color: style.backgroundColor,
              padding: EdgeInsets.only(
                left: spacer16,
                right: spacer16,
                top: TDTheme.of(context).spacer24,
                bottom: TDTheme.of(context).spacer8,
              ),
              child: widget.titleWidget ?? TDText(widget.title!, style: style.groupTitleStyle),
            ),
          Padding(
            padding: widget.theme == TDCellGroupTheme.cardTheme
                ? EdgeInsets.only(left: spacer16, right: spacer16)
                : EdgeInsets.zero,
            child: Container(
              decoration: BoxDecoration(border: _getBordered(style), borderRadius: radius),
              child: ClipRRect(
                borderRadius: radius,
                child: ListView.separated(
                  shrinkWrap: true, // 设置为true以避免无限制地增长
                  physics: const NeverScrollableScrollPhysics(), // 禁用ListView的滚动
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    return widget.cells[index];
                  },
                  separatorBuilder: (context, index) {
                    var bordered = (widget.cells[index].bordered ?? true) && itemCount > index + 1;
                    if (!bordered) {
                      return const SizedBox.shrink();
                    }
                    return Row(
                      children: [
                        Container(height: 0.5, width: TDTheme.of(context).spacer16, color: style.backgroundColor),
                        Expanded(
                          child: Container(height: 0.5, color: style.borderedColor ?? TDTheme.of(context).grayColor3),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxBorder? _getBordered(TDCellStyle style) {
    if (!(widget.bordered ?? false)) {
      return null;
    }
    var color = style.groupBorderedColor ?? TDTheme.of(context).grayColor3;
    return Border.all(
      color: color,
      width: 1,
    );
  }

  BorderRadius _getBorderRadius() {
    if (widget.theme == TDCellGroupTheme.cardTheme) {
      return BorderRadius.all(Radius.circular(TDTheme.of(context).radiusLarge));
    }
    return BorderRadius.zero;
  }
}
