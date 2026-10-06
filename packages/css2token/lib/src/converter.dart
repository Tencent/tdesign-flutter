import 'models.dart';

const _semanticColors = <String, List<String>>{
  '--td-brand-color': ['brandColor'],
  '--td-brand-color-focus': ['brandColorFocus'],
  '--td-brand-color-active': ['brandColorActive'],
  '--td-brand-color-disabled': ['brandColorDisabled'],
  '--td-brand-color-light': ['brandColorLight'],
  '--td-brand-color-light-hover': ['brandColorLightActive'],
  '--td-brand-color-light-active': ['brandColorLightActive'],
  '--td-warning-color': ['warningColor'],
  '--td-warning-color-focus': ['warningColorFocus'],
  '--td-warning-color-active': ['warningColorActive'],
  '--td-warning-color-disabled': ['warningColorDisabled'],
  '--td-warning-color-light': ['warningColorLight'],
  '--td-warning-color-light-hover': ['warningColorLightActive'],
  '--td-warning-color-light-active': ['warningColorLightActive'],
  '--td-error-color': ['errorColor'],
  '--td-error-color-focus': ['errorColorFocus'],
  '--td-error-color-active': ['errorColorActive'],
  '--td-error-color-disabled': ['errorColorDisabled'],
  '--td-error-color-light': ['errorColorLight'],
  '--td-error-color-light-hover': ['errorColorLightActive'],
  '--td-error-color-light-active': ['errorColorLightActive'],
  '--td-success-color': ['successColor'],
  '--td-success-color-focus': ['successColorFocus'],
  '--td-success-color-active': ['successColorActive'],
  '--td-success-color-disabled': ['successColorDisabled'],
  '--td-success-color-light': ['successColorLight'],
  '--td-success-color-light-hover': ['successColorLightActive'],
  '--td-success-color-light-active': ['successColorLightActive'],
  '--td-bg-color-page': ['bgColorPage'],
  '--td-bg-color-container': ['bgColorContainer'],
  '--td-bg-color-container-active': ['bgColorContainerActive'],
  '--td-bg-color-secondarycontainer': ['bgColorSecondaryContainer'],
  '--td-bg-color-secondarycontainer-active': [
    'bgColorSecondaryContainerActive',
  ],
  '--td-bg-color-component': ['bgColorComponent'],
  '--td-bg-color-component-active': ['bgColorComponentActive'],
  '--td-bg-color-component-disabled': ['bgColorComponentDisabled'],
  '--td-bg-color-secondarycomponent': ['bgColorSecondaryComponent'],
  '--td-bg-color-secondarycomponent-active': [
    'bgColorSecondaryComponentActive',
  ],
  '--td-bg-color-specialcomponent': ['bgColorSpecialComponent'],
  '--td-text-color-primary': ['textColorPrimary'],
  '--td-text-color-secondary': ['textColorSecondary'],
  '--td-text-color-placeholder': ['textColorPlaceholder'],
  '--td-text-color-disabled': ['textColorDisabled'],
  '--td-text-color-brand': ['textColorBrand'],
  '--td-text-color-link': ['textColorLink'],
  '--td-text-color-anti': ['textColorAnti'],
  '--td-mask-active': ['maskActive'],
  '--td-mask-disabled': ['maskDisabled'],
  '--td-component-stroke': ['componentStroke'],
  '--td-component-border': ['componentBorder'],
  '--td-border-level-1-color': ['borderLevel1Color'],
  '--td-border-level-2-color': ['borderLevel2Color'],
};

class _FontSpec {
  const _FontSpec(
    this.name,
    this.sizeSuffix,
    this.offset,
    this.defaultSize,
    this.heightSuffix,
    this.defaultHeight,
    this.weight,
  );
  final String name, sizeSuffix, heightSuffix;
  final double offset, defaultSize, defaultHeight;
  final int weight;
}

