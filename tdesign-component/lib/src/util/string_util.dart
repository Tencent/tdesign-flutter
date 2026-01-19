import 'package:flutter/material.dart';

import 'log.dart';

Color? toColor(String colorStr, {double alpha = 1}) {
  try {
    var hexColor = colorStr.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 3) {
      /// 处理3位HEX颜色值，扩展为6位
      /// hexColor = hexColor.split('').map((s) => s * 2).join('');
      /// 优化：使用字符串插值替代split/map/join操作，提高性能和可读性
      hexColor =
          '${hexColor[0]}${hexColor[0]}${hexColor[1]}${hexColor[1]}${hexColor[2]}${hexColor[2]}';
    }

    if (hexColor.length == 6) {
      if (alpha < 0) {
        alpha = 0;
      } else if (alpha > 1) {
        alpha = 1;
      }
      var alphaInt = (0xFF * alpha).toInt();
      var alphaString = alphaInt.toRadixString(16);

      /// 扩展为8位的AHEX
      hexColor = '$alphaString$hexColor';
    }

    return Color(int.parse(hexColor, radix: 16));
  } catch (e) {
    // Log.w('toColor', 'error: $e');
  }
  return null;
}
