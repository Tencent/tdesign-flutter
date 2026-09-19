import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../text/t_text.dart';
import 't_badge_fallback.dart';
import 't_badge_label.dart';
import 't_badge_layout.dart';
import 't_badge_resolved_style.dart';

/// 徽标的结构形态；尺寸与描边分别由 [TBadge.size]、[TBadge.border] 控制。
enum TBadgeVariant {
  /// 标准文本徽标；单字符呈圆形，多字符随内容扩展为胶囊形。
  circle,

  /// 不显示文本的圆点徽标，默认直径为 8 逻辑像素。
  dot,

  /// 小圆角方形文本徽标；多字符时随内容横向扩展为矩形。
  square,

  /// 左下角收紧、其余角为圆角的气泡徽标。
  bubble,

  /// 位于内容物理右上角的带状角标；RTL 下不交换方位。
  ribbonRight,

  /// 位于内容物理左上角的带状角标；RTL 下不交换方位。
  ribbonLeft,

  /// 位于内容物理右上角的三角角标；RTL 下不交换方位。
  triangleRight,

  /// 位于内容物理左上角的三角角标；RTL 下不交换方位。
  triangleLeft,
}

/// 徽标的预设尺寸，控制文本徽标的文字 Token、标签行盒高度与水平内边距。
///
/// [TBadgeVariant.dot] 的直径由 [BadgeThemeData.smallSize] 控制，不读取该值；
/// 角标形态会按该值在 32 与 40 逻辑像素两档尺寸之间切换。
enum TBadgeSize {
  /// 中尺寸，使用 `fontMarkExtraSmall` 与 16 逻辑像素标签行盒。
  medium,

  /// 大尺寸，使用 `fontMarkSmall` 与 20 逻辑像素标签行盒。
  large,
}

/// 由组合组件消费的徽标配置。
///
/// 该对象不参与 Widget 树，也不拥有被标记的内容。仅当 TabBar、SideBar、
/// ActionSheet 等组件在内部创建徽标锚点时使用；组件会把配置和自己的锚点交给
/// 与 [TBadge] 相同的渲染实现。
///
/// 调用方已经拥有锚点 Widget 时，应直接使用 [TBadge]：
///
/// ```dart
/// TBadge(label: '8', child: icon)
/// ```
///
/// 完全自定义徽标外观时使用 [TBadgeConfig.custom]。传入的 [badge] 是徽标本体，
/// 不应包含锚点或自行使用 `Positioned` 定位。
@immutable
class TBadgeConfig {
  const TBadgeConfig({
    this.label = '0',
    this.variant = TBadgeVariant.circle,
    this.size = TBadgeSize.medium,
    this.border = false,
    this.showZero = true,
    this.alignment,
    this.offset,
  }) : badge = null;

  /// 创建完全自定义外观的徽标配置。
  ///
  /// [badge] 仅定义徽标本体；最终锚点和默认位置由消费该配置的组合组件决定。
  const TBadgeConfig.custom({required this.badge, this.alignment, this.offset})
    : label = null,
      variant = TBadgeVariant.circle,
      size = TBadgeSize.medium,
      border = false,
      showZero = true;

  /// 预设徽标展示的短文本，例如 `8`、`99+` 或 `NEW`。
  ///
  /// 文本形态下为 null 时隐藏徽标；[TBadgeVariant.dot] 不读取该字段。
  /// [TBadgeConfig.custom] 下固定为 null。
  final String? label;

  /// 预设徽标的结构形态，默认为 [TBadgeVariant.circle]。
  ///
  /// [TBadgeConfig.custom] 不读取该字段。
  final TBadgeVariant variant;

  /// 预设徽标尺寸，默认为 [TBadgeSize.medium]。
  ///
  /// [TBadgeVariant.dot] 与 [TBadgeConfig.custom] 不读取该字段。
  final TBadgeSize size;

  /// 是否为预设徽标增加对比色描边，默认为 false。
  ///
  /// [TBadgeConfig.custom] 不读取该字段。
  final bool border;

  /// [label] 恰好为字符串 `0` 时是否显示，默认为 true。
  ///
  /// [TBadgeVariant.dot] 与 [TBadgeConfig.custom] 不读取该字段。
  final bool showZero;

  /// 徽标相对锚点的对齐方式。
  ///
  /// 为空时依次使用当前 [BadgeThemeData.alignment] 和消费组件的默认值。
  /// ribbon、triangle 的方位已编码在 [variant] 中，不读取该字段。
  final AlignmentGeometry? alignment;

