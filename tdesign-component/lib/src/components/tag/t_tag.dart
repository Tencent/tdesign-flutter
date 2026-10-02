import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/basic.dart' show Font, FontFamily;
import '../../theme/t_colors.dart';
import '../../theme/t_font_family.dart';
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
    this.colorPreset = TTagColorPreset.defaultTheme,
    this.variant = TTagVariant.dark,
    this.icon,
    this.size = TTagSize.medium,
    this.shape = TTagShape.square,
    this.needCloseIcon = false,
    this.enabled = true,
    this.onTap,
    this.onCloseTap,
    Key? key,
  }) : super(key: key);

  /// 标签内容
  final String text;

  /// 标签预设配色。
  final TTagColorPreset colorPreset;

  /// 绘制形态。
  final TTagVariant variant;

  /// 图标内容，可随状态改变颜色
  final IconData? icon;

  /// 标签大小
  final TTagSize size;

  /// 标签外形；仅选择形状，具体圆角值由组件 Theme 或全局 Token 决定。
  final TTagShape shape;

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
    final shape = this.shape;
    final overflow = theme?.overflow;

    final fixedWidth = theme?.fixedWidth;
    final padding = theme?.padding;
    final textColor = theme?.textColor;
    final backgroundColor = theme?.backgroundColor;
    final font = theme?.font;
    final maxLines = theme?.maxLines ?? 1;
    final effectiveFont = font ?? _getFont(context);
    final ambientFontFallback = DefaultTextStyle.of(
      context,
    ).style.fontFamilyFallback;
    final fontFallback = <String>{
      ...?ambientFontFallback,
      ...?context.tTheme.fontFamily?.flutterFontFamilyFallback,
    }.toList();

    // 计算样式颜色
    final colors = _resolveColors(
      context,
      colorPreset,
      isLight,
      isOutline,
      !enabled,
      theme,
    );
    final borderRadius = _resolveBorderRadius(context, shape, theme);

    var child = _buildLabel(
      // 禁用态应始终使用禁用 token，避免普通 ThemeExtension 的颜色覆盖状态。
      textColor: enabled ? textColor ?? colors.textColor : colors.textColor,
      font: effectiveFont,
      fontFamily: context.tTheme.fontFamily,
      fontFamilyFallback: fontFallback.isEmpty ? null : fontFallback,
      fontWeight: effectiveFont?.fontWeight,
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
      height: maxLines == 1
          ? _getTagHeight(effectiveFont, effectivePadding)
          : null,
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

  /// 文本行盒与 Tag 高度使用同一个字体 Token 的行高。
  Widget _buildLabel({
    required Color textColor,
    required Font? font,
    required FontFamily? fontFamily,
    required List<String>? fontFamilyFallback,
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
        height: font?.height,
        fontWeight: fontWeight ?? font?.fontWeight,
        fontFamily: fontFamily?.flutterFontFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: fontFamily?.package,
      ),
    );
  }

  /// 解析标签颜色。
  _TagColors _resolveColors(
    BuildContext context,
    TTagColorPreset colorPreset,
    bool isLight,
    bool isOutline,
    bool disable,
    TTagThemeData? theme,
  ) {
    final token = context.tTheme;
    final material = Theme.of(context).tExplicitColorScheme;
    if (disable) {
      return _TagColors(
        textColor:
            material?.onSurface.withValues(alpha: 0.38) ??
            token.textColorDisabled,
        backgroundColor:
            material?.onSurface.withValues(alpha: 0.12) ??
            token.bgColorComponentDisabled,
        borderColor: material?.outline ?? token.componentBorder,
        closeIconColor: token.textColorPlaceholder,
      );
    }

    Color textColor;
    Color backgroundColor;
    Color borderColor;

    switch (colorPreset) {
      case TTagColorPreset.primary:
        if (isOutline) {
          borderColor = material?.primary ?? token.brandColor;
          textColor = material?.primary ?? token.brandColor;
          backgroundColor = isLight
              ? material?.primaryContainer ?? token.brandColorLight
              : token.bgColorContainer;
        } else {
          textColor = isLight
              ? material?.primary ?? token.brandColor
              : material?.onPrimary ?? token.textColorAnti;
          backgroundColor = isLight
              ? material?.primaryContainer ?? token.brandColorLight
              : material?.primary ?? token.brandColor;
          borderColor = backgroundColor;
        }
        break;
      case TTagColorPreset.warning:
        if (isOutline) {
          borderColor = token.warningColor;
          textColor = token.warningColor;
          backgroundColor = isLight
              ? token.warningColor1
              : token.bgColorContainer;
        } else {
          textColor = isLight ? token.warningColor : token.textColorAnti;
          backgroundColor = isLight ? token.warningColor1 : token.warningColor;
          borderColor = backgroundColor;
        }
        break;
      case TTagColorPreset.danger:
        final dangerFallback = material?.error ?? token.errorColor;
        final baseColor =
            theme?.resolveDangerColor(dangerFallback) ?? dangerFallback;
        if (isOutline) {
          borderColor = baseColor;
          textColor = baseColor;
          backgroundColor = isLight
              ? material?.errorContainer ?? token.errorColor1
              : token.bgColorContainer;
        } else {
          textColor = isLight
              ? baseColor
              : material?.onError ?? token.textColorAnti;
          backgroundColor = isLight
              ? material?.errorContainer ?? token.errorColor1
              : baseColor;
          borderColor = backgroundColor;
        }
        break;
      case TTagColorPreset.success:
        final baseColor =
            theme?.resolveSuccessColor(token.successColor) ??
            token.successColor;
        final lightColor =
            theme?.resolveSuccessLightColor(token.successColor1) ??
            token.successColor1;
        if (isOutline) {
          borderColor = baseColor;
          textColor = baseColor;
          backgroundColor = isLight ? lightColor : token.bgColorContainer;
        } else {
          textColor = isLight ? baseColor : token.textColorAnti;
          backgroundColor = isLight ? lightColor : baseColor;
          borderColor = backgroundColor;
        }
        break;
      case TTagColorPreset.defaultTheme:
        if (isOutline) {
          // 小程序 light-outline/default 单独使用 component-border；普通
          // outline/default 则使用 tag-default-color 的回退 bg-color-component。
          borderColor = isLight
              ? material?.outline ?? token.componentBorder
              : material?.surfaceContainerHighest ?? token.bgColorComponent;
          textColor = material?.onSurface ?? token.textColorPrimary;
          backgroundColor = isLight
              ? material?.surfaceContainerHighest ??
                    token.bgColorSecondaryContainer
              : token.bgColorContainer;
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
    TTagThemeData? theme,
  ) {
    switch (shape) {
      case TTagShape.square:
        return BorderRadius.circular(
          theme?.resolveSquareBorderRadius(context.tTheme.radiusSmall) ??
              context.tTheme.radiusSmall,
        );
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

  /// 计算标签高度，只约束纵向布局，不影响标签按内容自适应宽度。
  double? _getTagHeight(Font? textFont, EdgeInsets padding) {
    if (size == TTagSize.custom || textFont == null) {
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
