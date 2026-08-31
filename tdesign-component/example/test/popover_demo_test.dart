import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'popover_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(popoverDemoPageTestSpec);

  testWidgets('Popover 公开 Demo 的 21 个触发按钮均使用 large 尺寸', (tester) async {
    await pumpFullDemoPage(tester, popoverDemoPageTestSpec, ThemeMode.light);

    final buttons = tester.widgetList<TButton>(find.byType(TButton)).toList();
    expect(buttons, hasLength(21));
    expect(buttons.every((button) => button.size == TButtonSize.large), isTrue);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Popover 左右侧 6 个触发按钮使用官方 446rpx 宽度', (tester) async {
    await pumpFullDemoPage(tester, popoverDemoPageTestSpec, ThemeMode.light);

    for (final label in ['右侧上', '右侧中', '右侧下', '左侧上', '左侧中', '左侧下']) {
      final button = find.widgetWithText(TButton, label);
      expect(button, findsOneWidget);
      expect(tester.getSize(button).width, 223);
    }
    await disposeDemoPage(tester);
  }, tags: 'demo');
}
