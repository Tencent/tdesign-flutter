import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'picker_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(pickerDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('picker linked changes ${mode.name} golden', (tester) async {
      await pumpDemoPageAtPhoneViewport(tester, pickerDemoPageTestSpec, mode);
      final trigger = find.byKey(const ValueKey('picker-area-trigger'));
      await tester.ensureVisible(trigger);
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      final panel = find.byKey(const ValueKey('picker-area-panel'));
      const expected = [
        ['beijing', 'beijing', 'dongcheng'],
        ['guangdong', 'dongguan', 'dongcheng'],
        ['guangdong', 'shenzhen', 'nanshan'],
      ];
      for (final column in [2, 1, 0]) {
        await tester.drag(
          find.byType(ListWheelScrollView).at(column),
          const Offset(0, 40),
        );
        await tester.pumpAndSettle();
        expect(tester.widget<TPicker>(panel).value, expected[column]);
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(Overlay),
          matchesGoldenFile(
            'goldens/picker_area_changed_column_${column}_${mode.name}.png',
          ),
        );
      }
      await disposeDemoPage(tester);
    }, tags: 'golden');
    for (final id in ['city', 'time', 'area', 'title', 'without-title']) {
      testWidgets('picker $id ${mode.name} opened golden', (tester) async {
        await pumpDemoPageAtPhoneViewport(tester, pickerDemoPageTestSpec, mode);
        final trigger = find.byKey(ValueKey('picker-$id-trigger'));
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
        expect(find.byType(TPicker), findsWidgets);
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(Overlay),
          matchesGoldenFile('goldens/picker_${id}_opened_${mode.name}.png'),
        );
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}
