import 'package:flutter/material.dart';

import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import 't_button_resolve.dart';
import 't_button_theme_data.dart';
import 't_button_types.dart';

// ============ TButton Widget ============

/// TD 常规按钮（V1.0）
///
/// Material 薄包装，`onPressed: null` 表示禁用；禁用时不会触发
/// [onLongPress]。
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
    this.size,
    this.variant,
    this.colorScheme,
    this.icon,
    this.iconPosition = TButtonIconPosition.left,
    this.onPressed,
    this.onLongPress,
    this.style,
  }) : super(key: key);

  /// 内容（纯文案用 `Text('...')`）
  final Widget? child;

  /// 尺寸，未传时使用 Theme [TButtonThemeData.defaultSize]
  final TButtonSize? size;

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

  /// 长按回调。
  ///
  /// 仅在 [onPressed] 非空时生效；当 [onPressed] 为空时按钮保持禁用态，
  /// 不会触发点击或长按回调。
  final VoidCallback? onLongPress;

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
    final effectiveVariant =
        widget.variant ?? theme?.defaultVariant ?? TButtonVariant.fill;
    final effectiveSize =
        widget.size ?? theme?.defaultSize ?? TButtonSize.medium;
    final hasGradient = theme?.gradient != null;

    // 解析 ButtonStyle
    final resolvedStyle = TButtonResolve.resolve(
      variant: effectiveVariant,
      colorScheme: widget.colorScheme,
      size: effectiveSize,
      icon: widget.icon,
      hasChild: widget.child != null,
      theme: theme,
      instanceStyle: widget.style,
      context: context,
      hasGradient: hasGradient,
    );

    // 构建带图标的内容
    final hasIcon = widget.icon != null;
    final hasChild = widget.child != null;
    final iconTextSpacing = theme?.iconTextSpacing ?? 8.0;
    final gradient = theme?.gradient;

    Widget? content;
    if (hasChild || hasIcon) {
      final children = <Widget>[];

      // 左侧图标
      if (hasIcon && widget.iconPosition == TButtonIconPosition.left) {
        children.add(_wrapIcon(widget.icon!, effectiveSize));
      }

      // 内容
      if (hasChild) {
        children.add(Flexible(child: widget.child!));
      }

      // 右侧图标
      if (hasIcon && widget.iconPosition == TButtonIconPosition.right) {
        children.add(_wrapIcon(widget.icon!, effectiveSize));
      }

      // 图标与文案间距
      if (children.length == 2) {
        children.insert(1, SizedBox(width: iconTextSpacing));
      }

      content = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }

    // 使用 ElevatedButton 作为底层（Flutter 3.16+ MaterialButton 已弃用）
    // 渐变模式：放弃 ElevatedButton，使用原生控件替代。
    //   Web 上 ElevatedButton(MaterialType.button) 即使设置 backgroundColor=Colors.transparent
    //   也会绘制不透明覆盖层，无法穿透显示底层渐变。
    Widget button;

    if (gradient != null) {
      // 渐变按钮保留自绘装饰层，同时复用 resolvedStyle 中的 P0/ButtonStyle 结果。
      final isDisabled = widget.onPressed == null;
      final states = <WidgetState>{if (isDisabled) WidgetState.disabled};
      final shape = resolvedStyle.shape?.resolve(states) ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              _borderRadiusForShape(
                  theme?.effectiveShape ?? TButtonShape.rectangle),
            ),
          );
      final side = resolvedStyle.side?.resolve(states);
      final effectiveShape = side == null ? shape : shape.copyWith(side: side);
      final backgroundColor = resolvedStyle.backgroundColor?.resolve(states);
      final foregroundColor = resolvedStyle.foregroundColor?.resolve(states);

      final textStyle = resolvedStyle.textStyle?.resolve(states) ??
          TextStyle(fontSize: _fontSizeForButton(effectiveSize));
      final padding = resolvedStyle.padding?.resolve(states) ??
          _gradientPadding(
            effectiveSize,
            widget.icon != null,
            widget.child != null,
            theme?.effectiveShape ?? TButtonShape.rectangle,
          );
      final minimumSize = resolvedStyle.minimumSize?.resolve(states) ??
          Size(0, _sideLengthForSize(effectiveSize));
      final maximumSize = resolvedStyle.maximumSize?.resolve(states);
      final fixedSize = resolvedStyle.fixedSize?.resolve(states);
      final elevation = resolvedStyle.elevation?.resolve(states) ?? 0;
      final shadowColor = resolvedStyle.shadowColor?.resolve(states);
      final surfaceTintColor = resolvedStyle.surfaceTintColor?.resolve(states);

      var styledContent = content;
      if (styledContent != null) {
        styledContent = IconTheme(
          data: IconThemeData(color: foregroundColor),
          child: DefaultTextStyle(
            style: textStyle.copyWith(color: foregroundColor),
            child: styledContent,
          ),
        );
      }

      final buttonChild = Container(
        decoration: ShapeDecoration(
          color: backgroundColor,
          gradient: backgroundColor == null ? gradient : null,
          shape: effectiveShape,
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          type: MaterialType.transparency,
          shape: effectiveShape,
          clipBehavior: Clip.antiAlias,
          elevation: elevation,
          shadowColor: shadowColor,
          surfaceTintColor: surfaceTintColor,
          child: InkWell(
            customBorder: effectiveShape,
            overlayColor: resolvedStyle.overlayColor,
            onTap: widget.onPressed,
            onLongPress: widget.onPressed == null ? null : widget.onLongPress,
            child: Padding(
              padding: padding,
              child: styledContent,
            ),
          ),
        ),
      );

      Widget constrainedButton = ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minimumSize.width,
          minHeight: minimumSize.height,
          maxWidth: maximumSize?.width ?? double.infinity,
          maxHeight: maximumSize?.height ?? double.infinity,
        ),
        child: buttonChild,
      );
      if (fixedSize != null) {
        constrainedButton = SizedBox.fromSize(
          size: fixedSize,
          child: constrainedButton,
        );
      }

      button = IntrinsicWidth(child: constrainedButton);

      if (theme?.margin != null) {
        button = Container(margin: theme!.margin, child: button);
      }
    } else {
      button = ElevatedButton(
        onPressed: widget.onPressed,
        style: resolvedStyle,
        child: content,
      );

      // ElevatedButton 没有公开 onLongPress；由外层手势补充长按，保留
      // ElevatedButton 自身的点击、Material 反馈和无障碍语义。
      if (widget.onPressed != null && widget.onLongPress != null) {
        button = GestureDetector(
          onLongPress: widget.onLongPress,
          child: button,
        );
      }

      // margin 外包（非渐变）
      if (theme?.margin != null) {
        button = Container(margin: theme!.margin, child: button);
      }
    }

    return button;
  }

  /// 包裹图标，按 TButtonSize 设置默认尺寸
  Widget _wrapIcon(Widget iconWidget, TButtonSize effectiveSize) {
    if (iconWidget is Icon) {
      final icon = iconWidget;
      final useDefaultSize = icon.size == null;
      final useDefaultColor = icon.color == null;

      if (useDefaultSize || useDefaultColor) {
        final iconSize = _iconSizeForButton(effectiveSize);
        return Icon(
          icon.icon!,
          size: useDefaultSize ? iconSize : icon.size, // coverage:ignore-line
          color: useDefaultColor ? null : icon.color, // coverage:ignore-line
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
      case TButtonSize.extraSmall: // coverage:ignore-line
        return 14;
    }
  }

  /// 根据 shape 获取渐变裁剪圆角值
  double _borderRadiusForShape(TButtonShape shape) {
    final tTheme = context.tTheme;
    return switch (shape) {
      TButtonShape.rectangle => tTheme.radiusDefault,
      TButtonShape.round => tTheme.radiusRound, // coverage:ignore-line
      TButtonShape.square ||
      TButtonShape.filled ||
      TButtonShape.circle =>
        0, // coverage:ignore-line
    };
  }

  /// 渐变模式下根据 size 计算 padding（与 _resolveSize 对齐）
  EdgeInsets _gradientPadding(
      TButtonSize size, bool hasIcon, bool hasChild, TButtonShape shape) {
    final isSquareOrCircle =
        shape == TButtonShape.square || shape == TButtonShape.circle;
    final onlyIcon = hasIcon && !hasChild;

    double padH;
    double padV;

    switch (size) {
      case TButtonSize.large:
        padH = onlyIcon ? 12 : 20;
        padV = onlyIcon ? 12 : 12;
      case TButtonSize.medium:
        padH = onlyIcon ? 10 : 16;
        padV = onlyIcon ? 10 : 8;
      case TButtonSize.small: // coverage:ignore-line
        padH = onlyIcon ? 7 : 12;
        padV = onlyIcon ? 7 : 5;
      case TButtonSize.extraSmall: // coverage:ignore-line
        padH = onlyIcon ? 5 : 8;
        padV = onlyIcon ? 5 : 3;
    }

    if (isSquareOrCircle && onlyIcon) {
      return EdgeInsets.all(padH); // coverage:ignore-line
    }
    return EdgeInsets.symmetric(horizontal: padH, vertical: padV);
  }

  /// 根据 size 获取默认字体大小
  double _fontSizeForButton(TButtonSize size) {
    return switch (size) {
      TButtonSize.large => 16,
      TButtonSize.medium => 14,
      TButtonSize.small => 12, // coverage:ignore-line
      TButtonSize.extraSmall => 10, // coverage:ignore-line
    };
  }

  /// 根据 size 获取按钮边长（对齐 _resolveSize 中的 sideLength）
  double _sideLengthForSize(TButtonSize size) {
    return switch (size) {
      TButtonSize.large => 48,
      TButtonSize.medium => 40,
      TButtonSize.small => 32, // coverage:ignore-line
      TButtonSize.extraSmall => 28, // coverage:ignore-line
    };
  }
}
