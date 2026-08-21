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

        Widget panel = Container(
          height: heightPx,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              colors: [Colors.white, baseColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: const LinearGradient(
                colors: [Colors.transparent, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
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
    var saturation = (position.dx / width).clamp(0.0, 1.0);
    var value = (1 - position.dy / heightPx).clamp(0.0, 1.0);
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

    final track = Container(
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
            : const LinearGradient(
                colors: [
                  Color(0xFFFF0000),
                  Color(0xFFFFFF00),
                  Color(0xFF00FF00),
                  Color(0xFF00FFFF),
                  Color(0xFF0000FF),
                  Color(0xFFFF00FF),
                  Color(0xFFFF0000),
                ],
              ),
      ),
    );

    // 透明条加棋盘格背景表示透明。
    Widget bar = track;
    if (widget.isAlpha) {
      bar = Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: sliderHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sliderHeight / 2),
              color: const Color(0xFFE5E5E5),
            ),
          ),
          track,
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final ratio = widget.isAlpha ? widget.color.alpha : widget.color.hue / 360;
        final thumbLeft = (ratio * width - thumbSize / 2).clamp(
              -thumbSize / 2,
              width - thumbSize / 2,
            );

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (details) => _update(details.localPosition.dx, width),
          onPanUpdate: (details) => _update(details.localPosition.dx, width),
          onPanEnd: (_) {},
          child: SizedBox(
            height: thumbSize,
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
                        border: Border.all(color: Colors.white),
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
    final ratio = (dx / width).clamp(0.0, 1.0);
    if (widget.isAlpha) {
      widget.onChanged(ratio);
    } else {
      widget.onChanged(ratio * 360);
    }
  }
}
