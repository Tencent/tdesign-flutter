import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'backtop_demo_test_spec.dart';
import 'demo_page_test_utils.dart';

void main() {
  registerDemoGoldenTests(backTopDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final shape in ['circle', 'half-round']) {
      testWidgets('backtop $shape scrolled ${mode.name} Demo golden', (
        tester,
      ) async {
        await pumpDemoPageAtPhoneViewport(
          tester,
          backTopDemoPageTestSpec,
          mode,
        );

        await tester.tap(find.byKey(Key('backtop-demo-$shape-trigger')));
        await tester.pumpAndSettle();

        await expectLater(
          find.byKey(const ValueKey('backtop-demo-page')),
          matchesGoldenFile(
            'goldens/backtop_page_${shape}_scrolled_${mode.name}.png',
          ),
        );
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}
