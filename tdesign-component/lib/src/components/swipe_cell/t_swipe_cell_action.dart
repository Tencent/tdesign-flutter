import 'package:flutter/material.dart';

import '../../theme/basic.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../text/t_text.dart';
import 't_swipe_cell_inherited.dart';
import 't_swipe_cell_panel.dart';
import 't_swipe_cell_theme_data.dart';

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
    this.iconSize,
    this.spacing,
    this.label,
    this.labelStyle,
    this.direction = Axis.horizontal,
    this.confirmIndex,
    this.builder,
    this.id,
  })  : assert(flex > 0, 'flex must be greater than 0'),
        assert(icon != null || label != null, 'icon or label must not be null'),
        super(key: key);

  /// 宽度占比，默认为 1，[TSwipeCellPanel.confirms]下无效（失踪占满整个[TSwipeCellPanel]宽度）
  final int flex;

  /// 背景颜色；为 null 时回退到组件级主题
  /// [TSwipeCellThemeData.actionBackgroundColor]。
  final Color? backgroundColor;

  /// 点击后自动关闭
  final bool autoClose;

  /// 点击回调
  final void Function(BuildContext context)? onPressed;

  /// 图标
  final IconData? icon;

  /// 图标颜色；为 null 时依次回退到组件级主题
  /// [TSwipeCellThemeData.actionIconColor]、label 字体颜色、P4 Token。
  final Color? iconColor;

  /// 图标大小，默认 18；为 null 时回退到组件级主题 [TSwipeCellThemeData.actionIconSize]，
  /// 再回退到内置默认值。
  final double? iconSize;

  /// 图标和标题的间距，默认 2；为 null 时回退到组件级主题 [TSwipeCellThemeData.actionSpacing]，
  /// 再回退到内置默认值。
  final double? spacing;

  /// 标题
  final String? label;

  /// 标题样式；为 null 时回退到组件级主题 [TSwipeCellThemeData.actionTextStyle]。
  final TextStyle? labelStyle;

  /// 图标和标题的排列方向
  final Axis direction;

  /// 指定[TSwipeCellPanel.children]的索引，来打开该[TSwipeCellAction]
  /// [TSwipeCellPanel.confirms]参数下才配置该参数
  final List<int>? confirmIndex;

  /// 自定义构建
  final WidgetBuilder? builder;

  /// 稳定标识，用于二次确认匹配。
  ///
  /// 二次确认通过 [TSwipeCellPanel.confirms] 的 [confirmIndex] 与 [TSwipeCellPanel.children]
  /// 的索引关联。默认依赖点击的 action 与 children 为同一实例（`==` 匹配）；
  /// 若通过 `copyWith` 等重建了等价实例，请为两者设置相同的 [id]，
  /// 以按标识而非实例引用匹配。
  final String? id;

  /// 获取生效的组件级主题
  TSwipeCellThemeData _effectiveTheme(BuildContext context) {
    return Theme.of(context).extension<TSwipeCellThemeData>() ??
        const TSwipeCellThemeData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _effectiveTheme(context);
    // P0 实例参数 > P1 组件主题 > P4 Token 兜底
    final effectiveBackgroundColor =
        backgroundColor ?? theme.actionBackgroundColor;
    final effectiveIconSize = iconSize ?? theme.actionIconSize ?? 18;
    final effectiveSpacing = spacing ?? theme.actionSpacing ?? 2;
    final effectiveIconColor = iconColor ??
        theme.actionIconColor ??
        labelStyle?.color ??
        context.tTheme.textColorAnti;
    final effectiveTextStyle = labelStyle ?? theme.actionTextStyle;
    // 文字样式：优先 P0/P1 的 TextStyle，否则回退 P4 fontMarkMedium
    final fallbackFont = context.tTheme.fontMarkMedium ??
        Font(size: 14, lineHeight: 22, fontWeight: FontWeight.w600);

    final children = <Widget>[
      if (icon != null)
        Flexible(
          fit: FlexFit.loose,
          child: Icon(
            icon,
            size: effectiveIconSize,
            color: effectiveIconColor,
          ),
        ),
      if (icon != null && label != null) SizedBox(width: effectiveSpacing),
      if (label != null)
        Flexible(
          fit: FlexFit.loose,
          child: TText(
            label,
            font: fallbackFont,
            textColor: context.tTheme.textColorAnti,
            style: effectiveTextStyle,
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
            color: effectiveBackgroundColor,
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
