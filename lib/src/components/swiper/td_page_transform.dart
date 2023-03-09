import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/src/transformer_page_view/transformer_page_view.dart';

/// TD默认PageTransformer
class TDPageTransformer extends PageTransformer {

  /// 缩放比例
  final double? scale;
  /// 淡化比例
  final double? fade;
  /// 左右间隔
  final double? margin;

  /// 普通margin的卡片式
  TDPageTransformer.margin({this.margin = 6.0})
      : fade = 1,
        scale = 1;

  /// 缩放或透明的卡片式
  TDPageTransformer.scaleAndFade({this.fade = 1, this.scale = 0.8})
      : margin = 0.0;

  TDPageTransformer({this.fade, this.scale, this.margin});

  @override
  Widget transform(Widget item, TransformInfo info) {
    var position = info.position;
    var child = item;
    if (scale != null) {
      var scaleFactor = (1 - position.abs()) * (1 - scale!);
      var rawScale = scale! + scaleFactor;

      child = Transform.scale(
        scale: rawScale,
        child: item,
      );
    }

    if (fade != null) {
      var fadeFactor = (1 - position.abs()) * (1 - fade!);
      var opacity = fade! + fadeFactor;
      child = Opacity(
        opacity: opacity,
        child: child,
      );
    }
    if (margin != null) {
      child = Container(
        margin: EdgeInsets.only(left: margin!, right: margin!),
        child: child,
      );
    }
    return child;
  }
}
