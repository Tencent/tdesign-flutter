import 'package:flutter/material.dart';

/// 内部只读投影视图，不从公开入口导出，也不创建第二份主题状态。
///
/// 组合文字解析器借此区分 Token 投影和调用方的逐字段覆盖。
abstract interface class TTextThemeSource {
  TextTheme get textTheme;
}
