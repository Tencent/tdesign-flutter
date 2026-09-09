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

    final letter = find.byKey(const ValueKey('indexes-letter-trigger'));
    final number = find.byKey(const ValueKey('indexes-number-trigger'));
    final capsule = find.byKey(const ValueKey('indexes-capsule-trigger'));
    expect(
      tester.getTopLeft(letter).dy,
      lessThan(tester.getTopLeft(number).dy),
    );
    expect(
      tester.getTopLeft(number).dy,
      lessThan(tester.getTopLeft(capsule).dy),
    );
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

    await tester.tap(find.byKey(const ValueKey('indexes-letter-trigger')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('indexes-letter-panel')), findsOneWidget);
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

  testWidgets('Indexes number scenario uses normal anchors', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      indexesDemoPageTestSpec,
      ThemeMode.light,
    );

    await tester.tap(find.byKey(const ValueKey('indexes-number-trigger')));
    await tester.pumpAndSettle();
    final panel = tester.widget<TIndexes>(
      find.byKey(const ValueKey('indexes-number-panel')),
    );
    expect(panel.indexList, ['1', '3', '5', '7', '8', '10', '#']);
    expect(panel.capsuleTheme, isFalse);
    expect(find.text('列表内容 1'), findsWidgets);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Indexes capsule scenario uses capsule anchors', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      indexesDemoPageTestSpec,
      ThemeMode.light,
    );

    await tester.tap(find.byKey(const ValueKey('indexes-capsule-trigger')));
    await tester.pumpAndSettle();
    final panel = tester.widget<TIndexes>(
      find.byKey(const ValueKey('indexes-capsule-panel')),
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
