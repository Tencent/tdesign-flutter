// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import 't_avatar_defaults.dart';
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
    this.shape,
    this.variant,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    this.fit = BoxFit.cover,
    this.onTap,
    super.key,
  }) : assert(
         shape == null || variant == null,
         'shape and deprecated variant cannot be used together',
       );

  /// 头像图片。
  final ImageProvider<Object>? image;

  /// 自定义头像内容。
  final Widget? child;

  /// 头像尺寸；未设置时依次读取 Theme 和中尺寸默认值。
  final TAvatarSize? size;

  /// 头像形状；未设置时依次读取 Theme 和圆形默认值。
  final TAvatarShape? shape;

  /// 头像形状的旧命名。
  @Deprecated('Use shape instead. This property will be removed in 1.0.0.')
  final TAvatarVariant? variant;

  /// 头像背景色，优先于 Theme。
  final Color? backgroundColor;

  /// 默认图标及字符内容的前景色，优先于 Theme。
  final Color? foregroundColor;

  /// 字符内容样式，优先于 Theme，并继承对应尺寸的默认字号和字重。
  final TextStyle? textStyle;

  /// 图片填充方式。
  final BoxFit fit;

  /// 点击回调；为空时头像不创建点击行为。
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TAvatarThemeData>();
    final resolvedSize = size ?? theme?.size ?? TAvatarSize.medium;
    final resolvedShape =
        shape ??
        _avatarShapeFromVariant(variant) ??
        theme?.shape ??
        _avatarShapeFromVariant(theme?.variant) ??
        TAvatarShape.circle;
    final dimension =
        theme?.dimension ?? TAvatarDefaults.dimensionFor(resolvedSize);
    final radius = resolvedShape == TAvatarShape.circle
        ? dimension / 2
        : theme?.squareBorderRadius ?? context.tTheme.radiusDefault;
    final resolvedForegroundColor =
        foregroundColor ??
        textStyle?.color ??
        theme?.foregroundColor ??
        theme?.textStyle?.color ??
        context.tTheme.brandNormalColor;
    final resolvedTextStyle =
        TextStyle(
              fontSize: TAvatarDefaults.fontSizeFor(resolvedSize),
              height: 1,
              fontWeight: FontWeight.w600,
            )
            .merge(theme?.textStyle)
            .merge(textStyle)
            .copyWith(color: resolvedForegroundColor);
    final content =
        child ??
        Icon(
          TIcons.user,
          size: theme?.iconSize ?? TAvatarDefaults.iconSizeFor(resolvedSize),
          color: resolvedForegroundColor,
        );

    final avatar = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: ColoredBox(
        color:
            backgroundColor ??
            theme?.backgroundColor ??
            context.tTheme.brandFocusColor,
        child: SizedBox.square(
          dimension: dimension,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: DefaultTextStyle.merge(
                  style: resolvedTextStyle,
                  child: IconTheme.merge(
                    data: IconThemeData(color: resolvedForegroundColor),
                    child: content,
                  ),
                ),
              ),
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
}

/// 叠放头像组。
///
/// 头像组只负责布局，不解析图片来源或缓存成员状态。
/// 当成员是 [TAvatar] 时，其 [TAvatar.shape] 同时决定成员外框与裁剪形状；
/// 其他 Widget 使用组件 Theme 中的形状或圆形默认值。
class TAvatarGroup extends StatelessWidget {
  const TAvatarGroup({
    required this.children,
    this.maxCount,
    this.overflow,
    this.spacing,
    this.dimension,
    this.cascading = TAvatarGroupCascading.endUp,
    super.key,
  }) : assert(maxCount == null || maxCount > 0),
       assert(
         dimension == null || (dimension > 0 && dimension != double.infinity),
       ),
       assert(spacing == null || (spacing >= 0 && spacing != double.infinity)),
       assert(
         dimension == null || spacing == null || spacing <= dimension,
         'spacing cannot be greater than dimension',
       );

