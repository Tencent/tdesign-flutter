import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

enum ProgressType { linear, circular, micro, button }

enum ProgressLabelPosition { inside, left, right }

enum ProgressStatus { primary, warning, danger, success }

enum ProgressStrokeCap { round, square, butt }

enum ProgressAnimationCurve { easeIn, easeOut, easeInout }

abstract class TDLabelWidget extends Widget {
  const TDLabelWidget({super.key});
}

class TDTextLabel extends Text implements TDLabelWidget {
  const TDTextLabel(String data, {Key? key, TextStyle? style})
      : super(data, key: key, style: style);
}

class TDIconLabel extends Icon implements TDLabelWidget {
  const TDIconLabel(IconData icon, {Key? key, double? size, Color? color})
      : super(icon, key: key, size: size, color: color);
}

/// 进度条组件
class TDProgress extends StatelessWidget {
  /// 进度条类型
  final ProgressType type;

  /// 进度值 (0.0 到 1.0 之间的正数)
  final double? value;

  /// 进度条标签
  final TDLabelWidget? label;

  /// 进度条状态
  final ProgressStatus progressStatus;

  /// 标签显示位置
  final ProgressLabelPosition progressLabelPosition;

  /// 进度条粗细 (正数)
  final double? strokeWidth;

  /// 进度条颜色
  final Color? color;

  /// 进度条背景颜色
  final Color? backgroundColor;

  /// 进度条末端形状
  final ProgressStrokeCap? strokeCap;

  /// 环形进度条半径 (正数)
  final double? circleRadius;

  /// 是否显示标签
  final bool showLabel;

  /// 点击事件
  final VoidCallback? onTap;

  /// 长按事件
  final VoidCallback? onLongPress;

  /// 动画持续时间 (正整数，单位为毫秒)
  final int? animationDuration;

  TDProgress({
    Key? key,
    required this.type,
    double? value,
    this.label,
    this.progressStatus = ProgressStatus.primary,
    this.progressLabelPosition = ProgressLabelPosition.inside,
    double? strokeWidth,
    this.color,
    this.backgroundColor,
    this.strokeCap,
    double? circleRadius,
    this.showLabel = true,
    this.onTap,
    this.onLongPress,
    int animationDuration = 300,
  })  : value = _validateProgress(value),
        strokeWidth = _validatePositiveDouble(strokeWidth),
        circleRadius = _validatePositiveDouble(circleRadius),
        animationDuration = _validatePositiveInt(animationDuration),
        super(key: key);

  static double? _validateProgress(double? value) =>
      value == null ? null : value.clamp(0.0, 1.0);

  static double? _validatePositiveDouble(double? value) =>
      value == null ? null : value <= 0 ? 0 : value;

  static int _validatePositiveInt(int? value) =>
      value == null || value <= 0 ? 0 : value;


  @override
  Widget build(BuildContext context) {
    final defaultValues = _getDefaultValues(type);
    return ProgressIndicator(
      value: value,
      label: label,
      progressStatus: progressStatus,
      progressLabelPosition: progressLabelPosition,
      strokeWidth: strokeWidth ?? defaultValues.strokeWidth,
      color: color,
      backgroundColor: backgroundColor ?? defaultValues.backgroundColor,
      strokeCap: strokeCap ?? defaultValues.strokeCap,
      circleRadius: circleRadius ?? defaultValues.circleRadius,
      showLabel: showLabel,
      onTap: onTap,
      onLongPress: onLongPress,
      type: type,

    );
  }

  _DefaultValues _getDefaultValues(ProgressType type) {
    switch (type) {
      case ProgressType.linear:
        return _DefaultValues(
          strokeWidth: 20.0,
          backgroundColor: TDTheme.of().grayColor3,
          strokeCap: ProgressStrokeCap.round,
          circleRadius: 0,
        );
      case ProgressType.circular:
        return _DefaultValues(
          strokeWidth: 5.0,
          backgroundColor: TDTheme.of().grayColor2,
          strokeCap: ProgressStrokeCap.round,
          circleRadius: 80.0,
        );
      case ProgressType.micro:
        return _DefaultValues(
          strokeWidth: 2.0,
          backgroundColor: TDTheme.of().grayColor2,
          strokeCap: ProgressStrokeCap.round,
          circleRadius: 20.0,
        );
      case ProgressType.button:
        return _DefaultValues(
          strokeWidth: 60.0,
          backgroundColor: TDTheme.of().brandNormalColor,
          strokeCap: ProgressStrokeCap.butt,
          circleRadius: 0,
        );
    }
  }
}

class _DefaultValues {
  final double strokeWidth;
  final Color backgroundColor;
  final ProgressStrokeCap strokeCap;
  final double circleRadius;

  _DefaultValues({
    required this.strokeWidth,
    required this.backgroundColor,
    required this.strokeCap,
    required this.circleRadius,
  });
}

