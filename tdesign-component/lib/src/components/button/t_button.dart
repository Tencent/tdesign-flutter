import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
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
  late final WidgetStatesController _statesController;
  bool _usesGradient = false;

  bool get _isEnabled => widget.onPressed != null;

  @override
  void initState() {
    super.initState();
    _statesController = WidgetStatesController();
    _statesController.update(WidgetState.disabled, !_isEnabled);
    _statesController.addListener(_handleStatesChange);
  }

  @override
  void didUpdateWidget(TButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.onPressed != null) != _isEnabled) {
      _statesController.update(WidgetState.disabled, !_isEnabled);
      if (!_isEnabled) {
        _statesController.update(WidgetState.pressed, false);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _usesGradient =
        Theme.of(context).extension<TButtonThemeData>()?.gradient != null;
  }

  @override
  void dispose() {
    _statesController.removeListener(_handleStatesChange);
    _statesController.dispose();
    super.dispose();
  }

  void _handleStatesChange() {
    // 渐变分支不像 ButtonStyleButton 会自动按 WidgetState 重建；由同一个
    // controller 驱动所有 stateful ButtonStyle 字段重新解析。
    if (mounted && _usesGradient) {
      setState(() {});
    }
  }

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
    final iconTextSpacing = theme?.iconTextSpacing ?? context.tTheme.spacer8;
    final gradient = theme?.gradient;

    Widget? content;
    if (hasChild || hasIcon) {
      final children = <Widget>[];

      // 左侧图标
      if (hasIcon && widget.iconPosition == TButtonIconPosition.left) {
        children.add(widget.icon!);
      }

      // 内容
      if (hasChild) {
        children.add(Flexible(child: widget.child!));
      }

      // 右侧图标
      if (hasIcon && widget.iconPosition == TButtonIconPosition.right) {
        children.add(widget.icon!);
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
      final isDisabled = !_isEnabled;
      final states = _statesController.value;
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
      final iconColor =
          resolvedStyle.iconColor?.resolve(states) ?? foregroundColor;
      final iconSize =
          resolvedStyle.iconSize?.resolve(states) ?? sizeMetrics.iconSize;

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
          Size(
            isIconOnly && isFixedIconShape ? sizeMetrics.height : 0,
            sizeMetrics.height,
          );
      final maximumSize = resolvedStyle.maximumSize?.resolve(states);
      final fixedSize = resolvedStyle.fixedSize?.resolve(states);
      final visualDensity =
          resolvedStyle.visualDensity ?? appTheme.visualDensity;
      final densityAdjustment = visualDensity.baseSizeAdjustment;
      final tapTargetSize = resolvedStyle.tapTargetSize!;
      final elevation = resolvedStyle.elevation?.resolve(states) ?? 0;
      final shadowColor = resolvedStyle.shadowColor?.resolve(states);
      final surfaceTintColor = resolvedStyle.surfaceTintColor?.resolve(states);
      final animationDuration =
          resolvedStyle.animationDuration ?? kThemeChangeDuration;
      final alignment = resolvedStyle.alignment ?? Alignment.center;
      final backgroundBuilder = resolvedStyle.backgroundBuilder;
      final foregroundBuilder = resolvedStyle.foregroundBuilder;

      // 与 ButtonStyleButton 一致：visual density 可以调整纵向 padding，
      // 但不会把桌面端横向 padding 压缩为负值。
      final dx = math.max(0.0, densityAdjustment.dx);
      final dy = densityAdjustment.dy;
      final effectivePadding = padding
          .add(EdgeInsets.fromLTRB(dx, dy, dx, dy))
          .clamp(EdgeInsets.zero, EdgeInsetsGeometry.infinity);

      final styledContent = content == null
          ? null
          : IconTheme.merge(
              data: IconThemeData(color: iconColor, size: iconSize),
              child: content,
            );
      Widget result = Padding(
        padding: effectivePadding,
        child: styledContent == null || alignment == Alignment.center
            ? styledContent
            : Align(
                alignment: alignment,
                widthFactor: 1,
                heightFactor: 1,
                child: styledContent,
              ),
      );
      if (foregroundBuilder != null) {
        result = foregroundBuilder(context, states, result);
      }
      if (backgroundBuilder != null) {
        result = backgroundBuilder(context, states, result);
      }

      final mouseCursor = WidgetStateMouseCursor.resolveWith(
        (cursorStates) =>
            resolvedStyle.mouseCursor?.resolve(cursorStates) ??
            WidgetStateMouseCursor.clickable.resolve(cursorStates),
        debugDescription: 'TButton_MouseCursor',
      );

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
          textStyle: textStyle.copyWith(color: foregroundColor),
          shadowColor: shadowColor,
          surfaceTintColor: surfaceTintColor,
          animationDuration: animationDuration,
          child: InkWell(
            customBorder: effectiveShape,
            overlayColor: resolvedStyle.overlayColor,
            mouseCursor: mouseCursor,
            enableFeedback: resolvedStyle.enableFeedback ?? true,
            splashFactory: resolvedStyle.splashFactory,
            statesController: _statesController,
            onTap: widget.onPressed,
            onLongPress: widget.onPressed == null ? null : widget.onLongPress,
            child: result,
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
        if (effectiveFixedSize.width.isFinite) {
          effectiveConstraints = effectiveConstraints.copyWith(
            minWidth: effectiveFixedSize.width,
            maxWidth: effectiveFixedSize.width,
          );
        }
        if (effectiveFixedSize.height.isFinite) {
          effectiveConstraints = effectiveConstraints.copyWith(
            minHeight: effectiveFixedSize.height,
            maxHeight: effectiveFixedSize.height,
          );
        }
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
    } else {
      button = ElevatedButton(
        onPressed: widget.onPressed,
        statesController: _statesController,
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
    }

    return button;
  }

  /// 根据 shape 获取渐变裁剪圆角值
  double _borderRadiusForShape(TButtonShape shape) {
    final tTheme = context.tTheme;
    return switch (shape) {
      TButtonShape.rectangle => tTheme.radiusDefault,
      TButtonShape.round => tTheme.radiusRound, // coverage:ignore-line
      TButtonShape.square => tTheme.radiusDefault,
      TButtonShape.circle => 0, // coverage:ignore-line
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
