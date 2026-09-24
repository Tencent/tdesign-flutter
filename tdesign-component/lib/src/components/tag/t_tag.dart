import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/basic.dart' show Font;
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import '../text/t_text.dart';
import 't_tag_theme_data.dart';
import 't_tag_types.dart';

/// 展示型标签组件，仅展示，内部不可更改自身状态
/// 支持样式：方形/圆角/半圆/带关闭图标
class TTag extends StatelessWidget {
  const TTag(
    this.text, {
    this.colorScheme = TTagColorScheme.defaultTheme,
    this.variant = TTagVariant.dark,
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

  /// 标签预设配色。
  final TTagColorScheme colorScheme;

  /// 绘制形态。
  final TTagVariant variant;

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
    final isOutline =
        variant == TTagVariant.outline || variant == TTagVariant.lightOutline;
    final isLight =
        variant == TTagVariant.light || variant == TTagVariant.lightOutline;
    final shape = theme?.shape ?? TTagShape.square;
    final overflow = theme?.overflow;

    final fixedWidth = theme?.fixedWidth;
    final padding = theme?.padding;
    final textColor = theme?.textColor;
    final backgroundColor = theme?.backgroundColor;
    final font = theme?.font;
    final fontWeight = theme?.fontWeight;
    final maxLines = theme?.maxLines ?? 1;
    final effectiveFont = font ?? _getFont(context);
    final textLineHeight = _getTextLineHeight(context, effectiveFont);

    // 计算样式颜色
    final colors = _resolveColors(
      context,
      colorScheme,
      isLight,
      isOutline,
      !enabled,
    );
    final borderRadius = _resolveBorderRadius(context, shape);

    var child = _buildLabel(
      // 禁用态应始终使用禁用 token，避免普通 ThemeExtension 的颜色覆盖状态。
      textColor: enabled ? textColor ?? colors.textColor : colors.textColor,
      font: effectiveFont,
      fontWeight: fontWeight,
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines,
      lineHeight: maxLines == 1 ? textLineHeight : null,
    );

    final iconSize = _getIconSize();
    final iconSpacing = _getIconSpacing();
    var innerIcon = _getIcon(colors.textColor, iconSize);
    if (innerIcon != null || needCloseIcon) {
      var children = <Widget>[];
      if (innerIcon != null) {
        children.add(
          Container(
            margin: EdgeInsets.only(right: iconSpacing),
            width: iconSize,
            height: iconSize,
            child: innerIcon,
          ),
        );
      }
      children.add(fixedWidth == null ? child : Flexible(child: child));
      if (needCloseIcon) {
        final closeIcon = Container(
          margin: EdgeInsets.only(left: iconSpacing),
          child: Icon(
            TIcons.close,
            color: colors.closeIconColor,
            size: iconSize,
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

    const borderWidth = 1.0;
    final effectivePadding = padding ?? _getPadding();
    final result = Container(
      width: fixedWidth,
      height: maxLines == 1
          ? _getTagHeight(textLineHeight, effectivePadding, borderWidth)
          : null,
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: enabled
            ? backgroundColor ?? colors.backgroundColor
            : colors.backgroundColor,
        border: Border.all(
          width: borderWidth,
          color: isOutline ? colors.borderColor : Colors.transparent,
        ),
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

  /// 构建标签文本。单行标签使用固定行盒承接字体 fallback 与文字缩放，
  /// 字形仍由 Flutter 原生文本布局在行盒内居中。
  Widget _buildLabel({
    required Color textColor,
    required Font? font,
    required FontWeight? fontWeight,
    required TextOverflow overflow,
    required int maxLines,
    required double? lineHeight,
  }) {
    final label = TText(
      text,
      maxLines: maxLines,
      overflow: overflow,
      font: font,
      fontWeight: fontWeight,
      textColor: textColor,
      style: const TextStyle(leadingDistribution: TextLeadingDistribution.even),
    );
    if (lineHeight == null) {
      return label;
    }
    return SizedBox(
      height: lineHeight,
      child: Align(
        alignment: Alignment.center,
        widthFactor: 1,
        heightFactor: 1,
        child: label,
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
        textColor: material?.onSurface.withValues(alpha: 0.38) ??
            token.textDisabledColor,
        backgroundColor: isOutline && !isLight
            ? material?.surface ?? token.bgColorContainer
            : material?.onSurface.withValues(alpha: 0.12) ??
                token.bgColorComponentDisabled,
        borderColor: material?.outline ?? token.componentBorderColor,
        closeIconColor: material?.onSurface.withValues(alpha: 0.38) ??
            token.textDisabledColor,
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
              : material?.surface ?? token.bgColorContainer;
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
              : material?.surface ?? token.bgColorContainer;
        } else {
          textColor = isLight ? token.warningNormalColor : token.textColorAnti;
          backgroundColor =
              isLight ? token.warningLightColor : token.warningNormalColor;
          borderColor = backgroundColor;
        }
        break;
      case TTagColorScheme.danger:
        if (isOutline) {
          borderColor = material?.error ?? token.errorNormalColor;
          textColor = material?.error ?? token.errorNormalColor;
          backgroundColor = isLight
              ? material?.errorContainer ?? token.errorLightColor
              : material?.surface ?? token.bgColorContainer;
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
              : material?.surface ?? token.bgColorContainer;
        } else {
          textColor = isLight ? token.successNormalColor : token.textColorAnti;
          backgroundColor =
              isLight ? token.successLightColor : token.successNormalColor;
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
              : material?.surface ?? token.bgColorContainer;
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
      closeIconColor: token.textColorPlaceholder,
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

  Widget? _getIcon(Color textColor, double iconSize) {
    if (icon != null) {
      // 使用 Icon 组件渲染，保证可被 find.byIcon 命中且视觉一致
      return Icon(icon, color: textColor, size: iconSize);
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

  /// 计算标签高度，只约束纵向布局，不影响标签按内容自适应宽度。
  double? _getTagHeight(
    double? textLineHeight,
    EdgeInsets padding,
    double borderWidth,
  ) {
    if (size == TTagSize.custom) {
      return null;
    }
    if (textLineHeight == null) {
      return null;
    }
    return textLineHeight + padding.vertical + borderWidth * 2;
  }

  /// 计算内容区 padding；边框由所有变体等量占位，不参与 padding 补偿。
  EdgeInsets _getPadding() {
    var hPadding = 0.0;
    var vPadding = 0.0;
    switch (size) {
      case TTagSize.extraLarge:
        hPadding = 15;
        vPadding = 8;
        break;
      case TTagSize.large:
        hPadding = 7;
        vPadding = 2;
        break;
      case TTagSize.medium:
        hPadding = 7;
        vPadding = 1;
        break;
      case TTagSize.small:
        hPadding = 5;
        vPadding = 1;
        break;
      default:
        return EdgeInsets.zero;
    }
    return EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding);
  }

  double? _getTextLineHeight(BuildContext context, Font? font) {
    if (font == null) {
      return null;
    }
    return MediaQuery.textScalerOf(context).scale(font.size) * font.height;
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

  double _getIconSpacing() => size == TTagSize.small ? 2 : 4;
}

/// 标签颜色解析结果
class _TagColors {
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color closeIconColor;

  _TagColors({
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.closeIconColor,
  });
}
