import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'demo_page_test_utils.dart';
import 'indexes_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(indexesDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('indexes basic ${mode.name} opened golden', (tester) async {
      await pumpDemoPageAtPhoneViewport(tester, indexesDemoPageTestSpec, mode);
      await tester.tap(find.byKey(const ValueKey('indexes-basic-trigger')));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile('goldens/indexes_basic_opened_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('indexes custom ${mode.name} opened golden', (tester) async {
      await pumpDemoPageAtPhoneViewport(tester, indexesDemoPageTestSpec, mode);
      await tester.tap(find.byKey(const ValueKey('indexes-custom-trigger')));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile('goldens/indexes_custom_opened_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
