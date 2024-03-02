import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../tdesign_flutter.dart';

/// 组件大小
enum TDProgressSize {
  /// 小
  small,

  /// 中等
  medium,

  /// 大
  large;
}

/// 进度条状态
enum TDProgressStatus {
  /// 成功
  success,

  /// 错误
  error,

  /// 告警
  warning,

  /// 执行动画
  active;
}

/// 进度条风格。
/// 值为 line，标签（label）显示在进度条右侧；
/// 值为 plump，标签（label）显示在进度条里面；
/// 值为 circle，标签（label）显示在进度条正中间。
enum TDProgressTheme {
  /// 标签（label）显示在进度条右侧；
  line,

  /// 标签（label）显示在进度条里面；
  plump,

  /// 标签（label）显示在进度条正中间。
  circle;
}

/// 进度条组件
/// 展示操作的当前进度
class TDProgress extends ImplicitlyAnimatedWidget {
  const TDProgress({
    super.key,
    this.color,
    this.showLabel = true,
    this.label,
    this.percentage = 0,
    this.circleSize,
    this.size = TDProgressSize.medium,
    this.status,
    this.strokeWidth,
    this.theme = TDProgressTheme.line,
    this.trackColor,
    this.strokeCap = StrokeCap.round,
    this.textStyle,
    super.curve = Curves.linear,
    super.duration = const Duration(milliseconds: 200),
    super.onEnd,
  });

  /// 进度条颜色,多个颜色会形成渐变色
  final List<Color>? color;

  /// 是否显示标签
  final bool showLabel;

  /// 标签
  final Widget? label;

  /// 进度条百分比 0-100
  final double percentage;

  /// 环形进度条尺寸，不为空则覆盖[size]中的默认值
  final Size? circleSize;

  /// 进度条尺寸
  final TDProgressSize size;

  /// 进度条状态
  final TDProgressStatus? status;

  /// 进度条线宽。宽度数值不能超过 size 的一半，否则不能输出环形进度
  final double? strokeWidth;

  /// 进度条风格。
  /// 值为 line，标签（label）显示在进度条右侧；
  /// 值为 plump，标签（label）显示在进度条里面；
  /// 值为 circle，标签（label）显示在进度条正中间。
  final TDProgressTheme theme;

  /// 进度条未完成部分颜色
  final Color? trackColor;

  /// 线条末端的形状
  final StrokeCap strokeCap;

  /// 文本样式
  final TextStyle? textStyle;

  @override
  AnimatedWidgetBaseState<TDProgress> createState() => _TProgressState();
}

class _TProgressState extends AnimatedWidgetBaseState<TDProgress> {
  late Tween<double> _percentage;

  /// 动画进度
  double get animationPercentage => _percentage.evaluate(animation);

  /// 实时进度
  double get percentage => widget.percentage.clamp(0, 100);

  /// 如果是默认状态，则值100时变更为success状态
  TDProgressStatus? get status {
    if (widget.status == null) {
      if (animationPercentage >= 100.0) {
        return TDProgressStatus.success;
      } else {
        return null;
      }
    } else if (widget.status == TDProgressStatus.active && animationPercentage >= 100) {
      return TDProgressStatus.success;
    }
    return widget.status;
  }

