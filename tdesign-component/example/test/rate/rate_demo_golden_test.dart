import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../demo_page_test_utils.dart';
import 'rate_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(rateDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('rate selected ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, rateDemoPageTestSpec, mode);
      final rate = find.byType(TRate).first;
      final rect = tester.getRect(rate);
      await tester.tapAt(Offset(rect.right - 2, rect.center.dy));
      await tester.pump();

      expect(tester.widget<TRate>(rate).value, 5);
      await expectLater(
        find.byKey(const ValueKey('rate-demo-page')),
        matchesGoldenFile('goldens/rate_selected_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
