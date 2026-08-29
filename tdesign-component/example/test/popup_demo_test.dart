import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'demo_page_test_utils.dart';
import 'popup_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(popupDemoPageTestSpec);

  testWidgets('Popup Demo exposes the official instance order only', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, popupDemoPageTestSpec, ThemeMode.light);

    const triggerKeys = [
      'popup-top-trigger',
      'popup-left-trigger',
      'popup-center-trigger',
      'popup-bottom-trigger',
      'popup-right-trigger',
      'popup-with-title-trigger',
      'popup-custom-close-trigger',
    ];
    final triggerTops = [
      for (final key in triggerKeys)
        tester.getTopLeft(find.byKey(ValueKey(key))).dy,
    ];
    expect(triggerTops, orderedEquals([...triggerTops]..sort()));
    expect(find.text('嵌套弹窗'), findsNothing);
    expect(find.text('单元测试'), findsNothing);

    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Popup Demo basic bottom uses a plain 240px content panel', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, popupDemoPageTestSpec, ThemeMode.light);

    await tester.tap(find.byKey(const ValueKey('popup-bottom-trigger')));
    await tester.pumpAndSettle();

    expect(find.text('取消'), findsNothing);
    expect(find.text('确定'), findsNothing);
    expect(
      tester.getSize(find.byKey(const ValueKey('popup-bottom-content'))),
      const Size(375, 240),
    );

    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Popup Demo application examples keep the official dimensions', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, popupDemoPageTestSpec, ThemeMode.light);

    await tester.tap(find.byKey(const ValueKey('popup-with-title-trigger')));
    await tester.pumpAndSettle();
    expect(find.text('取消'), findsOneWidget);
    expect(find.text('标题文字'), findsOneWidget);
    expect(find.text('确定'), findsOneWidget);
    expect(find.text('内容区域'), findsNothing);

    await tester.tapAt(const Offset(8, 8));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('popup-custom-close-trigger')));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byKey(const ValueKey('popup-custom-close-content'))),
      const Size(240, 240),
    );
    expect(find.byTooltip('关闭'), findsOneWidget);

    await tester.tap(find.byTooltip('关闭'));
    await tester.pumpAndSettle();
    await disposeDemoPage(tester);
  }, tags: 'demo');
}
