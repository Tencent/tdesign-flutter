import 'models.dart';

/// Splits a complete TDesign generator export into mode declaration sets.
///
/// Supports root rules only: `:root`, `:root.dark` and
/// `:root[theme-mode="light"|"dark"]` (including selector lists).
/// Mode-specific declarations override shared root declarations. Rules of the
/// same specificity retain source order. This is not a general CSS parser:
/// nested rules, unsupported selectors and incomplete exports throw
/// [FormatException], rather than silently mixing light and dark values.
CssThemeParts splitGeneratorCss(String css) {
  final source = css.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '').trim();
  final shared = <String>[], light = <String>[], dark = <String>[];
  final rules = RegExp(r'([^{}]+)\{([^{}]*)\}');
  var end = 0;
  for (final match in rules.allMatches(source)) {
    if (source.substring(end, match.start).trim().isNotEmpty) {
      throw const FormatException('Unsupported or nested CSS rule');
    }
    final modes = <String>{};
    for (final raw in match[1]!.split(',')) {
      final selector = raw.trim();
      if (selector == ':root') {
        modes.add('shared');
      } else if (selector == ':root.dark') {
        modes.add('dark');
      } else {
        final mode = RegExp(
          r'''^:root\[\s*theme-mode\s*=\s*(?:"(light|dark)"|'(light|dark)'|(light|dark))\s*\]$''',
        ).firstMatch(selector);
        if (mode == null) {
          throw FormatException('Unsupported generator selector: $selector');
        }
        modes.add((mode[1] ?? mode[2] ?? mode[3])!);
      }
    }
    final body = match[2]!;
    // The generator's :root, :root[theme-mode="light"] list is a light rule,
    // not a shared override that should overwrite dark-mode palette tokens.
    if (modes.contains('light')) light.add(body);
    if (modes.contains('dark')) dark.add(body);
    if (modes.length == 1 && modes.contains('shared')) shared.add(body);
    end = match.end;
  }
  if (source.substring(end).trim().isNotEmpty ||
      light.isEmpty ||
      dark.isEmpty) {
    throw const FormatException('Expected complete light and dark root rules');
  }
  return CssThemeParts(
    light: [...shared, ...light].join(';\n'),
    dark: [...shared, ...dark].join(';\n'),
  );
}