  @override
  void initState() {
    _percentage = Tween<double>(begin: percentage, end: percentage);
    super.initState();
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _percentage = visitor(
      _percentage,
      widget.percentage.clamp(0.0, 100.0),
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>;
  }

  Font _getCircleTextFont() {
    switch (widget.size) {
      case TDProgressSize.large:
        return Font(size: 36, lineHeight: 36);
      case TDProgressSize.medium:
        return Font(size: 20, lineHeight: 20);
      case TDProgressSize.small:
        return Font(size: 14, lineHeight: 14);
    }
  }

  /// 构建标签
  Widget? _buildLabel(TDThemeData theme) {
    var label = widget.label;
    IconThemeData? iconThemeData;
    TextStyle style;
    switch (widget.theme) {
      case TDProgressTheme.line:
        var fontBodyMedium = theme.fontBodyLarge ?? Font(size: 16, lineHeight: 24);
        var iconSize = fontBodyMedium.size;
        style = TextStyle(
          fontSize: fontBodyMedium.size,
          color: theme.fontGyColor1,
          overflow: TextOverflow.ellipsis,
        );
        switch (widget.status) {
          case TDProgressStatus.success:
            iconThemeData = IconThemeData(
              color: theme.successNormalColor,
              size: iconSize,
            );
            label ??= const Icon(TDIcons.check_circle_filled);
            break;
          case TDProgressStatus.error:
            iconThemeData = IconThemeData(
              color: theme.errorNormalColor,
              size: iconSize,
            );
            label ??= const Icon(TDIcons.close_circle_filled);
            break;
          case TDProgressStatus.warning:
            iconThemeData = IconThemeData(
              color: theme.warningNormalColor,
              size: iconSize,
            );
            label ??= const Icon(TDIcons.error_circle_filled);
            break;
          default:
            label ??= Text('${(percentage).round()}%');
        }
        break;
      case TDProgressTheme.plump:
        Color fontColor;
        if (animationPercentage <= 10) {
          fontColor = theme.fontGyColor1;
        } else {
          fontColor = theme.whiteColor1;
        }
        var fontBodySmall = theme.fontBodyMedium ?? Font(size: 14, lineHeight: 22);
        style = TextStyle(
          fontSize: fontBodySmall.size,
          color: fontColor,
          overflow: TextOverflow.ellipsis,
        );
        label ??= Text('${(percentage).round()}%');
        break;
      case TDProgressTheme.circle:
        var font = _getCircleTextFont();
        var iconSize = font.size * 2.40;
        style = TextStyle(
          fontSize: font.size,
          height: font.height,
          color: theme.fontGyColor1,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.bold,
        );
        switch (widget.status) {
          case TDProgressStatus.success:
            iconThemeData = IconThemeData(
              color: theme.successNormalColor,
              size: iconSize,
            );
            label ??= const Icon(TDIcons.check);
            break;
          case TDProgressStatus.error:
            iconThemeData = IconThemeData(
              color: theme.errorNormalColor,
              size: iconSize,
            );
            label ??= const Icon(TDIcons.close);
            break;
          case TDProgressStatus.warning:
            iconThemeData = IconThemeData(
              color: theme.warningNormalColor,
              size: iconSize,
            );
            label ??= const Icon(TDIcons.error);
            break;
          default:
            label ??= Text('${(percentage).round()}%');
        }
        break;
    }
    if (iconThemeData != null) {
      label = IconTheme(data: iconThemeData, child: label);
    }
    label = DefaultTextStyle(style: style.merge(widget.textStyle), child: label);
    return label;
  }

  @override
  Widget build(BuildContext context) {
    var theme = TDTheme.of(context);
    var trackColor = widget.trackColor ?? theme.grayColor3;
    var size = widget.size;

    // 线宽
    var strokeWidth = widget.strokeWidth;
    if (strokeWidth == null) {
      switch (widget.theme) {
        case TDProgressTheme.line:
          strokeWidth = 6;
          break;
        case TDProgressTheme.plump:
          strokeWidth = 18;
          break;
        case TDProgressTheme.circle:
          strokeWidth = 6;
          break;
      }
    }

    // 线条颜色
    var color = widget.color;
    if (color == null || color.isEmpty) {
      switch (status) {
        case TDProgressStatus.success:
          color = [theme.successNormalColor];
          break;
        case TDProgressStatus.error:
          color = [theme.errorNormalColor];
          break;
        case TDProgressStatus.warning:
          color = [theme.warningNormalColor];
          break;
        default:
          color = [theme.brandNormalColor];
      }
    }

    // 运动状态
    var isAction = widget.status == TDProgressStatus.active && percentage < 100;
    switch (widget.theme) {
      case TDProgressTheme.line:
        var list = <Widget>[
          Expanded(
            child: _TDProgressActionPaint(
              action: isAction,
              willChange: isAction,
              isComplex: isAction,
              size: Size.fromHeight(strokeWidth),
              painter: (animation) {
                return _TDProgressLinePrinter(
                  percentage: animationPercentage,
                  strokeWidth: strokeWidth!,
                  color: color!,
                  trackColor: trackColor,
                  animation: animation,
                  actionColor: theme.whiteColor1,
                  strokeCap: widget.strokeCap,
                );
              },
            ),
          ),
        ];

        if (widget.showLabel) {
          var label = _buildLabel(theme);
          list.add(Padding(
            padding: EdgeInsets.only(left: theme.spacer8),
            child: label,
          ));
        }
        return Row(children: list);
      case TDProgressTheme.plump:
        Widget? label;
        if (widget.showLabel) {
          AlignmentGeometry alignment1;
          AlignmentGeometry alignment2;
          double widthFactor;
          if (animationPercentage > 10) {
            alignment1 = Alignment.centerLeft;
            alignment2 = Alignment.centerRight;
            widthFactor = animationPercentage / 100;
          } else {
            alignment1 = Alignment.centerRight;
            alignment2 = Alignment.centerLeft;
            widthFactor = 1 - animationPercentage / 100;
          }
          label = FractionallySizedBox(
            alignment: alignment1,
            widthFactor: widthFactor,
            child: Align(
              alignment: alignment2,
              child: Padding(
                padding: EdgeInsets.only(left: strokeWidth / 2 + theme.spacer8),
                child: _buildLabel(theme),
              ),
            ),
          );
        }
        return Container(
          constraints: BoxConstraints(
            minWidth: double.infinity,
            minHeight: strokeWidth,
          ),
          child: _TDProgressActionPaint(
            action: isAction,
            willChange: isAction,
            isComplex: isAction,
            painter: (animation) {
              return _TDProgressLinePrinter(
                percentage: animationPercentage,
                strokeWidth: strokeWidth!,
                color: color!,
                trackColor: trackColor,
                animation: animation,
                actionColor: theme.whiteColor1,
                strokeCap: widget.strokeCap,
              );
            },
            child: label,
          ),
        );
      case TDProgressTheme.circle:
        Widget? label;
        var boxSize = widget.circleSize;
        switch (size) {
          case TDProgressSize.small:
            boxSize ??= const Size.square(72);
            break;
          case TDProgressSize.medium:
            boxSize ??= const Size.square(112);
            break;
          case TDProgressSize.large:
            boxSize ??= const Size.square(160);
            break;
        }
        if (widget.showLabel) {
          label = Center(child: _buildLabel(theme));
        }
        return Container(
          constraints: BoxConstraints.tightFor(
            width: boxSize.width,
            height: boxSize.height,
          ),
          child: _TDProgressActionPaint(
            action: isAction,
            willChange: isAction,
            isComplex: isAction,
            painter: (animation) {
              return _TDProgressCirclePainter(
                percentage: animationPercentage,
                strokeWidth: strokeWidth!,
                color: color!,
                trackColor: trackColor,
                animation: animation,
                actionColor: theme.whiteColor1,
                strokeCap: widget.strokeCap,
              );
            },
            child: label,
          ),
        );
    }
  }
}

typedef AnimationPainter = CustomPainter Function(Animation<double> animation);

class _TDProgressActionPaint extends StatefulWidget {
  const _TDProgressActionPaint({
    this.painter,
    this.size = Size.zero,
    this.isComplex = false,
    this.willChange = false,
    this.child,
    required this.action,
  });

