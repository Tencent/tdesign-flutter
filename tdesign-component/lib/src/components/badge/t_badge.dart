import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import '../text/t_text.dart';
import 't_badge_defaults.dart';
import 't_badge_theme_data.dart';

// Badge 专有几何来自移动端设计规范；公共色彩、字体与圆角仍由主题 token 提供。
const _badgeSquareRadius = 2.0;
const _badgeBubbleSharpRadius = 1.0;

/// 徽标的结构形态；尺寸与描边分别由 [TBadge.size]、[TBadge.border] 控制。
enum TBadgeVariant {
  /// 标准文本徽标；单字符呈圆形，多字符随内容扩展为胶囊形。
  normal,

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

/// 徽标的预设尺寸，控制文字 Token 与标签行盒高度。
enum TBadgeSize {
  /// 中尺寸，使用 `fontMarkExtraSmall` 与 16 逻辑像素标签行盒。
  medium,

  /// 大尺寸，使用 `fontMarkSmall` 与 20 逻辑像素标签行盒。
  large,
}

/// 在内容边角或独立位置展示短文本、圆点或角标状态。
///
/// 默认使用 [TBadgeVariant.normal] 与 [TBadgeSize.medium]。
class TBadge extends StatelessWidget {
  const TBadge({
    super.key,
    this.label = '0',
    this.variant = TBadgeVariant.normal,
    this.size = TBadgeSize.medium,
    this.border = false,
    this.showZero = true,
    this.offset,
    this.child,
    this.onTap,
  });

  /// 徽标实际展示的短文本，例如 `8`、`99+` 或 `NEW`。
  ///
  /// 文本形态下为 null 时隐藏徽标；[TBadgeVariant.dot] 不读取该字段。
  final String? label;

  /// 徽标的结构形态，默认为 [TBadgeVariant.normal]。
  final TBadgeVariant variant;

  /// 徽标的预设尺寸，默认为 [TBadgeSize.medium]。
  final TBadgeSize size;

  /// 是否为徽标增加对比色描边，默认为 false，适用于全部形态。
  final bool border;

  /// [label] 恰好为字符串 `0` 时是否显示徽标，默认为 true。
  ///
  /// [TBadgeVariant.dot] 始终显示，不受该字段影响。
  final bool showZero;

  /// 相对默认锚点的逐实例位置偏移；未设置时读取 [BadgeThemeData.offset]。
  final Offset? offset;

  /// 被徽标标记的内容；为空时徽标可独立展示。
  final Widget? child;

  /// 点击徽标及其 [child] 时触发；为空时不创建点击语义。
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    final localBadgeTheme = context
        .dependOnInheritedWidgetOfExactType<BadgeTheme>()
        ?.data;
    final globalBadgeTheme = materialTheme.tExplicitBadgeTheme;
    final tTheme = Theme.of(context).extension<TBadgeThemeData>();
    final token = context.tTheme;
    final backgroundColor =
        localBadgeTheme?.backgroundColor ??
        globalBadgeTheme?.backgroundColor ??
        token.errorNormalColor;
    final textColor =
        localBadgeTheme?.textColor ??
        globalBadgeTheme?.textColor ??
        token.textColorAnti;
    final smallSize =
        localBadgeTheme?.smallSize ??
        globalBadgeTheme?.smallSize ??
        TBadgeDefaults.dotSize;
    final font = size == TBadgeSize.large
        ? token.fontMarkSmall
        : token.fontMarkExtraSmall;
    final materialTextStyle = size == TBadgeSize.large
        ? materialTheme.tExplicitTextTheme?.labelMedium
        : materialTheme.tExplicitTextTheme?.labelSmall;
    final textStyle =
        localBadgeTheme?.textStyle ??
        globalBadgeTheme?.textStyle ??
        materialTextStyle ??
        TextStyle(
          color: textColor,
          fontSize: font?.size,
          height: font?.height,
          fontWeight: font?.fontWeight,
        );
    const mediumPadding = EdgeInsets.symmetric(horizontal: 4);
    const largePadding = EdgeInsets.symmetric(horizontal: 5);
    final padding =
        localBadgeTheme?.padding ??
        globalBadgeTheme?.padding ??
        (size == TBadgeSize.large ? largePadding : mediumPadding);
    final alignment = localBadgeTheme?.alignment ?? globalBadgeTheme?.alignment;
    final effectiveOffset =
        offset ?? localBadgeTheme?.offset ?? globalBadgeTheme?.offset;
    final visible =
        variant == TBadgeVariant.dot ||
        (label != null && (showZero || label != '0'));
    final tokenHeight = (font?.size ?? 0) * (font?.height ?? 0);
    final defaultLabelHeight = tokenHeight > 0
        ? tokenHeight
        : size == TBadgeSize.large
        ? 20.0
        : 16.0;
    final effectiveLargeSize =
        localBadgeTheme?.largeSize ??
        globalBadgeTheme?.largeSize ??
        defaultLabelHeight;
    final isDot = variant == TBadgeVariant.dot;
    final isCorner = _isCornerVariant(variant);
    final text = label ?? '';
    final textLabel = TText(
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
    );
    final borderColor =
        tTheme?.borderColor ??
        materialTheme.tExplicitColorScheme?.surface ??
        token.bgColorContainer;
    final borderWidth = tTheme?.borderWidth ?? 1;
    final effectivePadding = isDot ? EdgeInsets.zero : padding;