const _fonts = [
  _FontSpec('fontDisplayLarge', 'display-large', 0, 64, 'display-large', 72, 6),
  _FontSpec(
    'fontDisplayMedium',
    'display-medium',
    0,
    48,
    'display-medium',
    56,
    6,
  ),
  _FontSpec(
    'fontHeadlineLarge',
    'headline-large',
    0,
    36,
    'headline-large',
    44,
    6,
  ),
  _FontSpec(
    'fontHeadlineMedium',
    'headline-medium',
    0,
    28,
    'headline-medium',
    36,
    6,
  ),
  _FontSpec(
    'fontHeadlineSmall',
    'headline-small',
    0,
    24,
    'headline-small',
    32,
    6,
  ),
  _FontSpec(
    'fontTitleExtraLarge',
    'title-large',
    0,
    20,
    'title-extraLarge',
    28,
    6,
  ),
  _FontSpec('fontTitleLarge', 'title-large', -2, 18, 'title-large', 26, 6),
  _FontSpec('fontTitleMedium', 'title-medium', 0, 16, 'title-medium', 24, 6),
  _FontSpec('fontTitleSmall', 'title-small', 0, 14, 'title-small', 22, 4),
  _FontSpec('fontBodyLarge', 'body-large', 0, 16, 'body-large', 24, 4),
  _FontSpec('fontBodyMedium', 'body-medium', 0, 14, 'body-medium', 22, 4),
  _FontSpec('fontBodySmall', 'body-small', 0, 12, 'body-small', 20, 4),
  _FontSpec(
    'fontBodyExtraSmall',
    'body-small',
    -2,
    10,
    'body-extraSmall',
    16,
    4,
  ),
  _FontSpec('fontMarkLarge', 'mark-medium', 2, 16, 'mark-large', 24, 6),
  _FontSpec('fontMarkMedium', 'mark-medium', 0, 14, 'mark-medium', 22, 6),
  _FontSpec('fontMarkSmall', 'mark-small', 0, 12, 'mark-small', 20, 6),
  _FontSpec(
    'fontMarkExtraSmall',
    'mark-small',
    -2,
    10,
    'mark-extraSmall',
    16,
    6,
  ),
  _FontSpec('fontLinkLarge', 'link-large', 0, 16, 'link-large', 24, 4),
  _FontSpec('fontLinkMedium', 'link-medium', 0, 14, 'link-medium', 22, 4),
  _FontSpec('fontLinkSmall', 'link-small', 0, 12, 'link-small', 20, 4),
];

const _radii = <String, String>{
  'radiusSmall': '--td-radius-small',
  'radiusDefault': '--td-radius-default',
  'radiusLarge': '--td-radius-large',
  'radiusExtraLarge': '--td-radius-extraLarge',
  'radiusRound': '--td-radius-round',
  'radiusCircle': '--td-radius-circle',
};

const _shadows = <String, String>{
  'shadow1': '--td-shadow-1',
  'shadow2': '--td-shadow-2',
  'shadow3': '--td-shadow-3',
  'shadow4': '--td-shadow-4',
};

const _insets = <String, String>{
  'shadowInsetTop': '--td-shadow-inset-top',
  'shadowInsetRight': '--td-shadow-inset-right',
  'shadowInsetBottom': '--td-shadow-inset-bottom',
  'shadowInsetLeft': '--td-shadow-inset-left',
};

const _spacers = <String, (String, String, double)>{
  'spacer': ('--td-spacer', '--td-size-4', 1),
  'spacer1': ('--td-spacer-1', '--td-size-5', 1),
  'spacer2': ('--td-spacer-2', '--td-size-6', 1),
  'spacer3': ('--td-spacer-3', '--td-size-8', 1),
  'spacer4': ('--td-spacer-4', '--td-size-10', 1),
  'spacer5': ('--td-spacer-5', '--td-size-13', 1),
  'spacer6': ('--td-spacer-6', '--td-size-15', 1.25),
};

/// Reads td declarations in source order, ignoring comments and important.
///
/// This does not evaluate selectors, media queries, or CSS cascade priority.
Map<String, String> parseCssVariables(String cssText) {
  final source = cssText.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');
  return {
    for (final match in RegExp(
      r'(--td-[\w-]+)\s*:\s*([^;}]+)(?:;|(?=})|$)',
    ).allMatches(source))
      match[1]!:
          match[2]!.replaceFirst(RegExp(r'\s*!important\s*$'), '').trim(),
  };
}

