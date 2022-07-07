import 'package:tdesign_flutter/src/theme/td_theme.dart';

/// 常用的Margin，一般以8为倍数
extension TDMargins on TDThemeData {
  double get marginSmall => marginMap['small'] ?? 5.0;

  double get marginNormal => marginMap['normal'] ?? 8.0;

  double get marginMedium => marginMap['medium'] ?? 16.0;

  double get marginLarge => marginMap['large'] ?? 24.0;
}
