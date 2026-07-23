import 'package:flutter/material.dart';
import 'package:tdesign_icons/tdesign_icons.dart';

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
    this.uri,
    this.prefixIcon,
    this.suffixIcon,
    this.variant,
    this.colorScheme,
    this.size,
    this.onPressed,
    this.semanticLabel,
    this.tooltip,
  }) : super(key: key);

  /// 链接内容，一般是 [Text]
  final Widget? child;

  /// 链接 URI。
  ///
  /// 该字段仅作为链接目标数据保留；组件不引入平台跳转依赖。
  /// 如需打开链接，请在 [onPressed] 中自行处理。
  final Uri? uri;

  /// 链接形态；未传时读取 [TLinkThemeData.defaultVariant]，再回退 basic。
  final TLinkVariant? variant;

  /// 语义颜色方案
  final TLinkColorScheme? colorScheme;

  /// 尺寸；未传时读取 [TLinkThemeData.defaultSize]，再回退 medium。
  final TLinkSize? size;

  /// 前置图标（仅在 [variant] 为 [TLinkVariant.icon] 时生效）
  final Widget? prefixIcon;

  /// 后置图标（仅在 [variant] 为 [TLinkVariant.icon] 时生效）
  final Widget? suffixIcon;

  /// 点击回调。为 null 时链接为禁用态
  final VoidCallback? onPressed;

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
    final Widget link = InkWell(
      onTap: onPressed,
      child: text,
    );

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

    // 构建图标（优先用户传入，否则使用默认图标）
    Widget? resolvedPrefix;
    Widget? resolvedSuffix;

    final hasPrefix = prefixIcon != null;
    final hasSuffix = suffixIcon != null;

    if (hasPrefix) {
      resolvedPrefix = prefixIcon;
    } else if (hasSuffix) {
      // 只有 suffix 时，prefix 使用默认链接图标
      resolvedPrefix =
          _defaultIcon(context, TIcons.link, effectiveIconSize, effectiveColor);
    } else {
      // 两者都没传：默认显示链接图标 + 跳转图标
      resolvedPrefix =
          _defaultIcon(context, TIcons.link, effectiveIconSize, effectiveColor);
      resolvedSuffix =
          _defaultIcon(context, TIcons.jump, effectiveIconSize, effectiveColor);
    }

    resolvedSuffix ??= suffixIcon;

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

    return InkWell(
      onTap: onPressed,
      child: wrapped,
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
