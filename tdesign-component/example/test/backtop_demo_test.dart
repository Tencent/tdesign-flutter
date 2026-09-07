import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';

import 'backtop_demo_test_spec.dart';
import 'demo_page_test_utils.dart';

void main() {
  registerDemoStructureTests(backTopDemoPageTestSpec);

  testWidgets('公开 Demo 对齐小程序的形态选择与滚动模式', (tester) async {
    await pumpFullDemoPage(tester, backTopDemoPageTestSpec, ThemeMode.light);

    final page = tester.widget<ExamplePage>(find.byType(ExamplePage));
    expect(page.compactDemo, isTrue);
    expect(page.showTestModule, isFalse);
    expect(
      page.floatingActionButtonAnimator,
      FloatingActionButtonAnimator.noAnimation,
    );
    expect(page.children.map((module) => module.title), ['组件类型']);
    expect(page.children.single.children.map((item) => item.desc), [
      '圆形返回顶部',
      '半圆形返回顶部',
      '',
    ]);

    expect(find.byType(TButton), findsNWidgets(2));
    final backTop = tester.widget<TBackTop>(find.byType(TBackTop));
    expect(backTop.controller, isNotNull);
    expect(backTop.visibilityOffset, 200);
    expect(backTop.shape, TBackTopShape.circle);
    expect(backTop.colorScheme, TBackTopColorScheme.light);
    expect(backTop.showText, isTrue);

    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('选择形态后滚动到内容区并可点击回顶', (tester) async {
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

    await tester.tap(find.byKey(const Key('backtop-demo-half-round-trigger')));
    await tester.pumpAndSettle();
    expect(position.pixels, greaterThanOrEqualTo(200));

    final floating = find.byKey(const Key('backtop-demo-floating'));
    var backTop = tester.widget<TBackTop>(floating);
    expect(backTop.shape, TBackTopShape.halfCircle);
    expect(backTop.colorScheme, TBackTopColorScheme.dark);
    expect(tester.getSize(floating).height, 40);
    expect(
      tester.getTopRight(floating).dx,
      moreOrLessEquals(tester.getSize(find.byType(Scaffold)).width),
    );
    await tester.tap(floating);
    await tester.pumpAndSettle();
    expect(position.pixels, lessThan(1));

    await tester.tap(find.byKey(const Key('backtop-demo-circle-trigger')));
    await tester.pumpAndSettle();
    backTop = tester.widget<TBackTop>(floating);
    expect(backTop.shape, TBackTopShape.circle);
    expect(backTop.colorScheme, TBackTopColorScheme.light);
    expect(tester.getSize(floating), const Size(48, 48));

    await disposeDemoPage(tester);
  }, tags: 'demo');
}
