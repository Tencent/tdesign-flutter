import 'package:flutter/material.dart';

import '../../theme/basic.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../text/t_text.dart';
import '../text/t_text_styled.dart';
import 't_swipe_cell_inherited.dart';
import 't_swipe_cell_theme_data.dart';

/// 滑动单元格操作项。
///
/// 同一面板中的操作项可使用不同的颜色和文字样式。
/// 未指定的图文视觉字段从标准 Flutter 主题或全局 Token 取得默认值；
/// [TSwipeCellThemeData] 只提供共用内边距。
/// [builder] 自行绘制操作项，不能同时传入内置背景、图文或图文样式字段。
class TSwipeCellAction extends StatelessWidget {
  const TSwipeCellAction({
    Key? key,
    this.backgroundColor,
    this.onPressed,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.iconLabelSpacing,
    this.label,
    this.labelStyle,
    this.builder,
  }) : assert(
         builder != null || icon != null || label != null,
         'builder, icon or label must not be null',
       ),
       assert(
         builder == null ||
             (backgroundColor == null &&
                 icon == null &&
                 iconColor == null &&
                 iconSize == null &&
                 iconLabelSpacing == null &&
                 label == null &&
                 labelStyle == null),
         'builder cannot be combined with built-in action visuals',
       ),
       super(key: key);

  /// 当前操作项背景颜色。
  final Color? backgroundColor;

  /// 点击回调。回调后组件会自动关闭操作面板。
  final void Function(BuildContext context)? onPressed;

  /// 图标。
  final IconData? icon;

  /// 图标颜色。
  final Color? iconColor;

  /// 图标大小，默认 20。
  final double? iconSize;

  /// 图标和标签之间的水平间距，默认 8。
  final double? iconLabelSpacing;

  /// 操作文字。
  final String? label;

  /// 操作文字样式。
  final TextStyle? labelStyle;

  /// 自定义操作项。不可同时传入内置背景、图文或图文样式字段；
  /// 其实际布局宽度会直接用于面板宽度，无需额外指定尺寸。
  final WidgetBuilder? builder;

  TSwipeCellThemeData _effectiveTheme(BuildContext context) {
    return Theme.of(context).extension<TSwipeCellThemeData>() ??
        const TSwipeCellThemeData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _effectiveTheme(context);
    final effectiveBackgroundColor = backgroundColor;
    final materialTheme = Theme.of(context);
    final explicitIconTheme = context.tExplicitIconTheme;
    final effectiveIconSize = iconSize ?? explicitIconTheme?.size ?? 20;
    final effectiveSpacing = iconLabelSpacing ?? 8;
    final effectivePadding =
        theme.actionPadding ?? const EdgeInsets.symmetric(horizontal: 16);
    final effectiveIconColor =
        iconColor ?? explicitIconTheme?.color ?? context.tTheme.textColorAnti;
    final fallbackFont =
        context.tTheme.fontMarkMedium ??
        Font(size: 14, lineHeight: 22, fontWeight: FontWeight.w600);
    final tokenTextStyle = TextStyle(
      color: context.tTheme.textColorAnti,
      fontSize: fallbackFont.size,
      height: fallbackFont.height,
      fontWeight: fallbackFont.fontWeight,
    );
    final effectiveTextStyle = tokenTextStyle
        .merge(materialTheme.tExplicitTextTheme?.labelMedium)
        .merge(context.tExplicitDefaultTextStyle)
        .copyWith(color: context.tTheme.textColorAnti)
        .merge(labelStyle);

    final content =
        builder?.call(context) ??
        Container(
          height: double.infinity,
          color: effectiveBackgroundColor,
          padding: effectivePadding,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Icon(icon, size: effectiveIconSize, color: effectiveIconColor),
              if (icon != null && label != null)
                SizedBox(width: effectiveSpacing),
              if (label != null)
                TTextStyled(label!, style: effectiveTextStyle, maxLines: 1),
            ],
          ),
        );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onPressed?.call(context);
        TSwipeCellInherited.of(context)?.close();
      },
      child: content,
    );
  }
}
