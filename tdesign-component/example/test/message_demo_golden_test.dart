import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'message_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(messageDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final demoCase in messageDemoCases) {
      testWidgets('message ${demoCase.name} ${mode.name} opened golden', (
        tester,
      ) async {
        await pumpDemoPageAtPhoneViewport(
          tester,
          messageDemoPageTestSpec,
          mode,
        );
        await _openMessage(tester, demoCase);

        await expectLater(
          find.byType(Overlay),
          matchesGoldenFile(
            'goldens/message_${demoCase.name}_opened_${mode.name}.png',
          ),
        );
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}

Future<void> _openMessage(WidgetTester tester, MessageDemoCase demoCase) async {
  final trigger = find.widgetWithText(TButton, demoCase.triggerText);
  final scrollable = find.descendant(
    of: find.byType(CustomScrollView).first,
    matching: find.byType(Scrollable),
  );
  await tester.scrollUntilVisible(trigger, 200, scrollable: scrollable.first);
  final overflow = tester.getRect(trigger).bottom - 780;
  if (overflow > 0) {
    await tester.drag(scrollable.first, Offset(0, -overflow - 16));
    await tester.pumpAndSettle();
  }
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));

  expect(find.text(demoCase.visibleText), findsOneWidget);
  if (demoCase.actionText case final actionText?) {
    expect(find.text(actionText), findsOneWidget);
  }
  if (demoCase.lifetime == MessageDemoLifetime.declarative) {
    expect(find.widgetWithText(TButton, '隐藏消息'), findsOneWidget);
  }
}
