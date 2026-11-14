import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_internal_material.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import 't_image_theme_data.dart';

/// 图片形状。
enum TImageShape {
  /// 方形。
  square,

  /// 圆角方形。
  roundedSquare,

  /// 圆形。
  circle,
}

/// 网络图片内存缓存策略。
///
/// Flutter 的 `ImageCache` 默认缓存全部网络图；该策略提供按图控制内存缓存
/// 的开关，不涉及磁盘缓存或 HTTP 缓存头。
enum TImageCacheMode {
  /// 保留内存缓存（默认）。
  ///
  /// 与 Flutter `Image.network` 默认行为一致：同一 URL 复用内存缓存，
  /// 不主动清除缓存条目。
  enabled,

  /// 不保留内存缓存。
  ///
  /// 每次来源生效前先清除该 URL 对应的内存缓存条目，保证每次展示都取
  /// 最新数据；来源变更与组件销毁时同步清除，避免缓存被后续复用。
  /// 只影响内存缓存，不控制磁盘缓存与 HTTP 缓存头。
  disabled,
}

class TImage extends StatelessWidget {
  const TImage({
    super.key,
    this.src,
    this.imageFile,
    this.shape = TImageShape.square,
    this.errorWidget,
    this.loadingWidget,
    this.width,
    this.height,
    this.fit = BoxFit.fill,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.onLoad,
    this.onError,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.cacheWidth,
    this.cacheHeight,
    this.cacheMode = TImageCacheMode.enabled,
    this.filterQuality = FilterQuality.low,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.onTap,
  }) : assert(
         src == null || imageFile == null,
         'src and imageFile cannot be provided at the same time',
       );

  /// 网络 URL 或 asset 路径。
  ///
  /// 为 null 时显示加载占位；空字符串显示失败占位。
  final String? src;

  /// 本地图片文件；不能与 [src] 同时提供。
  final File? imageFile;

  /// 图片形状，默认为 [TImageShape.square]。
  final TImageShape shape;

  /// 默认错误占位内容；[errorBuilder] 非空时由其接管错误渲染。
  final Widget? errorWidget;

  /// 默认加载占位内容。
  ///
  /// [src] 为 null 时直接显示；网络图片加载时仅在 [loadingBuilder] 为空时显示。
  final Widget? loadingWidget;

  /// 图片宽度，未指定时为 72。
  final double? width;

  /// 图片高度，未指定时为 72。
  final double? height;

  /// 图片适配方式，默认为 [BoxFit.fill]。
  final BoxFit fit;

  /// 图片帧 UI 构建器；不用于触发加载成功副作用。
  final ImageFrameBuilder? frameBuilder;

  /// 网络图片的增量加载进度构建器。
  ///
  /// 仅透传给 [Image.network]；asset 和 [imageFile] 的首帧 UI 使用 [frameBuilder]。
  final ImageLoadingBuilder? loadingBuilder;

  /// 图片错误 UI 构建器；非空时优先于 [errorWidget]。
  ///
  /// 不用于执行错误上报等副作用；错误事件使用 [onError]。
  final ImageErrorWidgetBuilder? errorBuilder;

  /// 图片首帧加载成功后的回调。
  ///
  /// 每个图片来源生命周期只触发一次；动画图片的后续帧不重复触发。
  final VoidCallback? onLoad;

  /// 图片加载失败后的回调。
  ///
  /// 每个图片来源生命周期只触发一次，并接收原始错误与堆栈。
  final ImageErrorListener? onError;

  /// 无障碍标签。
  final String? semanticLabel;

  /// 是否从语义树排除图片。
  final bool excludeFromSemantics;

  /// 解码缓存宽度。
  final int? cacheWidth;

  /// 解码缓存高度。
  final int? cacheHeight;

  /// 网络图片内存缓存策略，默认 [TImageCacheMode.enabled]。
  ///
  /// 仅作用于网络图（http/https）；asset 与 [imageFile] 不受影响。
  final TImageCacheMode cacheMode;

  /// 图片滤镜质量。
  final FilterQuality filterQuality;

  /// 图片对齐方式。
  final AlignmentGeometry alignment;

  /// 图片重复方式。
  final ImageRepeat repeat;

  /// 点击回调；为空时不创建点击行为。
  final GestureTapCallback? onTap;