  /// 子组件
  final Widget? child;

  /// 继承自[CustomPaint.painter]
  final AnimationPainter? painter;

  /// 继承自[CustomPaint.size]
  final Size size;

  /// 继承自[CustomPaint.isComplex]
  final bool isComplex;

  /// 继承自[CustomPaint.willChange]
  final bool willChange;

  /// 是否是运动状态
  final bool action;

  @override
  State<_TDProgressActionPaint> createState() => _TDProgressActionPaintState();
}

/// 绘制active运动状态的进度条
class _TDProgressActionPaintState extends State<_TDProgressActionPaint> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late CurvedAnimation curvedAnimation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    curvedAnimation = CurvedAnimation(parent: _animationController, curve: const Cubic(.23, .99, .86, .2));
    if (widget.action) {
      _animationController.repeat();
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _TDProgressActionPaint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.action != oldWidget.action) {
      if (widget.action) {
        _animationController.repeat();
      } else {
        _animationController.value = 0;
        _animationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    curvedAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: widget.painter?.call(curvedAnimation),
      size: widget.size,
      isComplex: widget.isComplex,
      willChange: widget.willChange,
      child: widget.child,
    );
  }
}

/// 线条进度条绘制
class _TDProgressLinePrinter extends CustomPainter {
  const _TDProgressLinePrinter({
    required this.animation,
    required this.percentage,
    required this.color,
    required this.strokeWidth,
    required this.trackColor,
    required this.actionColor,
    required this.strokeCap,
  }) : super(repaint: animation);

  /// 动画
  final Animation<double> animation;

  /// 进度条百分比 0-100
  final double percentage;

