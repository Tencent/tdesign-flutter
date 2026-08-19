import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';

import 't_link_resolve.dart';
import 't_link_theme_data.dart';
import 't_link_types.dart';

/// 文字超链接用于跳转一个新页面，如当前项目跳转、友情链接等。
///
/// 基于 Material [InkWell] + [Text] 薄包装。
class TLink extends StatelessWidget {
  const TLink({
    Key? key,
    this.child,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconData,
    this.suffixIconData,
    this.variant,
    this.colorScheme,
    this.size,
    this.onPressed,
    this.hover = true,
    this.semanticLabel,
    this.tooltip,
  }) : super(key: key);

  /// 链接内容，一般是 [Text]
  final Widget? child;

  /// 链接形态；未传时读取 [TLinkThemeData.defaultVariant]，再回退 basic。
  final TLinkVariant? variant;

  /// 语义颜色方案
  final TLinkColorScheme? colorScheme;

  /// 尺寸；未传时读取 [TLinkThemeData.defaultSize]，再回退 medium。
  final TLinkSize? size;

  /// 前置图标（仅在 [variant] 为 [TLinkVariant.icon] 时生效）
  ///
  /// 传入 [Widget] 时原样透传，不做染色 / 定尺寸。
  /// 若希望图标颜色与尺寸跟随 [colorScheme] / 禁用态 / [size]，请改用 [prefixIconData]。
  final Widget? prefixIcon;

  /// 后置图标（仅在 [variant] 为 [TLinkVariant.icon] 时生效）
  ///
  /// 传入 [Widget] 时原样透传，不做染色 / 定尺寸。
  /// 若希望图标颜色与尺寸跟随 [colorScheme] / 禁用态 / [size]，请改用 [suffixIconData]。
  final Widget? suffixIcon;

  /// 前置图标数据（仅在 [variant] 为 [TLinkVariant.icon] 时生效）
  ///
  /// 传入 [IconData] 时由组件统一按 [colorScheme]（含禁用态）染色、并按 [size]
  /// 定尺寸，与默认图标走同一解析链路。与 [prefixIcon] 同时传入时以 [prefixIcon] 为准。
  final IconData? prefixIconData;

  /// 后置图标数据（仅在 [variant] 为 [TLinkVariant.icon] 时生效）
  ///
  /// 传入 [IconData] 时由组件统一按 [colorScheme]（含禁用态）染色、并按 [size]
  /// 定尺寸，与默认图标走同一解析链路。与 [suffixIcon] 同时传入时以 [suffixIcon] 为准。
  final IconData? suffixIconData;

  /// 点击回调。为 null 时链接为禁用态
  final VoidCallback? onPressed;

  /// 是否开启点击反馈。为 false 时点击链接不会出现 InkWell 水波纹 / 高亮反馈，
  /// 但仍可正常响应点击（对应 h5 的 `hover` 能力）。默认 true。
  final bool hover;

  /// 语义标签（无障碍）
  final String? semanticLabel;

  /// 悬浮提示
  final String? tooltip;

  /// 是否禁用
  bool get _isDisabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    final theme = _resolveTheme(context);
    final isDisabled = _isDisabled;
    final effectiveVariant =
        variant ?? theme?.defaultVariant ?? TLinkVariant.basic;
    final effectiveSize = size ?? theme?.defaultSize ?? TLinkSize.medium;

    // resolve 颜色
    final effectiveColor = TLinkResolve.resolveColor(
      context: context,
      colorScheme: colorScheme ?? theme?.defaultColorScheme,
      theme: theme,
      isDisabled: isDisabled,
    );

    // 构建链接文本
    final text = _buildLinkText(
      context: context,
      theme: theme,
      effectiveVariant: effectiveVariant,
      effectiveSize: effectiveSize,
      effectiveColor: effectiveColor,
    );

    // 带图标时组装 Row
    if (effectiveVariant == TLinkVariant.icon) {
      return _buildIconRow(context, text, effectiveColor, theme, effectiveSize);
    }

    // 纯文本 / 下划线：直接返回 InkWell 包裹的文本
    final link = hover ? _buildInkWell(text) : _buildGestureDetector(text);

