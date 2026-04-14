import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

/// 水印类型
enum TWatermarkType {
  /// 单行文本
  singleLine,
  
  /// 多行文本
  multiLine,
}

/// 水印排列方式
enum TWatermarkLayout {
  /// 水平排列
  horizontal,
  
  /// 垂直排列
  vertical,
  
  /// 网格排列
  grid,
}

/// 水印组件
class TWatermark extends StatefulWidget {
  const TWatermark({
    Key? key,
    required this.text,
    this.type = TWatermarkType.multiLine,
    this.layout = TWatermarkLayout.grid,
    this.textColor,
    this.textSize = 14,
    this.fontWeight = FontWeight.normal,
    this.opacity = 0.15,
    this.rotate = -20,
    this.gapX = 100,
    this.gapY = 100,
    this.offsetX = 0,
    this.offsetY = 0,
    this.zIndex = 1,
    this.width,
    this.height,
    this.child,
  }) : super(key: key);

  /// 水印文本内容
  final String text;

  /// 水印类型
  final TWatermarkType type;

  /// 水印排列方式
  final TWatermarkLayout layout;

  /// 水印文字颜色
  final Color? textColor;

  /// 水印文字大小
  final double textSize;

  /// 水印文字粗细
  final FontWeight fontWeight;

  /// 水印透明度 (0.0 - 1.0)
  final double opacity;

  /// 水印旋转角度（度）
  final double rotate;

  /// 水平间距
  final double gapX;

  /// 垂直间距
  final double gapY;

  /// 水平偏移量
  final double offsetX;

  /// 垂直偏移量
  final double offsetY;

  /// z-index层级
  final int zIndex;

  /// 水印区域宽度
  final double? width;

  /// 水印区域高度
  final double? height;

  /// 子组件（水印将覆盖在此组件上方）
  final Widget? child;

  @override
  State<TWatermark> createState() => _TWatermarkState();
}

class _TWatermarkState extends State<TWatermark> {
  @override
  Widget build(BuildContext context) {
    final theme = TTheme.of(context);
    final textColor = widget.textColor ?? theme.textColorPlaceholder;

    return Stack(
      children: [
        // 子组件
        if (widget.child != null) widget.child!,

        // 水印层
        Positioned.fill(
          child: IgnorePointer(
            ignoring: true,
            child: CustomPaint(
              painter: _WatermarkPainter(
                text: widget.text,
                type: widget.type,
                layout: widget.layout,
                textColor: textColor.withOpacity(widget.opacity),
                textSize: widget.textSize,
                fontWeight: widget.fontWeight,
                rotate: widget.rotate,
                gapX: widget.gapX,
                gapY: widget.gapY,
                offsetX: widget.offsetX,
                offsetY: widget.offsetY,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 水印绘制器
class _WatermarkPainter extends CustomPainter {
  final String text;
  final TWatermarkType type;
  final TWatermarkLayout layout;
  final Color textColor;
  final double textSize;
  final FontWeight fontWeight;
  final double rotate;
  final double gapX;
  final double gapY;
  final double offsetX;
  final double offsetY;

  _WatermarkPainter({
    required this.text,
    required this.type,
    required this.layout,
    required this.textColor,
    required this.textSize,
    required this.fontWeight,
    required this.rotate,
    required this.gapX,
    required this.gapY,
    required this.offsetX,
    required this.offsetY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = textColor
      ..isAntiAlias = true;

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: textColor,
          fontSize: textSize,
          fontWeight: fontWeight,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final textWidth = textPainter.width;
    final textHeight = textPainter.height;

    // 根据布局方式绘制水印
    switch (layout) {
      case TWatermarkLayout.horizontal:
        _drawHorizontal(canvas, textPainter, size, textWidth, textHeight);
        break;
      case TWatermarkLayout.vertical:
        _drawVertical(canvas, textPainter, size, textWidth, textHeight);
        break;
      case TWatermarkLayout.grid:
        _drawGrid(canvas, textPainter, size, textWidth, textHeight);
        break;
    }
  }

  /// 水平排列
  void _drawHorizontal(
    Canvas canvas,
    TextPainter textPainter,
    Size size,
    double textWidth,
    double textHeight,
  ) {
    final centerY = size.height / 2 + offsetY;
    var currentX = offsetX;

    while (currentX < size.width) {
      _drawTextWithRotation(
        canvas,
        textPainter,
        Offset(currentX, centerY - textHeight / 2),
      );
      currentX += textWidth + gapX;
    }
  }

  /// 垂直排列
  void _drawVertical(
    Canvas canvas,
    TextPainter textPainter,
    Size size,
    double textWidth,
    double textHeight,
  ) {
    final centerX = size.width / 2 + offsetX;
    var currentY = offsetY;

    while (currentY < size.height) {
      _drawTextWithRotation(
        canvas,
        textPainter,
        Offset(centerX - textWidth / 2, currentY),
      );
      currentY += textHeight + gapY;
    }
  }

  /// 网格排列
  void _drawGrid(
    Canvas canvas,
    TextPainter textPainter,
    Size size,
    double textWidth,
    double textHeight,
  ) {
    var currentY = -textHeight + offsetY;

    while (currentY < size.height + textHeight) {
      var currentX = -textWidth + offsetX;

      while (currentX < size.width + textWidth) {
        _drawTextWithRotation(
          canvas,
          textPainter,
          Offset(currentX, currentY),
        );
        currentX += textWidth + gapX;
      }
      currentY += textHeight + gapY;
    }
  }

  /// 绘制带旋转的文本
  void _drawTextWithRotation(
    Canvas canvas,
    TextPainter textPainter,
    Offset position,
  ) {
    canvas.save();

    // 移动到文本中心点
    final center = Offset(
      position.dx + textPainter.width / 2,
      position.dy + textPainter.height / 2,
    );

    canvas.translate(center.dx, center.dy);
    // 旋转
    canvas.rotate(rotate * 3.1415926535897932 / 180);
    canvas.translate(-center.dx, -center.dy);

    // 绘制文本
    textPainter.paint(canvas, position);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WatermarkPainter oldDelegate) {
    return oldDelegate.text != text ||
        oldDelegate.type != type ||
        oldDelegate.layout != layout ||
        oldDelegate.textColor != textColor ||
        oldDelegate.textSize != textSize ||
        oldDelegate.fontWeight != fontWeight ||
        oldDelegate.rotate != rotate ||
        oldDelegate.gapX != gapX ||
        oldDelegate.gapY != gapY ||
        oldDelegate.offsetX != offsetX ||
        oldDelegate.offsetY != offsetY;
  }
}