    if (isCorner) {
      final cornerBadge = _buildCornerBadge(
        label: textLabel,
        visible: visible,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
        dimension: effectiveLargeSize * 2,
        offset: effectiveOffset ?? Offset.zero,
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

    final badgeLabel = isDot
        ? border
              ? _buildDecoratedLabel(
                  label: null,
                  backgroundColor: backgroundColor,
                  borderColor: borderColor,
                  borderWidth: borderWidth,
                  padding: EdgeInsets.zero,
                  minHeight: smallSize,
                  minWidth: smallSize,
                  borderRadius: BorderRadius.circular(token.radiusRound),
                )
              : null
        : _buildLabelForVariant(
            label: textLabel,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            padding: effectivePadding,
            height: effectiveLargeSize,
          );
    final usesCustomLabel =
        border ||
        variant == TBadgeVariant.square ||
        variant == TBadgeVariant.bubble;
    final effectiveLabel = badgeLabel;
    final badge = Badge(
      isLabelVisible: visible,
      alignment: alignment,
      offset: effectiveOffset,
      backgroundColor: usesCustomLabel ? Colors.transparent : backgroundColor,
      textColor: textColor,
      textStyle: textStyle,
      padding: usesCustomLabel ? EdgeInsets.zero : effectivePadding,
      largeSize: isDot && border ? smallSize : effectiveLargeSize,
      smallSize: smallSize,
      label: effectiveLabel,
      child: child,
    );

    if (onTap == null) {
      return badge;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: badge,
    );
  }

  bool _isCornerVariant(TBadgeVariant value) => switch (value) {
    TBadgeVariant.ribbonRight ||
    TBadgeVariant.ribbonLeft ||
    TBadgeVariant.triangleRight ||
    TBadgeVariant.triangleLeft => true,
    _ => false,
  };

  Widget _buildLabelForVariant({
    required Widget label,
    required Color backgroundColor,
    required Color borderColor,
    required double borderWidth,
    required EdgeInsetsGeometry padding,
    required double height,
  }) {
    return switch (variant) {
      TBadgeVariant.square => _buildDecoratedLabel(
        label: label,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderWidth: border ? borderWidth : 0,
        padding: EdgeInsets.zero,
        minHeight: height,
        minWidth: height,
        borderRadius: BorderRadius.circular(_badgeSquareRadius),
      ),
      TBadgeVariant.bubble => _buildDecoratedLabel(
        label: label,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderWidth: border ? borderWidth : 0,
        padding: padding,
        minHeight: height,
        minWidth: 0,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(height),
          topRight: Radius.circular(height),
          bottomRight: Radius.circular(height),
          bottomLeft: const Radius.circular(_badgeBubbleSharpRadius),
        ),
      ),
      _ when border => _buildDecoratedLabel(
        label: label,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
        padding: padding,
        minHeight: height,
        minWidth: 0,
        borderRadius: BorderRadius.circular(999),
      ),
      _ => label,
    };
  }

  Widget _buildDecoratedLabel({
    required Widget? label,
    required Color backgroundColor,
    required Color borderColor,
    required double borderWidth,
    required EdgeInsetsGeometry padding,
    required double minHeight,
    required double minWidth,
    required BorderRadiusGeometry borderRadius,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight, minWidth: minWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: borderWidth > 0
              ? Border.all(color: borderColor, width: borderWidth)
              : null,
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: padding,
          child: Center(child: label),
        ),
      ),
    );
  }

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
