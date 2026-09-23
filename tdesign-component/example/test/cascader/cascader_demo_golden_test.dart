import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../demo_page_test_utils.dart';
import 'cascader_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(cascaderDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('cascader selected result ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, cascaderDemoPageTestSpec, mode);
      await tester.tap(find.byKey(const ValueKey('cascader-vertical-trigger')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('南头街道'));
      await tester.pumpAndSettle();

      expect(find.byType(TCascader), findsNothing);
      expect(find.text('广东 深圳 南山区 南头街道'), findsOneWidget);
      await expectLater(
        find.byKey(const ValueKey('cascader-demo-page')),
        matchesGoldenFile(
          'goldens/cascader_vertical_selected_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    for (final id in [
      'vertical',
      'vertical-locator',
      'horizontal',
      'horizontal-locator',
      'with-title',
      'without-title',
    ]) {
      testWidgets('cascader $id ${mode.name} opened golden', (tester) async {
        await pumpDemoPageAtPhoneViewport(
          tester,
          cascaderDemoPageTestSpec,
          mode,
        );
        final trigger = find.byKey(ValueKey('cascader-$id-trigger'));
        for (var attempt = 0; attempt < 12; attempt++) {
          if (trigger.evaluate().isNotEmpty &&
              tester.getRect(trigger).bottom < 760) {
            break;
          }
          await tester.drag(
            find.byType(CustomScrollView).first,
            const Offset(0, -240),
          );
          await tester.pumpAndSettle();
        }
        expect(trigger, findsOneWidget);
        await tester.tap(trigger);
        await tester.pumpAndSettle();
        expect(find.byType(TCascader), findsOneWidget);
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(Overlay),
          matchesGoldenFile(
            'goldens/cascader_${id}_opened_${mode.name}.png',
          ),
        );
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}
