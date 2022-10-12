import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../td_export.dart';
import '../../util/string_util.dart';
import 'image_widget.dart';

enum TDImageSize {
  /// 120*120px
  xl,

  /// 72*72
  l,

  /// 56*56
  m,

  /// 48*48
  s,

  /// 32*32
  xs,

  /// 24*24
  xxs
}

enum TDImageType {
  /// 裁剪
  clip,

  /// 适应高
  fitHeight,

  /// 拉伸
  stretch,

  /// 方形,
  square,

  /// 圆角方形
  roundedSquare,

  /// 圆形
  circle,
}

class TDImage extends StatefulWidget {
  /// 图片地址
  final String imgUrl;

  /// 图片类型
  final TDImageType type;

  /// 图片大小
  final TDImageSize size;

  /// 加载自定义提示
  final Widget? loadingWidget;

  /// 失败自定义提示
  final Widget? errorWidget;

  /// 自定义宽
  final double? width;

  /// 自定义高
  final double? height;

  /// 以下系统Image属性，释义请参考系统[Image]中注释

  final ImageFrameBuilder? frameBuilder;

  final ImageLoadingBuilder? loadingBuilder;

  final ImageErrorWidgetBuilder? errorBuilder;

  final Color? color;

  final Animation<double>? opacity;

  final FilterQuality filterQuality;

  final BlendMode? colorBlendMode;

  final AlignmentGeometry alignment;

  final ImageRepeat repeat;

  final Rect? centerSlice;

  final bool matchTextDirection;

  final bool gaplessPlayback;

  final String? semanticLabel;

  final bool excludeFromSemantics;

  final bool isAntiAlias;

  final int? cacheHeight;

  final int? cacheWidth;

