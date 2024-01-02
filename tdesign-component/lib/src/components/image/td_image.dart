import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import '../../util/string_util.dart';

enum TDImageType {
  /// 裁剪
  clip,

  /// 适应高
  fitHeight,

  /// 适应宽
  fitWidth,

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
  const TDImage({
    this.imgUrl,
    Key? key,
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
    this.assetUrl,
  }) : super(key: key);

  /// 图片地址
  final String? imgUrl;

  /// 本地素材地址
  final String? assetUrl;

  /// 图片类型
  final TDImageType type;

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
  State<StatefulWidget> createState() => _TDImageState();
}

class _TDImageState extends State<TDImage> {
  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case TDImageType.clip:
        return widget.assetUrl == null
            ? ImageWidget.network(
                widget.imgUrl,
                height: widget.height ?? 72,
                width: widget.width ?? 72,
                errorWidget: widget.errorWidget,
                loadingWidget: widget.loadingWidget,
                fit: BoxFit.none,
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
              )
            : ImageWidget.asset(
                widget.assetUrl!,
                width: widget.width ?? 72,
                height: widget.height ?? 72,
                errorWidget: widget.errorWidget,
                loadingWidget: widget.loadingWidget,
                fit: BoxFit.none,
                color: widget.color,
                frameBuilder: widget.frameBuilder,
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
              );
      case TDImageType.fitHeight:
        return widget.assetUrl == null
            ? ImageWidget.network(
                widget.imgUrl,
                height: widget.height ?? 72,
                width: widget.width ?? 72,
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
              )
            : ImageWidget.asset(
                widget.assetUrl!,
                width: widget.width ?? 72,
                height: widget.height ?? 72,
                errorWidget: widget.errorWidget,
                loadingWidget: widget.loadingWidget,
                fit: BoxFit.fitHeight,
                color: widget.color,
                frameBuilder: widget.frameBuilder,
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
              );
      case TDImageType.stretch:
        return widget.assetUrl == null
            ? ConstrainedBox(
                constraints: BoxConstraints(maxHeight: widget.height ?? 72, maxWidth: widget.width ?? 72),
                child: ImageWidget.network(
                  widget.imgUrl,
                  height: widget.height ?? 72,
                  width: widget.width ?? 72,
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
              )
            : ConstrainedBox(
                constraints: BoxConstraints(maxHeight: widget.height ?? 72, maxWidth: widget.width ?? 72),
                child: ImageWidget.asset(
                  widget.assetUrl!,
                  width: widget.width ?? 72,
                  height: widget.height ?? 72,
                  errorWidget: widget.errorWidget,
                  loadingWidget: widget.loadingWidget,
                  fit: BoxFit.fill,
                  color: widget.color,
                  frameBuilder: widget.frameBuilder,
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
        return widget.assetUrl == null
            ? ImageWidget.network(
                widget.imgUrl,
                height: widget.height ?? 72,
                width: widget.width ?? 72,
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
              )
            : ImageWidget.asset(
                widget.assetUrl!,
                width: widget.width ?? 72,
                height: widget.height ?? 72,
                errorWidget: widget.errorWidget,
                loadingWidget: widget.loadingWidget,
                fit: BoxFit.cover,
                color: widget.color,
                frameBuilder: widget.frameBuilder,
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
              );
      case TDImageType.roundedSquare:
        return Container(
            height: widget.height ?? 72,
            width: widget.width ?? 72,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(TDTheme.of(context).radiusDefault)),
            child: widget.assetUrl == null
                ? ImageWidget.network(
                    widget.imgUrl,
                    height: widget.height ?? 72,
                    width: widget.width ?? 72,
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
                  )
                : ImageWidget.asset(
                    widget.assetUrl!,
                    width: widget.width ?? 72,
                    height: widget.height ?? 72,
                    errorWidget: widget.errorWidget,
                    loadingWidget: widget.loadingWidget,
                    fit: BoxFit.cover,
                    color: widget.color,
                    frameBuilder: widget.frameBuilder,
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
            height: widget.height ?? 72,
            width: widget.width ?? 72,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: widget.assetUrl == null
                ? ImageWidget.network(
                    widget.imgUrl,
                    height: widget.height ?? 72,
                    width: widget.width ?? 72,
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
                  )
                : ImageWidget.asset(
                    widget.assetUrl!,
                    width: widget.width ?? 72,
                    height: widget.height ?? 72,
                    errorWidget: widget.errorWidget,
                    loadingWidget: widget.loadingWidget,
                    fit: BoxFit.cover,
                    color: widget.color,
                    frameBuilder: widget.frameBuilder,
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
      case TDImageType.fitWidth:
        return widget.assetUrl == null
            ? ImageWidget.network(
                widget.imgUrl,
                height: widget.height ?? 72,
                width: widget.width ?? 72,
                errorWidget: widget.errorWidget,
                loadingWidget: widget.loadingWidget,
                fit: BoxFit.fitWidth,
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
              )
            : ImageWidget.asset(
                widget.assetUrl!,
                width: widget.width ?? 72,
                height: widget.height ?? 72,
                errorWidget: widget.errorWidget,
                loadingWidget: widget.loadingWidget,
                fit: BoxFit.fitWidth,
                color: widget.color,
                frameBuilder: widget.frameBuilder,
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
              );
    }
  }
}
