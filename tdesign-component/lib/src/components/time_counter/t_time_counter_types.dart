/// 计时方向。
enum TTimeCounterDirection {
  /// 倒计时。
  down,

  /// 正向计时。
  up,
}

/// 计时器尺寸。
enum TTimeCounterSize {
  /// 小尺寸。
  small,

  /// 中等尺寸。
  medium,

  /// 大尺寸。
  large,
}

/// 计时器视觉形态。
enum TTimeCounterVariant {
  /// 无数字块背景。
  plain,

  /// 无数字块背景，并以错误色突出数字。
  highlight,

  /// 圆形数字块。
  round,

  /// 方形数字块。
  square,
}
