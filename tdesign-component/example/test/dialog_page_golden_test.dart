import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'dialog_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(dialogDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('dialog close button ${mode.name} opened golden', (
      tester,
    ) async {
      await pumpDemoPageAtPhoneViewport(tester, dialogDemoPageTestSpec, mode);

      final trigger = find.widgetWithText(TButton, '带关闭按钮的对话框');
      await tester.drag(
        find.byType(CustomScrollView).first,
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();
      await tester.tap(trigger);
      await tester.pumpAndSettle();

      expect(find.byType(TDialog), findsOneWidget);
      expect(find.byIcon(TIcons.close), findsOneWidget);
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile(
          'goldens/dialog_close_button_opened_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
