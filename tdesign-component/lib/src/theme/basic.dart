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
    /// 字体 JSON 配置。size 为正、lineHeight 为非负的有限整数或小数，保留精度；
    /// fontWeight 为 1 至 9 的整数，默认 4。非法配置抛出 FormatException。
    Map<String, dynamic> map,
  ) {
    final size = _metric(map['size'], 'size');
    final lineHeight = _metric(
      map['lineHeight'],
      'lineHeight',
      allowZero: true,
    );
    if (!(lineHeight / size).isFinite) {
      throw const FormatException('Font height ratio must be finite');
    }
    return Font._metrics(size, lineHeight, _getFontWeight(map));
  }

  Font._metrics(this.size, double lineHeight, this.fontWeight)
    : height = lineHeight / size;

  static double _metric(Object? value, String name, {bool allowZero = false}) {
    if (value is! num ||
        !value.isFinite ||
        value < 0 ||
        (!allowZero && value == 0)) {
      throw FormatException(
        'Invalid Font.$name: expected a finite ${allowZero ? 'nonnegative' : 'positive'} number',
      );
    }
    return value.toDouble();
  }

  static FontWeight _getFontWeight(Map<String, dynamic> map) {
    final weight = map['fontWeight'] ?? 4;
    if (weight is! int || weight < 1 || weight > FontWeight.values.length) {
      throw const FormatException('Font.fontWeight must be an integer in 1..9');
    }
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