String? _paletteName(String name) {
  final palette = RegExp(
    r'^--td-(primary|brand|warning|error|success|gray)-color-(\d+)$',
  ).firstMatch(name);
  if (palette != null) return '${palette[1]}Color${palette[2]}';
  final font = RegExp(r'^--td-font-(white|gray)-(\d+)$').firstMatch(name);
  if (font == null) return null;
  return 'font${font[1] == 'white' ? 'White' : 'Gray'}${font[2]}';
}

String _hexByte(double value) =>
    value.clamp(0, 255).round().toRadixString(16).padLeft(2, '0').toUpperCase();

/// Converts hex, rgb/rgba and transparent colors to Flutter hex notation.
///
/// CSS eight-digit hex is RGBA; Flutter eight-digit output is ARGB.
/// Unsupported or malformed colors return null.
String? normalizeCssColor(String? value) {
  final input = value?.trim();
  if (input == null || input.isEmpty) return null;
  if (input.toLowerCase() == 'transparent') return '#00000000';
  final hex = RegExp(
    r'^#([\da-f]+)$',
    caseSensitive: false,
  ).firstMatch(input)?[1];
  if (hex != null) {
    if (hex.length == 3) {
      return '#${hex.split('').map((v) => '$v$v').join()}'.toUpperCase();
    }
    if (hex.length == 4) {
      final parts = hex.split('').map((v) => '$v$v').toList();
      return '#${parts[3]}${parts[0]}${parts[1]}${parts[2]}'.toUpperCase();
    }
    if (hex.length == 6) return '#${hex.toUpperCase()}';
    if (hex.length == 8) {
      return '#${hex.substring(6)}${hex.substring(0, 6)}'.toUpperCase();
    }
    return null;
  }
  final rgb = RegExp(
    r'^rgba?\(\s*((?:\d+(?:\.\d*)?|\.\d+)%?)[,\s]+((?:\d+(?:\.\d*)?|\.\d+)%?)[,\s]+((?:\d+(?:\.\d*)?|\.\d+)%?)(?:\s*[,/]\s*((?:\d+(?:\.\d*)?|\.\d+)%?))?\s*\)$',
    caseSensitive: false,
  ).firstMatch(input);
  if (rgb == null) return null;
  double channel(String part, double scale) =>
      double.parse(part.replaceAll('%', '')) *
      (part.endsWith('%') ? scale / 100 : 1);
  final parts = [for (var i = 1; i <= 3; i++) channel(rgb[i]!, 255)];
  final alphaText = rgb[4] ?? '1';
  final alpha = channel(alphaText, 1) * 255;
  if (![...parts, alpha].every((v) => v.isFinite)) return null;
  return '#${_hexByte(alpha)}${parts.map(_hexByte).join()}';
}

List<String> _splitTopLevel(String value) {
  final parts = <String>[];
  var depth = 0;
  var start = 0;
  for (var i = 0; i < value.length; i++) {
    if (value[i] == '(') depth++;
    if (value[i] == ')') depth--;
    if (value[i] == ',' && depth == 0) {
      parts.add(value.substring(start, i));
      start = i + 1;
    }
  }
  return parts..add(value.substring(start));
}

String? _reference(String? value) => value == null
    ? null
    : RegExp(r'^var\(\s*(--td-[\w-]+)').firstMatch(value)?[1];

class _Resolver {
  _Resolver(this.variables, this.baseline);
  final Map<String, String> variables;
  final Map<String, String>? baseline;

  String? value(String? name, [Set<String>? visited]) {
    final seen = {...?visited};
    if (name == null || !seen.add(name)) return null;
    return expression(variables[name], seen);
  }

  String? expression(String? input, [Set<String>? visited]) {
    if (input == null || input.isEmpty) return null;
    var result = input;
    while (result.contains('var(')) {
      final start = result.indexOf('var(');
      var depth = 1;
      var end = start + 4;
      for (; end < result.length && depth > 0; end++) {
        if (result[end] == '(') depth++;
        if (result[end] == ')') depth--;
      }
      if (depth != 0) return null;
      final parts = _splitTopLevel(result.substring(start + 4, end - 1));
      final name = parts.removeAt(0).trim();
      if (!RegExp(r'^--td-[\w-]+$').hasMatch(name)) return null;
      final resolved =
          value(name, visited) ?? expression(parts.join(',').trim(), visited);
      if (resolved == null) return null;
      result = result.substring(0, start) + resolved + result.substring(end);
    }
    return result;
  }

