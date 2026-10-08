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
/// [child] 会作为图片加载失败前的背景内容。默认图标与文字前景色由
/// [TAvatarThemeData.foregroundColor] 控制；特殊文字排版可在 [child] 中使用
/// `Text(style: ...)`，组件不再额外提供文字样式入口。
class TAvatar extends StatelessWidget {
  const TAvatar({
    this.image,
    this.child,
    this.size,
    this.shape,
    this.fit = BoxFit.cover,
    this.onTap,
    super.key,
  });

  /// 头像图片。
  final ImageProvider<Object>? image;

  /// 自定义头像内容。
  final Widget? child;

  /// 头像尺寸；未设置时继承所在头像组的尺寸，独立使用时默认为中号。
  final TAvatarSize? size;

  /// 头像形状；未设置时使用圆形默认值。
  final TAvatarShape? shape;

  /// 图片填充方式。
  final BoxFit fit;

  /// 点击回调；为空时头像不创建点击行为。
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TAvatarThemeData>();
    final resolvedSize =
        size ??
        _AvatarGroupSizeScope.maybeOf(context)?.size ??
        TAvatarSize.medium;
    final resolvedShape = shape ?? TAvatarShape.circle;
    final dimension =
        theme?.resolveDimension(resolvedSize) ??
        TAvatarDefaults.dimensionFor(resolvedSize);
    final radius = resolvedShape == TAvatarShape.circle
        ? theme?.resolveCircleBorderRadius(context.tTheme.radiusCircle) ??
              context.tTheme.radiusCircle
        : theme?.resolveSquareBorderRadius(context.tTheme.radiusDefault) ??
              context.tTheme.radiusDefault;
    final resolvedForegroundColor =
        theme?.foregroundColor ?? context.tTheme.brandColor;
    final resolvedTextStyle = TAvatarDefaults.textStyleFor(
      resolvedSize,
    ).copyWith(color: resolvedForegroundColor);
    final content =
        child ??
        Icon(
          TIcons.user,
          size:
              theme?.resolveIconSize(resolvedSize) ??
              TAvatarDefaults.iconSizeFor(resolvedSize),
          color: resolvedForegroundColor,
        );

