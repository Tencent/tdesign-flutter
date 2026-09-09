import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
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

/// 统一展示网络、asset 或本地文件图片。
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

  /// 图片滤镜质量。
  final FilterQuality filterQuality;

  /// 图片对齐方式。
  final AlignmentGeometry alignment;

  /// 图片重复方式。
  final ImageRepeat repeat;

  /// 点击回调；为空时不创建点击行为。
  final GestureTapCallback? onTap;

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
        loadingWidget ?? const Icon(TIcons.ellipsis, size: 22),
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
    final uri = Uri.tryParse(value);
    final isNetwork =
        uri != null &&
        (uri.scheme.toLowerCase() == 'http' ||
            uri.scheme.toLowerCase() == 'https');
    if (isNetwork) {
      return Image.network(
        value,
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
                    loadingWidget ?? const Icon(TIcons.ellipsis, size: 22),
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
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
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
          child: IconTheme.merge(
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
  void didUpdateWidget(covariant _TImageLifecycle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_sourceIdentity(oldWidget.image) != _sourceIdentity(widget.image)) {
      _generation++;
      _terminalEventObserved = false;
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
          widget.image.errorWidget ?? const Icon(TIcons.close, size: 22),
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
}
