import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 't_button_resolve.dart';
import 't_button_theme_data.dart';

// ============ 枚举定义 ============

/// 按钮尺寸
enum TButtonSize { large, medium, small, extraSmall }

/// 按钮变体（fill / outline / text / ghost）
enum TButtonVariant { fill, outline, text, ghost }

/// 按钮配色方案
enum TButtonColorScheme { defaultTheme, primary, danger, light }

/// 图标位置
enum TButtonIconPosition { left, right }

// ============ TButton Widget ============

/// TD 常规按钮（V1.0）
///
/// Material 薄包装，`onPressed: null` 表示禁用。
///
/// **L1 三维正交**：
/// - [variant]：变体类型（fill / outline / text / ghost）
/// - [colorScheme]：配色方案（defaultTheme / primary / danger / light）
/// - shape：由 Theme [TButtonThemeData.shape] 控制
///
/// **示例**：
/// ```dart
/// // 基本用法
/// TButton(
///   child: Text('填充按钮'),
///   variant: TButtonVariant.fill,
///   colorScheme: TButtonColorScheme.primary,
///   onPressed: () {},
/// )
///
/// // 图标按钮
/// TButton(
///   icon: Icon(TIcons.app),
///   child: Text('按钮'),
///   onPressed: () {},
/// )
///
/// // 禁用
/// TButton(
///   child: Text('禁用'),
///   onPressed: null,
/// )
///
/// // 通栏（外包布局）
/// SizedBox(
///   width: double.infinity,
///   child: TButton(child: Text('通栏'), onPressed: () {}),
/// )
/// ```
class TButton extends StatefulWidget {
  const TButton({
    Key? key,
    this.child,
    this.size = TButtonSize.medium,
    this.variant,
    this.colorScheme,
    this.icon,
    this.iconPosition = TButtonIconPosition.left,
    this.onPressed,
    this.style,
  }) : super(key: key);

  /// 内容（纯文案用 `Text('...')`）
  final Widget? child;

  /// 尺寸，未传时使用 Theme [TButtonThemeData.defaultSize]
  final TButtonSize size;

  /// 变体（fill / outline / text / ghost），未传时使用 Theme [TButtonThemeData.defaultVariant]
  final TButtonVariant? variant;

  /// 配色方案，未传时使用 Theme 默认解析
  final TButtonColorScheme? colorScheme;

  /// 图标（Widget 类型，IconData 需包裹为 `Icon(...)`）
  final Widget? icon;

  /// 图标位置
  final TButtonIconPosition iconPosition;

  /// 点击回调，`null` 表示禁用
  final VoidCallback? onPressed;

  /// P0 逃逸舱：[ButtonStyle] 覆盖所有 resolve 结果
  final ButtonStyle? style;

  @override
  State<TButton> createState() => _TButtonState();
}

class _TButtonState extends State<TButton> {
  @override
  Widget build(BuildContext context) {
    // 获取 Theme
    final theme = Theme.of(context).extension<TButtonThemeData>();
    final effectiveVariant = widget.variant ?? theme?.defaultVariant ?? TButtonVariant.fill;

    // 解析 ButtonStyle
    final resolvedStyle = TButtonResolve.resolve(
      variant: effectiveVariant,
      colorScheme: widget.colorScheme,
      size: widget.size,
      icon: widget.icon,
      iconPosition: widget.iconPosition,
      theme: theme,
      instanceStyle: widget.style,
      context: context,
    );

    // 构建带图标的内容
    final hasIcon = widget.icon != null;
    final hasChild = widget.child != null;
    final iconSpacing = theme?.iconSpacing ?? 8.0;
    final gradient = theme?.gradient;

    Widget? content;
    if (hasChild || hasIcon) {
      final children = <Widget>[];

      // 左侧图标
      if (hasIcon && widget.iconPosition == TButtonIconPosition.left) {
        children.add(_wrapIcon(widget.icon!));
      }

      // 内容
      if (hasChild) {
        children.add(Flexible(child: widget.child!));
      }

      // 右侧图标
      if (hasIcon && widget.iconPosition == TButtonIconPosition.right) {
        children.add(_wrapIcon(widget.icon!));
      }

      // 图标与文案间距
      if (children.length == 2) {
        children.insert(1, SizedBox(width: iconSpacing));
      }

      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }

    // 使用 ElevatedButton 作为底层（Flutter 3.16+ MaterialButton 已弃用）
    Widget button = ElevatedButton(
      onPressed: widget.onPressed,
      style: resolvedStyle,
      child: content,
    );

    // 渐变 + margin 外包
    if (gradient != null || (theme?.margin != null)) {
      button = Container(
        margin: theme?.margin,
        decoration: gradient != null
            ? BoxDecoration(
                gradient: gradient,
                borderRadius: resolvedStyle.shape != null
                    ? null // shape 已在 MaterialButton 处理
                    : null,
              )
            : null,
        child: button,
      );
    }

    return button;
  }

  /// 包裹图标，按 TButtonSize 设置默认尺寸
  Widget _wrapIcon(Widget iconWidget) {
    if (iconWidget is Icon) {
      final icon = iconWidget;
      final useDefaultSize = icon.size == null;
      final useDefaultColor = icon.color == null;

      if (useDefaultSize || useDefaultColor) {
        final iconSize = _iconSizeForButton(widget.size);
        return Icon(
          icon.icon!,
          size: useDefaultSize ? iconSize : icon.size,
          color: useDefaultColor ? null : icon.color,
        );
      }
    }
    return iconWidget;
  }

  /// 根据 size 获取默认图标尺寸
  static double _iconSizeForButton(TButtonSize size) {
    switch (size) {
      case TButtonSize.large:
        return 24;
      case TButtonSize.medium:
        return 20;
      case TButtonSize.small:
        return 18;
      case TButtonSize.extraSmall:
        return 14;
    }
  }
}
