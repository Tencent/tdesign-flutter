import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'message_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(messageDemoPageTestSpec);

  testWidgets('带关闭通知的操作可点击并展示反馈', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      messageDemoPageTestSpec,
      ThemeMode.light,
    );
    final trigger = find.widgetWithText(TButton, '带关闭的通知');
    final scrollable = find.descendant(
      of: find.byType(CustomScrollView).first,
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(trigger, 200, scrollable: scrollable.first);
    await tester.tap(trigger);
    await tester.pumpAndSettle();

    expect(find.text('这是一条带关闭的消息通知'), findsOneWidget);
    await tester.tap(find.text('按钮'));
    await tester.pumpAndSettle();
    expect(find.text('已点击按钮'), findsOneWidget);

    await disposeDemoPage(tester);
  });
}
