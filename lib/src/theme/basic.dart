/// 字体宽高数据
class Font {
  late double size;
  late double height;

  Font({required int size, required int lineHeight}) {
    this.size = size.toDouble();
    height = lineHeight.toDouble() / size;
  }

  factory Font.fromJson(Map<String, dynamic> map) =>
      Font(size: map['size'], lineHeight: map['lineHeight']);
}

/// 字体样式
class FontFamily {
  late String fontFamily;

  FontFamily({required  this.fontFamily});

  factory FontFamily.fromJson(Map<String, dynamic> map) =>
      FontFamily(fontFamily: map['fontFamily']);
}
