import 't_theme.dart';

/// 全局尺寸刻度，单位为逻辑像素；与布局间距独立。
extension TSizes on TThemeData {
  /// 第 1 档尺寸，默认 2 逻辑像素。
  double get size1 => sizeMap['size1'] ?? 2.0;

  /// 第 2 档尺寸，默认 4 逻辑像素。
  double get size2 => sizeMap['size2'] ?? 4.0;

  /// 第 3 档尺寸，默认 6 逻辑像素。
  double get size3 => sizeMap['size3'] ?? 6.0;

  /// 第 4 档尺寸，默认 8 逻辑像素。
  double get size4 => sizeMap['size4'] ?? 8.0;

  /// 第 5 档尺寸，默认 12 逻辑像素。
  double get size5 => sizeMap['size5'] ?? 12.0;

  /// 第 6 档尺寸，默认 16 逻辑像素。
  double get size6 => sizeMap['size6'] ?? 16.0;

  /// 第 7 档尺寸，默认 20 逻辑像素。
  double get size7 => sizeMap['size7'] ?? 20.0;

  /// 第 8 档尺寸，默认 24 逻辑像素。
  double get size8 => sizeMap['size8'] ?? 24.0;

  /// 第 9 档尺寸，默认 28 逻辑像素。
  double get size9 => sizeMap['size9'] ?? 28.0;

  /// 第 10 档尺寸，默认 32 逻辑像素。
  double get size10 => sizeMap['size10'] ?? 32.0;

  /// 第 11 档尺寸，默认 36 逻辑像素。
  double get size11 => sizeMap['size11'] ?? 36.0;

  /// 第 12 档尺寸，默认 40 逻辑像素。
  double get size12 => sizeMap['size12'] ?? 40.0;

  /// 第 13 档尺寸，默认 48 逻辑像素。
  double get size13 => sizeMap['size13'] ?? 48.0;

  /// 第 14 档尺寸，默认 56 逻辑像素。
  double get size14 => sizeMap['size14'] ?? 56.0;

  /// 第 15 档尺寸，默认 64 逻辑像素。
  double get size15 => sizeMap['size15'] ?? 64.0;

  /// 第 16 档尺寸，默认 72 逻辑像素。
  double get size16 => sizeMap['size16'] ?? 72.0;
}