/// 构建工具类
class ProgressIndicator extends StatefulWidget {
  final double? value;
  final TDLabelWidget? label;
  final ProgressLabelPosition progressLabelPosition;
  final double strokeWidth;
  final double circleRadius;
  final ProgressStrokeCap strokeCap;
  final Color? color;
  final Color backgroundColor;
  final ProgressType type;
  final ProgressStatus progressStatus;
  final bool showLabel;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final int animationDuration;

  const ProgressIndicator({
    Key? key,
    this.value,
    this.label,
    this.progressLabelPosition = ProgressLabelPosition.inside,
    required this.strokeWidth,
    required this.strokeCap,
    required this.circleRadius,
    this.color,
    required this.backgroundColor,
    required this.type,
    this.progressStatus = ProgressStatus.primary,
    this.showLabel = true,
    this.onTap,
    this.onLongPress,
    this.animationDuration = 300,
  }) : super(key: key);

  @override
  _ProgressIndicatorState createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
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
      duration: Duration(milliseconds: widget.animationDuration),
    );
    _updateAnimation();
    _updateEffectiveColor();
    _updateEffectiveLabel();
  }

  @override
  void didUpdateWidget(ProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _updateAnimation(oldWidgetValue: oldWidget.value);
    }
    if (oldWidget.color != widget.color ||
        oldWidget.progressStatus != widget.progressStatus) {
      _updateEffectiveColor();
    }
    if (oldWidget.label != widget.label ||
        oldWidget.progressStatus != widget.progressStatus) {
      _updateEffectiveLabel();
    }
  }

  BorderRadius _getBorderRadius() {
    switch (widget.strokeCap) {
      case ProgressStrokeCap.round:
        return BorderRadius.circular(widget.strokeWidth / 2);
      case ProgressStrokeCap.square:
        return BorderRadius.zero;
      case ProgressStrokeCap.butt:
        return BorderRadius.circular(widget.strokeWidth / 6);
    }
  }

  void _updateEffectiveColor() {
    _effectiveColor =
        widget.color ?? _getColorFromStatus(widget.progressStatus);
  }

  void _updateEffectiveLabel() {
    _effectiveLabel =
        widget.label ?? _getDefaultLabelFromStatus(widget.progressStatus);
  }

  void _updateAnimation({double? oldWidgetValue}) {
    _animation = Tween<double>(begin: oldWidgetValue ?? _animationController.value, end: widget.value)
        .animate(_animationController);
    _animationController.forward(from: 0);
  }

  Widget _getDefaultLabelFromStatus(ProgressStatus status) {
    final showAutoText = widget.value != null;
    final showInsideLabel =
        widget.progressLabelPosition == ProgressLabelPosition.inside &&
            widget.type != ProgressType.circular;
    final showIconBorder = widget.type == ProgressType.linear;

    Widget getAutoText() => showAutoText && widget.type != ProgressType.micro
        ? Text('${(widget.value! * 100).round()}%')
        : const Text('');

    final statusWidgets = {
      ProgressStatus.primary: getAutoText(),
      ProgressStatus.warning: showInsideLabel
          ? getAutoText()
          : showIconBorder
              ? const Icon(TDIcons.error_circle_filled)
              : const Icon(TDIcons.error),
      ProgressStatus.danger: showInsideLabel
          ? getAutoText()
          : showIconBorder
              ? const Icon(TDIcons.close_circle_filled)
              : const Icon(TDIcons.close),
      ProgressStatus.success: showInsideLabel
          ? getAutoText()
          : showIconBorder
              ? const Icon(TDIcons.check_circle_filled)
              : const Icon(TDIcons.check),
    };

    return statusWidgets[status] ?? getAutoText();
  }

  Color _getColorFromStatus(ProgressStatus status) {
    switch (status) {
      case ProgressStatus.primary:
        return TDTheme.of().brandNormalColor;
      case ProgressStatus.warning:
        return TDTheme.of().warningNormalColor;
      case ProgressStatus.danger:
        return TDTheme.of().errorNormalColor;
      case ProgressStatus.success:
        return TDTheme.of().successNormalColor;
    }
  }

  StrokeCap _getFlutterStrokeCap(ProgressStrokeCap cap) {
    switch (cap) {
      case ProgressStrokeCap.round:
        return StrokeCap.round;
      case ProgressStrokeCap.square:
        return StrokeCap.square;
      case ProgressStrokeCap.butt:
        return StrokeCap.butt;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.type == ProgressType.linear)
          _buildLinearProgress()
        else if (widget.type == ProgressType.circular)
          _buildCircularProgress()
        else if (widget.type == ProgressType.micro)
          _buildMicroProgress()
        else if (widget.type == ProgressType.button)
          _buildButtonProgress()
      ],
    );
  }

  Widget _buildLinearProgress() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        if (widget.value != null &&
            widget.progressLabelPosition == ProgressLabelPosition.inside) {
          return _buildInsideLabel(maxWidth);
        } else {
          return _buildOutsideLabel();
        }
      },
    );
  }

  Widget _buildInsideLabel(double maxWidth) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final progressWidth = _animation.value * maxWidth;
        return Stack(
          children: [
            _buildBackgroundContainer(),
            if (widget.value! > 0.1)
              _buildProgressContainerWithLabel(progressWidth)
            else
              _buildProgressContainerWithLabelOutside(progressWidth),
          ],
        );
      },
    );
  }

  Widget _buildOutsideLabel() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.progressLabelPosition == ProgressLabelPosition.left)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _buildLabelWidget(TDTheme.of().fontGyColor1),
              ),
            Expanded(
              child: LinearProgressIndicator(
                borderRadius: _getBorderRadius(),
                value: widget.value != null ? _animation.value : null,
                backgroundColor: widget.backgroundColor,
                valueColor: AlwaysStoppedAnimation<Color>(_effectiveColor),
                minHeight: widget.strokeWidth,
              ),
            ),
            if (widget.progressLabelPosition == ProgressLabelPosition.right)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: _buildLabelWidget(TDTheme.of().fontGyColor1),
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
        borderRadius: _getBorderRadius(),
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
        borderRadius: _getBorderRadius(),
      ),
      child: widget.showLabel
          ? Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: _buildLabelWidget(TDTheme.of().fontWhColor1),
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
            borderRadius: _getBorderRadius(),
          ),
        ),
        if (widget.showLabel)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: _buildLabelWidget(TDTheme.of().fontGyColor1),
          ),
      ],
    );
  }

  Widget _buildLabelWidget(Color labelColor) {
    late double iconSize;
    late double fontSize;
    late FontWeight fontWeight;

    switch (widget.type) {
      case ProgressType.linear:
        if (widget.progressLabelPosition != ProgressLabelPosition.inside) {
          fontSize = widget.strokeWidth > 14 ? widget.strokeWidth : 14;
          iconSize = widget.strokeWidth > 20 ? widget.strokeWidth : 20;
        } else {
          fontSize = widget.strokeWidth * 0.6;
          iconSize = widget.strokeWidth;
        }
        fontWeight = FontWeight.normal;
        break;
      case ProgressType.circular:
        iconSize = widget.circleRadius * 0.4;
        fontSize = widget.circleRadius * 0.2;
        fontWeight = FontWeight.bold;
        break;
      case ProgressType.micro:
        iconSize = widget.circleRadius * 0.6;
        fontSize = widget.circleRadius * 0.2;
        fontWeight = FontWeight.normal;
        break;
      case ProgressType.button:
        iconSize = widget.strokeWidth * 0.8;
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
                child: CircularProgressIndicator(
                  value: widget.value != null ? _animation.value : null,
                  backgroundColor: widget.backgroundColor,
                  strokeCap: _getFlutterStrokeCap(widget.strokeCap),
                  valueColor: AlwaysStoppedAnimation<Color>(_effectiveColor),
                  strokeWidth: widget.strokeWidth,
                ),
              ),
            ),
            if (widget.showLabel) _buildLabelWidget(TDTheme.of().fontGyColor1),
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
                    _buildLabelWidget(TDTheme.of().fontGyColor1),
                ],
              ));
        });
  }

  Widget _buildMicroOutline() {
    return SizedBox(
      height: widget.circleRadius,
      width: widget.circleRadius,
      child: Padding(
        padding: EdgeInsets.all(widget.strokeWidth / 2),
        child: CircularProgressIndicator(
          value: widget.value != null ? _animation.value : null,
          backgroundColor: widget.backgroundColor,
          strokeCap: _getFlutterStrokeCap(widget.strokeCap),
          valueColor: AlwaysStoppedAnimation<Color>(_effectiveColor),
          strokeWidth: widget.strokeWidth,
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
                borderRadius: _getBorderRadius(),
                child: GestureDetector(
                    onTap: widget.onTap,
                    onLongPress: widget.onLongPress,
                    child: Stack(
                      children: [
                        _buildBackgroundContainer(),
                        _buildButtonActiveContainer(progressWidth),
                        if (widget.showLabel) _buildButtonLabel(maxWidth),
                      ],
                    )),
              );
            });
      },
    );
  }

  Widget _buildButtonActiveContainer(double progressWidth) {
    return Container(
      height: widget.strokeWidth,
      width: progressWidth,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x0096bbf8), Color(0x8096bbf8)],
        ),
      ),
    );
  }

  Widget _buildButtonLabel(double maxWidth) {
    return Container(
      height: widget.strokeWidth,
      alignment: Alignment.center,
      child: _buildLabelWidget(TDTheme.of().fontWhColor1),
    );
  }
}
