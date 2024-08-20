import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

// 用于区分线性和圆形进度条的枚举
enum _ProgressType { linear, circular, micro, button }

//label位置的枚举
enum ProgressLabelPosition { inside, left, right }

//status枚举
enum ProgressStatus { primary, warning, danger, success }

// label 类型的辅助类
abstract class LabelWidget extends Widget {
  const LabelWidget({super.key});
}

class TextLabel extends Text implements LabelWidget {
  const TextLabel(String data, {Key? key, TextStyle? style})
      : super(data, key: key, style: style);
}

class IconLabel extends Icon implements LabelWidget {
  const IconLabel(IconData icon, {Key? key, double? size, Color? color})
      : super(icon, key: key, size: size, color: color);
}

/// progress工具类
class Progress {
  Progress._();

  /// 创建线性进度条
  static Widget linear<T extends LabelWidget>(
      {Key? key,
      double? value,
      T? label,
      ProgressStatus progressStatus = ProgressStatus.primary,
      ProgressLabelPosition progressLabelPosition =
          ProgressLabelPosition.inside,
      double strokeWidth = 20.0,
      Color? color,
      Color backgroundColor = const Color(0xFFEEEEEE),
      BorderRadiusGeometry borderRadius =
          const BorderRadius.all(Radius.circular(20)),
      bool showLabel = true}) {
    return _ProgressIndicator<T>(
        key: key,
        value: value,
        label: label,
        progressStatus: progressStatus,
        progressLabelPosition: progressLabelPosition,
        strokeWidth: strokeWidth,
        color: color,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        showLabel: showLabel,
        type: _ProgressType.linear);
  }

  /// 创建圆形进度条
  static Widget circular<T extends LabelWidget>({
    Key? key,
    double? value,
    T? label,
    ProgressStatus progressStatus = ProgressStatus.primary,
    double strokeWidth = 5.0,
    Color? color,
    Color backgroundColor = const Color(0xFFEEEEEE),
    double circleRadius = 80.0,
    bool showLabel = true,
  }) {
    return _ProgressIndicator<T>(
      key: key,
      value: value,
      label: label,
      progressStatus: progressStatus,
      strokeWidth: strokeWidth,
      color: color,
      backgroundColor: backgroundColor,
      circleRadius: circleRadius,
      showLabel: showLabel,
      type: _ProgressType.circular,
    );
  }

  //构建微型进度条
  static Widget micro<T extends LabelWidget>(
      {Key? key,
      double? value,
      T? label,
      ProgressStatus progressStatus = ProgressStatus.primary,
      double strokeWidth = 2.0,
      Color? color,
      Color backgroundColor = const Color(0xFFEEEEEE),
      double circleRadius = 20.0,
      VoidCallback? onTap,
      VoidCallback? onLongPress,
      bool showLabel = true}) {
    return _ProgressIndicator(
      key: key,
      value: value,
      label: label ?? const TextLabel(""),
      progressStatus: progressStatus,
      strokeWidth: strokeWidth,
      color: color,
      backgroundColor: backgroundColor,
      circleRadius: circleRadius,
      onTap: onTap,
      onLongPress: onLongPress,
      showLabel: showLabel,
      type: _ProgressType.micro,
    );
  }

  // 构建按钮进度条
  static Widget button<T extends LabelWidget>(
      {Key? key,
      double? value,
      T? label,
      ProgressStatus progressStatus = ProgressStatus.primary,
      ProgressLabelPosition progressLabelPosition =
          ProgressLabelPosition.inside,
      double strokeWidth = 60.0,
      Color? color,
      Color backgroundColor = Colors.blue,
      BorderRadiusGeometry borderRadius =
          const BorderRadius.all(Radius.circular(10)),
      VoidCallback? onTap,
      VoidCallback? onLongPress,
      bool showLabel = true}) {
    return _ProgressIndicator<T>(
        key: key,
        value: value,
        label: label,
        progressStatus: progressStatus,
        progressLabelPosition: progressLabelPosition,
        strokeWidth: strokeWidth,
        color: color,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        showLabel: showLabel,
        onTap: onTap,
        onLongPress: onLongPress,
        type: _ProgressType.button);
  }
}

