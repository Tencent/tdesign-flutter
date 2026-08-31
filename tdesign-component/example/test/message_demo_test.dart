import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'message_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(messageDemoPageTestSpec);

  for (final demoCase in messageDemoCases) {
    testWidgets('${demoCase.triggerText}可触发展示并符合生命周期', (tester) async {
      await pumpDemoPageAtPhoneViewport(
        tester,
        messageDemoPageTestSpec,
        ThemeMode.light,
      );
      await _openMessage(tester, demoCase);

      switch (demoCase.lifetime) {
        case MessageDemoLifetime.autoDismiss:
          await tester.pump(const Duration(seconds: 3));
          await tester.pump(const Duration(milliseconds: 300));
          expect(find.text(demoCase.visibleText), findsNothing);
        case MessageDemoLifetime.persistent:
          await tester.pump(const Duration(milliseconds: 3500));
          expect(find.text(demoCase.visibleText), findsOneWidget);
        case MessageDemoLifetime.declarative:
          await tester.pump(const Duration(milliseconds: 3500));
          expect(find.text(demoCase.visibleText), findsOneWidget);
          await tester.tap(find.widgetWithText(TButton, '隐藏消息'));
          await tester.pump();
          expect(find.text(demoCase.visibleText), findsNothing);
      }

      if (demoCase.hasCloseButton) {
        final closeButton = find.descendant(
          of: find.byType(TMessage),
          matching: find.byIcon(TIcons.close),
        );
        await tester.tap(closeButton);
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.text(demoCase.visibleText), findsNothing);
      }
      await disposeDemoPage(tester);
    });
  }

  for (final demoCase in messageDemoCases.where(
    (demoCase) => demoCase.actionText != null,
  )) {
    testWidgets('${demoCase.triggerText}的操作可点击并展示反馈', (tester) async {
      await pumpDemoPageAtPhoneViewport(
        tester,
        messageDemoPageTestSpec,
        ThemeMode.light,
      );
      await _openMessage(tester, demoCase);
      await tester.tap(find.text(demoCase.actionText!));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text(demoCase.feedbackText!), findsOneWidget);

      await disposeDemoPage(tester);
    });
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
}
