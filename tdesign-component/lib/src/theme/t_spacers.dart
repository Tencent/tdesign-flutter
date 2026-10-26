import 't_theme.dart';

/// 全局间距 Token，单位为 Flutter 逻辑像素。
extension TSpacers on TThemeData {
  /// 间距 Token，未配置时回退为 8 逻辑像素。
  double get spacer => spacerMap['spacer'] ?? 8.0;

  /// 间距 Token，未配置时回退为 12 逻辑像素。
  double get spacer1 => spacerMap['spacer1'] ?? 12.0;

  /// 间距 Token，未配置时回退为 16 逻辑像素。
  double get spacer2 => spacerMap['spacer2'] ?? 16.0;

  /// 间距 Token，未配置时回退为 24 逻辑像素。
  double get spacer3 => spacerMap['spacer3'] ?? 24.0;

  /// 间距 Token，未配置时回退为 32 逻辑像素。
  double get spacer4 => spacerMap['spacer4'] ?? 32.0;

  /// 间距 Token，未配置时回退为 48 逻辑像素。
  double get spacer5 => spacerMap['spacer5'] ?? 48.0;

  /// 间距 Token，未配置时回退为 80 逻辑像素。
  double get spacer6 => spacerMap['spacer6'] ?? 80.0;
}
