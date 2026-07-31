import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import 't_avatar_theme_data.dart';
import 't_avatar_types.dart';

/// 头像。
///
/// [image] 负责图片内容，[child] 负责文字、图标等自定义内容。两者同时提供时，
/// [child] 会作为图片加载失败前的背景内容。
class TAvatar extends StatelessWidget {
  const TAvatar({
    this.image,
    this.child,
    this.size,
    this.variant,
    this.fit = BoxFit.cover,
    this.onTap,
    super.key,
  });

  /// 头像图片。
  final ImageProvider<Object>? image;

  /// 自定义头像内容。
  final Widget? child;

  /// 头像尺寸；未设置时依次读取 Theme 和中尺寸默认值。
  final TAvatarSize? size;

  /// 头像形状；未设置时依次读取 Theme 和圆形默认值。
  final TAvatarVariant? variant;

  /// 图片填充方式。
  final BoxFit fit;

  /// 点击回调；为空时头像不创建点击行为。
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TAvatarThemeData>();
    final resolvedSize = size ?? theme?.size ?? TAvatarSize.medium;
    final resolvedVariant = variant ?? theme?.variant ?? TAvatarVariant.circle;
    final dimension = theme?.dimension ?? _dimensionFor(resolvedSize);
    final radius = resolvedVariant == TAvatarVariant.circle
        ? dimension / 2
        : theme?.squareBorderRadius ?? context.tTheme.radiusDefault;
    final content = child ??
        Icon(
          TIcons.user,
          size: theme?.iconSize ?? _iconSizeFor(resolvedSize),
          color: theme?.foregroundColor ?? context.tTheme.brandNormalColor,
        );

    final avatar = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: ColoredBox(
        color: theme?.backgroundColor ?? context.tTheme.brandFocusColor,
        child: SizedBox.square(
          dimension: dimension,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(child: content),
              if (image != null)
                Image(
                  image: image!,
                  fit: fit,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
            ],
          ),
        ),
      ),
    );

    if (onTap == null) {
      return avatar;
    }
    return GestureDetector(onTap: onTap, child: avatar);
  }

  double _dimensionFor(TAvatarSize size) {
    switch (size) {
      case TAvatarSize.large:
        return 64;
      case TAvatarSize.medium:
        return 48;
      case TAvatarSize.small:
        return 40;
    }
  }

  double _iconSizeFor(TAvatarSize size) {
    switch (size) {
      case TAvatarSize.large:
        return 32;
      case TAvatarSize.medium:
        return 24;
      case TAvatarSize.small:
        return 20;
    }
  }
}

/// 叠放头像组。
///
/// 头像组只负责布局，不解析图片来源或缓存成员状态。
class TAvatarGroup extends StatelessWidget {
  const TAvatarGroup({
    required this.children,
    this.maxCount,
    this.overflow,
    this.spacing,
    super.key,
  }) : assert(maxCount == null || maxCount > 0);

  /// 头像列表。
  final List<Widget> children;

  /// 最多显示的头像数量。
  final int? maxCount;

  /// 发生截断时显示在末尾的内容。
  final Widget? overflow;

  /// 相邻头像的重叠宽度。
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context).extension<TAvatarThemeData>();
    final count = maxCount == null
        ? children.length
        : maxCount!.clamp(1, children.length);
    final visible = children.take(count).toList(growable: true);
    if (count < children.length && overflow != null) {
      visible.add(overflow!);
    }
    final dimension = theme?.dimension ?? 48;
    final overlap = spacing ?? theme?.groupSpacing ?? 8;
    final step = dimension - overlap;
    final borderWidth = theme?.groupBorderWidth ?? 2;
    final width = dimension + step * (visible.length - 1);

    return SizedBox(
      width: width,
      height: dimension,
      child: Stack(
        children: [
          for (var index = 0; index < visible.length; index++)
            PositionedDirectional(
              start: step * index,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme?.groupBorderColor ??
                        context.tTheme.bgColorContainer,
                    width: borderWidth,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(borderWidth),
                  child: SizedBox.square(
                    dimension: dimension - borderWidth * 2,
                    child: FittedBox(child: visible[index]),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
