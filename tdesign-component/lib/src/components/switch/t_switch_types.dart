/// 开关尺寸。
enum TSwitchSize {
  /// 大尺寸。
  large,

  /// 中尺寸。
  medium,

  /// 小尺寸。
  small,
}

/// 开关内容形态。
enum TSwitchVariant {
  /// 无滑块内容的填充开关。
  filled,

  /// 滑块内显示开关文案。
  text,

  /// 滑块内显示加载指示器，并禁用交互。
  loading,

  /// 滑块内显示开关图标。
  icon,
}
