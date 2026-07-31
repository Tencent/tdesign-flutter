import 'package:flutter/material.dart';

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

  /// 环形进度条。
  circular,

  /// 紧凑环形进度条。
  micro,

  /// 按钮外观的线性进度条。
  button,
}

/// 标签位置
enum TProgressLabelPosition {
  /// 标签位于进度条内部。
  inside,

  /// 标签位于进度条左侧。
  left,

  /// 标签位于进度条右侧。
  right,
}

/// 展示确定或不确定任务进度的组件。
class TProgress extends StatelessWidget {
  TProgress({
    Key? key,
    required this.variant,
    double? value,
    this.label,
    this.onTap,
    this.onLongPress,
  })  : value = _validateProgress(value),
        super(key: key);

  /// 进度条形态
  final TProgressVariant variant;

  /// 进度值；确定模式限制在 0 到 1，null 表示不确定进度。
  final double? value;

  /// 进度条标签。
  final Widget? label;

  /// 点击 `button` 或 `micro` 进度条时触发。
  ///
  /// 这两个形态提供了可操作的视觉样式；线性和环形形态不会响应点击。
  final VoidCallback? onTap;

  /// 长按 `button` 或 `micro` 进度条时触发。
  ///
  /// 可以独立于 [onTap] 使用；长按不会同时触发 [onTap]。线性和环形
  /// 形态不会响应长按。
  final VoidCallback? onLongPress;

  static double? _validateProgress(double? value) => value?.clamp(0.0, 1.0);

  /// 从 Theme 子树读取 L4 默认值
  TProgressThemeData? _theme(BuildContext context) =>
      Theme.of(context).extension<TProgressThemeData>();

  @override
  Widget build(BuildContext context) {
    final theme = _theme(context);
    final defaultValues = _getDefaultValues(context, variant);

    final strokeWidth = theme?.strokeWidth ?? defaultValues.strokeWidth;
    final backgroundColor =
        theme?.backgroundColor ?? defaultValues.backgroundColor;
    final linearBorderRadius =
        theme?.linearBorderRadius ?? defaultValues.linearBorderRadius;
    final circleRadius = theme?.circleRadius ?? defaultValues.circleRadius;
    final showLabel = theme?.showLabel ?? true;
    final labelWidgetWidth = theme?.labelWidgetWidth;
    final labelWidgetAlignment = theme?.labelWidgetAlignment;
    final progressLabelPosition =
        theme?.progressLabelPosition ?? TProgressLabelPosition.inside;
    final color = theme?.color ?? context.tTheme.brandNormalColor;
    final animationDuration =
        theme?.animationDuration ?? const Duration(milliseconds: 300);

    return _ProgressIndicator(
      value: value,
      label: label,
      onTap: onTap,
      onLongPress: onLongPress,
      progressLabelPosition: progressLabelPosition,
      strokeWidth: strokeWidth,
      circleRadius: circleRadius,
      linearBorderRadius: linearBorderRadius,
      color: color,
      backgroundColor: backgroundColor,
      type: variant,
      showLabel: showLabel,
      labelWidgetWidth: labelWidgetWidth,
      labelWidgetAlignment: labelWidgetAlignment,
      animationDuration: animationDuration,
    );
  }