  String? leaf(String? name, [Set<String>? visited]) {
    final seen = {...?visited};
    if (name == null || !seen.add(name) || !variables.containsKey(name)) {
      return null;
    }
    return _paletteName(name) ?? leaf(_reference(variables[name]), seen);
  }

  bool changed(String name, [Set<String>? visited]) {
    if (baseline == null) return true;
    final seen = {...?visited};
    if (!seen.add(name)) return false;
    if (variables[name] != baseline![name]) return true;
    return RegExp(
      r'var\(\s*(--td-[\w-]+)',
    ).allMatches(variables[name] ?? '').any((m) => changed(m[1]!, seen));
  }

  double? length(String name) {
    final match = RegExp(
      r'^(-?(?:\d+(?:\.\d*)?|\.\d+))(?:px)?$',
      caseSensitive: false,
    ).firstMatch(value(name) ?? '');
    final number = match == null ? null : double.tryParse(match[1]!);
    return number != null && number.isFinite ? number : null;
  }

  List<Map<String, Object>> shadows(String? value) {
    if (value == null || value == 'none') return [];
    final layers = <Map<String, Object>>[];
    for (final part in _splitTopLevel(value)) {
      final input = part.trim();
      if (input.startsWith('inset')) continue;
      final match = RegExp(
        r'^(-?(?:\d+(?:\.\d*)?|\.\d+))(?:px)?\s+(-?(?:\d+(?:\.\d*)?|\.\d+))(?:px)?\s+((?:\d+(?:\.\d*)?|\.\d+))(?:px)?(?:\s+(-?(?:\d+(?:\.\d*)?|\.\d+))(?:px)?)?\s+(.+)$',
      ).firstMatch(input);
      if (match == null) continue;
      final color = normalizeCssColor(expression(match[5]));
      if (color == null) continue;
      final values = [
        for (var i = 1; i <= 4; i++) double.parse(match[i] ?? '0'),
      ];
      if (!values.every((v) => v.isFinite)) continue;
      layers.add({
        'color': color,
        'blurRadius': values[2],
        'spreadRadius': values[3],
        'offset': {'x': values[0], 'y': values[1]},
      });
    }
    return layers;
  }
}

