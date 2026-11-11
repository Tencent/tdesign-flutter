import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../tool/source_glyph_scan.dart';

void main() {
  test('collects CJK glyphs from string literals and interpolation', () {
    const source = '''
const a = '标题';
const b = \'副\$count标题\';
final c = r'raw 文案';
''';
    final glyphs = collectDisplayedGlyphs(source);
    expect(glyphs, containsAll('标题副文案'.runes));
  });

  test('ignores line comments, block comments and dartdoc', () {
    const source = '''
// 行注释里的史
/* 块注释里的废 */
/// dartdoc 里的龘
/** 文档块里的懿 */
const label = '显示';
''';
    final glyphs = collectDisplayedGlyphs(source);
    expect(glyphs, {'显示'.runes.first, '显示'.runes.last});
    for (final absent in '史废龘懿'.runes) {
      expect(glyphs, isNot(contains(absent)));
    }
  });

  test('a dartdoc-only change does not require new font glyphs', () {
    const before = "/// 标题\nconst label = '确定';";
    const after = "/// 标题，附带史与废的说明\nconst label = '确定';";
    expect(collectDisplayedGlyphs(after), collectDisplayedGlyphs(before));
  });

  test('a comment glyph absent from the shared font still fails the gate', () {
    // Reproduces the CI false alarm: the comment adds 龘/懿, which the
    // manifest and the golden font do not cover.
    const legacyScan = "/// 龘懿\nconst label = '确定';";
    final legacyGlyphs = legacyScan.runes.where(isSharedCjkFontRune).toSet();
    expect(legacyGlyphs, contains('龘'.runes.first));
    expect(
      collectDisplayedGlyphs(legacyScan),
      isNot(contains('龘'.runes.first)),
    );
  });

  test('parse failures fall back to literal scan instead of throwing', () {
    const broken = "const a = '完整'; const b = ";
    expect(collectDisplayedGlyphs(broken), contains('完整'.runes.first));
  });

  test('repository sources are scanned without analyzer errors', () {
    final result = parseString(content: "const a = '一';");
    expect(result.errors, isEmpty);
  });
}
