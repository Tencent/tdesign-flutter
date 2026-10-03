import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/theme/theme_page.dart';

import '../demo_page_test_utils.dart';

void main() {
  const spec = DemoPageTestSpec(
    name: 'theme',
    title: 'Theme 主题',
    page: TThemeColorsPage(),
    expectedTexts: ['01 颜色示例', '功能色', '文字&图标颜色', '中性色板'],
    componentType: TText,
  );
  registerDemoPageTests(spec);

  testWidgets('Theme Demo lists the current palette keys', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);

    for (final prefix in ['fontGray', 'fontWhite']) {
      for (var index = 1; index <= 4; index++) {
        expect(find.text('$prefix$index'), findsOneWidget);
      }
    }
    for (var index = 1; index <= 14; index++) {
      expect(find.text('grayColor$index'), findsOneWidget);
    }
    expect(find.text('bgColorContainer'), findsOneWidget);
    expect(find.text('whiteColor1'), findsNothing);
    expect(tester.takeException(), isNull);
    await disposeDemoPage(tester);
  }, tags: 'demo');
}
