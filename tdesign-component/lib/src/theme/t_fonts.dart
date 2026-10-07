import 'basic.dart';
import 't_theme.dart';

/// 小程序独立字号与行高 Token。CSS 中 `--td-font-*` 由这些变量组合而成。
extension TFontMetrics on TThemeData {
  double _metric(String key, double fallback) => fontMetricMap[key] ?? fallback;

  /// 读取 `fontSize` 的字号 Token，单位为逻辑像素；未配置时回退为 10 逻辑像素。
  double get fontSize => _metric('fontSize', 10);

  /// 读取 `fontSizeXs` 的字号 Token，单位为逻辑像素；未配置时回退为 [fontSizeBodyExtraSmall]。
  double get fontSizeXs => _metric('fontSizeXs', fontSizeBodyExtraSmall);

  /// 读取 `fontSizeS` 的字号 Token，单位为逻辑像素；未配置时回退为 [fontSizeBodySmall]。
  double get fontSizeS => _metric('fontSizeS', fontSizeBodySmall);

  /// 读取 `fontSizeBase` 的字号 Token，单位为逻辑像素；未配置时回退为 [fontSizeTitleSmall]。
  double get fontSizeBase => _metric('fontSizeBase', fontSizeTitleSmall);

  /// 读取 `fontSizeM` 的字号 Token，单位为逻辑像素；未配置时回退为 [fontSizeTitleMedium]。
  double get fontSizeM => _metric('fontSizeM', fontSizeTitleMedium);

  /// 读取 `fontSizeL` 的字号 Token，单位为逻辑像素；未配置时回退为 [fontSizeTitleLarge]。
  double get fontSizeL => _metric('fontSizeL', fontSizeTitleLarge);

  /// 读取 `fontSizeXl` 的字号 Token，单位为逻辑像素；未配置时回退为 [fontSizeTitleExtraLarge]。
  double get fontSizeXl => _metric('fontSizeXl', fontSizeTitleExtraLarge);

  /// 读取 `fontSizeXxl` 的字号 Token，单位为逻辑像素；未配置时回退为 [fontSizeHeadlineLarge]。
  double get fontSizeXxl => _metric('fontSizeXxl', fontSizeHeadlineLarge);

  /// 读取 `fontSizeLinkSmall` 的字号 Token，单位为逻辑像素；未配置时回退为 12 逻辑像素。
  double get fontSizeLinkSmall => _metric('fontSizeLinkSmall', 12);

  /// 读取 `fontSizeLinkMedium` 的字号 Token，单位为逻辑像素；未配置时回退为 14 逻辑像素。
  double get fontSizeLinkMedium => _metric('fontSizeLinkMedium', 14);

  /// 读取 `fontSizeLinkLarge` 的字号 Token，单位为逻辑像素；未配置时回退为 16 逻辑像素。
  double get fontSizeLinkLarge => _metric('fontSizeLinkLarge', 16);

  /// 读取 `fontSizeMarkExtraSmall` 的字号 Token，单位为逻辑像素；未配置时回退为 10 逻辑像素。
  double get fontSizeMarkExtraSmall => _metric('fontSizeMarkExtraSmall', 10);

  /// 读取 `fontSizeMarkSmall` 的字号 Token，单位为逻辑像素；未配置时回退为 12 逻辑像素。
  double get fontSizeMarkSmall => _metric('fontSizeMarkSmall', 12);

  /// 读取 `fontSizeMarkMedium` 的字号 Token，单位为逻辑像素；未配置时回退为 14 逻辑像素。
  double get fontSizeMarkMedium => _metric('fontSizeMarkMedium', 14);

  /// 读取 `fontSizeMarkLarge` 的字号 Token，单位为逻辑像素；未配置时回退为 16 逻辑像素。
  double get fontSizeMarkLarge => _metric('fontSizeMarkLarge', 16);

