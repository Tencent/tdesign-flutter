/// 标签尺寸。
enum TTagSize {
  /// 超大尺寸。
  extraLarge,

  /// 大尺寸。
  large,

  /// 中等尺寸。
  medium,

  /// 小尺寸。
  small,

  /// 由 Theme padding 和字体决定尺寸。
  custom,
}

/// 标签形状。
enum TTagShape {
  /// 小圆角矩形。
  square,

  /// 胶囊形。
  round,

  /// 右侧胶囊标记形。
  mark,
}

/// 标签语义色。
enum TTagColorScheme {
  /// 默认中性色。
  defaultTheme,

  /// 品牌主色。
  primary,

  /// 警告色。
  warning,

  /// 危险色。
  danger,

  /// 成功色。
  success,
}

/// 标签绘制形态。
enum TTagVariant {
  /// 深色填充。
  dark,

  /// 浅色填充。
  light,

  /// 描边。
  outline,

  /// 浅色描边。
  lightOutline,
}