    final avatar = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: ColoredBox(
        color: theme?.backgroundColor ?? context.tTheme.brandColorLightActive,
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
/// 其他 Widget 使用圆形默认值。
/// 组尺寸由首个可见且显式设置 [TAvatar.size] 的成员确定，未设置时为中号；
/// 成员自己的显式尺寸始终优先，未设置的成员和折叠头像继承组尺寸。
/// 默认按 8 逻辑像素重叠，所有成员使用按尺寸区分的描边与阴影；
/// 可通过 [TAvatarThemeData] 调整这些视觉值。
class TAvatarGroup extends StatelessWidget {
  const TAvatarGroup({
    required this.children,
    this.maxCount,
    this.overflow,
    this.spacing,
    this.cascading = TAvatarGroupCascading.endUp,
    super.key,
  }) : assert(maxCount == null || maxCount > 0),
       assert(spacing == null || (spacing >= 0 && spacing != double.infinity));

  /// 头像列表。
  final List<Widget> children;

  /// 最多显示的原始头像数量；为空时显示全部，非空时必须大于 0。
  /// 若发生截断且提供了 [overflow]，会额外显示一个折叠头像。
  final int? maxCount;

  /// 发生截断时显示在末尾的内容。
  final Widget? overflow;

  /// 相邻头像的重叠宽度；非空时必须是有限、非负值，布局时限制到成员边长。
  /// 为空时使用组件主题，最终回退为 8 逻辑像素。
  final double? spacing;

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
    final groupSize =
        children
            .take(count)
            .whereType<TAvatar>()
            .fold<TAvatarSize?>(
              null,
              (result, avatar) => result ?? avatar.size,
            ) ??
        TAvatarSize.medium;
    final dimensions = visible.map((child) {
      final size = child is TAvatar ? child.size ?? groupSize : groupSize;
      final requested =
          theme?.resolveDimension(size) ?? TAvatarDefaults.dimensionFor(size);
      return requested.isFinite && requested > 0
          ? requested
          : TAvatarDefaults.dimensionFor(size);
    }).toList();
    final resolvedDimension = dimensions.reduce((a, b) => a > b ? a : b);
    final requestedOverlap =
        spacing ??
        theme?.resolveGroupSpacing(resolvedDimension) ??
        TAvatarDefaults.groupSpacing;
    final overlap = requestedOverlap.isFinite
        ? requestedOverlap.clamp(0, resolvedDimension).toDouble()
        : TAvatarDefaults.groupSpacing.clamp(0, resolvedDimension).toDouble();
    final positions = <double>[];
    var width = 0.0;
    for (var index = 0; index < dimensions.length; index++) {
      positions.add(width);
      width += dimensions[index];
      if (index < dimensions.length - 1) {
        width -= overlap.clamp(0, dimensions[index]).toDouble();
      }
    }
    final indexes = List.generate(visible.length, (index) => index);
    final paintOrder = cascading == TAvatarGroupCascading.startUp
        ? indexes.reversed
        : indexes;

    return SizedBox(
      width: width,
      height: resolvedDimension,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (final index in paintOrder)
            PositionedDirectional(
              start: positions[index],
              top: (resolvedDimension - dimensions[index]) / 2,
              child: _buildMember(
                context,
                visible[index],
                theme,
                dimensions[index],
                groupSize,
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
    TAvatarSize groupSize,
  ) {
    final shape = _shapeForChild(child);
    final memberSize = child is TAvatar ? child.size ?? groupSize : groupSize;
    final requestedBorderWidth =
        theme?.resolveGroupBorderWidth(memberSize) ??
        TAvatarDefaults.groupBorderWidthFor(memberSize);
    final borderWidth = requestedBorderWidth.isFinite
        ? requestedBorderWidth.clamp(0, resolvedDimension / 2).toDouble()
        : TAvatarDefaults.groupBorderWidthFor(
            memberSize,
          ).clamp(0, resolvedDimension / 2).toDouble();
    final squareRadius =
        theme?.resolveSquareBorderRadius(context.tTheme.radiusDefault) ??
        context.tTheme.radiusDefault;
    final radius = shape == TAvatarShape.circle
        ? theme?.resolveCircleBorderRadius(context.tTheme.radiusCircle) ??
              context.tTheme.radiusCircle
        : squareRadius;
    final isFullCircle =
        shape == TAvatarShape.circle && radius >= resolvedDimension / 2;
    final decorationShape = isFullCircle ? BoxShape.circle : BoxShape.rectangle;
    final decorationRadius = decorationShape == BoxShape.rectangle
        ? BorderRadius.circular(radius)
        : null;
    final borderDecoration = BoxDecoration(
      shape: decorationShape,
      borderRadius: decorationRadius,
      border: Border.all(
        color: theme?.groupBorderColor ?? context.tTheme.bgColorContainer,
        width: borderWidth,
      ),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: decorationShape,
        borderRadius: decorationRadius,
        boxShadow: [theme?.groupShadow ?? TAvatarDefaults.groupShadow],
      ),
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: borderDecoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: SizedBox.square(
            dimension: resolvedDimension,
            child: _AvatarGroupSizeScope(size: groupSize, child: child),
          ),
        ),
      ),
    );
  }

  TAvatarShape _shapeForChild(Widget child) {
    if (child is TAvatar) {
      return child.shape ?? TAvatarShape.circle;
    }
    return TAvatarShape.circle;
  }
}

class _AvatarGroupSizeScope extends InheritedWidget {
  const _AvatarGroupSizeScope({required this.size, required super.child});

  final TAvatarSize size;

  static _AvatarGroupSizeScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_AvatarGroupSizeScope>();

  @override
  bool updateShouldNotify(_AvatarGroupSizeScope oldWidget) =>
      size != oldWidget.size;
}
