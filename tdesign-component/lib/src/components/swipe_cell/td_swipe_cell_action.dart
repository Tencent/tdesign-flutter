import 'package:flutter/material.dart';

import '../../theme/basic.dart';
import '../../theme/td_colors.dart';
import '../../theme/td_fonts.dart';
import '../../theme/td_theme.dart';
import '../text/td_text.dart';
import 'td_swipe_cell_inherited.dart';
import 'td_swipe_cell_panel.dart';

/// 滑动单元格操作按钮
class TDSwipeCellAction extends StatelessWidget {
  const TDSwipeCellAction({
    Key? key,
    this.flex = 1,
    this.backgroundColor,
    this.autoClose = true,
    this.onPressed,
    this.icon,
    this.iconColor,
    this.iconSize = 18,
    this.spacing = 2,
    this.label,
    this.labelStyle,
    this.direction = Axis.horizontal,
    this.confirmIndex,
    this.builder,
  })  : assert((flex ?? 1) > 0, 'flex must be greater than 0'),
        assert(icon != null || label != null, 'icon or label must not be null'),
        super(key: key);

  /// 宽度占比，默认为 1，[TDSwipeCellPanel.confirms]下无效（失踪占满整个[TDSwipeCellPanel]宽度）
  final int? flex;

  /// 背景颜色
  final Color? backgroundColor;

  /// 点击后自动关闭
  final bool? autoClose;

  /// 点击回调
  final void Function(BuildContext context)? onPressed;

  /// 图标
  final IconData? icon;

  /// 图标颜色，默认label字体颜色
  final Color? iconColor;

  /// 图标大小
  final double? iconSize;

  /// 图标和标题的间距
  final double? spacing;

  /// 标题
  final String? label;

  /// 标题样式
  final TextStyle? labelStyle;

  /// 图标和标题的排列方向
  final Axis? direction;

  /// 指定[TDSwipeCellPanel.children]的索引，来打开该[TDSwipeCellAction]
  /// [TDSwipeCellPanel.confirms]参数下才配置该参数
  final List<int>? confirmIndex;

  /// 自定义构建
  final WidgetBuilder? builder;

  @override
  Widget build(BuildContext context) {
    final fontSize = TDTheme.of(context).fontMarkMedium ?? Font(size: 14, lineHeight: 22, fontWeight: FontWeight.w600);
    final children = <Widget>[
      if (icon != null)
        Icon(
          icon,
          size: iconSize ?? 18,
          color: labelStyle?.color ?? TDTheme.of(context).fontWhColor1,
        ),
      if (icon != null && label != null) SizedBox(width: spacing ?? 2),
      if (label != null)
        Flexible(
          child: TDText(
            label,
            forceVerticalCenter: true,
            font: fontSize,
            textColor: TDTheme.of(context).fontWhColor1,
            style: labelStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
    ];
    final child = GestureDetector(
      onTap: () {
        _handleTap(context);
      },
      child: builder?.call(context) ??
          Container(
            width: double.infinity,
            height: double.infinity,
            color: backgroundColor,
            child: Flex(
              mainAxisAlignment: MainAxisAlignment.center,
              direction: direction ?? Axis.horizontal,
              children: children,
            ),
          ),
    );
    return confirmIndex?.isNotEmpty == true
        ? child
        : Expanded(
            flex: flex ?? 1,
            child: child,
          );
  }

  void _handleTap(BuildContext context) {
    final swipeInherited = TDSwipeCellInherited.of(context)!;
    var openConfirm = swipeInherited.actionClick(this);
    if (openConfirm == true) {
      return;
    }
    onPressed?.call(context);
    if (autoClose ?? true) {
      swipeInherited.controller.close(duration: swipeInherited.duration);
    }
  }
}