  /// 头像列表。
  final List<Widget> children;

  /// 最多显示的头像数量。
  final int? maxCount;

  /// 发生截断时显示在末尾的内容。
  final Widget? overflow;

  /// 相邻头像的重叠宽度；有效范围为 0 到成员外框边长。
  final double? spacing;

  /// 头像组成员的外框边长；未设置时读取 Theme，默认 48。
  final double? dimension;

  /// 头像组成员的层叠方向，使用 start/end 语义并跟随文字方向。
  final TAvatarGroupCascading cascading;

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
    final requestedDimension =
        dimension ?? theme?.dimension ?? TAvatarDefaults.mediumDimension;
    final resolvedDimension =
        requestedDimension.isFinite && requestedDimension > 0
        ? requestedDimension
        : TAvatarDefaults.mediumDimension;
    final requestedOverlap =
        spacing ?? theme?.groupSpacing ?? TAvatarDefaults.groupSpacing;
    final overlap = requestedOverlap.isFinite
        ? requestedOverlap.clamp(0, resolvedDimension).toDouble()
        : TAvatarDefaults.groupSpacing.clamp(0, resolvedDimension).toDouble();
    final step = resolvedDimension - overlap;
    final requestedBorderWidth =
        theme?.groupBorderWidth ?? TAvatarDefaults.groupBorderWidth;
    final borderWidth = requestedBorderWidth.isFinite
        ? requestedBorderWidth.clamp(0, resolvedDimension / 2).toDouble()
        : TAvatarDefaults.groupBorderWidth
              .clamp(0, resolvedDimension / 2)
              .toDouble();
    final width = resolvedDimension + step * (visible.length - 1);
    final indexes = List.generate(visible.length, (index) => index);
    final paintOrder = cascading == TAvatarGroupCascading.startUp
        ? indexes.reversed
        : indexes;

    return SizedBox(
      width: width,
      height: resolvedDimension,
      child: Stack(
        children: [
          for (final index in paintOrder)
            PositionedDirectional(
              start: step * index,
              child: _buildMember(
                context,
                visible[index],
                theme,
                resolvedDimension,
                borderWidth,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMember(
    BuildContext context,
    Widget child,
    TAvatarThemeData? theme,
    double resolvedDimension,
    double borderWidth,
  ) {
    final shape = _shapeForChild(child, theme);
    final squareRadius =
        theme?.squareBorderRadius ?? context.tTheme.radiusDefault;
    final innerDimension = resolvedDimension - borderWidth * 2;
    final innerRadius = shape == TAvatarShape.circle
        ? innerDimension / 2
        : (squareRadius - borderWidth).clamp(0, innerDimension / 2).toDouble();
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: shape == TAvatarShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        borderRadius: shape == TAvatarShape.square
            ? BorderRadius.circular(squareRadius)
            : null,
        border: Border.all(
          color: theme?.groupBorderColor ?? context.tTheme.bgColorContainer,
          width: borderWidth,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(borderWidth),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(innerRadius),
          child: SizedBox.square(
            dimension: innerDimension,
            child: FittedBox(child: child),
          ),
        ),
      ),
    );
  }

  TAvatarShape _shapeForChild(Widget child, TAvatarThemeData? theme) {
    if (child is TAvatar) {
      return child.shape ??
          _avatarShapeFromVariant(child.variant) ??
          theme?.shape ??
          _avatarShapeFromVariant(theme?.variant) ??
          TAvatarShape.circle;
    }
    return theme?.shape ??
        _avatarShapeFromVariant(theme?.variant) ??
        TAvatarShape.circle;
  }
}

TAvatarShape? _avatarShapeFromVariant(TAvatarVariant? value) => switch (value) {
  TAvatarVariant.circle => TAvatarShape.circle,
  TAvatarVariant.square => TAvatarShape.square,
  null => null,
};
