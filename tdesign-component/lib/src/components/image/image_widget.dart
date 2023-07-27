import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

///封装图片加载控件，增加图片加载失败时加载默认图片
class ImageWidget extends StatefulWidget {
  /// 图片地址
  final String? src;

  /// 本地图片地址
  final String? assetUrl;

  /// 图片宽度
  final double width;

  /// 图片高度
  final double height;

  /// 加载错误时展示Widget
  final Widget? errorWidget;

  /// 加载中展示Widget
  final Widget? loadingWidget;

  /// 适配样式
  final BoxFit fit;

  /// 以下系统Image属性，释义请参考系统[Image]中注释
  final ImageProvider image;

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

  final int? cacheWidth;

  final int? cacheHeight;

  const ImageWidget(
      {Key? key,
      required this.image,
      this.frameBuilder,
      this.loadingBuilder,
      this.errorBuilder,
      this.semanticLabel,
      this.excludeFromSemantics = false,
      required this.width,
      required this.height,
      this.color,
      this.opacity,
      this.colorBlendMode,
      required this.fit,
      this.alignment = Alignment.center,
      this.repeat = ImageRepeat.noRepeat,
      this.centerSlice,
      this.matchTextDirection = false,
      this.gaplessPlayback = false,
      this.isAntiAlias = false,
      this.filterQuality = FilterQuality.low,
      required this.src,
      this.errorWidget,
      this.loadingWidget,
      this.cacheWidth,
      this.cacheHeight,
      this.assetUrl})
      : super(key: key);

  ImageWidget.network(this.src,
      {Key? key,
      required this.width,
      required this.height,
      double scale = 1.0,
      this.errorWidget,
      this.fit = BoxFit.none,
      this.loadingWidget,
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
      this.filterQuality = FilterQuality.low,
      this.isAntiAlias = false,
      Map<String, String>? headers,
      this.cacheWidth,
      this.assetUrl,
      this.cacheHeight})
      : image = ResizeImage.resizeIfNeeded(
            cacheWidth, cacheHeight, NetworkImage(src ?? '', scale: scale, headers: headers)),
        assert(cacheWidth == null || cacheWidth > 0),
        assert(cacheHeight == null || cacheHeight > 0),
        super(key: key);

  ImageWidget.asset(
    this.assetUrl, {
    Key? key,
    AssetBundle? bundle,
    this.frameBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    double? scale,
    required this.width,
    required this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit = BoxFit.none,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.isAntiAlias = false,
    String? package,
    this.filterQuality = FilterQuality.low,
    this.cacheWidth,
    this.cacheHeight,
    this.src,
    this.errorWidget,
    this.loadingWidget,
  })  : image = ResizeImage.resizeIfNeeded(
          cacheWidth,
          cacheHeight,
          scale != null
              ? ExactAssetImage(assetUrl ?? '', bundle: bundle, scale: scale, package: package)
              : AssetImage(assetUrl ?? '', bundle: bundle, package: package),
        ),
        loadingBuilder = null,
        assert(cacheWidth == null || cacheWidth > 0),
        assert(cacheHeight == null || cacheHeight > 0),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StateImageWidget();
  }
}

class _StateImageWidget extends State<ImageWidget> {
  late Image _image;
  late ImageStream _resolve;
  late ImageStreamListener _listener;
  bool error = false;
  bool loading = true;

  @override
  void didUpdateWidget(covariant ImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.src != widget.src || oldWidget.assetUrl != widget.assetUrl) {
      initImage();
    }
  }

  void initImage() {
    _image = widget.assetUrl == null
        ? Image.network(
            widget.src ?? '',
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            color: widget.color,
            frameBuilder: widget.frameBuilder,
            loadingBuilder: widget.loadingBuilder,
            errorBuilder: widget.errorBuilder,
            semanticLabel: widget.semanticLabel,
            excludeFromSemantics: widget.excludeFromSemantics,
            colorBlendMode: widget.colorBlendMode,
            alignment: widget.alignment,
            repeat: widget.repeat,
            centerSlice: widget.centerSlice,
            matchTextDirection: widget.matchTextDirection,
            gaplessPlayback: widget.gaplessPlayback,
            filterQuality: widget.filterQuality,
            isAntiAlias: widget.isAntiAlias,
            cacheWidth: widget.cacheWidth,
            cacheHeight: widget.cacheHeight,
          )
        : Image.asset(
            widget.assetUrl ?? '',
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            color: widget.color,
            frameBuilder: widget.frameBuilder,
            errorBuilder: widget.errorBuilder,
            semanticLabel: widget.semanticLabel,
            excludeFromSemantics: widget.excludeFromSemantics,
            colorBlendMode: widget.colorBlendMode,
            alignment: widget.alignment,
            repeat: widget.repeat,
            centerSlice: widget.centerSlice,
            matchTextDirection: widget.matchTextDirection,
            gaplessPlayback: widget.gaplessPlayback,
            filterQuality: widget.filterQuality,
            isAntiAlias: widget.isAntiAlias,
            cacheWidth: widget.cacheWidth,
            cacheHeight: widget.cacheHeight,
          );
    _resolve = _image.image.resolve(const ImageConfiguration());
    _listener = ImageStreamListener((_, __) {
      /// 加载成功
      if (mounted) {
        setState(() {
          loading = false;
          error = false;
        });
      }
    }, onChunk: (ImageChunkEvent event) {
      /// 加载中
      if (loading == false) {
        if (mounted) {
          setState(() {
            loading = true;
            error = false;
          });
        }
      }
    }, onError: (dynamic exception, StackTrace? stackTrace) {
      /// 加载失败
      if (error == false) {
        setState(() {
          error = true;
          loading = false;
        });
      }
    });
    _resolve.addListener(_listener);
  }

  @override
  void initState() {
    super.initState();
    initImage();
  }

  @override
  Widget build(BuildContext context) {
    if (error == false && loading == true) {
      return Container(
          alignment: widget.alignment,
          color: widget.color ?? TDTheme.of(context).grayColor2,
          child: widget.loadingWidget ??
              Icon(
                TDIcons.ellipsis,
                size: 22,
                color: TDTheme.of(context).fontGyColor3,
              ));
    }
    if (error == true && loading == false) {
      return Container(
        alignment: widget.alignment,
        color: widget.color ?? TDTheme.of(context).grayColor2,
        child: widget.errorWidget ??
            Icon(
              TDIcons.close,
              size: 22,
              color: TDTheme.of(context).fontGyColor3,
            ),
      );
    }
    if (loading == false && error == false) {
      return _image;
    }
    return Container();
  }

  @override
  void dispose() {
    super.dispose();
    _resolve.removeListener(_listener);
  }
}
