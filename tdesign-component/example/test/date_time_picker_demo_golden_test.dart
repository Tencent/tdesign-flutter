import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'date_time_picker_demo_test_spec.dart';
import 'demo_page_test_utils.dart';

void main() {
  registerDemoGoldenTests(dateTimePickerDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final id in [
      'date',
      'month',
      'month-day',
      'second',
      'minute',
      'date-time',
      'week',
      'title',
      'without-title',
    ]) {
      testWidgets('date_time_picker $id ${mode.name} opened golden', (
        tester,
      ) async {
        await pumpDemoPageAtPhoneViewport(
          tester,
          dateTimePickerDemoPageTestSpec,
          mode,
        );
        final trigger = find.byKey(ValueKey('date-time-picker-$id-trigger'));
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
        expect(find.byType(TDateTimePicker), findsWidgets);
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(Overlay),
          matchesGoldenFile(
            'goldens/date_time_picker_${id}_opened_${mode.name}.png',
          ),
        );
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}
