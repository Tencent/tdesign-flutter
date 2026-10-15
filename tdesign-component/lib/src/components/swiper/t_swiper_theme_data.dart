import 'package:flutter/material.dart';


const _defaultDotSize = 6.0;
const _defaultActiveDotExtent = 20.0;
const _defaultDotSpacing = 5.0;
const _defaultControlIconSize = 18.0;

/// 轮播组件级 ThemeExtension。
///
/// 保存指示器、内容圆角和切换按钮的视觉默认值。
///
/// {@category ComponentTheme}
class TSwiperThemeData extends ThemeExtension<TSwiperThemeData> {
  const TSwiperThemeData({
    this.paginationAlignment,
    this.paginationMargin,
    this.borderRadius,
    this.activeColor,
    this.inactiveColor,
    this.dotSize,
    this.activeDotExtent,
    this.dotSpacing,
    this.fractionStyle,
    this.fractionBackgroundColor,
    this.controlStyle,
  }) : assert(dotSize == null || dotSize > 0),
       assert(activeDotExtent == null || activeDotExtent > 0),
       assert(dotSpacing == null || dotSpacing >= 0);

  /// 默认指示器对齐方式。
  /// 未配置时 controls 居中，其他类型横向轮播为 bottomCenter、纵向轮播为 centerRight。
  final AlignmentGeometry? paginationAlignment;

  /// 指示器外边距。
  /// 未配置时普通指示器四边为 12；controls 沿滚动轴两端为 15 逻辑像素。
  final EdgeInsetsGeometry? paginationMargin;

  /// 轮播内容圆角。
  /// null 时使用 radiusLarge Token 构造圆角。
  final BorderRadiusGeometry? borderRadius;

  /// 激活项颜色。
  /// null 时使用 textColorAnti Token。
  final Color? activeColor;

  /// 未激活项颜色。
  final Color? inactiveColor;

  /// 圆点直径。
  /// 未配置时为 6 逻辑像素，必须大于 0。
  final double? dotSize;

  /// 长条激活项在滚动主轴上的长度。
  /// 未配置时为 20 逻辑像素，必须大于 0。
  final double? activeDotExtent;

  /// 圆点间距。
  /// 未配置时为 5 逻辑像素，必须大于或等于 0。
  final double? dotSpacing;

  /// 数字指示器文字样式。
  final TextStyle? fractionStyle;

  /// 数字指示器背景色。
  /// null 时使用 textColorPlaceholder Token。
  final Color? fractionBackgroundColor;

