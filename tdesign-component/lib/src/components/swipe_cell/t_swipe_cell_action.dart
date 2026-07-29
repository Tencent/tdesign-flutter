import 'package:flutter/material.dart';

import '../../theme/basic.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../text/t_text.dart';
import 't_swipe_cell_inherited.dart';
import 't_swipe_cell_panel.dart';

/// 滑动单元格操作按钮
class TSwipeCellAction extends StatelessWidget {
  const TSwipeCellAction({
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
  })  : assert(flex > 0, 'flex must be greater than 0'),
        assert(icon != null || label != null, 'icon or label must not be null'),
        super(key: key);

  /// 宽度占比，默认为 1，[TSwipeCellPanel.confirms]下无效（失踪占满整个[TSwipeCellPanel]宽度）
  final int flex;

  /// 背景颜色
  final Color? backgroundColor;

  /// 点击后自动关闭
  final bool autoClose;

  /// 点击回调
  final void Function(BuildContext context)? onPressed;

  /// 图标
  final IconData? icon;

  /// 图标颜色，默认label字体颜色
  final Color? iconColor;

  /// 图标大小
  final double iconSize;

  /// 图标和标题的间距
  final double spacing;

  /// 标题
  final String? label;

  /// 标题样式
  final TextStyle? labelStyle;

  /// 图标和标题的排列方向
  final Axis direction;

  /// 指定[TSwipeCellPanel.children]的索引，来打开该[TSwipeCellAction]
  /// [TSwipeCellPanel.confirms]参数下才配置该参数
  final List<int>? confirmIndex;

  /// 自定义构建
  final WidgetBuilder? builder;

  @override
  Widget build(BuildContext context) {
    final fontSize = context.tTheme.fontMarkMedium ??
        Font(size: 14, lineHeight: 22, fontWeight: FontWeight.w600);
    final children = <Widget>[
      if (icon != null)
        Icon(
          icon,
          size: iconSize,
          color: iconColor ?? labelStyle?.color ?? context.tTheme.textColorAnti,
        ),
      if (icon != null && label != null) SizedBox(width: spacing),
      if (label != null)
        Flexible(
          child: TText(
            label,
            font: fontSize,
            textColor: context.tTheme.textColorAnti,
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
              direction: direction,
              children: children,
            ),
          ),
    );
    return confirmIndex?.isNotEmpty == true
        ? child
        : Expanded(
            flex: flex,
            child: child,
          );
  }

  void _handleTap(BuildContext context) {
    final swipeInherited = TSwipeCellInherited.of(context)!;
    var openConfirm = swipeInherited.actionClick(this);
    if (openConfirm == true) {
      return;
    }
    onPressed?.call(context);
    if (autoClose) {
      swipeInherited.controller.close(duration: swipeInherited.duration);
    }
  }
}
