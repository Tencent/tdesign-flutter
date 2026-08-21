import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import 't_button_resolve.dart';
import 't_button_theme_data.dart';
import 't_button_types.dart';

// ============ TButton Widget ============

/// TD 常规按钮
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

  /// 尺寸，未传时使用 Theme [TButtonThemeData.defaultSize]。
  ///
  /// 默认按 48、40、32、28dp 的 TDesign 视觉高度参与布局。
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

  /// P0 逃逸舱：[ButtonStyle] 覆盖所有 resolve 结果。
  ///
  /// 组件默认使用 [MaterialTapTargetSize.shrinkWrap] 保持 TDesign 精确尺寸；
  /// 需要至少 48dp 点击区时可将 [ButtonStyle.tapTargetSize] 设为
  /// [MaterialTapTargetSize.padded]。
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
    final sizeMetrics = TButtonResolve.sizeMetrics(
      effectiveSize,
      context.tTheme,
    );
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
        children.add(_wrapIcon(widget.icon!, sizeMetrics));
      }

      // 内容
      if (hasChild) {
        children.add(Flexible(child: widget.child!));
      }

      // 右侧图标
      if (hasIcon && widget.iconPosition == TButtonIconPosition.right) {
        children.add(_wrapIcon(widget.icon!, sizeMetrics));
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
      final appTheme = Theme.of(context);
      final isDisabled = widget.onPressed == null;
      final states = <WidgetState>{if (isDisabled) WidgetState.disabled};
      final shape =
          resolvedStyle.shape?.resolve(states) ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              _borderRadiusForShape(
                theme?.effectiveShape ?? TButtonShape.rectangle,
              ),
            ),
          );
      final side = resolvedStyle.side?.resolve(states);
      final effectiveShape = side == null ? shape : shape.copyWith(side: side);
      final backgroundColor = resolvedStyle.backgroundColor?.resolve(states);
      final foregroundColor = resolvedStyle.foregroundColor?.resolve(states);

      final textStyle =
          resolvedStyle.textStyle?.resolve(states) ??
          TextStyle(
            fontSize: sizeMetrics.fontSize,
            height: sizeMetrics.fontHeight,
            fontWeight: sizeMetrics.fontWeight,
          );
      final isIconOnly = widget.icon != null && widget.child == null;
      final isFixedIconShape =
          theme?.effectiveShape == TButtonShape.square ||
          theme?.effectiveShape == TButtonShape.circle;
      final padding =
          resolvedStyle.padding?.resolve(states) ??
          (isIconOnly && isFixedIconShape
              ? EdgeInsets.all(sizeMetrics.iconOnlyPadding)
              : EdgeInsets.symmetric(
                  horizontal: sizeMetrics.horizontalPadding,
                  vertical: sizeMetrics.verticalPadding,
                ));
      final minimumSize =
          resolvedStyle.minimumSize?.resolve(states) ??
          Size(0, sizeMetrics.height);
      final maximumSize = resolvedStyle.maximumSize?.resolve(states);
      final fixedSize = resolvedStyle.fixedSize?.resolve(states);
      final visualDensity =
          resolvedStyle.visualDensity ?? appTheme.visualDensity;
      final densityAdjustment = visualDensity.baseSizeAdjustment;
      final tapTargetSize =
          resolvedStyle.tapTargetSize ?? appTheme.materialTapTargetSize;
      final elevation = resolvedStyle.elevation?.resolve(states) ?? 0;
      final shadowColor = resolvedStyle.shadowColor?.resolve(states);
      final surfaceTintColor = resolvedStyle.surfaceTintColor?.resolve(states);
      final animationDuration =
          resolvedStyle.animationDuration ?? kThemeChangeDuration;

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
          animationDuration: animationDuration,
          child: InkWell(
            customBorder: effectiveShape,
            overlayColor: resolvedStyle.overlayColor,
            mouseCursor: resolvedStyle.mouseCursor?.resolve(states),
            enableFeedback: resolvedStyle.enableFeedback ?? true,
            splashFactory: resolvedStyle.splashFactory,
            onTap: widget.onPressed,
            onLongPress: widget.onPressed == null ? null : widget.onLongPress,
            child: Padding(padding: padding, child: styledContent),
          ),
        ),
      );

      var effectiveConstraints = visualDensity.effectiveConstraints(
        BoxConstraints(
          minWidth: minimumSize.width,
          minHeight: minimumSize.height,
          maxWidth: maximumSize?.width ?? double.infinity,
          maxHeight: maximumSize?.height ?? double.infinity,
        ),
      );
      if (fixedSize != null) {
        final effectiveFixedSize = effectiveConstraints.constrain(fixedSize);
        effectiveConstraints = effectiveConstraints.copyWith(
          minWidth: effectiveFixedSize.width,
          maxWidth: effectiveFixedSize.width,
          minHeight: effectiveFixedSize.height,
          maxHeight: effectiveFixedSize.height,
        );
      }

      Widget constrainedButton = ConstrainedBox(
        constraints: effectiveConstraints,
        child: buttonChild,
      );

      final minimumTapSize = switch (tapTargetSize) {
        MaterialTapTargetSize.padded => Size(
          math.max(0, kMinInteractiveDimension + densityAdjustment.dx),
          math.max(0, kMinInteractiveDimension + densityAdjustment.dy),
        ),
        MaterialTapTargetSize.shrinkWrap => Size.zero,
      };
      // 与 Flutter ButtonStyleButton 保持相同结构：外层 Semantics 声明
      // button/enabled，内层 InkWell 提供 tap 动作，二者合并为一个语义节点。
      button = Semantics(
        container: true,
        button: true,
        enabled: !isDisabled,
        child: _TButtonTapTarget(
          minSize: minimumTapSize,
          child: IntrinsicWidth(child: constrainedButton),
        ),
      );

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
  Widget _wrapIcon(Widget iconWidget, TButtonSizeMetrics metrics) {
    if (iconWidget is Icon) {
      return IconTheme.merge(
        data: IconThemeData(size: metrics.iconSize),
        child: iconWidget,
      );
    }
    return iconWidget;
  }

  /// 根据 shape 获取渐变裁剪圆角值
  double _borderRadiusForShape(TButtonShape shape) {
    final tTheme = context.tTheme;
    return switch (shape) {
      TButtonShape.rectangle => tTheme.radiusDefault,
      TButtonShape.round => tTheme.radiusRound, // coverage:ignore-line
      TButtonShape.square => tTheme.radiusDefault,
      TButtonShape.filled || TButtonShape.circle => 0, // coverage:ignore-line
    };
  }
}

