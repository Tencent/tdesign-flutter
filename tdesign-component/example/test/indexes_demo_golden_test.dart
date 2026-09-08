import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'demo_page_test_utils.dart';
import 'indexes_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(indexesDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('indexes letter ${mode.name} opened golden', (tester) async {
      await pumpDemoPageAtPhoneViewport(tester, indexesDemoPageTestSpec, mode);
      await tester.tap(find.byKey(const ValueKey('indexes-letter-trigger')));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile('goldens/indexes_letter_opened_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('indexes number ${mode.name} opened golden', (tester) async {
      await pumpDemoPageAtPhoneViewport(tester, indexesDemoPageTestSpec, mode);
      await tester.tap(find.byKey(const ValueKey('indexes-number-trigger')));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile('goldens/indexes_number_opened_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('indexes capsule ${mode.name} opened golden', (tester) async {
      await pumpDemoPageAtPhoneViewport(tester, indexesDemoPageTestSpec, mode);
      await tester.tap(find.byKey(const ValueKey('indexes-capsule-trigger')));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile('goldens/indexes_capsule_opened_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
