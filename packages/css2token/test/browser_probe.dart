import 'dart:convert';
import 'dart:js_interop';
import 'package:css2token/css2token.dart';

@JS('document.getElementById')
external _Element? _element(String id);
extension type _Element(JSObject _) implements JSObject {
  external String? get textContent;
  external set textContent(String? value);
}
bool _equal(Object? a, Object? b) {
  if (a is Map && b is Map) {
    return a.length == b.length &&
        a.keys.every((k) => b.containsKey(k) && _equal(a[k], b[k]));
  }
  if (a is List && b is List) {
    return a.length == b.length &&
        Iterable.generate(a.length).every((i) => _equal(a[i], b[i]));
  }
  return a == b;
}

void main() {
  final fixtures = jsonDecode(_element('fixtures')!.textContent!) as List;
  final output = <String>[];
  var passed = 0;
  for (final fixture in fixtures.cast<Map<String, dynamic>>()) {
    try {
      final base = fixture['baseline'] as Map?;
      final result = cssToFlutterTokens(
              lightCss: fixture['light'] as String,
              darkCss: fixture['dark'] as String,
              extraCss: fixture['extra'] as String,
              baseline: base == null
                  ? null
                  : CssThemeParts(
                      light: base['light'] as String,
                      dark: base['dark'] as String,
                      extra: base['extra'] as String))
          .toJson();
      for (final mode in ['light', 'dark']) {
        final success =
            _equal(result[mode], (fixture['expected'] as Map)[mode]);
        if (success) passed++;
        output.add('${fixture['name']} / $mode: ${success ? 'PASS' : 'FAIL'}');
      }
    } on Object catch (error) {
      output.add('${fixture['name']}: FAIL $error');
    }
  }
  _element('summary')!.textContent =
      '$passed/${fixtures.length * 2} 通过（实际执行 Dart 编译代码）';
  _element('results')!.textContent = output.join('\n');
}
