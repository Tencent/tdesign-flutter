import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'calendar_demo_test_spec.dart';
import 'demo_page_test_utils.dart';

void main() {
  configureCalendarDemoResources();
  registerDemoGoldenTests(calendarDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final id in [
      'single',
      'multiple',
      'single-description',
      'double-description',
      'switch',
      'range',
      'localized',
      'limited',
    ]) {
      testWidgets('calendar $id ${mode.name} opened golden', (tester) async {
        await pumpDemoPageAtPhoneViewport(
          tester,
          calendarDemoPageTestSpec,
          mode,
        );
        final trigger = find.byKey(ValueKey('calendar-$id-trigger'));
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
        expect(find.byType(TCalendar), findsWidgets);
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(Overlay),
          matchesGoldenFile('goldens/calendar_${id}_opened_${mode.name}.png'),
        );
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}
