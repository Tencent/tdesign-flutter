import 't_theme.dart';

/// 内置圆角数据
extension TRadius on TThemeData {
  /// 小圆角，默认 3 逻辑像素。
  double get radiusSmall => radiusMap['radiusSmall'] ?? 3;

  /// 默认圆角，默认 6 逻辑像素。
  double get radiusDefault => radiusMap['radiusDefault'] ?? 6;

  /// 大圆角，默认 9 逻辑像素。
  double get radiusLarge => radiusMap['radiusLarge'] ?? 9;

  /// 特大圆角，默认 12 逻辑像素。
  double get radiusExtraLarge => radiusMap['radiusExtraLarge'] ?? 12;

  /// 胶囊圆角，默认 999 逻辑像素。
  double get radiusRound => radiusMap['radiusRound'] ?? 999;

  /// Flutter 固定逻辑像素圆角，默认 9999。
  ///
  /// 自定义值仍按逻辑像素解释，不按宽高比例解释。
  double get radiusCircle => radiusMap['radiusCircle'] ?? 9999;
}