  _DefaultValues _getDefaultValues(
      BuildContext context, TProgressVariant type) {
    switch (type) {
      case TProgressVariant.linear:
        return _DefaultValues(
          strokeWidth: 20.0,
          backgroundColor: context.tTheme.bgColorComponent,
          linearBorderRadius: BorderRadius.circular(20),
          circleRadius: 0,
        );
      case TProgressVariant.circular:
        return _DefaultValues(
          strokeWidth: 5.0,
          backgroundColor: context.tTheme.bgColorComponent,
          linearBorderRadius: BorderRadius.circular(20),
          circleRadius: 100.0,
        );
      case TProgressVariant.micro:
        return _DefaultValues(
          strokeWidth: 2.0,
          backgroundColor: context.tTheme.bgColorComponent,
          linearBorderRadius: BorderRadius.circular(20),
          circleRadius: 25.0,
        );
      case TProgressVariant.button:
        return _DefaultValues(
          strokeWidth: 50.0,
          backgroundColor: context.tTheme.brandNormalColor,
          linearBorderRadius: BorderRadius.circular(8),
          circleRadius: 0,
        );
    }
  }
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
  final Widget? label;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final TProgressLabelPosition progressLabelPosition;
  final double strokeWidth;
  final double circleRadius;
  final BorderRadiusGeometry linearBorderRadius;
  final Color color;
  final Color backgroundColor;
  final TProgressVariant type;
  final bool showLabel;
  final double? labelWidgetWidth;
  final Alignment? labelWidgetAlignment;
  final Duration animationDuration;

