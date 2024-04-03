import 'package:flutter/material.dart';

import 'log.dart';

Color? toColor(String colorStr, {double alpha = 1}) {
  try {
    var hexColor = colorStr.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
        if (alpha < 0) {
          alpha = 0;
        } else if (alpha > 1) {
          alpha = 1;
        }
        var alphaInt = (0xFF * alpha).toInt();
        var alphaString = alphaInt.toRadixString(16);

        hexColor = '$alphaString$hexColor';
      }
    return Color(int.parse(hexColor, radix: 16));
  } catch (e) {
    // Log.w('toColor', 'error: $e');
  }
  return null;
}