  /// 在最终对齐位置上追加的偏移。
  ///
  /// 为空时依次使用当前 [BadgeThemeData.offset] 和消费组件的默认值。
  /// 显式值使用物理坐标：正 x 始终向右，RTL 下不会自动镜像；消费组件仅会
  /// 根据最终生效的 [alignment] 转换自己提供的默认偏移。
  /// ribbon、triangle 始终贴住锚点的物理左上角或右上角，但仍读取该偏移。
  final Offset? offset;

  /// [TBadgeConfig.custom] 提供的完整徽标外观。
  ///
  /// 普通构造下为 null。该 Widget 不包含锚点，定位由消费组件负责。
  final Widget? badge;

  /// 当前配置是否使用完全自定义徽标外观。
  bool get isCustom => badge != null;
}

/// 在内容边角或独立位置展示短文本、圆点或角标状态。
///
/// 默认使用 [TBadgeVariant.circle] 与 [TBadgeSize.medium]。当 [child] 非空时，
/// 徽标叠加在 [child] 上；当 [child] 为空时，只渲染徽标本体。
///
/// TabBar、SideBar、ActionSheet 等内部拥有锚点的组合组件使用
/// [TBadgeConfig]，调用方不应向这些组件传入一个待拆解的 [TBadge]。
class TBadge extends StatelessWidget {
  const TBadge({
    super.key,
    this.label = '0',
    this.variant = TBadgeVariant.circle,
    this.size = TBadgeSize.medium,
    this.border = false,
    this.showZero = true,
    this.alignment,
    this.offset,
    this.child,
    this.onTap,
  }) : badge = null;

  /// 创建完全自定义外观的徽标；[badge] 是徽标本体，[child] 是可选锚点，未提供锚点时直接展示徽标本体。
  const TBadge.custom({
    super.key,
    required this.badge,
    this.alignment,
    this.offset,
    this.child,
    this.onTap,
  }) : label = null,
       variant = TBadgeVariant.circle,
       size = TBadgeSize.medium,
       border = false,
       showZero = true;

  /// 徽标实际展示的短文本，例如 `8`、`99+` 或 `NEW`。
  ///
  /// 文本形态下为 null 时隐藏徽标；[TBadgeVariant.dot] 不读取该字段。
  final String? label;

  /// 徽标的结构形态，默认为 [TBadgeVariant.circle]。
  ///
  /// [TBadge.custom] 不读取该字段。
  final TBadgeVariant variant;

  /// 徽标的预设尺寸，默认为 [TBadgeSize.medium]。
  ///
  /// [TBadgeVariant.dot] 与 [TBadge.custom] 不读取该字段。
  final TBadgeSize size;

  /// 是否为徽标增加对比色描边，默认为 false，适用于全部形态。
  final bool border;

  /// [label] 恰好为字符串 `0` 时是否显示徽标，默认为 true。
  ///
  /// [TBadgeVariant.dot] 始终显示，不受该字段影响。
  final bool showZero;

  /// 徽标相对 [child] 的对齐方式。
  ///
  /// 为空时依次读取局部与全局 [BadgeThemeData.alignment]，最终回退为逻辑
  /// 右上角 [AlignmentDirectional.topEnd]，在 RTL 下对应物理左上角。
  /// ribbon、triangle 的方位已编码在 [variant] 中，不读取该字段。
  /// 当 [child] 为空时不参与布局。
  final AlignmentGeometry? alignment;

  /// 相对默认锚点的逐实例位置偏移；未设置时读取 [BadgeThemeData.offset]，
  /// 再读取组合组件提供的默认偏移，最终回退为 [Offset.zero]。
  ///
  /// 显式值使用物理坐标：正 x 始终向右，RTL 下不会自动镜像。
  /// 默认徽标以中心点对齐内容的逻辑右上角，在 RTL 下对应物理左上角。
  /// 当 [child] 为空时不参与布局。
  final Offset? offset;

  /// 被徽标标记的内容；为空时徽标可独立展示。
  final Widget? child;

  /// [TBadge.custom] 提供的完整徽标外观。
  ///
  /// 普通构造下为 null。该 Widget 仅表示徽标本体，不包含 [child]。
  final Widget? badge;

