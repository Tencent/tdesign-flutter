import 't_theme.dart';

/// 小程序全局间距 Token；375 逻辑像素宽下按 2rpx = 1dp 转换。
extension TSpacers on TThemeData {
  /// `--td-spacer`: 16rpx。
  double get spacer => spacerMap['spacer'] ?? 8.0;

  /// `--td-spacer-1`: 24rpx。
  double get spacer1 => spacerMap['spacer1'] ?? 12.0;

  /// `--td-spacer-2`: 32rpx。
  double get spacer2 => spacerMap['spacer2'] ?? 16.0;

  /// `--td-spacer-3`: 48rpx。
  double get spacer3 => spacerMap['spacer3'] ?? 24.0;

  /// `--td-spacer-4`: 64rpx。旧 Flutter `spacer4` 的 4dp 语义已移除。
  double get spacer4 => spacerMap['spacer4'] ?? 32.0;

  /// `--td-spacer-5`: 96rpx。
  double get spacer5 => spacerMap['spacer5'] ?? 48.0;

  /// `--td-spacer-6`: 160rpx。
  double get spacer6 => spacerMap['spacer6'] ?? 80.0;
}
