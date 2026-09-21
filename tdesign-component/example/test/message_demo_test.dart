import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'message_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(messageDemoPageTestSpec);

  testWidgets('Message Demo 使用设计稿的大尺寸通栏按钮与说明间距', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      messageDemoPageTestSpec,
      ThemeMode.light,
    );

    final iconButton = find.widgetWithText(TButton, '带图标的通知');
    final iconLabel = find.byKey(const ValueKey('message-type-label-带图标的通知'));
    final textButton = find.widgetWithText(TButton, '纯文字的通知');
    expect(
      tester.getRect(iconLabel).top - tester.getRect(textButton).bottom,
      24,
    );
    expect(
      tester.getRect(iconButton).top - tester.getRect(iconLabel).bottom,
      16,
    );

    final scrollable = find.descendant(
      of: find.byType(CustomScrollView).first,
      matching: find.byType(Scrollable),
    );
    for (final demoCase in messageDemoCases) {
      final button = find.widgetWithText(TButton, demoCase.triggerText);
      await tester.scrollUntilVisible(
        button,
        200,
        scrollable: scrollable.first,
      );
      expect(tester.getSize(button), const Size(343, 48));
    }

    await disposeDemoPage(tester);
  });

  testWidgets('函数式调用不改变 Demo 页面布局', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      messageDemoPageTestSpec,
      ThemeMode.light,
    );

    final previousButton = find.widgetWithText(TButton, '带按钮的通知');
    final functionButton = find.widgetWithText(TButton, '函数式调用');
    final functionLabel = find.byKey(
      const ValueKey('message-type-label-函数式调用'),
    );
    final scrollable = find.descendant(
      of: find.byType(CustomScrollView).first,
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      functionButton,
      200,
      scrollable: scrollable.first,
    );
    final overflow = tester.getRect(functionButton).bottom - 780;
    if (overflow > 0) {
      await tester.drag(scrollable.first, Offset(0, -overflow - 16));
      await tester.pumpAndSettle();
    }

    expect(
      tester.getRect(functionLabel).top - tester.getRect(previousButton).bottom,
      24,
    );
    expect(
      tester.getRect(functionButton).top - tester.getRect(functionLabel).bottom,
      16,
    );

    final buttonRect = tester.getRect(functionButton);
    await tester.tap(functionButton);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(TMessage), findsOneWidget);
    expect(find.widgetWithText(TButton, '函数式调用'), findsOneWidget);
    expect(tester.getRect(functionButton), buttonRect);
    expect(
      tester.getRect(functionLabel).top - tester.getRect(previousButton).bottom,
      24,
    );
    expect(
      tester.getRect(functionButton).top - tester.getRect(functionLabel).bottom,
      16,
    );

    await disposeDemoPage(tester);
  });

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
    testWidgets('${demoCase.triggerText}的操作可点击且不改变消息', (tester) async {
      await pumpDemoPageAtPhoneViewport(
        tester,
        messageDemoPageTestSpec,
        ThemeMode.light,
      );
      await _openMessage(tester, demoCase);
      await tester.tap(find.text(demoCase.actionText!));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text(demoCase.visibleText), findsOneWidget);

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