  /// 判断 [value] 是否为网络图地址（http/https）。
  static bool _isNetworkUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme.toLowerCase() == 'http' ||
            uri.scheme.toLowerCase() == 'https');
  }

  @override
  Widget build(BuildContext context) {
    return _TImageLifecycle(image: this);
  }

  Widget _buildContent(
    BuildContext context, {
    required ImageFrameBuilder? effectiveFrameBuilder,
    required ImageErrorWidgetBuilder effectiveErrorBuilder,
  }) {
    final resolvedWidth = width ?? 72;
    final resolvedHeight = height ?? 72;
    final theme = Theme.of(context).extension<TImageThemeData>();
    final image = _buildImage(
      context,
      theme,
      width: resolvedWidth,
      height: resolvedHeight,
      fit: fit,
      effectiveFrameBuilder: effectiveFrameBuilder,
      effectiveErrorBuilder: effectiveErrorBuilder,
    );
    final clipped = _clip(context, image);

    if (onTap == null) {
      return clipped;
    }
    return GestureDetector(onTap: onTap, child: clipped);
  }

  Widget _buildImage(
    BuildContext context,
    TImageThemeData? theme, {
    required double width,
    required double height,
    required BoxFit fit,
    required ImageFrameBuilder? effectiveFrameBuilder,
    required ImageErrorWidgetBuilder effectiveErrorBuilder,
  }) {
    final color = theme?.color;
    final colorBlendMode = theme?.colorBlendMode;
    final centerSlice = theme?.centerSlice;
    final matchTextDirection = theme?.matchTextDirection ?? false;
    final gaplessPlayback = theme?.gaplessPlayback ?? false;
    final isAntiAlias = theme?.isAntiAlias ?? false;
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        width: width,
        height: height,
        fit: fit,
        frameBuilder: effectiveFrameBuilder,
        errorBuilder: effectiveErrorBuilder,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        color: color,
        colorBlendMode: colorBlendMode,
        alignment: alignment,
        repeat: repeat,
        centerSlice: centerSlice,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        filterQuality: filterQuality,
        isAntiAlias: isAntiAlias,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
      );
    }

    final value = src;
    if (value == null) {
      return _placeholder(
        context,
        loadingWidget ??
            TInternalIcon(
              TIcons.ellipsis,
              size: 22,
              color: context.tTheme.textColorPlaceholder,
            ),
        width: width,
        height: height,
      );
    }
    if (value.isEmpty) {
      return effectiveErrorBuilder(
        context,
        ArgumentError.value(value, 'src', 'must not be empty'),
        StackTrace.empty,
      );
    }
    if (TImage._isNetworkUrl(value)) {
      final networkProvider = NetworkImage(value);
      // 显式声明类型：三元两分支推断结果为 Object，无法赋给 Image.image。
      // ignore: omit_local_variable_types
      final ImageProvider<Object> provider =
          cacheWidth != null || cacheHeight != null
          ? ResizeImage(networkProvider, width: cacheWidth, height: cacheHeight)
          : networkProvider;
      return Image(
        image: provider,
        width: width,
        height: height,
        fit: fit,
        frameBuilder: effectiveFrameBuilder,
        loadingBuilder:
            loadingBuilder ??
            (context, child, progress) => progress == null
                ? child
                : _placeholder(
                    context,
                    loadingWidget ??
                        TInternalIcon(
                          TIcons.ellipsis,
                          size: 22,
                          color: context.tTheme.textColorPlaceholder,
                        ),
                    width: width,
                    height: height,
                  ),
        errorBuilder: effectiveErrorBuilder,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        color: color,
        colorBlendMode: colorBlendMode,
        alignment: alignment,
        repeat: repeat,
        centerSlice: centerSlice,
        matchTextDirection: matchTextDirection,
        gaplessPlayback: gaplessPlayback,
        filterQuality: filterQuality,
        isAntiAlias: isAntiAlias,
      );
    }

    return Image.asset(
      value,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: effectiveFrameBuilder,
      errorBuilder: effectiveErrorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      color: color,
      colorBlendMode: colorBlendMode,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      filterQuality: filterQuality,
      isAntiAlias: isAntiAlias,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  Widget _placeholder(
    BuildContext context,
    Widget child, {
    required double width,
    required double height,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: ColoredBox(
        color: context.tTheme.bgColorComponent,
        child: Center(
          child: TInternalIconTheme.merge(
            data: IconThemeData(color: context.tTheme.textColorPlaceholder),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _clip(BuildContext context, Widget child) {
    switch (shape) {
      case TImageShape.square:
        return child;
      case TImageShape.roundedSquare:
        return ClipRRect(
          borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
          child: child,
        );
      case TImageShape.circle:
        return ClipOval(child: child);
    }
  }
}

class _TImageLifecycle extends StatefulWidget {
  const _TImageLifecycle({required this.image});

  final TImage image;

  @override
  State<_TImageLifecycle> createState() => _TImageLifecycleState();
}

class _TImageLifecycleState extends State<_TImageLifecycle> {
  var _generation = 0;
  var _terminalEventObserved = false;

  @override
  void initState() {
    super.initState();
    _evictIfDisabled(widget.image);
  }

  @override
  void didUpdateWidget(covariant _TImageLifecycle oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldImage = oldWidget.image;
    final newImage = widget.image;
    if (_sourceIdentity(oldImage) != _sourceIdentity(newImage)) {
      _evictIfDisabled(oldImage);
      _generation++;
      _terminalEventObserved = false;
    }
  }

  @override
  void dispose() {
    _evictIfDisabled(widget.image);
    super.dispose();
  }

  /// 不保留缓存策略的清除入口：仅作用于 disabled 模式的网络图。
  void _evictIfDisabled(TImage image) {
    if (image.cacheMode == TImageCacheMode.disabled) {
      _evictCache(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.image;
    return image._buildContent(
      context,
      effectiveFrameBuilder: _buildFrame,
      effectiveErrorBuilder: _buildError,
    );
  }

  Widget _buildFrame(
    BuildContext context,
    Widget child,
    int? frame,
    bool wasSynchronouslyLoaded,
  ) {
    if (frame != null) {
      _scheduleTerminalEvent(widget.image.onLoad);
    }
    return widget.image.frameBuilder?.call(
          context,
          child,
          frame,
          wasSynchronouslyLoaded,
        ) ??
        child;
  }

  Widget _buildError(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    final onError = widget.image.onError;
    _scheduleTerminalEvent(
      onError == null ? null : () => onError(error, stackTrace),
    );
    return widget.image.errorBuilder?.call(context, error, stackTrace) ??
        widget.image._placeholder(
          context,
          widget.image.errorWidget ??
              TInternalIcon(
                TIcons.close,
                size: 22,
                color: context.tTheme.textColorPlaceholder,
              ),
          width: widget.image.width ?? 72,
          height: widget.image.height ?? 72,
        );
  }

  void _scheduleTerminalEvent(VoidCallback? callback) {
    if (_terminalEventObserved) {
      return;
    }
    _terminalEventObserved = true;
    if (callback == null) {
      return;
    }
    final generation = _generation;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || generation != _generation) {
        return;
      }
      callback();
    });
  }

  Object? _sourceIdentity(TImage image) {
    if (image.imageFile != null) {
      return (
        'file',
        image.imageFile!.path,
        image.cacheWidth,
        image.cacheHeight,
      );
    }
    if (image.src != null) {
      return ('src', image.src, image.cacheWidth, image.cacheHeight);
    }
    return null;
  }

  /// 清除网络来源对应的内存缓存条目；非网络图不处理。
  ///
  /// 返回是否实际清除了缓存条目。`ResizeImage` 的缓存键是其 `obtainKey`
  /// 生成的内部键（`NetworkImage.obtainKey` 返回 `SynchronousFuture`，
  /// 可同步取值），需按原参数重建后取键清除，不能用 provider 实例直接查。
  bool _evictCache(TImage image) {
    final src = image.src;
    if (src == null || !TImage._isNetworkUrl(src)) {
      return false;
    }
    final cache = PaintingBinding.instance.imageCache;
    var evicted = cache.evict(NetworkImage(src));
    if (image.cacheWidth != null || image.cacheHeight != null) {
      final resized = ResizeImage(
        NetworkImage(src),
        width: image.cacheWidth,
        height: image.cacheHeight,
      );
      final keyFuture = resized.obtainKey(const ImageConfiguration());
      ResizeImageKey? key;
      keyFuture.then((value) => key = value);
      if (key != null) {
        evicted = cache.evict(key!) || evicted;
      }
    }
    return evicted;
  }
}
