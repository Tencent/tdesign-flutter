import 'package:flutter/cupertino.dart';

/// 字体宽高数据
class Font {
  /// 字体大小，单位为逻辑像素。
  late double size;

  /// 行高与字号的比值，用于 TextStyle.height；构造时按 lineHeight / size 计算。
  late double height;

  /// 字重，默认 FontWeight.w400。
  late FontWeight fontWeight;

  Font({
    required int size,

    /// 行高，单位为逻辑像素；构造后转换为相对于字号的比例。
    required int lineHeight,
    this.fontWeight = FontWeight.w400,
  }) {
    this.size = size.toDouble();
    height = lineHeight.toDouble() / size;
  }

  factory Font.fromJson(
    /// 字体 JSON 配置，包含 size、lineHeight 和可选的 fontWeight（1 至 9，默认 4）。
    Map<String, dynamic> map,
  ) => Font(
    size: map['size'],
    lineHeight: map['lineHeight'],
    fontWeight: _getFontWeight(map),
  );

  static FontWeight _getFontWeight(Map<String, dynamic> map) {
    int weight = map['fontWeight'] ?? 4;
    return FontWeight.values[weight - 1];
  }
}

/// 字体样式
class FontFamily {
  /// 主字体名称。
  late String fontFamily;

  /// 字体所在资源包；为空时从应用或系统字体解析。
  String? package;

  /// 主字体不可用时按顺序尝试的备用字体名称。
  List<String>? fallback;

  FontFamily({required this.fontFamily, this.package, this.fallback});

  factory FontFamily.fromJson(
    /// 字体栈 JSON 配置，包含 fontFamily、可选 package 和 fallback。
    Map<String, dynamic> map,
  ) => FontFamily(
    fontFamily: map['fontFamily'],
    package: map['package'],
    fallback: (map['fallback'] as List<dynamic>?)?.cast<String>(),
  );
}

/// Font字体宽高的扩展
extension FontExtensions on Font {
  /// 调整字体大小。
  ///
  /// ## 返回值
  /// 使用 [newSize] 字号的字体副本，保留字重，并按当前行高比例计算新行高后取整。
  Font withSize(int newSize) => Font(
    size: newSize,
    lineHeight: (height * newSize).round(),
    fontWeight: fontWeight,
  );
}
