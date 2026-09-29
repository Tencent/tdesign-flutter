import 'basic.dart';
import 't_theme.dart';

extension TFontFamilies on TThemeData {
  /// 小程序 `--td-font-family`；可用于 Flutter `TextStyle.fontFamily` 和
  /// `fontFamilyFallback`。`TText` 在非 Apple 平台会为默认字体栈选择
  /// Flutter 可用的主字体，不改变这里保存的小程序原始值。
  FontFamily? get fontFamily => fontFamilyMap['fontFamily'];

  /// 小程序 `--td-font-family-medium`。
  FontFamily? get fontFamilyMedium => fontFamilyMap['fontFamilyMedium'];
}