  const _ProgressIndicator({
    Key? key,
    this.value,
    this.label,
    this.onTap,
    this.onLongPress,
    this.progressLabelPosition = TProgressLabelPosition.inside,
    required this.strokeWidth,
    required this.linearBorderRadius,
    required this.circleRadius,
    required this.color,
    required this.backgroundColor,
    required this.type,
    this.showLabel = true,
    this.labelWidgetWidth,
    this.labelWidgetAlignment,
    this.animationDuration = const Duration(milliseconds: 300),
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
    _animationController =
        AnimationController(vsync: this, duration: widget.animationDuration);
    _updateAnimation();
    _updateEffectiveColor();
    _updateEffectiveLabel();
  }

  @override
  void didUpdateWidget(_ProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _updateAnimation(oldWidgetValue: oldWidget.value);
      _updateEffectiveLabel();
    }
    if (oldWidget.color != widget.color) {
      _updateEffectiveColor();
    }
    if (oldWidget.label != widget.label) {
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
    _animation = Tween<double>(
            begin: oldWidgetValue ?? _animationController.value,
            end: widget.value ?? 0)
        .animate(_animationController);
    _animationController.forward(from: 0);
  }

  Widget _getDefaultLabel() {
    final showAutoText = widget.value != null;

    Widget getAutoText() =>
        showAutoText && widget.type != TProgressVariant.micro
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
    if (widget.value == null) {
      return _buildIndeterminate();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.type == TProgressVariant.linear)
          _buildLinearProgress()
        else if (widget.type == TProgressVariant.circular)
          _buildCircularProgress()
        else if (widget.type == TProgressVariant.micro)
          _buildMicroProgress()
        else if (widget.type == TProgressVariant.button)
          _buildButtonProgress()
      ],
    );
  }

  Widget _buildIndeterminate() {
    switch (widget.type) {
      case TProgressVariant.linear:
      case TProgressVariant.button:
        return LinearProgressIndicator(
          minHeight: widget.strokeWidth,
          color: _effectiveColor,
          backgroundColor: widget.backgroundColor,
          borderRadius: widget.linearBorderRadius is BorderRadius
              ? widget.linearBorderRadius as BorderRadius
              : null,
        );
      case TProgressVariant.circular:
      case TProgressVariant.micro:
        return SizedBox.square(
          dimension: widget.circleRadius,
          child: CircularProgressIndicator(
            strokeWidth: widget.strokeWidth,
            color: _effectiveColor,
            backgroundColor: widget.backgroundColor,
          ),
        );
    }
  }

  Widget _buildLinearProgress() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        if (widget.value != null &&
            widget.progressLabelPosition == TProgressLabelPosition.inside) {
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
            ));
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
          textDirection:
              widget.progressLabelPosition == TProgressLabelPosition.right
                  ? TextDirection.rtl
                  : TextDirection.ltr,
          children: [
            Container(
              alignment: widget.labelWidgetAlignment ??
                  (widget.progressLabelPosition == TProgressLabelPosition.left
                      ? Alignment.centerRight
                      : Alignment.centerLeft),
              constraints:
                  BoxConstraints(minWidth: widget.labelWidgetWidth ?? 0),
              child: _buildLabelWidget(context.tTheme.textColorPrimary),
            ),
            SizedBox(width: context.tTheme.spacer8),
            Expanded(
              child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(context.tTheme.radiusRound),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          _buildBackgroundContainer(),
                          Container(
                            height: widget.strokeWidth,
                            width: constraints.maxWidth * _animation.value,
                            decoration: BoxDecoration(
                              color: _effectiveColor,
                              borderRadius: widget.linearBorderRadius,
                            ),
                          ),
                        ],
                      );
                    },
                  )),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBackgroundContainer() {
    return Container(
      height: widget.strokeWidth,
      decoration: BoxDecoration(
        borderRadius: widget.linearBorderRadius,
        color: widget.backgroundColor,
      ),
    );
  }

  Widget _buildProgressContainerWithLabel(double progressWidth) {
    return Container(
      height: widget.strokeWidth,
      width: progressWidth,
      decoration: BoxDecoration(
        color: _effectiveColor,
        borderRadius: widget.linearBorderRadius,
      ),
      child: widget.showLabel
          ? Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: _buildLabelWidget(context.tTheme.textColorAnti),
              ),
            )
          : null,
    );
  }

  Widget _buildProgressContainerWithLabelOutside(double progressWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: widget.strokeWidth,
          width: progressWidth,
          decoration: BoxDecoration(
            color: _effectiveColor,
            borderRadius: BorderRadius.only(
              topLeft:
                  widget.linearBorderRadius.resolve(TextDirection.ltr).topLeft,
              bottomLeft: widget.linearBorderRadius
                  .resolve(TextDirection.ltr)
                  .bottomLeft,
              topRight: Radius.circular(widget.linearBorderRadius
                  .resolve(TextDirection.ltr)
                  .topRight
                  .x),
              bottomRight: Radius.circular(widget.linearBorderRadius
                  .resolve(TextDirection.ltr)
                  .bottomRight
                  .x),
            ),
          ),
        ),
        if (widget.showLabel)
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
        if (widget.progressLabelPosition != TProgressLabelPosition.inside) {
          fontSize = widget.strokeWidth > 14 ? widget.strokeWidth : 14;
          iconSize = widget.strokeWidth > 20 ? widget.strokeWidth : 20;
        } else {
          fontSize = widget.strokeWidth * 0.6;
          iconSize = widget.strokeWidth;
        }
        fontWeight = FontWeight.normal;
        break;
      case TProgressVariant.circular:
        iconSize = widget.circleRadius * 0.4;
        fontSize = widget.circleRadius * 0.15;
        fontWeight = FontWeight.bold;
        break;
      case TProgressVariant.micro:
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

    return IconTheme(
      data: IconThemeData(color: _effectiveColor, size: iconSize),
      child: DefaultTextStyle(
        style: TextStyle(
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
            if (widget.showLabel)
              _buildLabelWidget(context.tTheme.textColorPrimary),
          ],
        );
      },
    );
  }

  Widget _buildMicroProgress() {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return GestureDetector(
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildMicroOutline(),
                if (widget.showLabel)
                  _buildLabelWidget(context.tTheme.textColorPrimary),
              ],
            ),
          );
        });
  }

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
                  onTap: widget.onTap,
                  onLongPress: widget.onLongPress,
                  child: Stack(
                    children: [
                      _buildBackgroundContainer(),
                      _buildButtonActiveContainer(progressWidth),
                      if (widget.showLabel) _buildButtonLabel(maxWidth),
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  Widget _buildButtonActiveContainer(double progressWidth) {
    return Container(
      height: widget.strokeWidth,
      width: progressWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _effectiveColor,
            context.tTheme.brandDisabledColor.withValues(alpha: .5)
          ],
        ),
      ),
    );
  }

  Widget _buildButtonLabel(double maxWidth) {
    return Container(
      height: widget.strokeWidth,
      alignment: Alignment.center,
      child: _buildLabelWidget(context.tTheme.fontWhColor1),
    );
  }
}
