import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/calendar/t_calendar_header.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  setUpAll(() async {
    final flutterBin = File(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;
    await (FontLoader('Roboto')..addFont(
          File(
            '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load();
  });
  testWidgets('equal-length weekday labels fit their actual shared row', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: [
            TThemeData.defaultData(),
            const TTextThemeData(textStyle: TextStyle(fontFamily: 'Roboto')),
          ],
        ),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: 375,
                child: TCalendar(
                  weekdayNames: const [
                    'iii',
                    'WWW',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                  ],
                  minDate: DateTime(2026, 10, 1),
                  maxDate: DateTime(2026, 10, 31),
                  value: [DateTime(2026, 10, 1)],
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final header = tester.getRect(find.byType(TCalendarHeader));
    for (final label in ['iii', 'WWW', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']) {
      final text = tester.getRect(find.text(label));
      expect(text.top, greaterThanOrEqualTo(header.top - .01));
      expect(text.bottom, lessThanOrEqualTo(header.bottom + .01));
      expect(text.center.dy, closeTo(header.center.dy, .01));
    }
    expect(tester.takeException(), isNull);
  });
  testWidgets('explicit calendar sizes and custom month theme remain', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.purple),
          ),
          extensions: [
            TThemeData.defaultData(),
            const TCalendarThemeData(
              height: 360,
              cellHeight: 38,
              monthTitleHeight: 18,
            ),
          ],
        ),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 375,
              child: TCalendar(
                minDate: DateTime(2026, 10, 1),
                maxDate: DateTime(2026, 10, 31),
                value: const [],
                monthTitleBuilder: (context, date) => Text(
                  'custom month',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(TCalendar)).height, 360);
    expect(
      tester.widget<Text>(find.text('custom month')).style!.color,
      Colors.purple,
    );
    expect(tester.getSize(find.text('custom month')).height, 18);
    expect(tester.takeException(), isNull);
  });
}
