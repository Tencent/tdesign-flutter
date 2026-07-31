import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/basic.dart' show Font;
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import 't_tag_theme_data.dart';
import 't_tag_types.dart';

/// 展示型标签组件，仅展示，内部不可更改自身状态
/// 支持样式：方形/圆角/半圆/带关闭图标
class TTag extends StatelessWidget {
  const TTag(
    this.text, {
    this.colorScheme,
    this.icon,
    this.size = TTagSize.medium,
    this.needCloseIcon = false,
    this.enabled = true,
    this.onTap,
    this.onCloseTap,
    Key? key,
  }) : super(key: key);

  /// 标签内容
  final String text;

  /// 语义色
  final TTagColorScheme? colorScheme;

  /// 图标内容，可随状态改变颜色
  final IconData? icon;

  /// 标签大小
  final TTagSize size;

  /// 是否显示关闭图标。
  final bool needCloseIcon;

  /// 是否使用禁用视觉状态。
  final bool enabled;

  /// 标签点击回调；为空时不创建标签点击行为。
  final GestureTapCallback? onTap;

  /// 关闭图标点击事件。
  ///
  /// 标签本身不持有列表状态；需要移除标签时，请在此回调中更新父组件的
  /// 数据源并触发重建。
  final GestureTapCallback? onCloseTap;

  /// 从 Theme 子树读取 L4 默认值
  TTagThemeData? _theme(BuildContext context) =>
      Theme.of(context).extension<TTagThemeData>();