  /// 点击徽标及其 [child] 时触发；为空时不创建点击语义。
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fallback = context
        .dependOnInheritedWidgetOfExactType<TBadgeFallback>();
    final style = TBadgeResolvedStyle.resolve(
      context,
      large: size == TBadgeSize.large,
      alignment: alignment,
      offset: offset,
      fallbackAlignment: fallback?.alignment,
      fallbackOffset: fallback?.offset,
    );
    final backgroundColor = style.backgroundColor;
    final textColor = style.textColor;
    final smallSize = style.smallSize;
    final textStyle = style.textStyle;
    final padding = style.padding;
    final resolvedAlignment = style.alignment;
    final resolvedOffset = style.offset;
    if (badge != null) {
      return _buildCustomBadge(
        context: context,
        badge: badge!,
        alignment: resolvedAlignment,
        offset: resolvedOffset,
      );
    }
    final visible =
        variant == TBadgeVariant.dot ||
        (label != null && (showZero || label != '0'));
    final effectiveLargeSize = style.largeSize;
    final isDot = variant == TBadgeVariant.dot;
    final isCorner = _isCornerVariant(variant);
    final text = label ?? '';
    final resolvedPadding = padding.resolve(Directionality.of(context));
    final singleCharacterWidth = isSingleBadgeCharacter(text) && !isDot
        ? math
              .max(0.0, effectiveLargeSize - resolvedPadding.horizontal)
              .toDouble()
        : null;
    final textLineHeight = switch ((textStyle.fontSize, textStyle.height)) {
      (final double fontSize, final double height) =>
        MediaQuery.textScalerOf(context).scale(fontSize) * height,
      _ => effectiveLargeSize,
    };
    final textLabel = SizedBox(
      height: textLineHeight,
      width: singleCharacterWidth,
      child: Align(
        widthFactor: 1,
        heightFactor: 1,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: TText(
            text,
            style: textStyle.copyWith(
              color: textColor,
              leadingDistribution:
                  textStyle.leadingDistribution ?? TextLeadingDistribution.even,
            ),
            textHeightBehavior: const TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
          ),
        ),
      ),
    );
    final borderColor = style.borderColor;
    final borderWidth = style.borderWidth;
    final effectivePadding = isDot ? EdgeInsets.zero : padding;

    if (isCorner) {
      final cornerBadge = _buildCornerBadge(
        label: textLabel,
        visible: visible,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
        dimension: effectiveLargeSize * 2,
        offset: resolvedOffset,
      );
      final result = Stack(
        clipBehavior: Clip.none,
        children: [
          child ?? SizedBox.square(dimension: effectiveLargeSize * 2),
          cornerBadge,
        ],
      );
      return onTap == null
          ? result
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: result,
            );
    }

    final labelShape = switch (variant) {
      TBadgeVariant.dot => TBadgeLabelShape.dot,
      TBadgeVariant.square => TBadgeLabelShape.square,
      TBadgeVariant.bubble => TBadgeLabelShape.bubble,
      _ => TBadgeLabelShape.circle,
    };
    final badgeLabel = TBadgeLabel(
      shape: labelShape,
      visible: visible,
      label: textLabel,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: border ? borderWidth : 0,
      padding: effectivePadding,
      height: effectiveLargeSize,
      dotSize: smallSize,
    );
    if (variant == TBadgeVariant.square || variant == TBadgeVariant.bubble) {
      final result = child == null
          ? badgeLabel
          : _buildAnchoredBadge(
              context: context,
              badge: badgeLabel,
              alignment: resolvedAlignment,
              offset: resolvedOffset,
            );
      return _wrapTap(result);
    }
    final usesCustomLabel = border;
    final effectiveLabel = border ? badgeLabel : (isDot ? null : textLabel);
    final effectiveAlignment = resolvedAlignment;
    final effectiveOffset = resolvedOffset;
    final materialBadge = Badge(
      isLabelVisible: visible,
      alignment: effectiveAlignment,
      offset: effectiveOffset,
      backgroundColor: usesCustomLabel ? Colors.transparent : backgroundColor,
      textColor: textColor,
      textStyle: textStyle,
      padding: usesCustomLabel ? EdgeInsets.zero : effectivePadding,
      largeSize: isDot && border ? smallSize : effectiveLargeSize,
      smallSize: smallSize,
      label: effectiveLabel,
    );
    final result = child == null
        ? materialBadge
        : _buildAnchoredBadge(
            context: context,
            badge: materialBadge,
            alignment: effectiveAlignment,
            offset: effectiveOffset,
          );
    return _wrapTap(result);
  }

  Widget _buildCustomBadge({
    required BuildContext context,
    required Widget badge,
    required AlignmentGeometry alignment,
    required Offset offset,
  }) {
    Widget result;
    if (child == null) {
      result = badge;
    } else {
      result = _buildAnchoredBadge(
        context: context,
        badge: badge,
        alignment: alignment,
        offset: offset,
      );
    }
    return _wrapTap(result);
  }

  Widget _buildAnchoredBadge({
    required BuildContext context,
    required Widget badge,
    required AlignmentGeometry alignment,
    required Offset offset,
  }) {
    final resolvedAlignment = alignment.resolve(Directionality.of(context));
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        Positioned.fill(
          child: OverflowBox(
            alignment: resolvedAlignment,
            minWidth: 0,
            minHeight: 0,
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            child: FractionalTranslation(
              translation: Offset(
                resolvedAlignment.x / 2,
                resolvedAlignment.y / 2,
              ),
              child: Transform.translate(offset: offset, child: badge),
            ),
          ),
        ),
      ],
    );
  }

  Widget _wrapTap(Widget result) {
    return onTap == null
        ? result
        : GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: result,
          );
  }

  bool _isCornerVariant(TBadgeVariant value) => switch (value) {
    TBadgeVariant.ribbonRight ||
    TBadgeVariant.ribbonLeft ||
    TBadgeVariant.triangleRight ||
    TBadgeVariant.triangleLeft => true,
    _ => false,
  };

  Widget _buildCornerBadge({
    required Widget label,
    required bool visible,
    required Color backgroundColor,
    required Color borderColor,
    required double borderWidth,
    required double dimension,
    required Offset offset,
  }) {
    if (!visible) {
      return const SizedBox.shrink();
    }
    final isLeft =
        variant == TBadgeVariant.ribbonLeft ||
        variant == TBadgeVariant.triangleLeft;
    final isRibbon =
        variant == TBadgeVariant.ribbonLeft ||
        variant == TBadgeVariant.ribbonRight;
    final corner = SizedBox.square(
      dimension: dimension,
      child: CustomPaint(
        painter: _CornerBadgePainter(
          color: backgroundColor,
          borderColor: borderColor,
          borderWidth: border ? borderWidth : 0,
          isLeft: isLeft,
          isRibbon: isRibbon,
        ),
        child: Center(
          child: Transform.rotate(
            angle: isLeft ? -math.pi / 4 : math.pi / 4,
            child: Transform.translate(
              offset: Offset(0, -dimension * 0.18),
              child: SizedBox(
                width: dimension * 0.8,
                height: dimension * 0.38,
                child: FittedBox(fit: BoxFit.scaleDown, child: label),
              ),
            ),
          ),
        ),
      ),
    );
    return Positioned(
      top: offset.dy,
      left: isLeft ? offset.dx : null,
      right: isLeft ? null : -offset.dx,
      child: corner,
    );
  }
}

