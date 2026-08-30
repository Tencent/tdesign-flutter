import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'message_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(messageDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('message closeable ${mode.name} opened golden', (tester) async {
      await pumpDemoPageAtPhoneViewport(tester, messageDemoPageTestSpec, mode);

      final trigger = find.widgetWithText(TButton, '带关闭的通知');
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

      expect(find.text('这是一条带关闭的消息通知'), findsOneWidget);
      expect(find.text('按钮'), findsOneWidget);
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile(
          'goldens/message_closeable_opened_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
