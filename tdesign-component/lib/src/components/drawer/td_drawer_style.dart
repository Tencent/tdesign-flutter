import 'package:flutter/material.dart';

/// 抽屉组件样式
class TDDrawerStyle {
  TDDrawerStyle({
    this.space
  });

  /// 间距
  double? space;

  /// 生成默认样式
  TDDrawerStyle.generateStyle(BuildContext context) {
    space = 1;
  }
}
