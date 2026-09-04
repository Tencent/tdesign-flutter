import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';

import 'backtop_demo_test_spec.dart';
import 'demo_page_test_utils.dart';

void main() {
  registerDemoStructureTests(backTopDemoPageTestSpec);

  testWidgets('公开 Demo 覆盖 Figma 的 8 个设计状态', (tester) async {
    await pumpFullDemoPage(tester, backTopDemoPageTestSpec, ThemeMode.light);

    final page = tester.widget<ExamplePage>(find.byType(ExamplePage));
    expect(page.compactDemo, isTrue);
    expect(page.showTestModule, isFalse);
    expect(page.children.map((module) => module.title), ['组件类型']);
    expect(page.children.single.children.map((item) => item.desc), [
      '圆形返回顶部',
      '半圆形返回顶部',
    ]);

    final backTops = tester
        .widgetList<TBackTop>(find.byType(TBackTop))
        .toList();
    expect(backTops, hasLength(9));
    final previews = backTops.take(8).toList();
    expect(previews.map((item) => item.shape), [
      TBackTopShape.circle,
      TBackTopShape.circle,
      TBackTopShape.circle,
      TBackTopShape.circle,
      TBackTopShape.halfCircle,
      TBackTopShape.halfCircle,
      TBackTopShape.halfCircle,
      TBackTopShape.halfCircle,
    ]);
    expect(previews.map((item) => item.colorScheme), [
      TBackTopColorScheme.light,
      TBackTopColorScheme.dark,
      TBackTopColorScheme.light,
      TBackTopColorScheme.dark,
      TBackTopColorScheme.light,
      TBackTopColorScheme.dark,
      TBackTopColorScheme.light,
      TBackTopColorScheme.dark,
    ]);
    expect(previews.map((item) => item.showText), [
      false,
      false,
      true,
      true,
      false,
      false,
      true,
      true,
    ]);
    expect(backTops.last.controller, isNotNull);
    expect(backTops.last.visibilityOffset, 200);

    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('滚动超过阈值后点击悬浮实例回到顶部', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      backTopDemoPageTestSpec,
      ThemeMode.light,
    );

    final customScrollView = find.byType(CustomScrollView);
    final scrollable = find.descendant(
      of: customScrollView,
      matching: find.byType(Scrollable),
    );
    final position = tester.state<ScrollableState>(scrollable.first).position;
    expect(position.maxScrollExtent, greaterThan(200));

    await tester.drag(customScrollView, const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(position.pixels, greaterThanOrEqualTo(200));

    final floating = find.byType(TBackTop).last;
    expect(tester.getSize(floating), const Size(48, 48));
    await tester.tap(floating);
    await tester.pumpAndSettle();
    expect(position.pixels, lessThan(1));

    await disposeDemoPage(tester);
  }, tags: 'demo');
}
