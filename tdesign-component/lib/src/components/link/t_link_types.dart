/// 链接形态
enum TLinkVariant {
  /// 纯文本链接
  basic,

  /// 下划线链接
  underline,

  /// 带图标链接（通过 prefixIcon / suffixIcon 区分前后）
  icon,
}

/// 语义颜色方案（对齐 Button colorScheme）
enum TLinkColorScheme {
  /// 品牌主色链接
  primary,

  /// 默认文本色链接
  defaultTheme,

  /// 危险操作链接
  danger,

  /// 警告提示链接
  warning,

  /// 成功状态链接
  success,
}

/// 链接尺寸
enum TLinkSize {
  /// 小尺寸链接
  small,

  /// 中尺寸链接
  medium,

  /// 大尺寸链接
  large,
}
