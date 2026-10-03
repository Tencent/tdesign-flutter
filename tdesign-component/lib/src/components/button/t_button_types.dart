/// 按钮尺寸
enum TButtonSize {
  /// 大尺寸按钮
  large,

  /// 中尺寸按钮
  medium,

  /// 小尺寸按钮
  small,

  /// 超小尺寸按钮
  extraSmall,
}

/// 按钮变体（fill / outline / text / ghost）
enum TButtonVariant {
  /// 填充按钮
  fill,

  /// 描边按钮
  outline,

  /// 文字按钮
  text,

  /// 幽灵按钮
  ghost,
}

/// 按钮内置配色预设，不是 Material ColorScheme。
enum TButtonColorPreset {
  /// 默认配色
  defaultTheme,

  /// 品牌主色
  primary,

  /// 危险操作配色
  danger,

  /// 浅色品牌配色；不改变填充/描边等 [TButtonVariant] 绘制方式。
  light,
}

/// 图标位置
enum TButtonIconPosition {
  /// 图标在文本左侧
  left,

  /// 图标在文本右侧
  right,
}

/// 按钮形状
enum TButtonShape {
  /// 矩形按钮
  rectangle,

  /// 圆角按钮
  round,

  /// 纯图标场景保持等宽高和默认圆角；图文内容不会被裁剪。
  square,

  /// 圆形按钮
  circle,
}