/// 扩展按钮点击区域但保持可见 Material 的规格尺寸。
///
/// Flutter 的 [ButtonStyleButton] 使用私有 `_InputPadding` 实现同一语义，
/// 但该实现不能被组件复用。这里保留最小的等价实现：以
/// [kMinInteractiveDimension] 和 visual density 计算点击区、将可见按钮居中，
/// 并把点击区空白位置的命中重定向到可见按钮中心。
///
/// intrinsic、dry layout、baseline、样式更新和空白区命中均有回归测试；
/// Flutter 若提供公开扩展点，应优先替换本实现。
class _TButtonTapTarget extends SingleChildRenderObjectWidget {
  const _TButtonTapTarget({required this.minSize, required super.child});

  final Size minSize;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderTButtonTapTarget(minSize);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderTButtonTapTarget renderObject,
  ) {
    renderObject.minSize = minSize;
  }
}

class _RenderTButtonTapTarget extends RenderShiftedBox {
  _RenderTButtonTapTarget(this._minSize) : super(null);

  Size _minSize;

  Size get minSize => _minSize;

  set minSize(Size value) {
    if (_minSize == value) {
      return;
    }
    _minSize = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) => child == null
      ? 0
      : math.max(child!.getMinIntrinsicWidth(height), minSize.width);

  @override
  double computeMinIntrinsicHeight(double width) => child == null
      ? 0
      : math.max(child!.getMinIntrinsicHeight(width), minSize.height);

  @override
  double computeMaxIntrinsicWidth(double height) => child == null
      ? 0
      : math.max(child!.getMaxIntrinsicWidth(height), minSize.width);

  @override
  double computeMaxIntrinsicHeight(double width) => child == null
      ? 0
      : math.max(child!.getMaxIntrinsicHeight(width), minSize.height);

  Size _computeSize({
    required BoxConstraints constraints,
    required ChildLayouter layoutChild,
  }) {
    if (child == null) {
      return Size.zero;
    }
    // 宽高分别扩展到 minSize；不要交换两个轴。Flutter 3.47 的
    // ButtonStyleButton._RenderInputPadding 采用相同计算。
    final childSize = layoutChild(child!, constraints);
    return constraints.constrain(
      Size(
        math.max(childSize.width, minSize.width),
        math.max(childSize.height, minSize.height),
      ),
    );
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => _computeSize(
    constraints: constraints,
    layoutChild: ChildLayoutHelper.dryLayoutChild,
  );

  @override
  double? computeDryBaseline(
    covariant BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    final child = this.child;
    if (child == null) {
      return null;
    }
    final childBaseline = child.getDryBaseline(constraints, baseline);
    if (childBaseline == null) {
      return null;
    }
    final childSize = child.getDryLayout(constraints);
    return childBaseline +
        Alignment.center
            .alongOffset(computeDryLayout(constraints) - childSize as Offset)
            .dy;
  }

  @override
  void performLayout() {
    size = _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.layoutChild,
    );
    final child = this.child;
    if (child != null) {
      final childParentData = child.parentData! as BoxParentData;
      childParentData.offset = Alignment.center.alongOffset(
        size - child.size as Offset,
      );
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (super.hitTest(result, position: position)) {
      return true;
    }
    final child = this.child;
    if (child == null) {
      return false;
    }
    // 对齐 ButtonStyleButton 的 padded tap-target：可见 Material 外的命中
    // 重定向到子节点中心，使 InkWell 收到同一次点击。
    final center = child.size.center(Offset.zero);
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(center),
      position: center,
      hitTest: (result, position) => child.hitTest(result, position: center),
    );
  }
}
