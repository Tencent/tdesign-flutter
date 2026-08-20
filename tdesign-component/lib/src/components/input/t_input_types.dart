/// 输入框清除按钮的显示模式。
enum TInputClearButtonMode {
  /// 从不显示清除按钮。
  never,

  /// 有文本时显示清除按钮。
  always,

  /// 输入框获得焦点且有文本时显示清除按钮。
  focused,
}

/// 输入框的语义状态。
///
/// 状态不改变已输入文字的正文色。
enum TInputStatus {
  /// 默认状态。
  normal,

  /// 成功状态。
  success,

  /// 警告状态。
  warning,

  /// 错误状态。
  error,
}
