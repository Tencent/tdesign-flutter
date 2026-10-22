import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../demo_page_test_utils.dart';
import 'result_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(resultDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('result opened page ${mode.name} golden', (tester) async {
      await pumpDemoPageAtPhoneViewport(tester, resultDemoPageTestSpec, mode);
      final entry = find.byKey(const Key('result-page-example'));
      await tester.scrollUntilVisible(
        entry,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(entry);
      await tester.pumpAndSettle();
      expect(find.byType(TNavBar), findsOneWidget);
      expect(find.text('成功状态'), findsOneWidget);
      expect(tester.takeException(), isNull);
      // The opened route belongs to Navigator's overlay, outside the Demo boundary.
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile('goldens/result_page_opened_${mode.name}.png'),
      );
      await tester.tap(find.byKey(const Key('result-page-back')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('result-page-example')), findsOneWidget);
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
