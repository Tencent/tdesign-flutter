/*
 * Created by haozhicao@tencent.com on 6/17/22.
 * auto_size.dart
 * 
 */

import 'dart:ui';

import 'package:flutter/widgets.dart';

/// 宽高屏幕自动适配，使用举例：100.as
extension TDIntScale on int {
  double get scale {
    /// 屏幕的逻辑宽度=屏幕物理宽度/屏幕的像素倍数
    var view = PlatformDispatcher.instance.views.first;
    var screenWidth = view.physicalSize.width / view.devicePixelRatio;

    /// 设计稿用的是750的宽度
    return screenWidth / 375.0 * this;
  }
}

extension TDDoubleScale on double {
  double get scale {
    /// 屏幕的逻辑宽度=屏幕物理宽度/屏幕的像素倍数
    var view = PlatformDispatcher.instance.views.first;
    var screenWidth = view.physicalSize.width / view.devicePixelRatio;

    /// 设计稿用的是750的宽度
    return screenWidth / 375.0 * this;
  }
}