// 构建进度条基础小部件类
class _ProgressIndicator<T extends LabelWidget> extends StatefulWidget {
  final double? value;
  final T? label;
  final ProgressLabelPosition progressLabelPosition;
  final double strokeWidth;
  final BorderRadiusGeometry borderRadius;
  final double circleRadius;
  final Color? color;
  final Color backgroundColor;
  final _ProgressType type;
  final StrokeCap strokeCap;
  final ProgressStatus progressStatus;
  final bool showLabel;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const _ProgressIndicator(
      {Key? key,
      this.value,
      this.label,
      this.progressLabelPosition = ProgressLabelPosition.inside,
      this.strokeWidth = 20.0,
      this.borderRadius = const BorderRadius.all(Radius.circular(20)),
      this.circleRadius = 80.0,
      this.color,
      this.backgroundColor = const Color(0xFFEEEEEE),
      this.type = _ProgressType.linear,
      this.strokeCap = StrokeCap.round,
      this.progressStatus = ProgressStatus.primary,
      this.showLabel = true,
      this.onTap,
      this.onLongPress})
      : super(key: key);

  @override
  _ProgressIndicatorState<T> createState() => _ProgressIndicatorState<T>();
}

class _ProgressIndicatorState<T extends LabelWidget>
    extends State<_ProgressIndicator<T>> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Color _effectiveColor;
  late Widget _effectiveLabel;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _updateAnimation();
    final int duration = (_animation.value * 1000).toInt();
    _animationController.duration = Duration(milliseconds: duration);
    _updateEffectiveColor();
    _updateEffectiveLabel();
  }

  @override
  void didUpdateWidget(_ProgressIndicator<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _updateAnimation();
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

  void _updateEffectiveColor() {
    _effectiveColor =
        widget.color ?? _getColorFromStatus(widget.progressStatus);
  }

  void _updateEffectiveLabel() {
    _effectiveLabel =
        widget.label ?? _getDefaultLabelFromStatus(widget.progressStatus);
  }

  void _updateAnimation() {
    _animation = Tween<double>(begin: 0, end: widget.value ?? 0)
        .animate(_animationController);
    _animationController.forward(from: 0);
  }

  //根据status构建默认参数
  Widget _getDefaultLabelFromStatus(ProgressStatus status) {
    final bool showAutoText = widget.value != null;
    final bool showInsideLabel =
        widget.progressLabelPosition == ProgressLabelPosition.inside &&
            widget.type != _ProgressType.circular;
    final bool showIconBorder = widget.type == _ProgressType.linear;
    // 生成自动文本
    Widget getAutoText() => showAutoText
        ? Text('${(widget.value! * 100).round()}%')
        : const Text("");

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

    return statusWidgets[status] ?? getAutoText(); // 如果状态不匹配，默认返回自动文本
  }

  //设置默认颜色
  Color _getColorFromStatus(ProgressStatus status) {
    switch (status) {
      case ProgressStatus.primary:
        return Colors.blue;
      case ProgressStatus.warning:
        return Colors.orange;
      case ProgressStatus.danger:
        return Colors.red;
      case ProgressStatus.success:
        return Colors.green;
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
        if (widget.type == _ProgressType.linear)
          _buildLinearProgress()
        else if (widget.type == _ProgressType.circular)
          _buildCircularProgress()
        else if (widget.type == _ProgressType.micro)
          _buildMicroProgress()
        else if (widget.type == _ProgressType.button)
          _buildButtonProgress()
      ],
    );
  }

  //构建条形指示器
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

  //构建百分比内显label
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

  //构建外显label
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
                child: _buildLabelWidget(Colors.black),
              ),
            Expanded(
              child: LinearProgressIndicator(
                borderRadius: widget.borderRadius,
                value: widget.value != null ? _animation.value : null,
                backgroundColor: widget.backgroundColor,
                valueColor: AlwaysStoppedAnimation<Color>(_effectiveColor),
                minHeight: widget.strokeWidth,
              ),
            ),
            if (widget.progressLabelPosition == ProgressLabelPosition.right)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: _buildLabelWidget(Colors.black),
              ),
          ],
        );
      },
    );
  }

  //构建进度条外容器
  Widget _buildBackgroundContainer() {
    return Container(
      height: widget.strokeWidth,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
      ),
    );
  }

  //构建内显label的进度条内容器
  Widget _buildProgressContainerWithLabel(double progressWidth) {
    return Container(
      height: widget.strokeWidth,
      width: progressWidth,
      decoration: BoxDecoration(
        color: _effectiveColor,
        borderRadius: widget.borderRadius,
      ),
      child: widget.showLabel
          ? Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: _buildLabelWidget(Colors.white),
              ),
            )
          : null,
    );
  }

  //构建外显label的进度条内容器
  Widget _buildProgressContainerWithLabelOutside(double progressWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: widget.strokeWidth,
          width: progressWidth,
          decoration: BoxDecoration(
            color: _effectiveColor,
            borderRadius: widget.borderRadius,
          ),
        ),
        if (widget.showLabel)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: _buildLabelWidget(Colors.black),
          ),
      ],
    );
  }

  //构建label基础容器
  Widget _buildLabelWidget(Color labelColor) {
    late double iconSize;
    late double fontSize;
    late FontWeight fontWeight;

    switch (widget.type) {
      case _ProgressType.linear:
        iconSize = widget.strokeWidth;
        fontSize = widget.strokeWidth * 0.6;
        fontWeight = FontWeight.normal;
        break;
      case _ProgressType.circular:
        iconSize = widget.circleRadius * 0.4;
        fontSize = widget.circleRadius * 0.2;
        fontWeight = FontWeight.bold;
        break;
      case _ProgressType.micro:
        iconSize = widget.circleRadius * 0.6;
        fontSize = widget.circleRadius * 0.2;
        fontWeight = FontWeight.normal;
        break;
      case _ProgressType.button:
        iconSize = widget.strokeWidth * 0.8;
        fontSize = widget.strokeWidth * 0.4;
        fontWeight = FontWeight.normal;
        break;
      default:
        iconSize = 20;
        fontSize = 12;
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

  // 构建圆形进度条
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
                  strokeCap: widget.strokeCap,
                  valueColor: AlwaysStoppedAnimation<Color>(_effectiveColor),
                  strokeWidth: widget.strokeWidth,
                ),
              ),
            ),
            if (widget.showLabel) _buildLabelWidget(Colors.black),
          ],
        );
      },
    );
  }

  //构建微型进度条
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
                if (widget.showLabel) _buildLabelWidget(Colors.black),
              ],
            )
          );
        }
    );
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
          strokeCap: widget.strokeCap,
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
            return GestureDetector(
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              child: Stack(
                children: [
                  _buildBackgroundContainer(),
                  _buildButtonActiveContainer(progressWidth),
                  if (widget.showLabel) _buildButtonLabel(maxWidth),
                ],
              )
            );
          }
        );
      },
    );
  }

  // 按钮进度条内容器
  Widget _buildButtonActiveContainer(double progressWidth) {
    return Container(
      height: widget.strokeWidth,
      width: progressWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [widget.backgroundColor, Colors.white.withOpacity(.2)]),
        borderRadius: widget.borderRadius,
      ),
    );
  }

  Widget _buildButtonLabel(double maxWidth) {
    return Container(
      height: widget.strokeWidth,
      alignment: Alignment.center,
      child: _buildLabelWidget(Colors.white),
    );
  }
}