/// Converts one CSS declaration set into sparse Flutter token overrides.
///
/// With [baselineCss], only changes against the pristine full CSS are emitted,
/// including changes in referenced dependencies. Missing tokens are omitted.
/// For a font with only size or height, the other dimension uses the current
/// Flutter profile's default. Invalid supplied dimensions omit that font.
FlutterThemeTokens parseCssToFlutterTokens(String css, {String? baselineCss}) {
  final variables = parseCssVariables(css);
  final resolver = _Resolver(
    variables,
    baselineCss == null ? null : parseCssVariables(baselineCss),
  );
  final color = <String, Object>{}, ref = <String, Object>{};
  for (final name in variables.keys) {
    final flutterName = _paletteName(name);
    if (flutterName == null || !resolver.changed(name)) continue;
    final normalized = normalizeCssColor(resolver.value(name));
    if (normalized != null) color[flutterName] = normalized;
  }
  for (final entry in _semanticColors.entries) {
    if (!variables.containsKey(entry.key) || !resolver.changed(entry.key)) {
      continue;
    }
    final leaf = resolver.leaf(entry.key);
    final direct = normalizeCssColor(resolver.value(entry.key));
    if (direct == null) continue;
    for (final name in entry.value) {
      if (entry.key.startsWith('--td-border-level-') &&
          (ref.containsKey(name) || color.containsKey(name))) {
        continue;
      }
      if (leaf != null) {
        ref[name] = leaf;
      } else {
        color[name] = direct;
        ref[name] = name;
      }
    }
  }
  final font = <String, Object>{}, metrics = <String, Object>{};
  for (final spec in _fonts) {
    final sizeToken = '--td-font-size-${spec.sizeSuffix}';
    final heightToken = '--td-line-height-${spec.heightSuffix}';
    if (!variables.containsKey(sizeToken) &&
        !variables.containsKey(heightToken)) {
      continue;
    }
    if (!resolver.changed(sizeToken) && !resolver.changed(heightToken)) {
      continue;
    }
    final sourceSize = resolver.length(sizeToken);
    final sourceHeight = resolver.length(heightToken);
    if ((variables.containsKey(sizeToken) && sourceSize == null) ||
        (variables.containsKey(heightToken) && sourceHeight == null)) {
      continue;
    }
    final size =
        sourceSize == null ? spec.defaultSize : sourceSize + spec.offset;
    final height = sourceHeight ?? spec.defaultHeight;
    if (size <= 0 || height <= 0) continue;
    font[spec.name] = {
      // Flutter's composite Font JSON contract uses integral dimensions.
      'size': size == size.roundToDouble() ? size.toInt() : size,
      'lineHeight': height == height.roundToDouble() ? height.toInt() : height,
      'fontWeight': spec.weight,
    };
    final suffix = spec.name.substring(4);
    metrics['fontSize$suffix'] = size;
    metrics['lineHeight$suffix'] = height;
  }
  final radius = <String, Object>{};
  for (final entry in _radii.entries) {
    if (!resolver.changed(entry.value)) continue;
    final raw = resolver.value(entry.value);
    final length = resolver.length(entry.value);
    if (entry.key == 'radiusCircle' &&
        RegExp(r'^(?:\d+(?:\.\d*)?|\.\d+)%$').hasMatch(raw ?? '')) {
      radius[entry.key] = 9999;
    } else if (length != null && length >= 0) {
      radius[entry.key] = length;
    }
  }
  final shadow = <String, Object>{}, inset = <String, Object>{};
  for (final entry in _shadows.entries) {
    if (!resolver.changed(entry.value)) continue;
    final raw = resolver.value(entry.value);
    final layers = resolver.shadows(raw);
    if (layers.isNotEmpty || raw == 'none') shadow[entry.key] = layers;
  }
  for (final entry in _insets.entries) {
    if (!resolver.changed(entry.value)) continue;
    final raw = resolver.value(entry.value);
    if (raw == 'none') {
      inset[entry.key] = {'color': '#00000000', 'width': 0};
      continue;
    }
    final layers = resolver.shadows(
      raw?.replaceFirst(RegExp(r'^inset\s+'), ''),
    );
    if (layers.length != 1) continue;
    final edge = layers.single;
    final offset = edge['offset']! as Map<String, double>;
    if (edge['blurRadius'] == 0 && edge['spreadRadius'] == 0) {
      inset[entry.key] = {
        'color': edge['color']!,
        'width': (offset['x'] == 0 ? offset['y']! : offset['x']!).abs(),
      };
    }
  }
  final margin = <String, Object>{};
  for (final entry in _spacers.entries) {
    final (native, controller, scale) = entry.value;
    final explicit = variables.containsKey(native);
    final name = explicit ? native : controller;
    if (!resolver.changed(name)) continue;
    final length = resolver.length(name);
    if (length != null && length >= 0) {
      margin[entry.key] = length * (explicit ? 1 : scale);
    }
  }
  return FlutterThemeTokens(
    ref: ref,
    color: color,
    font: font,
    fontMetric: metrics,
    radius: radius,
    shadow: shadow,
    insetShadow: inset,
    margin: margin,
  );
}

/// Converts independent light/dark CSS and shared declarations.
///
/// [baseline] must contain pristine controller CSS, not the saved custom theme.
/// [extraCss] is appended after each mode, so shared declarations win.
FlutterThemeOverrides cssToFlutterTokens({
  required String lightCss,
  required String darkCss,
  String extraCss = '',
  CssThemeParts? baseline,
}) =>
    FlutterThemeOverrides(
      light: parseCssToFlutterTokens(
        '$lightCss\n;\n$extraCss',
        baselineCss:
            baseline == null ? null : '${baseline.light}\n;\n${baseline.extra}',
      ),
      dark: parseCssToFlutterTokens(
        '$darkCss\n;\n$extraCss',
        baselineCss:
            baseline == null ? null : '${baseline.dark}\n;\n${baseline.extra}',
      ),
    );
