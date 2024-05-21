import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 'td_cell_style.dart';

typedef TDCellClick = void Function(TDCell cell);

enum TDCellAlign { top, middle, bottom }

/// 单元格组件
class TDCell extends StatefulWidget {
  const TDCell({
    Key? key,
    this.align = TDCellAlign.middle,
    this.arrow = false,
    this.bordered = true,
    this.description,
    this.descriptionWidget,
    this.hover = true,
    this.image,
    this.imageSize,
    this.imageWidget,
    this.leftIcon,
    this.leftIconWidget,
    this.note,
    this.noteWidget,
    this.required = false,
    // this.rightIcon,
    this.title,
    this.titleWidget,
    this.onClick,
    this.style,
  }) : super(key: key);

  /// 内容的对齐方式，默认居中对齐。可选项：top/middle/bottom
  final TDCellAlign? align;

  /// 是否显示右侧箭头
  final bool? arrow;

  /// 是否显示下边框
  final bool? bordered;

  /// 下方内容描述文字
  final String? description;

  /// 下方内容描述组件
  final Widget? descriptionWidget;

  /// 是否开启点击反馈
  final bool? hover;

  /// 主图
  final ImageProvider? image;

  /// 主图尺寸
  final double? imageSize;

  /// 主图组件
  final Widget? imageWidget;

  /// 左侧图标，出现在单元格标题的左侧
  final IconData? leftIcon;

  /// 左侧图标组件
  final Widget? leftIconWidget;

  /// 和标题同行的说明文字
  final String? note;

  /// 说明文字组件
  final Widget? noteWidget;

  /// 是否显示表单必填星号
  final bool? required;

  /// 最右侧图标
  // final Widget? rightIcon;

  /// 标题
  final String? title;

  /// 标题组件
  final Widget? titleWidget;

  /// 点击事件
  final TDCellClick? onClick;

  /// 自定义样式
  final TDCellStyle? style;

  @override
  _TDCellState createState() => _TDCellState();
}

class _TDCellState extends State<TDCell> {
  @override
  Widget build(BuildContext context) {
    var style = widget.style ?? TDCellStyle.generateStyle(context);
    var imageSize = widget.imageSize ?? 48;
    var crossAxisAlignment = _getAlign();
    return InkWell(
      highlightColor: (widget.hover ?? true) ? null : Colors.transparent,
      onTap: () {
        if (widget.onClick != null) {
          widget.onClick!(widget);
        }
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: EdgeInsets.all(TDTheme.of(context).spacer16),
            child: Row(
              crossAxisAlignment: crossAxisAlignment,
              children: [
                if (widget.image != null || widget.imageWidget != null) ...[
                  widget.imageWidget ?? Image(image: widget.image!, width: imageSize, height: imageSize),
                  SizedBox(width: TDTheme.of(context).spacer12),
                ],
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.leftIcon != null || widget.leftIconWidget != null) ...[
                        widget.leftIconWidget ?? Icon(widget.leftIcon, size: 24, color: style.leftIconColor),
                        SizedBox(width: TDTheme.of(context).spacer12),
                      ],
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (widget.titleWidget != null)
                                widget.titleWidget!
                              else if (widget.title != null)
                                Text(widget.title!, style: style.titleStyle),
                              if (widget.required ?? false) Text('*', style: style.requiredStyle),
                            ],
                          ),
                          SizedBox(height: TDTheme.of(context).spacer4),
                          if (widget.descriptionWidget != null)
                            widget.descriptionWidget!
                          else if (widget.description != null)
                            Text(widget.description!, style: style.descriptionStyle),
                        ],
                      ),
                    ],
                  ),
                ),
                if (widget.noteWidget != null)
                  widget.noteWidget!
                else if (widget.note != null)
                  Text(widget.note!, style: style.noteStyle),
                if ((widget.noteWidget != null || widget.note != null) && (widget.arrow ?? false))
                  SizedBox(width: TDTheme.of(context).spacer4),
                if (widget.arrow ?? false) Icon(TDIcons.chevron_right, size: 24, color: style.arrowColor),
              ],
            ),
          ),
          if (widget.bordered ?? true)
            TDDivider(
              margin: EdgeInsets.only(left: TDTheme.of(context).spacer16),
            ),
        ],
      ),
    );
  }

  CrossAxisAlignment _getAlign() {
    switch (widget.align) {
      case TDCellAlign.top:
        return CrossAxisAlignment.start;
      case TDCellAlign.middle:
        return CrossAxisAlignment.center;
      case TDCellAlign.bottom:
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.center;
    }
  }
}
