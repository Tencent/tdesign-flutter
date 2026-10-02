import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';

void main() {
  test('Golden 字体通过 TDesign Token 注入且不修改原主题', () {
    final token = TThemeData.defaultData();
    final theme = TThemeBuilder.light(token);
    const spec = DemoPageTestSpec(
      name: 'font-test',
      title: '字体',
      page: SizedBox(),
      expectedTexts: [],
    );

    final result = withDemoGoldenFonts(theme, spec);
    final goldenFont = result.extension<TThemeData>()!.fontFamily;

    expect(goldenFont?.fontFamily, token.fontFamily?.flutterFontFamily);
    expect(goldenFont?.fallback, contains('TDesign Golden CJK'));
    expect(theme.extension<TThemeData>()!.fontFamily, token.fontFamily);
    expect(
      result.textTheme.bodyMedium?.fontFamilyFallback,
      contains('TDesign Golden CJK'),
    );
  });
}