  @override
  Widget build(BuildContext context) {
    final theme = _theme(context);
    final resolvedColorScheme =
        colorScheme ?? theme?.colorScheme ?? TTagColorScheme.defaultTheme;
    final isOutline = theme?.isOutline ?? false;
    final isLight = theme?.isLight ?? false;
    final shape = theme?.shape ?? TTagShape.square;
    final overflow = theme?.overflow;

    final fixedWidth = theme?.fixedWidth;
    final padding = theme?.padding;
    final textColor = theme?.textColor;
    final backgroundColor = theme?.backgroundColor;
    final font = theme?.font;
    final fontWeight = theme?.fontWeight;
    final maxLines = theme?.maxLines ?? 1;

    // 计算样式颜色
    final colors = _resolveColors(
      context,
      resolvedColorScheme,
      isLight,
      isOutline,
      !enabled,
    );
    final borderRadius = _resolveBorderRadius(context, shape);

    var child = _buildLabel(
      // 禁用态应始终使用禁用 token，避免普通 ThemeExtension 的颜色覆盖状态。
      textColor: enabled ? textColor ?? colors.textColor : colors.textColor,
      font: font ?? _getFont(context),
      fontWeight: fontWeight,
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines,
    );

    var innerIcon = _getIcon(colors.textColor);
    if (innerIcon != null || needCloseIcon) {
      var children = <Widget>[];
      if (innerIcon != null) {
        children.add(
          Container(
            margin: const EdgeInsets.only(right: 4),
            width: 14,
            height: 14,
            child: innerIcon,
          ),
        );
      }
      children.add(fixedWidth == null ? child : Flexible(child: child));
      if (needCloseIcon) {
        final closeIcon = Container(
          margin: const EdgeInsets.only(left: 4),
          child: Icon(
            TIcons.close,
            color: colors.closeIconColor ?? context.tTheme.textColorAnti,
            size: 14,
          ),
        );
        children.add(
          onCloseTap == null || !enabled
              ? closeIcon
              : GestureDetector(onTap: onCloseTap, child: closeIcon),
        );
      }
      child = Row(mainAxisSize: MainAxisSize.min, children: children);
    }

    final effectivePadding = padding ?? _getPadding(isOutline ? 1.0 : 0.0);
    final result = Container(
      width: fixedWidth,
      height: maxLines == 1 ? _getTagHeight(context, effectivePadding) : null,
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: enabled
            ? backgroundColor ?? colors.backgroundColor
            : colors.backgroundColor,
        border: Border.all(width: isOutline ? 1 : 0, color: colors.borderColor),
        borderRadius: borderRadius,
      ),
      child: Align(
        alignment: Alignment.center,
        widthFactor: fixedWidth == null ? 1 : null,
        child: child,
      ),
    );
    if (onTap == null || !enabled) {
      return result;
    }
    return GestureDetector(onTap: onTap, child: result);
  }

  /// 构建标签文本，参考按钮的文字居中方式：文本本身不额外设置行高，交给外层固定高度居中。
  Widget _buildLabel({
    required Color textColor,
    required Font? font,
    required FontWeight? fontWeight,
    required TextOverflow overflow,
    required int maxLines,
  }) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color: textColor,
        fontSize: font?.size,
        fontWeight: fontWeight ?? font?.fontWeight,
      ),
    );
  }

  /// 解析标签颜色。
  _TagColors _resolveColors(
    BuildContext context,
    TTagColorScheme colorScheme,
    bool isLight,
    bool isOutline,
    bool disable,
  ) {
    final token = context.tTheme;
    final material = Theme.of(context).tExplicitColorScheme;
    if (disable) {
      return _TagColors(
        textColor:
            material?.onSurface.withValues(alpha: 0.38) ??
            token.textDisabledColor,
        backgroundColor: isOutline && !isLight
            ? Colors.transparent
            : material?.onSurface.withValues(alpha: 0.12) ??
                  token.bgColorComponentDisabled,
        borderColor: material?.outline ?? token.componentBorderColor,
      );
    }

    Color textColor;
    Color backgroundColor;
    Color borderColor;

    switch (colorScheme) {
      case TTagColorScheme.primary:
        if (isOutline) {
          borderColor = material?.primary ?? token.brandNormalColor;
          textColor = material?.primary ?? token.brandNormalColor;
          backgroundColor = isLight
              ? material?.primaryContainer ?? token.brandLightColor
              : Colors.transparent;
        } else {
          textColor = isLight
              ? material?.primary ?? token.brandNormalColor
              : material?.onPrimary ?? token.textColorAnti;
          backgroundColor = isLight
              ? material?.primaryContainer ?? token.brandLightColor
              : material?.primary ?? token.brandNormalColor;
          borderColor = backgroundColor;
        }
        break;
      case TTagColorScheme.warning:
        if (isOutline) {
          borderColor = token.warningNormalColor;
          textColor = token.warningNormalColor;
          backgroundColor = isLight
              ? token.warningLightColor
              : Colors.transparent;
        } else {
          textColor = isLight
              ? token.warningNormalColor
              : token.textColorAnti;
          backgroundColor = isLight
              ? token.warningLightColor
              : token.warningNormalColor;
          borderColor = backgroundColor;
        }
        break;
      case TTagColorScheme.danger:
        if (isOutline) {
          borderColor = material?.error ?? token.errorNormalColor;
          textColor = material?.error ?? token.errorNormalColor;
          backgroundColor = isLight
              ? material?.errorContainer ?? token.errorLightColor
              : Colors.transparent;
        } else {
          textColor = isLight
              ? material?.error ?? token.errorNormalColor
              : material?.onError ?? token.textColorAnti;
          backgroundColor = isLight
              ? material?.errorContainer ?? token.errorLightColor
              : material?.error ?? token.errorNormalColor;
          borderColor = backgroundColor;
        }
        break;
      case TTagColorScheme.success:
        if (isOutline) {
          borderColor = token.successNormalColor;
          textColor = token.successNormalColor;
          backgroundColor = isLight
              ? token.successLightColor
              : Colors.transparent;
        } else {
          textColor = isLight ? token.successNormalColor : token.textColorAnti;
          backgroundColor = isLight
              ? token.successLightColor
              : token.successNormalColor;
          borderColor = backgroundColor;
        }
        break;
      case TTagColorScheme.defaultTheme:
        if (isOutline) {
          borderColor = material?.outline ?? token.componentBorderColor;
          textColor = material?.onSurface ?? token.textColorPrimary;
          backgroundColor = isLight
              ? material?.surfaceContainerHighest ??
                    token.bgColorSecondaryContainer
              : Colors.transparent;
        } else {
          textColor = material?.onSurface ?? token.textColorPrimary;
          backgroundColor = isLight
              ? material?.surfaceContainerHighest ??
                    token.bgColorSecondaryContainer
              : material?.surfaceContainerHighest ?? token.bgColorComponent;
          borderColor = backgroundColor;
        }
    }

    return _TagColors(
      textColor: textColor,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      closeIconColor: textColor,
    );
  }

  BorderRadiusGeometry _resolveBorderRadius(
    BuildContext context,
    TTagShape shape,
  ) {
    switch (shape) {
      case TTagShape.square:
        return BorderRadius.circular(context.tTheme.radiusSmall);
      case TTagShape.round:
        return BorderRadius.circular(context.tTheme.radiusRound);
      case TTagShape.mark:
        return BorderRadius.only(
          topRight: Radius.circular(context.tTheme.radiusRound),
          bottomRight: Radius.circular(context.tTheme.radiusRound),
        );
    }
  }

  Widget? _getIcon(Color textColor) {
    if (icon != null) {
      // 使用 Icon 组件渲染，保证可被 find.byIcon 命中且视觉一致
      return Icon(icon, color: textColor, size: _getIconSize());
    }
    return null;
  }

  Font? _getFont(BuildContext context) {
    switch (size) {
      case TTagSize.extraLarge:
        return context.tTheme.fontBodyMedium;
      case TTagSize.large:
        return context.tTheme.fontBodyMedium;
      case TTagSize.small:
        return context.tTheme.fontBodyExtraSmall;
      default:
        return context.tTheme.fontBodySmall;
    }
  }

  /// 计算标签高度，只约束纵向布局，不影响标签按内容自适应宽度
  double? _getTagHeight(BuildContext context, EdgeInsets padding) {
    if (size == TTagSize.custom) {
      return null;
    }
    final textFont = _getFont(context);
    if (textFont == null) {
      return null;
    }
    return textFont.size * textFont.height + padding.vertical;
  }

  /// 计算padding，需去除描边的宽对，对内描边
  EdgeInsets _getPadding(double border) {
    var hPadding = 0.0;
    var vPadding = 0.0;
    switch (size) {
      case TTagSize.extraLarge:
        hPadding = 16;
        vPadding = 9;
        break;
      case TTagSize.large:
        hPadding = 8;
        vPadding = 3;
        break;
      case TTagSize.medium:
        hPadding = 8;
        vPadding = 2;
        break;
      case TTagSize.small:
        hPadding = 6;
        vPadding = 2;
        break;
      default:
        return EdgeInsets.zero;
    }
    if (hPadding >= border) {
      hPadding = hPadding - border;
    } else {
      hPadding = 0;
    }
    if (vPadding >= border) {
      vPadding = vPadding - border;
    } else {
      vPadding = 0;
    }
    return EdgeInsets.only(
      left: hPadding,
      right: hPadding,
      top: vPadding,
      bottom: vPadding,
    );
  }

  double _getIconSize() {
    switch (size) {
      case TTagSize.extraLarge:
        return 16;
      case TTagSize.large:
        return 16;
      case TTagSize.medium:
        return 14;
      case TTagSize.small:
        return 12;
      default:
        return 14;
    }
  }
}

/// 标签颜色解析结果
class _TagColors {
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color? closeIconColor;

  _TagColors({
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    this.closeIconColor,
  });
}
