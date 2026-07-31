import 'dart:io';

import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import 't_image_theme_data.dart';

/// 图片裁剪形态。
enum TImageVariant {
  /// 保持原始尺寸并裁剪。
  clip,

  /// 适应高度。
  fitHeight,

  /// 适应宽度。
  fitWidth,

  /// 拉伸填充。
  stretch,

  /// 方形裁剪。
  square,

  /// 圆角方形裁剪。
  roundedSquare,

  /// 圆形裁剪。
  circle,
}

/// 统一展示网络、asset 或本地文件图片。
class TImage extends StatelessWidget {
  const TImage({
    super.key,
    this.src,
    this.imageFile,
    this.variant = TImageVariant.roundedSquare,
    this.errorWidget,
    this.loadingWidget,
    this.width,
    this.height,
    this.fit,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.cacheWidth,
    this.cacheHeight,
    this.filterQuality = FilterQuality.low,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.onTap,
  }) : assert(
         (src == null) != (imageFile == null),
         'Exactly one of src or imageFile must be provided',
       );

  /// 网络 URL 或 asset 路径；空字符串显示加载占位。
  final String? src;

  /// 本地图片文件；不能与 [src] 同时提供。
  final File? imageFile;

  /// 图片裁剪形态。
  final TImageVariant variant;

  /// 默认错误占位内容。
  final Widget? errorWidget;

  /// 默认加载占位内容。
  final Widget? loadingWidget;

  /// 图片宽度。
  final double? width;

  /// 图片高度。
  final double? height;

  /// 图片适配方式；优先于 [variant] 的默认适配方式。
  final BoxFit? fit;

  /// 图片帧构建器。
  final ImageFrameBuilder? frameBuilder;

  /// 网络图片加载进度构建器。
  final ImageLoadingBuilder? loadingBuilder;

  /// 图片错误构建器。
  final ImageErrorWidgetBuilder? errorBuilder;

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
    final resolvedWidth = width ?? 72;
    final resolvedHeight = height ?? 72;
    final resolvedFit = fit ?? _defaultFit(variant);
    final theme = Theme.of(context).extension<TImageThemeData>();
    final image = _buildImage(
      context,
      theme,
      width: resolvedWidth,
      height: resolvedHeight,
      fit: resolvedFit,
    );
    final clipped = _clip(
      context,
      image,
      width: resolvedWidth,
      height: resolvedHeight,
    );

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
  }) {
    final fallbackErrorBuilder =
        errorBuilder ??
        (_, __, ___) => _placeholder(
          context,
          errorWidget ?? const Icon(Icons.broken_image_outlined),
          width: width,
          height: height,
        );
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
        frameBuilder: frameBuilder,
        errorBuilder: fallbackErrorBuilder,
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
        loadingWidget ?? const Icon(Icons.more_horiz),
        width: width,
        height: height,
      );
    }
    if (value.isEmpty) {
      return _placeholder(
        context,
        loadingWidget ?? const Icon(Icons.more_horiz),
        width: width,
        height: height,
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
        frameBuilder: frameBuilder,
        loadingBuilder:
            loadingBuilder ??
            (context, child, progress) => progress == null
                ? child
                : _placeholder(
                    context,
                    loadingWidget ?? const Icon(Icons.more_horiz),
                    width: width,
                    height: height,
                  ),
        errorBuilder: fallbackErrorBuilder,
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
      frameBuilder: frameBuilder,
      errorBuilder: fallbackErrorBuilder,
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

  Widget _clip(
    BuildContext context,
    Widget child, {
    required double width,
    required double height,
  }) {
    switch (variant) {
      case TImageVariant.clip:
      case TImageVariant.fitHeight:
      case TImageVariant.fitWidth:
      case TImageVariant.square:
        return child;
      case TImageVariant.stretch:
        return ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: width, height: height),
          child: child,
        );
      case TImageVariant.roundedSquare:
        return ClipRRect(
          borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
          child: child,
        );
      case TImageVariant.circle:
        return ClipOval(child: child);
    }
  }

  BoxFit _defaultFit(TImageVariant value) {
    switch (value) {
      case TImageVariant.clip:
        return BoxFit.none;
      case TImageVariant.fitHeight:
        return BoxFit.fitHeight;
      case TImageVariant.fitWidth:
        return BoxFit.fitWidth;
      case TImageVariant.stretch:
        return BoxFit.fill;
      case TImageVariant.square:
      case TImageVariant.roundedSquare:
      case TImageVariant.circle:
        return BoxFit.cover;
    }
  }
}
