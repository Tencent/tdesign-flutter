import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import 't_progress_circular.dart';
import 't_progress_theme_data.dart';

/// 进度条形态
enum TProgressVariant {
  /// 线性进度条。
  linear,

  /// 百分比显示在进度条内部的胶囊形进度条。
  plump,

  /// 环形进度条。
  circular,

  /// 紧凑、只读的环形进度条。
  microCircular,

  /// 按钮外观的线性进度条。
  button,

  /// 带按钮语义和紧凑圆环外观的进度操作。
  microButton,
}

/// 进度条所表达的任务状态。
enum TProgressStatus {
  /// 常规进行中状态。
  normal,

  /// 警告状态。
  warning,

  /// 错误状态。
  error,

  /// 成功状态。
  success,
}

/// 展示确定或不确定任务进度的组件。
class TProgress extends StatelessWidget {
  TProgress({
    Key? key,
    required this.variant,
    double? value,
    this.status = TProgressStatus.normal,
    this.label,
    this.gradient,
    this.semanticsLabel,
    this.semanticsValue,
    this.onTap,
    this.onLongPress,
  }) : value = _validateProgress(value),
       assert(
         gradient == null ||
             variant == TProgressVariant.linear ||
             variant == TProgressVariant.plump ||
             variant == TProgressVariant.button,
         'gradient is only supported by linear, plump, and button variants.',
       ),
       super(key: key);

  /// 进度条形态
  final TProgressVariant variant;

  /// 进度值；确定模式限制在 0 到 1，null 表示不确定进度。
  final double? value;

  /// 当前任务状态，决定默认颜色和状态图标，默认为 [TProgressStatus.normal]。
  ///
  /// 显式的组件 Theme 或 Flutter ProgressIndicatorTheme 颜色仍可覆盖状态默认色。
  final TProgressStatus status;

  /// 进度条标签。
  ///
  /// 未指定时，常规状态显示百分比，warning、error、success 显示状态图标；
  /// [TProgressVariant.microCircular] 默认不显示标签。
  final Widget? label;

  /// 线性填充渐变。
  ///
  /// 仅用于 [TProgressVariant.linear]、[TProgressVariant.plump] 和
  /// [TProgressVariant.button]，并优先于 Theme 和 [status] 的默认颜色。
  final LinearGradient? gradient;

  /// 辅助技术播报的进度条名称。
  final String? semanticsLabel;

  /// 辅助技术播报的进度值；未指定时由 [value] 格式化为百分比。
  final String? semanticsValue;

  /// 点击 `button` 或 `microButton` 进度条时触发。
  ///
  /// 其他只读形态不会响应点击。
  final VoidCallback? onTap;

  /// 长按 `button` 或 `microButton` 进度条时触发。
  ///
  /// 可以独立于 [onTap] 使用；长按不会同时触发 [onTap]。其他只读形态
  /// 不会响应长按。
  final VoidCallback? onLongPress;

  static double? _validateProgress(double? value) => value?.clamp(0.0, 1.0);

  /// 从 Theme 子树读取 L4 默认值
  TProgressThemeData? _theme(BuildContext context) =>
      Theme.of(context).extension<TProgressThemeData>();

