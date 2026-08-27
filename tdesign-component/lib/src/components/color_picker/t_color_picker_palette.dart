import 'package:flutter/material.dart';

import '../../util/t_color_object.dart';
import 't_color_picker_theme_data.dart';

/// 饱和度-明度二维色板。
///
/// 背景由当前色相决定基色，横向表示饱和度（左 0 → 右 100%），
/// 纵向表示明度（上 100% → 下 0%）。带可拖拽的 thumb。
class TColorPickerSaturationPanel extends StatefulWidget {
  const TColorPickerSaturationPanel({
    super.key,
    required this.color,
    required this.onChanged,
    this.theme,
  });

  /// 当前颜色对象（用于读取色相、饱和度、明度）。
  final TColorObject color;

  /// 拖拽过程中回调（更新饱和度/明度）。
  final ValueChanged<({double saturation, double value})> onChanged;

  /// 组件主题。
  final TColorPickerThemeData? theme;

  @override
  State<TColorPickerSaturationPanel> createState() =>
      _TColorPickerSaturationPanelState();
}

class _TColorPickerSaturationPanelState
    extends State<TColorPickerSaturationPanel> {
  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final height = theme?.saturationHeight ?? 144;
    final radius = theme?.saturationRadius ?? 6;
    final thumbSize = theme?.saturationThumbSize ?? 24;

    final hue = widget.color.hue;
    final baseColor = HSLColor.fromAHSL(1, hue, 1, 0.5).toColor();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final heightPx = height;

        Widget panel = ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ColoredBox(color: baseColor),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.transparent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              // 黑色渐变自下而上淡出，对齐 mobile-vue ::after（0deg）。
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        );

        final left = widget.color.saturation * width;
        final top = (1 - widget.color.value) * heightPx;

        final thumb = Positioned(
          left: left - thumbSize / 2,
          top: top - thumbSize / 2,
          child: Container(
            width: thumbSize,
            height: thumbSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.toFlutterColor(),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        );

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (details) {
            _update(details.localPosition, width, heightPx);
          },
          onPanUpdate: (details) =>
              _update(details.localPosition, width, heightPx),
          onPanEnd: (_) {},
          onPanCancel: () {},
          child: SizedBox(
            width: width,
            height: heightPx,
            child: Stack(
              clipBehavior: Clip.none,
              children: [panel, thumb],
            ),
          ),
        );
      },
    );
  }

  void _update(
    Offset position,
    double width,
    double heightPx,
  ) {
    final saturation = (position.dx / width).clamp(0.0, 1.0).toDouble();
    final value = (1 - position.dy / heightPx).clamp(0.0, 1.0).toDouble();
    widget.onChanged((saturation: saturation, value: value));
  }
}

/// 色相条 / 透明条。
///
/// 横向可拖拽滑块。色相条背景为彩虹渐变；透明条背景为当前颜色随 alpha 变化。
class TColorPickerSlider extends StatefulWidget {
  const TColorPickerSlider({
    super.key,
    required this.color,
    required this.isAlpha,
    required this.onChanged,
    this.theme,
  });

  /// 当前颜色对象。
  final TColorObject color;

  /// 是否为透明条（true）还是色相条（false）。
  final bool isAlpha;

  /// 拖拽落定回调。色相条返回 hue（0-360），透明条返回 alpha（0-1）。
  final ValueChanged<double> onChanged;

  /// 组件主题。
  final TColorPickerThemeData? theme;

  @override
  State<TColorPickerSlider> createState() => _TColorPickerSliderState();
}

class _TColorPickerSliderState extends State<TColorPickerSlider> {
  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final sliderHeight = theme?.sliderHeight ?? 8;
    final thumbSize = theme?.sliderThumbSize ?? 24;
    final thumbPadding = theme?.sliderThumbPadding ?? 3;

    final baseColor = HSLColor.fromAHSL(1, widget.color.hue, 1, 0.5).toColor();

    // 色相渐变 stop 对齐 mobile-vue（red→17% 黄→33% 绿→50% 青→67% 蓝→83% 品红→red）。
    const hueGradient = LinearGradient(
      stops: [0, 0.17, 0.33, 0.5, 0.67, 0.83, 1],
      colors: [
        Color(0xFFFF0000),
        Color(0xFFFFFF00),
        Color(0xFF00FF00),
        Color(0xFF00FFFF),
        Color(0xFF0000FF),
        Color(0xFFFF00FF),
        Color(0xFFFF0000),
      ],
    );

    Widget rail = Container(
      height: sliderHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sliderHeight / 2),
        gradient: widget.isAlpha
            ? LinearGradient(
                colors: [
                  baseColor.withValues(alpha: 0),
                  baseColor,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : hueGradient,
      ),
    );

    // 对齐 mobile-vue：轨道包裹 thumb 区域，透明条底为斜向棋盘格表示透明。
    Widget bar = ClipRRect(
      borderRadius: BorderRadius.circular(sliderHeight / 2),
      child: SizedBox(
        height: sliderHeight,
        child: Stack(
          children: [
            Positioned.fill(child: rail),
            if (widget.isAlpha)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _AlphaCheckerPainter()),
                ),
              ),
          ],
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final ratio = widget.isAlpha ? widget.color.alpha : widget.color.hue / 360;
        final thumbLeft = (ratio * width - thumbSize / 2)
            .clamp(-thumbSize / 2, width - thumbSize / 2)
            .toDouble();

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (details) => _update(details.localPosition.dx, width),
          onPanUpdate: (details) => _update(details.localPosition.dx, width),
          onPanEnd: (_) {},
          child: SizedBox(
            height: thumbSize,
            width: width,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: (thumbSize - sliderHeight) / 2,
                  child: bar,
                ),
                // thumb 以白圆为底、内嵌当前色圆点，对齐 mobile-vue `__thumb`。
                Positioned(
                  left: thumbLeft,
                  top: 0,
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    padding: EdgeInsets.all(thumbPadding),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.color.toFlutterColor(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _update(double dx, double width) {
    final ratio = (dx / width).clamp(0.0, 1.0).toDouble();
    if (widget.isAlpha) {
      widget.onChanged(ratio);
    } else {
      widget.onChanged(ratio * 360);
    }
  }
}

/// 透明条斜向棋盘格，对齐 mobile-vue `__slider-wrapper--alpha-type` 的
/// 双层 45° 渐变（6px 网格，#c5c5c5 与透明交错）。
class _AlphaCheckerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cell = 3.0;
    final paint = Paint()..color = const Color(0xFFC5C5C5);
    for (var y = 0.0; y < size.height; y += cell * 2) {
      for (var x = -cell * 2; x < size.width; x += cell * 2) {
        canvas.drawRect(Rect.fromLTWH(x + cell, y, cell, cell), paint);
        canvas.drawRect(
          Rect.fromLTWH(x, y + cell, cell, cell),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AlphaCheckerPainter oldDelegate) => false;
}
