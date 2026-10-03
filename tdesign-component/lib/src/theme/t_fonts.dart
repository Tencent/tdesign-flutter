import 'basic.dart';
import 't_theme.dart';

/// 小程序独立字号与行高 Token。CSS 中 `--td-font-*` 由这些变量组合而成。
extension TFontMetrics on TThemeData {
  double _metric(String key, double fallback) => fontMetricMap[key] ?? fallback;

  double get fontSize => _metric('fontSize', 10);
  double get fontSizeXs => _metric('fontSizeXs', fontSizeBodyExtraSmall);
  double get fontSizeS => _metric('fontSizeS', fontSizeBodySmall);
  double get fontSizeBase => _metric('fontSizeBase', fontSizeTitleSmall);
  double get fontSizeM => _metric('fontSizeM', fontSizeTitleMedium);
  double get fontSizeL => _metric('fontSizeL', fontSizeTitleLarge);
  double get fontSizeXl => _metric('fontSizeXl', fontSizeTitleExtraLarge);
  double get fontSizeXxl => _metric('fontSizeXxl', fontSizeHeadlineLarge);

  double get fontSizeLinkSmall => _metric('fontSizeLinkSmall', 12);
  double get fontSizeLinkMedium => _metric('fontSizeLinkMedium', 14);
  double get fontSizeLinkLarge => _metric('fontSizeLinkLarge', 16);
  double get fontSizeMarkExtraSmall => _metric('fontSizeMarkExtraSmall', 10);
  double get fontSizeMarkSmall => _metric('fontSizeMarkSmall', 12);
  double get fontSizeMarkMedium => _metric('fontSizeMarkMedium', 14);
  double get fontSizeMarkLarge => _metric('fontSizeMarkLarge', 16);
  double get fontSizeBodyExtraSmall => _metric('fontSizeBodyExtraSmall', 10);
  double get fontSizeBodySmall => _metric('fontSizeBodySmall', 12);
  double get fontSizeBodyMedium => _metric('fontSizeBodyMedium', 14);
  double get fontSizeBodyLarge => _metric('fontSizeBodyLarge', 16);
  double get fontSizeTitleSmall => _metric('fontSizeTitleSmall', 14);
  double get fontSizeTitleMedium => _metric('fontSizeTitleMedium', 16);
  double get fontSizeTitleLarge => _metric('fontSizeTitleLarge', 18);
  double get fontSizeTitleExtraLarge => _metric('fontSizeTitleExtraLarge', 20);
  double get fontSizeHeadlineSmall => _metric('fontSizeHeadlineSmall', 24);
  double get fontSizeHeadlineMedium => _metric('fontSizeHeadlineMedium', 28);
  double get fontSizeHeadlineLarge => _metric('fontSizeHeadlineLarge', 36);
  double get fontSizeDisplayMedium => _metric('fontSizeDisplayMedium', 48);
  double get fontSizeDisplayLarge => _metric('fontSizeDisplayLarge', 64);

  double get lineHeightLinkSmall => _metric('lineHeightLinkSmall', 20);
  double get lineHeightLinkMedium => _metric('lineHeightLinkMedium', 22);
  double get lineHeightLinkLarge => _metric('lineHeightLinkLarge', 24);
  double get lineHeightMarkExtraSmall =>
      _metric('lineHeightMarkExtraSmall', 16);
  double get lineHeightMarkSmall => _metric('lineHeightMarkSmall', 20);
  double get lineHeightMarkMedium => _metric('lineHeightMarkMedium', 22);
  double get lineHeightMarkLarge => _metric('lineHeightMarkLarge', 24);
  double get lineHeightBodyExtraSmall =>
      _metric('lineHeightBodyExtraSmall', 16);
  double get lineHeightBodySmall => _metric('lineHeightBodySmall', 20);
  double get lineHeightBodyMedium => _metric('lineHeightBodyMedium', 22);
  double get lineHeightBodyLarge => _metric('lineHeightBodyLarge', 24);
  double get lineHeightTitleSmall => _metric('lineHeightTitleSmall', 22);
  double get lineHeightTitleMedium => _metric('lineHeightTitleMedium', 24);
  double get lineHeightTitleLarge => _metric('lineHeightTitleLarge', 26);
  double get lineHeightTitleExtraLarge =>
      _metric('lineHeightTitleExtraLarge', 28);
  double get lineHeightHeadlineSmall => _metric('lineHeightHeadlineSmall', 32);
  double get lineHeightHeadlineMedium =>
      _metric('lineHeightHeadlineMedium', 36);
  double get lineHeightHeadlineLarge => _metric('lineHeightHeadlineLarge', 44);
  double get lineHeightDisplayMedium => _metric('lineHeightDisplayMedium', 56);
  double get lineHeightDisplayLarge => _metric('lineHeightDisplayLarge', 72);
}