  @override
  Widget build(BuildContext context) {
    final theme = _theme(context);
    final materialTheme = Theme.of(context);
    final materialProgress = materialTheme.progressIndicatorTheme;
    final colorScheme = materialTheme.tExplicitColorScheme;
    final defaultValues = _getDefaultValues(context, variant);

    final strokeWidth = theme?.strokeWidth ?? defaultValues.strokeWidth;
    final materialTrackColor = switch (variant) {
      TProgressVariant.circular ||
      TProgressVariant.microCircular ||
      TProgressVariant.microButton => materialProgress.circularTrackColor,
      TProgressVariant.linear ||
      TProgressVariant.plump ||
      TProgressVariant.button => materialProgress.linearTrackColor,
    };
    final backgroundColor =
        theme?.backgroundColor ??
        materialTrackColor ??
        colorScheme?.surfaceContainerHighest ??
        defaultValues.backgroundColor;
    final linearBorderRadius =
        theme?.linearBorderRadius ?? defaultValues.linearBorderRadius;
    final circleRadius = theme?.circleRadius ?? defaultValues.circleRadius;
    final color =
        theme?.color ??
        materialProgress.color ??
        (status == TProgressStatus.normal ? colorScheme?.primary : null) ??
        _statusColor(context, status);
    final animationDuration =
        theme?.animationDuration ?? const Duration(milliseconds: 300);
    final indeterminateAnimationDuration =
        theme?.indeterminateAnimationDuration ??
        const Duration(milliseconds: 1200);
    if (indeterminateAnimationDuration <= Duration.zero) {
      throw FlutterError(
        'TProgressThemeData.indeterminateAnimationDuration must be '
        'greater than zero.',
      );
    }
    final indeterminateLinearSegmentFraction =
        theme?.indeterminateLinearSegmentFraction ?? 0.32;
    final indeterminateCircularValue =
        theme?.indeterminateCircularValue ?? 0.25;

    final indicator = _ProgressIndicator(
      value: value,
      status: status,
      label: label,
      gradient: gradient,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      onTap: onTap,
      onLongPress: onLongPress,
      strokeWidth: strokeWidth,
      circleRadius: circleRadius,
      linearBorderRadius: linearBorderRadius,
      color: color,
      backgroundColor: backgroundColor,
      type: variant,
      animationDuration: animationDuration,
      indeterminateAnimationDuration: indeterminateAnimationDuration,
      indeterminateLinearSegmentFraction: indeterminateLinearSegmentFraction,
      indeterminateCircularValue: indeterminateCircularValue,
    );
    if (variant != TProgressVariant.linear &&
        variant != TProgressVariant.plump &&
        variant != TProgressVariant.button) {
      return indicator;
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.hasBoundedWidth) {
          return indicator;
        }
        final fallbackWidth = MediaQuery.maybeSizeOf(context)?.width;
        if (fallbackWidth == null ||
            !fallbackWidth.isFinite ||
            fallbackWidth <= 0) {
          throw FlutterError(
            'TProgress requires a bounded width or a MediaQuery viewport width.',
          );
        }
        return SizedBox(width: fallbackWidth, child: indicator);
      },
    );
  }

  _DefaultValues _getDefaultValues(
    BuildContext context,
    TProgressVariant type,
  ) {
    switch (type) {
      case TProgressVariant.linear:
        return _DefaultValues(
          strokeWidth: 4.0,
          backgroundColor: context.tTheme.bgColorComponent,
          linearBorderRadius: BorderRadius.circular(context.tTheme.radiusRound),
          circleRadius: 0,
        );
      case TProgressVariant.plump:
        return _DefaultValues(
          strokeWidth: 16.0,
          backgroundColor: context.tTheme.bgColorComponent,
          linearBorderRadius: BorderRadius.circular(context.tTheme.radiusRound),
          circleRadius: 0,
        );
      case TProgressVariant.circular:
        return _DefaultValues(
          strokeWidth: 4.0,
          backgroundColor: context.tTheme.bgColorComponent,
          linearBorderRadius: BorderRadius.circular(context.tTheme.radiusRound),
          circleRadius: 72.0,
        );
      case TProgressVariant.microCircular:
      case TProgressVariant.microButton:
        return _DefaultValues(
          strokeWidth: 2.0,
          backgroundColor: context.tTheme.bgColorComponent,
          linearBorderRadius: BorderRadius.circular(context.tTheme.radiusRound),
          circleRadius: 16.0,
        );
      case TProgressVariant.button:
        return _DefaultValues(
          strokeWidth: 40.0,
          backgroundColor: context.tTheme.brandNormalColor,
          linearBorderRadius: BorderRadius.circular(
            context.tTheme.radiusDefault,
          ),
          circleRadius: 0,
        );
    }
  }

  Color _statusColor(BuildContext context, TProgressStatus status) =>
      switch (status) {
        TProgressStatus.normal => context.tTheme.brandNormalColor,
        TProgressStatus.warning => context.tTheme.warningNormalColor,
        TProgressStatus.error => context.tTheme.errorNormalColor,
        TProgressStatus.success => context.tTheme.successNormalColor,
      };
}

class _DefaultValues {
  final double strokeWidth;
  final Color backgroundColor;
  final BorderRadiusGeometry linearBorderRadius;
  final double circleRadius;

  _DefaultValues({
    required this.strokeWidth,
    required this.backgroundColor,
    required this.linearBorderRadius,
    required this.circleRadius,
  });
}

class _ProgressIndicator extends StatefulWidget {
  final double? value;
  final TProgressStatus status;
  final Widget? label;
  final LinearGradient? gradient;
  final String? semanticsLabel;
  final String? semanticsValue;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double strokeWidth;
  final double circleRadius;
  final BorderRadiusGeometry linearBorderRadius;
  final Color color;
  final Color backgroundColor;
  final TProgressVariant type;
  final Duration animationDuration;
  final Duration indeterminateAnimationDuration;
  final double indeterminateLinearSegmentFraction;
  final double indeterminateCircularValue;

