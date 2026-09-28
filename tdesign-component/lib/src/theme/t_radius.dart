import 't_theme.dart';

/// 内置圆角数据
extension TRadius on TThemeData {
  /// 圆角数据
  double get radiusSmall => radiusMap['radiusSmall'] ?? 3;
  double get radiusDefault => radiusMap['radiusDefault'] ?? 6;
  double get radiusLarge => radiusMap['radiusLarge'] ?? 9;
  double get radiusExtraLarge => radiusMap['radiusExtraLarge'] ?? 12;

  /// 小程序 `--td-radius-round: 999px`，Flutter 默认 999 逻辑像素。
  double get radiusRound => radiusMap['radiusRound'] ?? 999;

  /// Flutter 固定逻辑像素圆角，默认 9999。
  ///
  /// 小程序 `--td-radius-circle` 为 CSS `50%`；这里是明确的跨端几何例外。
  /// 自定义值仍按逻辑像素解释，不按宽高比例解释。
  double get radiusCircle => radiusMap['radiusCircle'] ?? 9999;
}