  /// 前后切换按钮样式；仅 controls 指示器生效。
  ///
  /// 非空字段覆盖 TD 默认值；状态属性返回 null 时回退到同状态默认值。
  /// iconSize 是图标尺寸的唯一主题入口，默认 18dp；自定义图标自身显式尺寸优先。
  /// 可配置颜色、图标、padding、尺寸、形状、描边、阴影、表面色和状态反馈，
  /// 以及鼠标指针、enableFeedback、splashFactory 和 tapTargetSize。
  /// 默认背景尺寸为 32dp、点击热区为 48dp；显式尺寸和 tapTargetSize 可调整热区。
  /// visualDensity 不生效，请使用 padding 或尺寸字段调整布局。
  /// animationDuration 仅控制按钮样式过渡，不改变 Swiper 的切页动画。
  /// textStyle 为自定义文字内容提供默认样式；iconAlignment 不创建图标文字布局。
  /// backgroundBuilder / foregroundBuilder 保留调用方主题及按钮的插槽默认样式。
  /// 外部 Material 按钮主题不覆盖此配置，切页、禁用和 Tooltip 由组件管理。
  /// 原 controlIconSize 请迁移为 ButtonStyle 的 iconSize 状态属性。
  /// 主题过渡中，图标尺寸、最小尺寸等使用组件有效默认值插值；
  /// 最大尺寸缺省保持无限约束，固定尺寸缺省恢复自然布局。
  /// 仅一端配置的颜色或文字样式切换到对应端配置，未配置时仍读取当前 TD 默认值。
  final ButtonStyle? controlStyle;

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TSwiperThemeData copyWith({
    AlignmentGeometry? paginationAlignment,
    EdgeInsetsGeometry? paginationMargin,
    BorderRadiusGeometry? borderRadius,
    Color? activeColor,
    Color? inactiveColor,
    double? dotSize,
    double? activeDotExtent,
    double? dotSpacing,
    TextStyle? fractionStyle,
    Color? fractionBackgroundColor,
    ButtonStyle? controlStyle,
  }) {
    return TSwiperThemeData(
      paginationAlignment: paginationAlignment ?? this.paginationAlignment,
      paginationMargin: paginationMargin ?? this.paginationMargin,
      borderRadius: borderRadius ?? this.borderRadius,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      dotSize: dotSize ?? this.dotSize,
      activeDotExtent: activeDotExtent ?? this.activeDotExtent,
      dotSpacing: dotSpacing ?? this.dotSpacing,
      fractionStyle: fractionStyle ?? this.fractionStyle,
      fractionBackgroundColor:
          fractionBackgroundColor ?? this.fractionBackgroundColor,
      controlStyle: controlStyle ?? this.controlStyle,
    );
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TSwiperThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    TSwiperThemeData? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other == null) {
      return this;
    }
    return TSwiperThemeData(
      paginationAlignment: AlignmentGeometry.lerp(
        paginationAlignment,
        other.paginationAlignment,
        t,
      ),
      paginationMargin: EdgeInsetsGeometry.lerp(
        paginationMargin,
        other.paginationMargin,
        t,
      ),
      borderRadius: BorderRadiusGeometry.lerp(
        borderRadius,
        other.borderRadius,
        t,
      ),
      activeColor: Color.lerp(activeColor, other.activeColor, t),
      inactiveColor: Color.lerp(inactiveColor, other.inactiveColor, t),
      dotSize: _lerpNullableDouble(dotSize, other.dotSize, t, _defaultDotSize),
      activeDotExtent: _lerpNullableDouble(
        activeDotExtent,
        other.activeDotExtent,
        t,
        _defaultActiveDotExtent,
      ),
      dotSpacing: _lerpNullableDouble(
        dotSpacing,
        other.dotSpacing,
        t,
        _defaultDotSpacing,
      ),
      fractionStyle: TextStyle.lerp(fractionStyle, other.fractionStyle, t),
      fractionBackgroundColor: Color.lerp(
        fractionBackgroundColor,
        other.fractionBackgroundColor,
        t,
      ),
      controlStyle: _lerpControlStyle(controlStyle, other.controlStyle, t),
    );
  }

  ButtonStyle? _lerpControlStyle(ButtonStyle? a, ButtonStyle? b, double t) {
    if (t == 0) {
      return a;
    }
    if (t == 1) {
      return b;
    }
    final style = ButtonStyle.lerp(a, b, t);
    if (style == null) {
      return null;
    }
    return style.copyWith(
      textStyle: _lerpStyleProperty(
        a?.textStyle,
        b?.textStyle,
        t,
        TextStyle.lerp,
      ),
      backgroundColor: _lerpStyleProperty(
        a?.backgroundColor,
        b?.backgroundColor,
        t,
        Color.lerp,
      ),
      foregroundColor: _lerpStyleProperty(
        a?.foregroundColor,
        b?.foregroundColor,
        t,
        Color.lerp,
      ),
      iconColor: _lerpStyleProperty(a?.iconColor, b?.iconColor, t, Color.lerp),
      overlayColor: _lerpStyleProperty(
        a?.overlayColor,
        b?.overlayColor,
        t,
        Color.lerp,
      ),
      shadowColor: _lerpStyleProperty(
        a?.shadowColor,
        b?.shadowColor,
        t,
        Color.lerp,
        fallback: Colors.transparent,
      ),
      surfaceTintColor: _lerpStyleProperty(
        a?.surfaceTintColor,
        b?.surfaceTintColor,
        t,
        Color.lerp,
        fallback: Colors.transparent,
      ),
      elevation: _lerpStyleProperty(
        a?.elevation,
        b?.elevation,
        t,
        (a, b, t) => a + (b - a) * t,
        fallback: 0.0,
      ),
      padding: _lerpStyleProperty(
        a?.padding,
        b?.padding,
        t,
        EdgeInsetsGeometry.lerp,
        fallback: EdgeInsets.zero,
      ),
      minimumSize: _lerpStyleProperty(
        a?.minimumSize,
        b?.minimumSize,
        t,
        Size.lerp,
        fallback: const Size.square(32),
      ),
      fixedSize: _lerpStyleProperty(a?.fixedSize, b?.fixedSize, t, Size.lerp),
      maximumSize: _lerpStyleProperty(
        a?.maximumSize,
        b?.maximumSize,
        t,
        _lerpMaximumSize,
        fallback: Size.infinite,
      ),
      iconSize: _lerpStyleProperty(
        a?.iconSize,
        b?.iconSize,
        t,
        (a, b, t) => a + (b - a) * t,
        fallback: _defaultControlIconSize,
      ),
      side: _lerpStyleProperty(
        a?.side,
        b?.side,
        t,
        BorderSide.lerp,
        fallback: BorderSide.none,
      ),
      shape: _lerpStyleProperty(
        a?.shape,
        b?.shape,
        t,
        OutlinedBorder.lerp,
        fallback: const CircleBorder(),
      ),
    );
  }

  // Token-dependent values remain nullable; the current TD theme resolves them.
  WidgetStateProperty<T?>? _lerpStyleProperty<T>(
    WidgetStateProperty<T?>? a,
    WidgetStateProperty<T?>? b,
    double t,
    T? Function(T a, T b, double t) interpolate, {
    T? fallback,
  }) {
    if (a == null && b == null) {
      return null;
    }
    return WidgetStateProperty.resolveWith((states) {
      final from = a?.resolve(states) ?? fallback;
      final to = b?.resolve(states) ?? fallback;
      if (from == null || to == null) {
        return t < 0.5 ? from : to;
      }
      return interpolate(from, to, t);
    });
  }

  Size _lerpMaximumSize(Size a, Size b, double t) {
    double axis(double a, double b) =>
        a.isFinite && b.isFinite ? a + (b - a) * t : double.infinity;
    return Size(axis(a.width, b.width), axis(a.height, b.height));
  }

  double? _lerpNullableDouble(
    double? a,
    double? b,
    double t,
    double defaultValue,
  ) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? defaultValue) +
        ((b ?? defaultValue) - (a ?? defaultValue)) * t;
  }
}
