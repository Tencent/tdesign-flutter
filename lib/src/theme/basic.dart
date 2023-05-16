import 'package:flutter/cupertino.dart';

/// 字体宽高数据
class Font {
  late double size;
  late double height;
  late FontWeight fontWeight;

  Font({required int size, required int lineHeight, this.fontWeight = FontWeight.w400}) {
    this.size = size.toDouble();
    height = lineHeight.toDouble() / size;
  }

  factory Font.fromJson(Map<String, dynamic> map) =>
      Font(size: map['size'], lineHeight: map['lineHeight'], fontWeight: _getFontWeight(map));

  static _getFontWeight(Map<String, dynamic> map) {
    int weight = map['fontWeight'] ?? 4;
    return FontWeight.values[weight - 1];
  }
}

/// 字体样式
class FontFamily {
  late String fontFamily;

  FontFamily({required this.fontFamily});

  factory FontFamily.fromJson(Map<String, dynamic> map) =>
      FontFamily(fontFamily: map['fontFamily']);
}
