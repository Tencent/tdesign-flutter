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
  }) : badge = null,
       _fallbackAlignment = null,
       _fallbackOffset = null;

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
       showZero = true,
       _fallbackAlignment = null,
       _fallbackOffset = null;

  /// 使用组合组件提供的 [config] 创建徽标；回退位置只在配置与 [BadgeThemeData] 均未指定位置时生效。
  TBadge.fromConfig({
    super.key,

    /// 组合组件传入的徽标内容、形态与可选位置覆盖。
    required TBadgeConfig config,
    this.child,
    this.onTap,

    /// 消费组件为自身锚点定义的默认对齐方式。
    AlignmentGeometry? fallbackAlignment,

    /// 消费组件为自身锚点定义的默认偏移。
    Offset? fallbackOffset,
  }) : label = config.label,
       variant = config.variant,
       size = config.size,
       border = config.border,
       showZero = config.showZero,
       alignment = config.alignment,
       offset = config.offset,
       badge = config.badge,
       _fallbackAlignment = fallbackAlignment,
       _fallbackOffset = fallbackOffset;

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
  /// 为空时依次读取局部与全局 [BadgeThemeData.alignment]，最终回退为右上角。
  /// ribbon、triangle 的方位已编码在 [variant] 中，不读取该字段。
  /// 当 [child] 为空时不参与布局。
  final AlignmentGeometry? alignment;

  /// 相对默认锚点的逐实例位置偏移；未设置时读取 [BadgeThemeData.offset]，
  /// 再读取组合组件提供的默认偏移，最终回退为 [Offset.zero]。
  ///
  /// 默认右上角徽标以中心点对齐内容右上角。当 [child] 为空时不参与布局。
  final Offset? offset;

  /// 被徽标标记的内容；为空时徽标可独立展示。
  final Widget? child;

  /// [TBadge.custom] 提供的完整徽标外观。
  ///
  /// 普通构造下为 null。该 Widget 仅表示徽标本体，不包含 [child]。
  final Widget? badge;

  /// 点击徽标及其 [child] 时触发；为空时不创建点击语义。
  final GestureTapCallback? onTap;

  final AlignmentGeometry? _fallbackAlignment;
  final Offset? _fallbackOffset;

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
    const largePadding = EdgeInsets.symmetric(horizontal: 6);
    final padding =
        localBadgeTheme?.padding ??
        globalBadgeTheme?.padding ??
        (size == TBadgeSize.large ? largePadding : mediumPadding);
    final resolvedAlignment =
        alignment ??
        localBadgeTheme?.alignment ??
        globalBadgeTheme?.alignment ??
        _fallbackAlignment;
    final resolvedOffset =
        offset ??
        localBadgeTheme?.offset ??
        globalBadgeTheme?.offset ??
        _fallbackOffset;
    if (badge != null) {
      return _buildCustomBadge(
        context: context,
        badge: badge!,
        alignment: resolvedAlignment ?? AlignmentDirectional.topEnd,
        offset: resolvedOffset ?? Offset.zero,
      );
    }
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
    final resolvedPadding = padding.resolve(Directionality.of(context));
    final singleCharacterWidth = text.runes.length == 1 && !isDot
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
      child: Center(
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
        offset: resolvedOffset ?? Offset.zero,
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
    final effectiveAlignment = resolvedAlignment ?? AlignmentDirectional.topEnd;
    final effectiveOffset = resolvedOffset ?? Offset.zero;
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
        padding: padding,
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
        minWidth: height,
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