  /// 读取 `fontSizeBodyExtraSmall` 的字号 Token，单位为逻辑像素；未配置时回退为 10 逻辑像素。
  double get fontSizeBodyExtraSmall => _metric('fontSizeBodyExtraSmall', 10);

  /// 读取 `fontSizeBodySmall` 的字号 Token，单位为逻辑像素；未配置时回退为 12 逻辑像素。
  double get fontSizeBodySmall => _metric('fontSizeBodySmall', 12);

  /// 读取 `fontSizeBodyMedium` 的字号 Token，单位为逻辑像素；未配置时回退为 14 逻辑像素。
  double get fontSizeBodyMedium => _metric('fontSizeBodyMedium', 14);

  /// 读取 `fontSizeBodyLarge` 的字号 Token，单位为逻辑像素；未配置时回退为 16 逻辑像素。
  double get fontSizeBodyLarge => _metric('fontSizeBodyLarge', 16);

  /// 读取 `fontSizeTitleSmall` 的字号 Token，单位为逻辑像素；未配置时回退为 14 逻辑像素。
  double get fontSizeTitleSmall => _metric('fontSizeTitleSmall', 14);

  /// 读取 `fontSizeTitleMedium` 的字号 Token，单位为逻辑像素；未配置时回退为 16 逻辑像素。
  double get fontSizeTitleMedium => _metric('fontSizeTitleMedium', 16);

  /// 读取 `fontSizeTitleLarge` 的字号 Token，单位为逻辑像素；未配置时回退为 18 逻辑像素。
  double get fontSizeTitleLarge => _metric('fontSizeTitleLarge', 18);

  /// 读取 `fontSizeTitleExtraLarge` 的字号 Token，单位为逻辑像素；未配置时回退为 20 逻辑像素。
  double get fontSizeTitleExtraLarge => _metric('fontSizeTitleExtraLarge', 20);

  /// 读取 `fontSizeHeadlineSmall` 的字号 Token，单位为逻辑像素；未配置时回退为 24 逻辑像素。
  double get fontSizeHeadlineSmall => _metric('fontSizeHeadlineSmall', 24);

  /// 读取 `fontSizeHeadlineMedium` 的字号 Token，单位为逻辑像素；未配置时回退为 28 逻辑像素。
  double get fontSizeHeadlineMedium => _metric('fontSizeHeadlineMedium', 28);

  /// 读取 `fontSizeHeadlineLarge` 的字号 Token，单位为逻辑像素；未配置时回退为 36 逻辑像素。
  double get fontSizeHeadlineLarge => _metric('fontSizeHeadlineLarge', 36);

  /// 读取 `fontSizeDisplayMedium` 的字号 Token，单位为逻辑像素；未配置时回退为 48 逻辑像素。
  double get fontSizeDisplayMedium => _metric('fontSizeDisplayMedium', 48);

  /// 读取 `fontSizeDisplayLarge` 的字号 Token，单位为逻辑像素；未配置时回退为 64 逻辑像素。
  double get fontSizeDisplayLarge => _metric('fontSizeDisplayLarge', 64);

  /// 读取 `lineHeightLinkSmall` 的行高 Token，单位为逻辑像素；未配置时回退为 20 逻辑像素。
  double get lineHeightLinkSmall => _metric('lineHeightLinkSmall', 20);

  /// 读取 `lineHeightLinkMedium` 的行高 Token，单位为逻辑像素；未配置时回退为 22 逻辑像素。
  double get lineHeightLinkMedium => _metric('lineHeightLinkMedium', 22);

  /// 读取 `lineHeightLinkLarge` 的行高 Token，单位为逻辑像素；未配置时回退为 24 逻辑像素。
  double get lineHeightLinkLarge => _metric('lineHeightLinkLarge', 24);

  /// 读取 `lineHeightMarkExtraSmall` 的行高 Token，单位为逻辑像素；未配置时回退为 16 逻辑像素。
  double get lineHeightMarkExtraSmall =>
      _metric('lineHeightMarkExtraSmall', 16);

