import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/src/transformer_page_view/transformer_page_view.dart';

/// TD默认PageTransformer
class TDPageTransformer extends PageTransformer {
  final double? _scale;
  final double? _fade;
  final double? _margin;

  /// 普通margin的卡片式
  TDPageTransformer.margin({double? margin = 6})
      : _fade = 1,
        _scale = 1,
        _margin = margin;

  /// 缩放或透明的卡片式
  TDPageTransformer.scaleAndFade({double? fade = 1, double? scale = 0.8})
      : _fade = fade,
        _scale = scale,
        _margin = 0;

  TDPageTransformer({double? fade, double? scale, double? margin})
      : _fade = fade,
        _scale = scale,
        _margin = margin;

  @override
  Widget transform(Widget item, TransformInfo info) {
    var position = info.position;
    var child = item;
    if (_scale != null) {
      var scaleFactor = (1 - position.abs()) * (1 - _scale!);
      var scale = _scale! + scaleFactor;

      child = Transform.scale(
        scale: scale,
        child: item,
      );
    }

    if (_fade != null) {
      var fadeFactor = (1 - position.abs()) * (1 - _fade!);
      var opacity = _fade! + fadeFactor;
      child = Opacity(
        opacity: opacity,
        child: child,
      );
    }
    if (_margin != null) {
      child = Container(
        margin: EdgeInsets.only(left: _margin!, right: _margin!),
        child: child,
      );
    }
    return child;
  }
}