  const _ProgressIndicator({
    Key? key,
    this.value,
    required this.status,
    this.label,
    this.gradient,
    this.semanticsLabel,
    this.semanticsValue,
    this.onTap,
    this.onLongPress,
    required this.strokeWidth,
    required this.linearBorderRadius,
    required this.circleRadius,
    required this.color,
    required this.backgroundColor,
    required this.type,
    this.animationDuration = const Duration(milliseconds: 300),
    this.indeterminateAnimationDuration = const Duration(milliseconds: 1200),
    this.indeterminateLinearSegmentFraction = 0.32,
    this.indeterminateCircularValue = 0.25,
  }) : super(key: key);

  @override
  _ProgressIndicatorState createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<_ProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Color _effectiveColor;
  late Widget _effectiveLabel;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _updateAnimation();
    _updateEffectiveColor();
    _updateEffectiveLabel();
  }

  @override
  void didUpdateWidget(_ProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value ||
        oldWidget.animationDuration != widget.animationDuration ||
        oldWidget.indeterminateAnimationDuration !=
            widget.indeterminateAnimationDuration) {
      _updateAnimation(oldWidgetValue: oldWidget.value);
      _updateEffectiveLabel();
    }
    if (oldWidget.color != widget.color) {
      _updateEffectiveColor();
    }
    if (oldWidget.label != widget.label || oldWidget.status != widget.status) {
      _updateEffectiveLabel();
    }
  }

  void _updateEffectiveColor() {
    _effectiveColor = widget.color;
  }

  void _updateEffectiveLabel() {
    _effectiveLabel = widget.label ?? _getDefaultLabel();
  }

  void _updateAnimation({double? oldWidgetValue}) {
    _animationController.stop();
    if (widget.value == null) {
      _animationController.duration = widget.indeterminateAnimationDuration;
      _animation = _animationController;
      _animationController.repeat();
      return;
    }
    _animationController.duration = widget.animationDuration;
    _animation = Tween<double>(
      begin: oldWidgetValue ?? widget.value!,
      end: widget.value!,
    ).animate(_animationController);
    _animationController.forward(from: 0);
  }

  Widget _getDefaultLabel() {
    final statusIcon = switch (widget.status) {
      TProgressStatus.normal => null,
      TProgressStatus.warning => TIcons.error_circle,
      TProgressStatus.error => TIcons.close_circle,
      TProgressStatus.success => TIcons.check_circle,
    };
    if (statusIcon != null) {
      return Icon(statusIcon, key: ValueKey('progress-${widget.status.name}'));
    }
    final showAutoText = widget.value != null;

    Widget getAutoText() =>
        showAutoText && widget.type != TProgressVariant.microCircular
        ? Text('${(widget.value! * 100).round()}%')
        : const Text('');

    return getAutoText();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.value == null
        ? _buildIndeterminate()
        : _buildDeterminate();
    return Semantics(
      excludeSemantics: true,
      label: widget.semanticsLabel,
      value:
          widget.semanticsValue ??
          (widget.value == null ? null : '${(widget.value! * 100).round()}%'),
      button: _isInteractiveVariant,
      enabled: _isInteractiveVariant
          ? widget.onTap != null || widget.onLongPress != null
          : null,
      onTap: _isInteractiveVariant ? widget.onTap : null,
      onLongPress: _isInteractiveVariant ? widget.onLongPress : null,
      child: child,
    );
  }

  bool get _isInteractiveVariant =>
      widget.type == TProgressVariant.button ||
      widget.type == TProgressVariant.microButton;

  bool get _showsLabel =>
      widget.type != TProgressVariant.microCircular ||
      widget.label != null ||
      widget.status != TProgressStatus.normal;

  Widget _buildDeterminate() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (widget.type == TProgressVariant.linear ||
          widget.type == TProgressVariant.plump)
        _buildLinearProgress()
      else if (widget.type == TProgressVariant.circular)
        _buildCircularProgress()
      else if (widget.type == TProgressVariant.microCircular ||
          widget.type == TProgressVariant.microButton)
        _buildMicroProgress()
      else if (widget.type == TProgressVariant.button)
        _buildButtonProgress(),
    ],
  );

  Widget _buildIndeterminate() {
    switch (widget.type) {
      case TProgressVariant.linear:
      case TProgressVariant.plump:
        return _buildIndeterminateLinear();
      case TProgressVariant.button:
        final progress = _buildIndeterminateLinear();
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          child: progress,
        );
      case TProgressVariant.circular:
      case TProgressVariant.microCircular:
      case TProgressVariant.microButton:
        final progress = RotationTransition(
          turns: _animationController,
          child: SizedBox.square(
            dimension: widget.circleRadius,
            child: Padding(
              padding: EdgeInsets.all(widget.strokeWidth / 2),
              child: TProgressCircular(
                strokeWidth: widget.strokeWidth,
                circleRadius: widget.circleRadius,
                value: widget.indeterminateCircularValue,
                backgroundColor: widget.backgroundColor,
                valueColor: AlwaysStoppedAnimation<Color>(_effectiveColor),
              ),
            ),
          ),
        );
        if (widget.type == TProgressVariant.microButton) {
          return _buildMicroButtonHitTarget(progress);
        }
        return progress;
    }
  }

  Widget _buildIndeterminateLinear() {
    return ClipRRect(
      borderRadius: widget.linearBorderRadius.resolve(
        Directionality.of(context),
      ),
      child: SizedBox(
        height: widget.strokeWidth,
        child: ColoredBox(
          color: widget.backgroundColor,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  final segmentWidth =
                      constraints.maxWidth *
                      widget.indeterminateLinearSegmentFraction;
                  final left =
                      (constraints.maxWidth + segmentWidth) *
                          _animationController.value -
                      segmentWidth;
                  return Stack(
                    children: [
                      Positioned(
                        left: left,
                        width: segmentWidth,
                        top: 0,
                        bottom: 0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: widget.gradient == null
                                ? _effectiveColor
                                : null,
                            gradient: widget.gradient,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLinearProgress() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        if (widget.type == TProgressVariant.plump) {
          return _buildInsideLabel(maxWidth);
        }
        return _buildOutsideLabel(maxWidth);
      },
    );
  }

  Widget _buildInsideLabel(double maxWidth) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final progressWidth = _animation.value * maxWidth;
        return ClipRRect(
          borderRadius: BorderRadius.circular(context.tTheme.radiusRound),
          child: Stack(
            children: [
              _buildBackgroundContainer(),
              if (widget.value! > 0.1)
                _buildProgressContainerWithLabel(progressWidth)
              else
                _buildProgressContainerWithLabelOutside(progressWidth),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOutsideLabel(double maxWidth) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: TextDirection.rtl,
          children: [
            _buildLabelWidget(context.tTheme.textColorPrimary),
            SizedBox(width: context.tTheme.spacer8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(context.tTheme.radiusRound),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        _buildBackgroundContainer(),
                        Container(
                          key: const ValueKey('progress-value'),
                          height: widget.strokeWidth,
                          width: constraints.maxWidth * _animation.value,
                          decoration: BoxDecoration(
                            color: widget.gradient == null
                                ? _effectiveColor
                                : null,
                            gradient: widget.gradient,
                            borderRadius: widget.linearBorderRadius,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBackgroundContainer() {
    return Container(
      key: const ValueKey('progress-track'),
      height: widget.strokeWidth,
      decoration: BoxDecoration(
        borderRadius: widget.linearBorderRadius,
        color: widget.backgroundColor,
      ),
    );
  }

  Widget _buildProgressContainerWithLabel(double progressWidth) {
    return Container(
      key: const ValueKey('progress-value'),
      height: widget.strokeWidth,
      width: progressWidth,
      decoration: BoxDecoration(
        color: widget.gradient == null ? _effectiveColor : null,
        gradient: widget.gradient,
        borderRadius: widget.linearBorderRadius,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: _buildLabelWidget(context.tTheme.textColorAnti),
        ),
      ),
    );
  }

  Widget _buildProgressContainerWithLabelOutside(double progressWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          key: const ValueKey('progress-value'),
          height: widget.strokeWidth,
          width: progressWidth,
          decoration: BoxDecoration(
            color: widget.gradient == null ? _effectiveColor : null,
            gradient: widget.gradient,
            borderRadius: BorderRadius.only(
              topLeft: widget.linearBorderRadius
                  .resolve(TextDirection.ltr)
                  .topLeft,
              bottomLeft: widget.linearBorderRadius
                  .resolve(TextDirection.ltr)
                  .bottomLeft,
              topRight: Radius.circular(
                widget.linearBorderRadius.resolve(TextDirection.ltr).topRight.x,
              ),
              bottomRight: Radius.circular(
                widget.linearBorderRadius
                    .resolve(TextDirection.ltr)
                    .bottomRight
                    .x,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _buildLabelWidget(context.tTheme.textColorPrimary),
        ),
      ],
    );
  }

  Widget _buildLabelWidget(Color labelColor) {
    late double iconSize;
    late double fontSize;
    late FontWeight fontWeight;

    switch (widget.type) {
      case TProgressVariant.linear:
        fontSize = widget.strokeWidth > 14 ? widget.strokeWidth : 14;
        iconSize = widget.strokeWidth > 20 ? widget.strokeWidth : 20;
        fontWeight = FontWeight.normal;
        break;
      case TProgressVariant.plump:
        fontSize = widget.strokeWidth * 0.6;
        iconSize = widget.strokeWidth;
        fontWeight = FontWeight.normal;
        break;
      case TProgressVariant.circular:
        iconSize = widget.circleRadius * 0.4;
        fontSize = widget.circleRadius * 0.15;
        fontWeight = FontWeight.bold;
        break;
      case TProgressVariant.microCircular:
      case TProgressVariant.microButton:
        iconSize = widget.circleRadius * 0.5;
        fontSize = widget.circleRadius * 0.2;
        fontWeight = FontWeight.normal;
        break;
      case TProgressVariant.button:
        iconSize = widget.strokeWidth * 0.3;
        fontSize = widget.strokeWidth * 0.3;
        fontWeight = FontWeight.normal;
        break;
    }

    final iconColor = widget.type == TProgressVariant.plump
        ? labelColor
        : _effectiveColor;
    return IconTheme(
      data: IconThemeData(color: iconColor, size: iconSize),
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(
          color: labelColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        child: _effectiveLabel,
      ),
    );
  }

  Widget _buildCircularProgress() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: widget.circleRadius,
              width: widget.circleRadius,
              child: Padding(
                padding: EdgeInsets.all(widget.strokeWidth / 2),
                child: TProgressCircular(
                  strokeWidth: widget.strokeWidth,
                  circleRadius: widget.circleRadius,
                  value: _animation.value,
                  backgroundColor: widget.backgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(_effectiveColor),
                ),
              ),
            ),
            if (_showsLabel) _buildLabelWidget(context.tTheme.textColorPrimary),
          ],
        );
      },
    );
  }

  Widget _buildMicroProgress() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final progress = Stack(
          alignment: Alignment.center,
          children: [
            _buildMicroOutline(),
            if (_showsLabel) _buildLabelWidget(context.tTheme.textColorPrimary),
          ],
        );
        return widget.type == TProgressVariant.microButton
            ? _buildMicroButtonHitTarget(progress)
            : progress;
      },
    );
  }

  Widget _buildMicroButtonHitTarget(Widget child) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: widget.onTap,
    onLongPress: widget.onLongPress,
    child: SizedBox.square(
      key: const ValueKey('progress-micro-button-hit-target'),
      dimension: 44,
      child: Center(child: child),
    ),
  );

  Widget _buildMicroOutline() {
    return SizedBox(
      height: widget.circleRadius,
      width: widget.circleRadius,
      child: Padding(
        padding: EdgeInsets.all(widget.strokeWidth / 2),
        child: TProgressCircular(
          strokeWidth: widget.strokeWidth,
          circleRadius: widget.circleRadius,
          value: _animation.value,
          backgroundColor: widget.backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(_effectiveColor),
        ),
      ),
    );
  }

  Widget _buildButtonProgress() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final progressWidth = maxWidth * _animation.value;
            return ClipRRect(
              borderRadius: widget.linearBorderRadius,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onTap,
                onLongPress: widget.onLongPress,
                child: Stack(
                  children: [
                    _buildBackgroundContainer(),
                    _buildButtonActiveContainer(progressWidth),
                    _buildButtonLabel(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildButtonActiveContainer(double progressWidth) {
    return Container(
      key: const ValueKey('progress-value'),
      height: widget.strokeWidth,
      width: progressWidth,
      decoration: BoxDecoration(
        color: widget.gradient == null ? _effectiveColor : null,
        gradient: widget.gradient,
      ),
    );
  }

  Widget _buildButtonLabel() {
    return Container(
      height: widget.strokeWidth,
      alignment: Alignment.center,
      child: _buildLabelWidget(context.tTheme.fontWhColor1),
    );
  }
}
