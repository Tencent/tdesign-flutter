import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'action_sheet_demo_test_spec.dart';
import 'demo_page_test_utils.dart';

void main() {
  registerDemoGoldenTests(actionSheetDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('action sheet basic list ${mode.name} opened golden', (
      tester,
    ) async {
      await pumpDemoPageAtPhoneViewport(
        tester,
        actionSheetDemoPageTestSpec,
        mode,
      );

      final trigger = find.widgetWithText(TButton, '常规列表型');
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

      expect(find.text('Move'), findsOneWidget);
      expect(find.text('cancel'), findsOneWidget);
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile(
          'goldens/action_sheet_basic_list_opened_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
