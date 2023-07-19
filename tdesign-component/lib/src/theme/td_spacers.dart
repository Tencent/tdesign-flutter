import 'td_theme.dart';

/// 常用的Margin，一般以8为倍数
extension TDSpacers on TDThemeData {
  double get spacer4 => spacerMap['spacer4'] ?? 4.0;

  double get spacer8 => spacerMap['spacer8'] ?? 8.0;

  double get spacer12 => spacerMap['spacer12'] ?? 12.0;

  double get spacer16 => spacerMap['spacer16'] ?? 16.0;

  double get spacer24 => spacerMap['spacer24'] ?? 24.0;

  double get spacer32 => spacerMap['spacer32'] ?? 32.0;

  double get spacer40 => spacerMap['spacer40'] ?? 40.0;

  double get spacer48 => spacerMap['spacer48'] ?? 48.0;

  double get spacer64 => spacerMap['spacer64'] ?? 64.0;

  double get spacer96 => spacerMap['spacer96'] ?? 96.0;

  double get spacer160 => spacerMap['spacer160'] ?? 160.0;
}