class _CornerBadgePainter extends CustomPainter {
  const _CornerBadgePainter({
    required this.color,
    required this.borderColor,
    required this.borderWidth,
    required this.isLeft,
    required this.isRibbon,
  });

  final Color color;
  final Color borderColor;
  final double borderWidth;
  final bool isLeft;
  final bool isRibbon;

  @override
  void paint(Canvas canvas, Size size) {
    final path = isRibbon ? _ribbonPath(size) : _trianglePath(size);
    canvas.drawPath(path, Paint()..color = color);
    if (borderWidth > 0) {
      canvas.drawPath(
        path,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth,
      );
    }
  }

  Path _trianglePath(Size size) => isLeft
      ? (Path()
          ..lineTo(size.width, 0)
          ..lineTo(0, size.height)
          ..close())
      : (Path()
          ..moveTo(size.width, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, 0)
          ..close());

  Path _ribbonPath(Size size) {
    final inner = size.width * 0.3;
    final outer = size.width * 0.7;
    return isLeft
        ? (Path()
            ..moveTo(size.width, 0)
            ..lineTo(inner, 0)
            ..lineTo(0, inner)
            ..lineTo(0, size.height)
            ..close())
        : (Path()
            ..moveTo(0, 0)
            ..lineTo(outer, 0)
            ..lineTo(size.width, inner)
            ..lineTo(size.width, size.height)
            ..close());
  }

  @override
  bool shouldRepaint(covariant _CornerBadgePainter oldDelegate) =>
      color != oldDelegate.color ||
      borderColor != oldDelegate.borderColor ||
      borderWidth != oldDelegate.borderWidth ||
      isLeft != oldDelegate.isLeft ||
      isRibbon != oldDelegate.isRibbon;
}