  /// 进度条颜色,多个颜色会形成渐变色
  final List<Color> color;

  /// 进度条线宽。宽度数值不能超过 size 的一半，否则不能输出环形进度
  final double strokeWidth;

  /// 进度条未完成部分颜色
  final Color trackColor;

  /// 运动状态颜色
  final Color actionColor;

  /// 线条末端的形状
  final StrokeCap strokeCap;

  @override
  void paint(Canvas canvas, Size size) {
    // 圆角超出矩形部分
    var offset = Offset(strokeWidth / 2, 0);

    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = strokeCap
      ..color = trackColor
      ..strokeWidth = strokeWidth;

    // 轨道
    var p1 = size.centerLeft(Offset.zero) + offset;
    var p2 = size.centerRight(Offset.zero) - offset;
    if (p2.dx <= p1.dx) {
      return;
    }
    canvas.drawLine(p1, p2, paint);

    if (percentage == 0) {
      return;
    }
    var percentageSize = Size((size.width * percentage / 100).clamp(p1.dx, p2.dx), size.height);
    p2 = percentageSize.centerRight(Offset.zero);

    if (color.length >= 2) {
      Gradient gradient = LinearGradient(
        colors: color,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      );
      paint.shader = gradient.createShader(Offset.zero & percentageSize);
    } else {
      paint.color = color[0];
    }
    // 进度
    canvas.drawLine(p1, p2, paint);

    // action动画
    if (animation.value > 0) {
      var value = animation.value;
      if (value <= .35) {
        var tween = Tween<double>(begin: .1, end: .4);
        paint.color = actionColor.withOpacity(tween.transform(value));
      } else {
        var tween = Tween<double>(begin: .4, end: 0);
        paint.color = actionColor.withOpacity(tween.transform(value));
      }
      paint.shader = null;
      paint.strokeCap = strokeCap;
      canvas.drawLine(p1, Offset(max(p1.dx, p2.dx * value), p2.dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TDProgressLinePrinter oldDelegate) {
    return this != oldDelegate;
  }
}

/// 环形进度条绘制
class _TDProgressCirclePainter extends CustomPainter {
  const _TDProgressCirclePainter({
    required this.animation,
    required this.percentage,
    required this.color,
    required this.strokeWidth,
    required this.trackColor,
    required this.actionColor,
    required this.strokeCap,
  }) : super(repaint: animation);

  /// 动画
  final Animation<double> animation;

  /// 进度条百分比 0-100
  final double percentage;

  /// 进度条颜色,多个颜色会形成渐变色
  final List<Color> color;

  /// 进度条线宽。宽度数值不能超过 size 的一半，否则不能输出环形进度
  final double strokeWidth;

  /// 进度条未完成部分颜色
  final Color trackColor;

  /// 运动状态颜色
  final Color actionColor;

  /// 线条末端的形状
  final StrokeCap strokeCap;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = strokeCap
      ..strokeWidth = strokeWidth;

    var effectiveSize = Size(size.width - strokeWidth, size.height - strokeWidth);
    var offset = Offset(strokeWidth / 2, strokeWidth / 2);

    // 轨道
    paint.color = trackColor;
    canvas.drawArc(offset & effectiveSize, 0, pi * 2, false, paint);

    var endAngle = pi * 2 * (percentage / 100);
    if (endAngle == 0) {
      return;
    }
    if (color.length > 1) {
      var radians = (-pi / 2) - (strokeWidth * 4 / (pi * effectiveSize.width));
      Gradient gradient = SweepGradient(
        colors: color,
        endAngle: endAngle,
        transform: GradientRotation(radians),
      );
      paint.shader = gradient.createShader(offset & effectiveSize);
    } else {
      paint.color = color[0];
    }

    canvas.drawArc(offset & effectiveSize, -pi / 2, endAngle, false, paint);

    // action动画
    if (animation.value > 0) {
      var value = animation.value;
      if (value <= .35) {
        var tween = Tween<double>(begin: .1, end: .4);
        paint.color = actionColor.withOpacity(tween.transform(value));
      } else {
        var tween = Tween<double>(begin: .4, end: 0);
        paint.color = actionColor.withOpacity(tween.transform(value));
      }
      paint.shader = null;
      paint.strokeCap = strokeCap;
      canvas.drawArc(offset & effectiveSize, -pi / 2, endAngle * animation.value, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TDProgressCirclePainter oldDelegate) {
    return this != oldDelegate;
  }
}
