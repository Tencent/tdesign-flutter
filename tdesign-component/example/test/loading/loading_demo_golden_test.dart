import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../demo_page_test_utils.dart';
import 'loading_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(loadingDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('loading speed ${mode.name} post action golden', (
      tester,
    ) async {
      await pumpFullDemoPage(tester, loadingDemoPageTestSpec, mode);
      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(80, 0));
      await tester.pump();
      expect(find.text('800'), findsNothing);
      await expectLater(
        find.byKey(const ValueKey('loading-demo-page')),
        matchesGoldenFile(
          'goldens/loading_speed_post_action_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
