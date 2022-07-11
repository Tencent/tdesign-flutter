/*
 * Created by haozhicao@tencent.com on 6/28/22.
 * td_loading.dart
 * 
 */

import 'package:flutter/material.dart';
import 'td_loading_content.dart';

/// Loading 尺寸
enum TDLoadingSize {
  small,
  medium,
  large,
}

/// Loading的图标
enum TDLoadingIcon {
  circle,
  point,
  activity,
}

/// Loading排列样式
enum TDLoadingStyle {
  vertical,
  horizontal,
}

class TDLoading {
  static BuildContext? _buildContext;

  /// 显示Loading
  static void show({
    required BuildContext context,

    /// 尺寸,medium,small,large
    TDLoadingSize size = TDLoadingSize.medium,

    /// 显示时间，默认为0，不自动隐藏
    int duration = 0,

    /// 动画图标，有circle,point,activity三种
    TDLoadingIcon? icon,

    /// 图标颜色
    Color iconColor = const Color(0xff0052d9),

    /// 图标+文字时的排列,横排或者竖排
    TDLoadingStyle style = TDLoadingStyle.vertical,

    /// 文字
    String? text,

    /// 文字颜色
    Color textColor = Colors.black,
  }) {
    assert((text != null || icon != null), "文字和图标不能同时为空");
    _buildContext = context;
    _showLoading(TDContentLoading(
      size: size,
      text: text,
      textColor: textColor,
      icon: icon,
      iconColor: iconColor,
      style: style,
    ));
    if (duration > 0) {
      Future.delayed(Duration(seconds: duration), hide);
    }
  }

  /// 隐藏Loading
  static void hide() {
    if (_buildContext != null) {
      Navigator.of(_buildContext!).pop();
    }
  }

  static void _showLoading(Widget content) {
    Navigator.of(_buildContext!).push(PageRouteBuilder(
      opaque: false,
      barrierColor: const Color(0x00000001),
      pageBuilder: (context, animation, secondaryAnimation) => content,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          child,
    ));
  }
}
