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

  /// 前置图标，颜色与正文共用解析后的前景色；关闭图标使用独立颜色。
  final IconData? icon;

  /// 标签大小
  final TTagSize size;

  /// 标签外形；仅选择形状，具体圆角值由组件 Theme 或全局 Token 决定。
  final TTagShape shape;

  /// 是否显示关闭图标。
  final bool needCloseIcon;

  /// 是否启用标签；false 时使用禁用样式并阻止标签点击与关闭图标回调。
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
    final font = theme?.font;
    final maxLines = theme?.maxLines ?? 1;
    final effectiveFont = font ?? _getFont(context);
    final fontFallback = context.tTheme.fontFamily?.flutterFontFamilyFallback;

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

    // 前置图标与正文继承同一个前景色；关闭图标使用独立的占位色。
    final foregroundColor = enabled
        ? theme?.resolveTextColor(colors.textColor) ?? colors.textColor
        : colors.textColor;
    var child = _buildLabel(
      // 禁用态应始终使用禁用 token，避免普通 ThemeExtension 的颜色覆盖状态。
      textColor: foregroundColor,
      font: effectiveFont,
      fontFamily: context.tTheme.fontFamily,
      fontFamilyFallback: fontFallback,
      fontWeight: effectiveFont?.fontWeight,
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines,
    );

    var innerIcon = _getIcon(foregroundColor);
    final iconSize = _getIconSize();
    final iconSpacing = size == TTagSize.small ? 2.0 : 4.0;
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
            color: colors.closeIconColor ?? context.tTheme.textColorAnti,
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

    final borderWidth = isOutline ? 1.0 : 0.0;
    final defaultPadding = _getPadding(borderWidth);
    final effectivePadding =
        theme?.resolvePadding(defaultPadding) ?? defaultPadding;
    final result = Container(
      width: fixedWidth,
      height: maxLines == 1
          ? _getTagHeight(effectiveFont, effectivePadding, borderWidth)
          : null,
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: enabled
            ? theme?.resolveBackgroundColor(colors.backgroundColor) ??
                  colors.backgroundColor
            : colors.backgroundColor,
        border: Border.all(width: borderWidth, color: colors.borderColor),
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
    if (disable) {
      return _TagColors(
        textColor: token.textColorDisabled,
        backgroundColor: token.bgColorComponentDisabled,
        borderColor: token.componentBorder,
        closeIconColor: token.textColorPlaceholder,
      );
    }

    Color textColor;
    Color backgroundColor;
    Color borderColor;

    switch (colorPreset) {
      case TTagColorPreset.primary:
        if (isOutline) {
          borderColor = token.brandColor;
          textColor = token.brandColor;
          backgroundColor = isLight
              ? token.brandColorLight
              : token.bgColorContainer;
        } else {
          textColor = isLight ? token.brandColor : token.textColorAnti;
          backgroundColor = isLight ? token.brandColorLight : token.brandColor;
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
        final dangerFallback = token.errorColor;
        final baseColor =
            theme?.resolveDangerColor(dangerFallback) ?? dangerFallback;
        if (isOutline) {
          borderColor = baseColor;
          textColor = baseColor;
          backgroundColor = isLight
              ? token.errorColor1
              : token.bgColorContainer;
        } else {
          textColor = isLight ? baseColor : token.textColorAnti;
          backgroundColor = isLight ? token.errorColor1 : baseColor;
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
          // light-outline/default 单独使用 component-border；普通
          // outline/default 则使用 tag-default-color 的回退 bg-color-component。
          borderColor = isLight
              ? token.componentBorder
              : token.bgColorComponent;
          textColor = token.textColorPrimary;
          backgroundColor = isLight
              ? token.bgColorSecondaryContainer
              : token.bgColorContainer;
        } else {
          textColor = token.textColorPrimary;
          backgroundColor = isLight
              ? token.bgColorSecondaryContainer
              : token.bgColorComponent;
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
  double? _getTagHeight(
    Font? textFont,
    EdgeInsets padding,
    double borderWidth,
  ) {
    if (size == TTagSize.custom || textFont == null) {
      return null;
    }
    // Container 将描边计入内容 inset；总高需补回两侧描边，避免压缩行框。
    return textFont.size * textFont.height + padding.vertical + borderWidth * 2;
  }

  /// 将默认外部间距换算为描边以内的 padding，保持各变体总高一致。
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