    if (isDisabled) {
      return IgnorePointer(child: link);
    }
    return link;
  }

  /// 构建链接文本（含下划线样式）
  Widget _buildLinkText({
    required BuildContext context,
    required TLinkThemeData? theme,
    required TLinkVariant effectiveVariant,
    required TLinkSize effectiveSize,
    required Color effectiveColor,
  }) {
    final effectiveFontSize = TLinkResolve.resolveFontSize(
      size: effectiveSize,
      theme: theme,
    );

    final hasUnderline = effectiveVariant == TLinkVariant.underline;

    final defaultChild = child ?? const SizedBox.shrink();

    // 如果 child 是纯文本 Text（data 非空），重新构建以注入样式
    if (defaultChild is Text && defaultChild.data != null) {
      return Text(
        defaultChild.data!,
        style: defaultChild.style?.copyWith(
              fontSize: effectiveFontSize,
              color: effectiveColor,
              decoration: hasUnderline ? TextDecoration.underline : null,
              decorationColor: hasUnderline ? effectiveColor : null,
            ) ??
            TextStyle(
              fontSize: effectiveFontSize,
              color: effectiveColor,
              decoration: hasUnderline ? TextDecoration.underline : null,
              decorationColor: hasUnderline ? effectiveColor : null,
            ),
        semanticsLabel: semanticLabel ?? defaultChild.semanticsLabel,
        maxLines: defaultChild.maxLines ?? 1,
        overflow: defaultChild.overflow ?? TextOverflow.ellipsis,
        softWrap: defaultChild.softWrap ?? false,
      );
    }

    // Text.rich 或其他 Widget：用 DefaultTextStyle 包裹注入样式
    return DefaultTextStyle.merge(
      style: TextStyle(
        fontSize: effectiveFontSize,
        color: effectiveColor,
        decoration: hasUnderline ? TextDecoration.underline : null,
        decorationColor: hasUnderline ? effectiveColor : null,
      ),
      child: defaultChild,
    );
  }

  /// 带图标时组装 Row
  Widget _buildIconRow(
    BuildContext context,
    Widget text,
    Color effectiveColor,
    TLinkThemeData? theme,
    TLinkSize effectiveSize,
  ) {
    final (leftGap, rightGap) = TLinkResolve.resolveGap(
      size: effectiveSize,
      theme: theme,
    );

    final effectiveIconSize = TLinkResolve.resolveIconSize(
      size: effectiveSize,
      theme: theme,
    );

    // 构建图标：显式传入的 Widget 优先于 IconData，最后回退默认图标
    final hasPrefixIcon = prefixIcon != null || prefixIconData != null;
    final hasSuffixIcon = suffixIcon != null || suffixIconData != null;

    Widget? resolvedPrefix;
    Widget? resolvedSuffix;

    if (prefixIcon != null) {
      resolvedPrefix = prefixIcon;
    } else if (prefixIconData != null) {
      resolvedPrefix = _defaultIcon(
          context, prefixIconData!, effectiveIconSize, effectiveColor);
    }

    if (suffixIcon != null) {
      resolvedSuffix = suffixIcon;
    } else if (suffixIconData != null) {
      resolvedSuffix = _defaultIcon(
          context, suffixIconData!, effectiveIconSize, effectiveColor);
    }

    // 两者都没显式传入：默认显示链接图标 + 跳转图标；
    // 仅传后缀（或后缀图标数据）时不补默认前缀链接图标（对齐 h5 设计）
    if (!hasPrefixIcon && !hasSuffixIcon) {
      resolvedPrefix =
          _defaultIcon(context, TIcons.link, effectiveIconSize, effectiveColor);
      resolvedSuffix =
          _defaultIcon(context, TIcons.jump, effectiveIconSize, effectiveColor);
    }

    final rowChildren = <Widget>[];
    if (resolvedPrefix != null) {
      rowChildren.add(resolvedPrefix);
      rowChildren.add(SizedBox(width: leftGap));
    }
    rowChildren.add(Flexible(child: text));
    if (resolvedSuffix != null) {
      rowChildren.add(SizedBox(width: rightGap));
      rowChildren.add(resolvedSuffix);
    }

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: rowChildren,
    );

    final wrapped =
        tooltip != null ? Tooltip(message: tooltip!, child: row) : row;

    if (_isDisabled) {
      return IgnorePointer(child: wrapped);
    }

    return hover ? _buildInkWell(wrapped) : _buildGestureDetector(wrapped);
  }

  /// 使用 [InkWell] 包裹子组件，提供水波纹 / 悬浮点击反馈
  Widget _buildInkWell(Widget child) {
    return InkWell(
      onTap: onPressed,
      child: child,
    );
  }

  /// 关闭点击反馈时使用 [GestureDetector] 包裹，仅响应点击、无水波纹
  Widget _buildGestureDetector(Widget child) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: child,
    );
  }

  /// 构建默认图标
  Widget _defaultIcon(
      BuildContext context, IconData icon, double size, Color color) {
    return Icon(icon, size: size, color: color);
  }

  /// 获取当前上下文中的 TLinkThemeData
  TLinkThemeData? _resolveTheme(BuildContext context) {
    return Theme.of(context).extension<TLinkThemeData>();
  }
}
