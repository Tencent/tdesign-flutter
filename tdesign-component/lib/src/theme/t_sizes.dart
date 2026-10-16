import 't_size_defaults.dart';
import 't_theme.dart';

/// 全局尺寸刻度，单位为逻辑像素；与布局间距独立。
extension TSizes on TThemeData {
  /// 第 1 档尺寸，默认 2 逻辑像素。
  double get size1 => sizeMap['size1'] ?? defaultSizeTokens['size1']!;

  /// 第 2 档尺寸，默认 4 逻辑像素。
  double get size2 => sizeMap['size2'] ?? defaultSizeTokens['size2']!;

  /// 第 3 档尺寸，默认 6 逻辑像素。
  double get size3 => sizeMap['size3'] ?? defaultSizeTokens['size3']!;

  /// 第 4 档尺寸，默认 8 逻辑像素。
  double get size4 => sizeMap['size4'] ?? defaultSizeTokens['size4']!;

  /// 第 5 档尺寸，默认 12 逻辑像素。
  double get size5 => sizeMap['size5'] ?? defaultSizeTokens['size5']!;

  /// 第 6 档尺寸，默认 16 逻辑像素。
  double get size6 => sizeMap['size6'] ?? defaultSizeTokens['size6']!;

  /// 第 7 档尺寸，默认 20 逻辑像素。
  double get size7 => sizeMap['size7'] ?? defaultSizeTokens['size7']!;

  /// 第 8 档尺寸，默认 24 逻辑像素。
  double get size8 => sizeMap['size8'] ?? defaultSizeTokens['size8']!;

  /// 第 9 档尺寸，默认 28 逻辑像素。
  double get size9 => sizeMap['size9'] ?? defaultSizeTokens['size9']!;

  /// 第 10 档尺寸，默认 32 逻辑像素。
  double get size10 => sizeMap['size10'] ?? defaultSizeTokens['size10']!;

  /// 第 11 档尺寸，默认 36 逻辑像素。
  double get size11 => sizeMap['size11'] ?? defaultSizeTokens['size11']!;

  /// 第 12 档尺寸，默认 40 逻辑像素。
  double get size12 => sizeMap['size12'] ?? defaultSizeTokens['size12']!;

  /// 第 13 档尺寸，默认 48 逻辑像素。
  double get size13 => sizeMap['size13'] ?? defaultSizeTokens['size13']!;

  /// 第 14 档尺寸，默认 56 逻辑像素。
  double get size14 => sizeMap['size14'] ?? defaultSizeTokens['size14']!;

  /// 第 15 档尺寸，默认 64 逻辑像素。
  double get size15 => sizeMap['size15'] ?? defaultSizeTokens['size15']!;

  /// 第 16 档尺寸，默认 72 逻辑像素。
  double get size16 => sizeMap['size16'] ?? defaultSizeTokens['size16']!;
}
