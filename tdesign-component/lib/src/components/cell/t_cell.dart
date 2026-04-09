import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 't_cell_inherited.dart';

typedef TCellClick = void Function(TCell cell);

enum TCellAlign { top, middle, bottom }

/// 单元格组件
class TCell extends StatefulWidget {
  const TCell({
    Key? key,
    this.align = TCellAlign.middle,
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
    this.noteMaxWidth,
    this.noteMaxLine = 1,
    this.required = false,
    this.title,
    this.titleWidget,
    this.onClick,
    this.onLongPress,
    this.style,
    this.rightIcon,
    this.rightIconWidget,
    this.disabled = false,
    this.imageCircle = 50,
    this.showBottomBorder = false,
    this.height,
  }) : super(key: key);

  /// 内容的对齐方式，默认居中对齐。可选项：top/middle/bottom
  final TCellAlign? align;

  /// 是否显示右侧箭头
  final bool? arrow;

  /// 是否显示下边框，仅在TDCellGroup组件下起作用
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

  /// 主图圆角，默认50（圆形）
  final double? imageCircle;

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

  /// 说明文字组件 最大宽度，超过部分显示省略号，防止文字溢出
  final double? noteMaxWidth;

  /// 说明文字组件 最大行数
  final int noteMaxLine;

  /// 是否显示表单必填星号
  final bool? required;

  /// 最右侧图标
  final IconData? rightIcon;

  /// 最右侧图标组件
  final Widget? rightIconWidget;

  /// 标题
  final String? title;

  /// 标题组件
  final Widget? titleWidget;

  /// 点击事件
  final TCellClick? onClick;

  /// 长按事件
  final TCellClick? onLongPress;

  /// 自定义样式
  final TCellStyle? style;

  /// 禁用
  final bool? disabled;

  /// 是否显示下边框（建议TDCellGroup组件下false，避免与bordered重叠）
  final bool? showBottomBorder;

  /// 高度
  final double? height;

  @override
  _TCellState createState() => _TCellState();
}

class _TCellState extends State<TCell> {
  var _status = 'default';

  bool get disabled {
    return widget.disabled ?? false;
  }


  @override
  Widget build(BuildContext context) {
    final theme = TTheme.of(context);
    final style = widget.style ??
        TCellInherited.of(context)?.style ??
        TCellStyle.cellStyle(context);
    final crossAxisAlignment = _getAlign();
    final color = _status == 'default'
        ? style.backgroundColor
        : style.clickBackgroundColor;
    final border = (widget.showBottomBorder ?? false)
        ? Border(
      bottom: BorderSide(
        width: 0.5,
        color: style.borderedColor ?? theme.componentStrokeColor,
      ),
    )
        : null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.onClick != null && !disabled) {
          widget.onClick!(widget);
        }
        TSwipeCellInherited.of(context)?.cellClick();
      },
      onLongPress: widget.onLongPress != null && !disabled
          ? () => widget.onLongPress!(widget)
          : null,
      onTapDown: (_) => _setStatus('active', 0),
      onTapUp: (_) => _setStatus('default', 100),
      onTapCancel: () => _setStatus('default', 0),
      child: Container(
        height: widget.height,
        padding: style.padding,
        decoration: BoxDecoration(color: color, border: border),
        child: Row(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            ..._buildImage(),
            Expanded(
              child: Row(
                crossAxisAlignment: crossAxisAlignment,
                children: [
                  if (widget.leftIcon != null ||
                      widget.leftIconWidget != null) ...[
                    widget.leftIconWidget ??
                        Icon(widget.leftIcon,
                            size: 24, color: style.leftIconColor),
                    SizedBox(width: theme.spacer12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // spacing: theme.spacer4,
                      children: [
                        Row(
                          children: [
                            if (widget.titleWidget != null)
                              Flexible(child: widget.titleWidget!)
                            else if (widget.title?.isNotEmpty == true)
                              Flexible(
                                  child: TText(widget.title!,
                                      style: style.titleStyle)),
                            if (widget.required ?? false)
                              TText(' *', style: style.requiredStyle),
                          ],
                        ),
                        if ((widget.titleWidget != null || widget.title != null) &&
                            (widget.descriptionWidget != null || widget.description?.isNotEmpty == true))
                          SizedBox(height: TTheme.of(context).spacer4),
                        if (widget.descriptionWidget != null)
                          widget.descriptionWidget!
                        else if (widget.description?.isNotEmpty ?? false)
                          TText(widget.description!,
                              style: style.descriptionStyle),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: theme.spacer4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (widget.noteWidget != null)
                  widget.noteWidget!
                else if (widget.note?.isNotEmpty ?? false)
                  ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: widget.noteMaxWidth ??
                              MediaQuery.of(context).size.width - 84),
                      child: TText(
                        widget.note!,
                        style: style.noteStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: widget.noteMaxLine,
                      )),
                if (widget.rightIconWidget != null)
                  widget.rightIconWidget!
                else if (widget.rightIcon != null)
                  Icon(widget.rightIcon, size: 24, color: style.rightIconColor),
                if (widget.arrow ?? false)
                  Icon(TIcons.chevron_right,
                      size: 24, color: style.arrowColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  CrossAxisAlignment _getAlign() {
    switch (widget.align) {
      case TCellAlign.top:
        return CrossAxisAlignment.start;
      case TCellAlign.middle:
        return CrossAxisAlignment.center;
      case TCellAlign.bottom:
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.center;
    }
  }

  void _setStatus(String status, int milliseconds) {
    if (disabled || !(widget.hover ?? true)) {
      return;
    }
    if (milliseconds == 0) {
      setState(() {
        _status = status;
      });
      return;
    }
    Future.delayed(Duration(milliseconds: milliseconds), () {
      setState(() {
        _status = status;
      });
    });
  }

  List<Widget> _buildImage() {
    final imageSize = widget.imageSize ?? 48;
    final imageWidgets = <Widget>[];

    if (widget.imageWidget != null) {
      imageWidgets.add(widget.imageWidget!);
    } else if (widget.image != null) {
      imageWidgets.add(ClipRRect(
        borderRadius: BorderRadius.circular(widget.imageCircle ?? 50),
        child: Image(
          image: widget.image!,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.cover,
        ),
      ));
    }

    if (imageWidgets.isNotEmpty) {
      imageWidgets.add(SizedBox(width: TTheme.of(context).spacer12));
    }

    return imageWidgets;
  }
}
