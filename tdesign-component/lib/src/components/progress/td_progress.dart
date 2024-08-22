import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

enum TDProgressType { linear, circular, micro, button }

enum TDProgressLabelPosition { inside, left, right }

enum TDProgressStatus { primary, warning, danger, success }

enum ProgressStrokeCap {
  round,
  square,
  butt,
}

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
  final TDProgressType type;

  /// 进度值
  final double? value;

  /// 进度条标签
  final TDLabelWidget? label;

  /// 进度条状态
  final TDProgressStatus progressStatus;

  /// 标签显示位置
  final TDProgressLabelPosition progressLabelPosition;

  /// 进度条粗细
  final double? strokeWidth;

  /// 进度条颜色
  final Color? color;

  /// 进度条背景颜色
  final Color? backgroundColor;

  /// 进度条末端形状
  final ProgressStrokeCap? strokeCap;

  /// 进度条背景圆角
  final double? circleRadius;

  /// 是否显示标签
  final bool showLabel;

  /// 点击事件
  final VoidCallback? onTap;

  /// 长按事件
  final VoidCallback? onLongPress;

  const TDProgress({
    Key? key,
    required this.type,
    double? value,
    this.label,
    this.progressStatus = TDProgressStatus.primary,
    this.progressLabelPosition = TDProgressLabelPosition.inside,
    this.strokeWidth,
    this.color,
    this.backgroundColor,
    this.strokeCap,
    this.circleRadius,
    this.showLabel = true,
    this.onTap,
    this.onLongPress,
  })  : value =
            (value == null) ? null : (value < 0 ? 0 : (value > 1 ? 1 : value)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultValues = _getDefaultValues(type);
    return MyProgressIndicator(
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

  _DefaultValues _getDefaultValues(TDProgressType type) {
    switch (type) {
      case TDProgressType.linear:
        return _DefaultValues(
          strokeWidth: 20.0,
          backgroundColor: TDTheme.of().grayColor3,
          strokeCap: ProgressStrokeCap.round,
          circleRadius: 0, // Not applicable for linear progress
        );
      case TDProgressType.circular:
        return _DefaultValues(
          strokeWidth: 5.0,
          backgroundColor: TDTheme.of().grayColor2,
          strokeCap: ProgressStrokeCap.round,
          circleRadius: 80.0,
        );
      case TDProgressType.micro:
        return _DefaultValues(
          strokeWidth: 2.0,
          backgroundColor: TDTheme.of().grayColor2,
          strokeCap: ProgressStrokeCap.round,
          circleRadius: 20.0,
        );
      case TDProgressType.button:
        return _DefaultValues(
          strokeWidth: 60.0,
          backgroundColor: TDTheme.of().brandNormalColor,
          strokeCap: ProgressStrokeCap.butt,
          circleRadius: 0, // Not applicable for button progress
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
class MyProgressIndicator extends StatefulWidget {
  final double? value;
  final TDLabelWidget? label;
  final TDProgressLabelPosition progressLabelPosition;
  final double strokeWidth;
  final double circleRadius;
  final ProgressStrokeCap strokeCap;
  final Color? color;
  final Color backgroundColor;
  final TDProgressType type;
  final TDProgressStatus progressStatus;
  final bool showLabel;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const MyProgressIndicator({
    Key? key,
    this.value,
    this.label,
    this.progressLabelPosition = TDProgressLabelPosition.inside,
    required this.strokeWidth,
    required this.strokeCap,
    required this.circleRadius,
    this.color,
    required this.backgroundColor,
    required this.type,
    this.progressStatus = TDProgressStatus.primary,
    this.showLabel = true,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  _ProgressIndicatorState createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<MyProgressIndicator>
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
      value: widget.value ?? 0,
      duration: Duration(
          milliseconds:
              widget.value != null ? (widget.value! * 1000).toInt() : 1000),
    );
    _updateAnimation();
    _updateEffectiveColor();
    _updateEffectiveLabel();
  }

  @override
  void didUpdateWidget(MyProgressIndicator oldWidget) {
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
    _animation = Tween<double>(begin: _animationController.value, end: widget.value ?? 0)
        .animate(_animationController);
    _animationController.forward(from: _animationController.value);
  }

  Widget _getDefaultLabelFromStatus(TDProgressStatus status) {
    final bool showAutoText = widget.value != null;
    final bool showInsideLabel =
        widget.progressLabelPosition == TDProgressLabelPosition.inside &&
            widget.type != TDProgressType.circular;
    final bool showIconBorder = widget.type == TDProgressType.linear;

    Widget getAutoText() => showAutoText && widget.type != TDProgressType.micro
        ? Text('${(widget.value! * 100).round()}%')
        : const Text('');

    final statusWidgets = {
      TDProgressStatus.primary: getAutoText(),
      TDProgressStatus.warning: showInsideLabel
          ? getAutoText()
          : showIconBorder
              ? const Icon(TDIcons.error_circle_filled)
              : const Icon(TDIcons.error),
      TDProgressStatus.danger: showInsideLabel
          ? getAutoText()
          : showIconBorder
              ? const Icon(TDIcons.close_circle_filled)
              : const Icon(TDIcons.close),
      TDProgressStatus.success: showInsideLabel
          ? getAutoText()
          : showIconBorder
              ? const Icon(TDIcons.check_circle_filled)
              : const Icon(TDIcons.check),
    };

    return statusWidgets[status] ?? getAutoText();
  }

  Color _getColorFromStatus(TDProgressStatus status) {
    switch (status) {
      case TDProgressStatus.primary:
        return TDTheme.of().brandNormalColor;
      case TDProgressStatus.warning:
        return TDTheme.of().warningNormalColor;
      case TDProgressStatus.danger:
        return TDTheme.of().errorNormalColor;
      case TDProgressStatus.success:
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
        if (widget.type == TDProgressType.linear)
          _buildLinearProgress()
        else if (widget.type == TDProgressType.circular)
          _buildCircularProgress()
        else if (widget.type == TDProgressType.micro)
          _buildMicroProgress()
        else if (widget.type == TDProgressType.button)
          _buildButtonProgress()
      ],
    );
  }

  Widget _buildLinearProgress() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        if (widget.value != null &&
            widget.progressLabelPosition == TDProgressLabelPosition.inside) {
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
            if (widget.progressLabelPosition == TDProgressLabelPosition.left)
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
            if (widget.progressLabelPosition == TDProgressLabelPosition.right)
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
      case TDProgressType.linear:
        if (widget.progressLabelPosition != TDProgressLabelPosition.inside) {
          fontSize = widget.strokeWidth > 14 ? widget.strokeWidth : 14;
          iconSize = widget.strokeWidth > 20 ? widget.strokeWidth : 20;
        } else {
          fontSize = widget.strokeWidth * 0.6;
          iconSize = widget.strokeWidth;
        }
        fontWeight = FontWeight.normal;
        break;
      case TDProgressType.circular:
        iconSize = widget.circleRadius * 0.4;
        fontSize = widget.circleRadius * 0.2;
        fontWeight = FontWeight.bold;
        break;
      case TDProgressType.micro:
        iconSize = widget.circleRadius * 0.6;
        fontSize = widget.circleRadius * 0.2;
        fontWeight = FontWeight.normal;
        break;
      case TDProgressType.button:
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