  /// 读取 `lineHeightMarkSmall` 的行高 Token，单位为逻辑像素；未配置时回退为 20 逻辑像素。
  double get lineHeightMarkSmall => _metric('lineHeightMarkSmall', 20);

  /// 读取 `lineHeightMarkMedium` 的行高 Token，单位为逻辑像素；未配置时回退为 22 逻辑像素。
  double get lineHeightMarkMedium => _metric('lineHeightMarkMedium', 22);

  /// 读取 `lineHeightMarkLarge` 的行高 Token，单位为逻辑像素；未配置时回退为 24 逻辑像素。
  double get lineHeightMarkLarge => _metric('lineHeightMarkLarge', 24);

  /// 读取 `lineHeightBodyExtraSmall` 的行高 Token，单位为逻辑像素；未配置时回退为 16 逻辑像素。
  double get lineHeightBodyExtraSmall =>
      _metric('lineHeightBodyExtraSmall', 16);

  /// 读取 `lineHeightBodySmall` 的行高 Token，单位为逻辑像素；未配置时回退为 20 逻辑像素。
  double get lineHeightBodySmall => _metric('lineHeightBodySmall', 20);

  /// 读取 `lineHeightBodyMedium` 的行高 Token，单位为逻辑像素；未配置时回退为 22 逻辑像素。
  double get lineHeightBodyMedium => _metric('lineHeightBodyMedium', 22);

  /// 读取 `lineHeightBodyLarge` 的行高 Token，单位为逻辑像素；未配置时回退为 24 逻辑像素。
  double get lineHeightBodyLarge => _metric('lineHeightBodyLarge', 24);

  /// 读取 `lineHeightTitleSmall` 的行高 Token，单位为逻辑像素；未配置时回退为 22 逻辑像素。
  double get lineHeightTitleSmall => _metric('lineHeightTitleSmall', 22);

  /// 读取 `lineHeightTitleMedium` 的行高 Token，单位为逻辑像素；未配置时回退为 24 逻辑像素。
  double get lineHeightTitleMedium => _metric('lineHeightTitleMedium', 24);

  /// 读取 `lineHeightTitleLarge` 的行高 Token，单位为逻辑像素；未配置时回退为 26 逻辑像素。
  double get lineHeightTitleLarge => _metric('lineHeightTitleLarge', 26);

  /// 读取 `lineHeightTitleExtraLarge` 的行高 Token，单位为逻辑像素；未配置时回退为 28 逻辑像素。
  double get lineHeightTitleExtraLarge =>
      _metric('lineHeightTitleExtraLarge', 28);

  /// 读取 `lineHeightHeadlineSmall` 的行高 Token，单位为逻辑像素；未配置时回退为 32 逻辑像素。
  double get lineHeightHeadlineSmall => _metric('lineHeightHeadlineSmall', 32);

  /// 读取 `lineHeightHeadlineMedium` 的行高 Token，单位为逻辑像素；未配置时回退为 36 逻辑像素。
  double get lineHeightHeadlineMedium =>
      _metric('lineHeightHeadlineMedium', 36);

  /// 读取 `lineHeightHeadlineLarge` 的行高 Token，单位为逻辑像素；未配置时回退为 44 逻辑像素。
  double get lineHeightHeadlineLarge => _metric('lineHeightHeadlineLarge', 44);

  /// 读取 `lineHeightDisplayMedium` 的行高 Token，单位为逻辑像素；未配置时回退为 56 逻辑像素。
  double get lineHeightDisplayMedium => _metric('lineHeightDisplayMedium', 56);

  /// 读取 `lineHeightDisplayLarge` 的行高 Token，单位为逻辑像素；未配置时回退为 72 逻辑像素。
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

