import 'package:flutter/material.dart';

import 'td_theme.dart';

/// 内置圆角数据
extension TDCorners on TDThemeData {
  /// 基础圆角数据
  double? get baseBorderRadius => cornerMap['baseBorderRadius'];
}
