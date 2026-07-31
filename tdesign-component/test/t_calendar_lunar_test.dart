import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  group('TCalendarSubtitleBuilder', () {
    testWidgets('subtitleBuilder 收到当前格日期', (tester) async {
      final seenDates = <DateTime>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TCalendar(
              variant: TCalendarVariant.single,
              minDate: DateTime(2025, 6, 1),
              maxDate: DateTime(2025, 6, 30),
              value: [DateTime(2025, 6, 15)],
              onChanged: (_) {},
              subtitleBuilder: (context, ctx) {
                seenDates.add(ctx.date);
                return TText('副-${ctx.date.day}');
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(seenDates, isNotEmpty);
      expect(seenDates.every((d) => d.year == 2025 && d.month == 6), isTrue);
      expect(find.textContaining('副-'), findsWidgets);
    });
  });

  group('TCalendarCellModel', () {
    test('selectType 随 typeNotifier 更新', () {
      final cell = TCalendarCellModel(
        date: DateTime(2025, 6, 15),
        typeNotifier: DateSelectTypeNotifier(DateSelectType.empty),
        isLastDayOfMonth: false,
      );

      expect(cell.selectType, DateSelectType.empty);
      cell.typeNotifier.setType(DateSelectType.selected);
      expect(cell.selectType, DateSelectType.selected);
    });
  });
}