  /// 读取 `fontDisplayLarge` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontDisplayLarge => _resolveFont(
    'fontDisplayLarge',
    'fontSizeDisplayLarge',
    'lineHeightDisplayLarge',
  );

  /// 读取 `fontDisplayMedium` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontDisplayMedium => _resolveFont(
    'fontDisplayMedium',
    'fontSizeDisplayMedium',
    'lineHeightDisplayMedium',
  );

  /// 读取 `fontHeadlineLarge` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontHeadlineLarge => _resolveFont(
    'fontHeadlineLarge',
    'fontSizeHeadlineLarge',
    'lineHeightHeadlineLarge',
  );

  /// 读取 `fontHeadlineMedium` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontHeadlineMedium => _resolveFont(
    'fontHeadlineMedium',
    'fontSizeHeadlineMedium',
    'lineHeightHeadlineMedium',
  );

  /// 读取 `fontHeadlineSmall` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontHeadlineSmall => _resolveFont(
    'fontHeadlineSmall',
    'fontSizeHeadlineSmall',
    'lineHeightHeadlineSmall',
  );

  /// 读取 `fontTitleExtraLarge` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontTitleExtraLarge => _resolveFont(
    'fontTitleExtraLarge',
    'fontSizeTitleExtraLarge',
    'lineHeightTitleExtraLarge',
  );

  /// 读取 `fontTitleLarge` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontTitleLarge => _resolveFont(
    'fontTitleLarge',
    'fontSizeTitleLarge',
    'lineHeightTitleLarge',
  );

  /// 读取 `fontTitleMedium` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontTitleMedium => _resolveFont(
    'fontTitleMedium',
    'fontSizeTitleMedium',
    'lineHeightTitleMedium',
  );

  /// 读取 `fontTitleSmall` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontTitleSmall => _resolveFont(
    'fontTitleSmall',
    'fontSizeTitleSmall',
    'lineHeightTitleSmall',
  );

  /// 读取 `fontBodyLarge` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontBodyLarge =>
      _resolveFont('fontBodyLarge', 'fontSizeBodyLarge', 'lineHeightBodyLarge');

  /// 读取 `fontBodyMedium` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontBodyMedium => _resolveFont(
    'fontBodyMedium',
    'fontSizeBodyMedium',
    'lineHeightBodyMedium',
  );

  /// 读取 `fontBodySmall` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontBodySmall =>
      _resolveFont('fontBodySmall', 'fontSizeBodySmall', 'lineHeightBodySmall');

  /// 读取 `fontBodyExtraSmall` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontBodyExtraSmall => _resolveFont(
    'fontBodyExtraSmall',
    'fontSizeBodyExtraSmall',
    'lineHeightBodyExtraSmall',
  );

  /// 读取 `fontMarkLarge` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontMarkLarge =>
      _resolveFont('fontMarkLarge', 'fontSizeMarkLarge', 'lineHeightMarkLarge');

  /// 读取 `fontMarkMedium` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontMarkMedium => _resolveFont(
    'fontMarkMedium',
    'fontSizeMarkMedium',
    'lineHeightMarkMedium',
  );

  /// 读取 `fontMarkSmall` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontMarkSmall =>
      _resolveFont('fontMarkSmall', 'fontSizeMarkSmall', 'lineHeightMarkSmall');

  /// 读取 `fontMarkExtraSmall` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontMarkExtraSmall => _resolveFont(
    'fontMarkExtraSmall',
    'fontSizeMarkExtraSmall',
    'lineHeightMarkExtraSmall',
  );

  /// 读取 `fontLinkLarge` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontLinkLarge =>
      _resolveFont('fontLinkLarge', 'fontSizeLinkLarge', 'lineHeightLinkLarge');

  /// 读取 `fontLinkMedium` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontLinkMedium => _resolveFont(
    'fontLinkMedium',
    'fontSizeLinkMedium',
    'lineHeightLinkMedium',
  );

  /// 读取 `fontLinkSmall` 复合字体 Token；显式配置的复合字体优先，否则结合对应独立字号、行高 Token 解析；未配置时返回 null。
  Font? get fontLinkSmall =>
      _resolveFont('fontLinkSmall', 'fontSizeLinkSmall', 'lineHeightLinkSmall');
}