/// 小程序复合字体 Token。显式覆盖复合 [Font] 时以它为准；否则随独立字号和行高变化。
extension TFonts on TThemeData {
  Font? _resolveFont(String key, String sizeKey, String lineHeightKey) {
    final configured = fontMap[key];
    if (configured == null) {
      return null;
    }
    final defaultFont = TThemeData.defaultData().fontMap[key];
    if (defaultFont == null ||
        configured.size != defaultFont.size ||
        configured.height != defaultFont.height ||
        configured.fontWeight != defaultFont.fontWeight) {
      return configured;
    }
    final size = fontMetricMap[sizeKey] ?? configured.size;
    final lineHeight =
        fontMetricMap[lineHeightKey] ?? configured.size * configured.height;
    if (size == configured.size &&
        lineHeight.round() == (configured.size * configured.height).round()) {
      return configured;
    }
    return Font(
      size: size.round(),
      lineHeight: lineHeight.round(),
      fontWeight: configured.fontWeight,
    );
  }

  Font? get fontDisplayLarge => _resolveFont(
    'fontDisplayLarge',
    'fontSizeDisplayLarge',
    'lineHeightDisplayLarge',
  );
  Font? get fontDisplayMedium => _resolveFont(
    'fontDisplayMedium',
    'fontSizeDisplayMedium',
    'lineHeightDisplayMedium',
  );
  Font? get fontHeadlineLarge => _resolveFont(
    'fontHeadlineLarge',
    'fontSizeHeadlineLarge',
    'lineHeightHeadlineLarge',
  );
  Font? get fontHeadlineMedium => _resolveFont(
    'fontHeadlineMedium',
    'fontSizeHeadlineMedium',
    'lineHeightHeadlineMedium',
  );
  Font? get fontHeadlineSmall => _resolveFont(
    'fontHeadlineSmall',
    'fontSizeHeadlineSmall',
    'lineHeightHeadlineSmall',
  );
  Font? get fontTitleExtraLarge => _resolveFont(
    'fontTitleExtraLarge',
    'fontSizeTitleExtraLarge',
    'lineHeightTitleExtraLarge',
  );
  Font? get fontTitleLarge => _resolveFont(
    'fontTitleLarge',
    'fontSizeTitleLarge',
    'lineHeightTitleLarge',
  );
  Font? get fontTitleMedium => _resolveFont(
    'fontTitleMedium',
    'fontSizeTitleMedium',
    'lineHeightTitleMedium',
  );
  Font? get fontTitleSmall => _resolveFont(
    'fontTitleSmall',
    'fontSizeTitleSmall',
    'lineHeightTitleSmall',
  );
  Font? get fontBodyLarge =>
      _resolveFont('fontBodyLarge', 'fontSizeBodyLarge', 'lineHeightBodyLarge');
  Font? get fontBodyMedium => _resolveFont(
    'fontBodyMedium',
    'fontSizeBodyMedium',
    'lineHeightBodyMedium',
  );
  Font? get fontBodySmall =>
      _resolveFont('fontBodySmall', 'fontSizeBodySmall', 'lineHeightBodySmall');
  Font? get fontBodyExtraSmall => _resolveFont(
    'fontBodyExtraSmall',
    'fontSizeBodyExtraSmall',
    'lineHeightBodyExtraSmall',
  );
  Font? get fontMarkLarge =>
      _resolveFont('fontMarkLarge', 'fontSizeMarkLarge', 'lineHeightMarkLarge');
  Font? get fontMarkMedium => _resolveFont(
    'fontMarkMedium',
    'fontSizeMarkMedium',
    'lineHeightMarkMedium',
  );
  Font? get fontMarkSmall =>
      _resolveFont('fontMarkSmall', 'fontSizeMarkSmall', 'lineHeightMarkSmall');
  Font? get fontMarkExtraSmall => _resolveFont(
    'fontMarkExtraSmall',
    'fontSizeMarkExtraSmall',
    'lineHeightMarkExtraSmall',
  );
  Font? get fontLinkLarge =>
      _resolveFont('fontLinkLarge', 'fontSizeLinkLarge', 'lineHeightLinkLarge');
  Font? get fontLinkMedium => _resolveFont(
    'fontLinkMedium',
    'fontSizeLinkMedium',
    'lineHeightLinkMedium',
  );
  Font? get fontLinkSmall =>
      _resolveFont('fontLinkSmall', 'fontSizeLinkSmall', 'lineHeightLinkSmall');
}