  @override
  const TDImage(
    this.imgUrl, {
    Key? key,
    this.size = TDImageSize.l,
    this.type = TDImageType.roundedSquare,
    this.errorWidget,
    this.loadingWidget,
    this.width,
    this.height,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    this.filterQuality = FilterQuality.low,
    this.cacheHeight,
    this.cacheWidth,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDImageState();
}

class _TDImageState extends State<TDImage> {
  double _getImageWidth() {
    double width;
    switch (widget.size) {
      case TDImageSize.xl:
        width = 120;
        break;
      case TDImageSize.l:
        width = 72;
        break;
      case TDImageSize.m:
        width = 56;
        break;
      case TDImageSize.s:
        width = 48;
        break;
      case TDImageSize.xs:
        width = 32;
        break;
      case TDImageSize.xxs:
        width = 24;
        break;
      default:
        width = 72;
        break;
    }
    return widget.width ?? width;
  }

  double _getImageHeight() {
    double height;
    height = _getImageWidth();
    return widget.height ?? height;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case TDImageType.clip:
        return SizedBox(
          width: _getImageWidth(),
          height: _getImageHeight(),
          child: ImageWidget.network(
            widget.imgUrl,
            height: _getImageHeight(),
            width: _getImageWidth(),
            errorWidget: widget.errorWidget,
            loadingWidget: widget.loadingWidget,
            fit: BoxFit.cover,
            color: widget.color,
            frameBuilder: widget.frameBuilder,
            loadingBuilder: widget.loadingBuilder,
            errorBuilder: widget.errorBuilder,
            semanticLabel: widget.semanticLabel,
            excludeFromSemantics: widget.excludeFromSemantics,
            opacity: widget.opacity,
            colorBlendMode: widget.colorBlendMode,
            alignment: widget.alignment,
            repeat: widget.repeat,
            centerSlice: widget.centerSlice,
            matchTextDirection: widget.matchTextDirection,
            gaplessPlayback: widget.gaplessPlayback,
            filterQuality: widget.filterQuality,
            isAntiAlias: widget.isAntiAlias,
            cacheHeight: widget.cacheHeight,
            cacheWidth: widget.cacheWidth,
          ),
        );
      case TDImageType.fitHeight:
        return SizedBox(
          width: _getImageWidth(),
          height: _getImageHeight(),
          child: ImageWidget.network(
            widget.imgUrl,
            height: _getImageHeight(),
            width: _getImageWidth(),
            errorWidget: widget.errorWidget,
            loadingWidget: widget.loadingWidget,
            fit: BoxFit.fitHeight,
            color: widget.color,
            frameBuilder: widget.frameBuilder,
            loadingBuilder: widget.loadingBuilder,
            errorBuilder: widget.errorBuilder,
            semanticLabel: widget.semanticLabel,
            excludeFromSemantics: widget.excludeFromSemantics,
            opacity: widget.opacity,
            colorBlendMode: widget.colorBlendMode,
            alignment: widget.alignment,
            repeat: widget.repeat,
            centerSlice: widget.centerSlice,
            matchTextDirection: widget.matchTextDirection,
            gaplessPlayback: widget.gaplessPlayback,
            filterQuality: widget.filterQuality,
            isAntiAlias: widget.isAntiAlias,
            cacheHeight: widget.cacheHeight,
            cacheWidth: widget.cacheWidth,
          ),
        );
      case TDImageType.stretch:
        return SizedBox(
          width: _getImageWidth(),
          height: _getImageHeight(),
          child: ImageWidget.network(
            widget.imgUrl,
            height: _getImageHeight(),
            width: _getImageWidth(),
            errorWidget: widget.errorWidget,
            loadingWidget: widget.loadingWidget,
            fit: BoxFit.fill,
            color: widget.color,
            frameBuilder: widget.frameBuilder,
            loadingBuilder: widget.loadingBuilder,
            errorBuilder: widget.errorBuilder,
            semanticLabel: widget.semanticLabel,
            excludeFromSemantics: widget.excludeFromSemantics,
            opacity: widget.opacity,
            colorBlendMode: widget.colorBlendMode,
            alignment: widget.alignment,
            repeat: widget.repeat,
            centerSlice: widget.centerSlice,
            matchTextDirection: widget.matchTextDirection,
            gaplessPlayback: widget.gaplessPlayback,
            filterQuality: widget.filterQuality,
            isAntiAlias: widget.isAntiAlias,
            cacheHeight: widget.cacheHeight,
            cacheWidth: widget.cacheWidth,
          ),
        );
      case TDImageType.square:
        return SizedBox(
          width: _getImageWidth(),
          height: _getImageHeight(),
          child: ImageWidget.network(
            widget.imgUrl,
            height: _getImageHeight(),
            width: _getImageWidth(),
            errorWidget: widget.errorWidget,
            loadingWidget: widget.loadingWidget,
            fit: BoxFit.cover,
            color: widget.color,
            frameBuilder: widget.frameBuilder,
            loadingBuilder: widget.loadingBuilder,
            errorBuilder: widget.errorBuilder,
            semanticLabel: widget.semanticLabel,
            excludeFromSemantics: widget.excludeFromSemantics,
            opacity: widget.opacity,
            colorBlendMode: widget.colorBlendMode,
            alignment: widget.alignment,
            repeat: widget.repeat,
            centerSlice: widget.centerSlice,
            matchTextDirection: widget.matchTextDirection,
            gaplessPlayback: widget.gaplessPlayback,
            filterQuality: widget.filterQuality,
            isAntiAlias: widget.isAntiAlias,
            cacheHeight: widget.cacheHeight,
            cacheWidth: widget.cacheWidth,
          ),
        );
      case TDImageType.roundedSquare:
        return Container(
            width: _getImageWidth(),
            height: _getImageHeight(),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
            child: ImageWidget.network(
              widget.imgUrl,
              height: _getImageHeight(),
              width: _getImageWidth(),
              errorWidget: widget.errorWidget,
              loadingWidget: widget.loadingWidget,
              fit: BoxFit.cover,
              color: widget.color,
              frameBuilder: widget.frameBuilder,
              loadingBuilder: widget.loadingBuilder,
              errorBuilder: widget.errorBuilder,
              semanticLabel: widget.semanticLabel,
              excludeFromSemantics: widget.excludeFromSemantics,
              opacity: widget.opacity,
              colorBlendMode: widget.colorBlendMode,
              alignment: widget.alignment,
              repeat: widget.repeat,
              centerSlice: widget.centerSlice,
              matchTextDirection: widget.matchTextDirection,
              gaplessPlayback: widget.gaplessPlayback,
              filterQuality: widget.filterQuality,
              isAntiAlias: widget.isAntiAlias,
              cacheHeight: widget.cacheHeight,
              cacheWidth: widget.cacheWidth,
            ));
      case TDImageType.circle:
        return Container(
            width: _getImageWidth(),
            height: _getImageHeight(),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ImageWidget.network(
              widget.imgUrl,
              height: _getImageHeight(),
              width: _getImageWidth(),
              errorWidget: widget.errorWidget,
              loadingWidget: widget.loadingWidget,
              fit: BoxFit.cover,
              color: widget.color,
              frameBuilder: widget.frameBuilder,
              loadingBuilder: widget.loadingBuilder,
              errorBuilder: widget.errorBuilder,
              semanticLabel: widget.semanticLabel,
              excludeFromSemantics: widget.excludeFromSemantics,
              opacity: widget.opacity,
              colorBlendMode: widget.colorBlendMode,
              alignment: widget.alignment,
              repeat: widget.repeat,
              centerSlice: widget.centerSlice,
              matchTextDirection: widget.matchTextDirection,
              gaplessPlayback: widget.gaplessPlayback,
              filterQuality: widget.filterQuality,
              isAntiAlias: widget.isAntiAlias,
              cacheHeight: widget.cacheHeight,
              cacheWidth: widget.cacheWidth,
            ));
    }
  }
}
