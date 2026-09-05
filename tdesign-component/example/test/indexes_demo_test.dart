import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'indexes_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(indexesDemoPageTestSpec);

  testWidgets('Indexes Demo follows the official scenario order', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, indexesDemoPageTestSpec, ThemeMode.light);

    final basic = find.byKey(const ValueKey('indexes-basic-trigger'));
    final custom = find.byKey(const ValueKey('indexes-custom-trigger'));
    expect(tester.getTopLeft(basic).dy, lessThan(tester.getTopLeft(custom).dy));
    expect(find.text('胶囊索引'), findsNothing);
    expect(find.text('其他索引类型'), findsNothing);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Indexes basic scenario opens and selects a letter', (
    tester,
  ) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      indexesDemoPageTestSpec,
      ThemeMode.light,
    );

    await tester.tap(find.byKey(const ValueKey('indexes-basic-trigger')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('indexes-basic-panel')), findsOneWidget);
    expect(find.text('北京'), findsOneWidget);
    expect(find.text('白银'), findsOneWidget);

    final list = tester.widget<TIndexesList>(find.byType(TIndexesList));
    expect(list.activeIndex.value, 'B');
    await tester.tap(
      find.descendant(of: find.byType(TIndexesList), matching: find.text('C')),
    );
    await tester.pump();
    expect(list.activeIndex.value, 'C');
    expect(find.text('C'), findsAtLeastNWidgets(2));
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Indexes custom scenario uses number and capsule variants', (
    tester,
  ) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      indexesDemoPageTestSpec,
      ThemeMode.light,
    );

    await tester.tap(find.byKey(const ValueKey('indexes-custom-trigger')));
    await tester.pumpAndSettle();
    final panel = tester.widget<TIndexes>(
      find.byKey(const ValueKey('indexes-custom-panel')),
    );
    expect(panel.indexList, ['1', '3', '5', '7', '8', '10', '#']);
    expect(panel.capsuleTheme, isTrue);
    expect(find.text('列表内容 1'), findsWidgets);
    expect(
      find.descendant(of: find.byType(TIndexesList), matching: find.text('10')),
      findsOneWidget,
    );
    await disposeDemoPage(tester);
  }, tags: 'demo');
}
