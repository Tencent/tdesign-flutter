import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'demo_page_test_utils.dart';
import 'dropdown_menu_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(dropdownMenuDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('dropdown menu single select ${mode.name} opened golden', (
      tester,
    ) async {
      await pumpDemoPageAtPhoneViewport(
        tester,
        dropdownMenuDemoPageTestSpec,
        mode,
      );

      final trigger = find.text('全部产品');
      final scrollable = find.descendant(
        of: find.byType(CustomScrollView).first,
        matching: find.byType(Scrollable),
      );
      await tester.scrollUntilVisible(
        trigger,
        200,
        scrollable: scrollable.first,
      );
      await tester.tap(trigger);
      await tester.pumpAndSettle();

      expect(find.text('最新产品'), findsOneWidget);
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile(
          'goldens/dropdown_menu_single_opened_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
