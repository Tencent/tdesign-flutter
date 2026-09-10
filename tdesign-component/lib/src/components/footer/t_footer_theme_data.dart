import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 页脚组件级 ThemeExtension。
///
/// 未配置 [height] 时，页脚按内容自然撑开；配置后才会约束外层高度。
class TFooterThemeData extends ThemeExtension<TFooterThemeData> {
  /// 页脚外层高度。
  ///
  /// 默认值为 null，表示由 logo、链接或文字内容自然决定高度；这与
  /// TDesign 小程序 Footer 的内容驱动布局一致。
  final double? height;

  const TFooterThemeData({this.height});

  @override
  TFooterThemeData copyWith({double? height}) {
    return TFooterThemeData(height: height ?? this.height);
  }

  @override
  TFooterThemeData lerp(ThemeExtension<TFooterThemeData>? other, double t) {
    if (other is! TFooterThemeData) {
      return this;
    }
    return TFooterThemeData(height: lerpDouble(height, other.height, t));
  }
}
