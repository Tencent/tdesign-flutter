import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'demo_page_test_utils.dart';
import 'popup_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(popupDemoPageTestSpec);

  const basicPopupCases = {
    'top': ('popup-top-trigger', '顶部弹出'),
    'left': ('popup-left-trigger', '左侧弹出'),
    'center': ('popup-center-trigger', '中间弹出'),
    'bottom': ('popup-bottom-trigger', '底部弹出'),
    'right': ('popup-right-trigger', '右侧弹出'),
  };

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final entry in basicPopupCases.entries) {
      final placement = entry.key;
      final popupCase = entry.value;
      testWidgets('popup basic $placement ${mode.name} opened golden', (
        tester,
      ) async {
        await pumpDemoPageAtPhoneViewport(tester, popupDemoPageTestSpec, mode);

        final trigger = find.byKey(ValueKey(popupCase.$1));
        expect(trigger, findsOneWidget);
        await tester.tap(trigger);
        await tester.pumpAndSettle();

        expect(find.text(popupCase.$2), findsAtLeastNWidgets(2));
        await expectLater(
          find.byType(Overlay),
          matchesGoldenFile(
            'goldens/popup_basic_${placement}_opened_${mode.name}.png',
          ),
        );
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}
