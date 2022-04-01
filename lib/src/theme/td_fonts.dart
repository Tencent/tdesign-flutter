import 'package:tdesign_flutter/src/theme/td_theme.dart';

import 'basic.dart';

/// 内置字体数据
extension TDFonts on TDThemeData {
  /// 字体大小/行高
  /// 36/44
  Font? get fontXL => fonts['fontXL'];

  /// 20/28
  Font? get fontL => fonts['fontL'];

  /// 16/24
  Font? get fontM => fonts['fontM'];

  /// 14/22
  Font? get fontS => fonts['fontS'];

  /// 12/20
  Font? get fontXS => fonts['fontXS'];

  /// 10/16
  Font? get fontXXS => fonts['fontXXS'];
}
