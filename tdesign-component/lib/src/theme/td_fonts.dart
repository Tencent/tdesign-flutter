import 'basic.dart';
import 'td_theme.dart';

/// 内置字体数据
extension TDFonts on TDThemeData {
  /// 字体大小/行高
  /// 64/72
  Font? get fontDisplayLarge => fontMap['fontDisplayLarge'];

  /// 48/56
  Font? get fontDisplayMedium => fontMap['fontDisplayMedium'];

  /// 36/44
  Font? get fontHeadlineLarge => fontMap['fontHeadlineLarge'];

  /// 28/36
  Font? get fontHeadlineMedium => fontMap['fontHeadlineMedium'];

  /// 24/32
  Font? get fontHeadlineSmall => fontMap['fontHeadlineSmall'];

  /// 20/28
  Font? get fontTitleExtraLarge => fontMap['fontTitleExtraLarge'];

  /// 18/26
  Font? get fontTitleLarge => fontMap['fontTitleLarge'];

  /// 16/24
  Font? get fontTitleMedium => fontMap['fontTitleMedium'];

  /// 14/22
  Font? get fontTitleSmall => fontMap['fontTitleSmall'];

  /// 18/26
  Font? get fontBodyExtraLarge => fontMap['fontBodyExtraLarge'];

  /// 16/24
  Font? get fontBodyLarge => fontMap['fontBodyLarge'];

  /// 14/22
  Font? get fontBodyMedium => fontMap['fontBodyMedium'];

  /// 12/20
  Font? get fontBodySmall => fontMap['fontBodySmall'];

  /// 10/16
  Font? get fontBodyExtraSmall => fontMap['fontBodyExtraSmall'];

  /// 16/24
  Font? get fontMarkLarge => fontMap['fontMarkLarge'];

  /// 14/22
  Font? get fontMarkMedium => fontMap['fontMarkMedium'];

  /// 12/20
  Font? get fontMarkSmall => fontMap['fontMarkSmall'];

  /// 10/16
  Font? get fontMarkExtraSmall => fontMap['fontMarkExtraSmall'];

  /// 16/24
  Font? get fontLinkLarge => fontMap['fontLinkLarge'];

  /// 14/22
  Font? get fontLinkMedium => fontMap['fontLinkMedium'];

  /// 12/20
  Font? get fontLinkSmall => fontMap['fontLinkSmall'];


}
