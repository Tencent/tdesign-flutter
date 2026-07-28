import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/calendar/t_calendar_cell.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: TThemeBuilder.light(TThemeData.defaultData()),
      home: Scaffold(body: SizedBox(width: 320, child: child)),
    );
  }

  testWidgets('selection notifier rebuilds the cell and range bridge',
      (tester) async {
    final startNotifier = DateSelectTypeNotifier(DateSelectType.start);
    final endNotifier = DateSelectTypeNotifier(DateSelectType.end);
    final start = TCalendarCellModel(
      date: DateTime(2024, 1, 1),
      typeNotifier: startNotifier,
      isLastDayOfMonth: false,
    );
    final end = TCalendarCellModel(
      date: DateTime(2024, 1, 2),
      typeNotifier: endNotifier,
      isLastDayOfMonth: false,
    );
    await tester.pumpWidget(wrap(TCalendarCell(
      cell: start,
      height: 48,
      padding: 4,
      rowIndex: 0,
      colIndex: 0,
      dateList: [start, end],
    )));
    expect(find.text('1'), findsOneWidget);

    startNotifier.setType(DateSelectType.centre);
    await tester.pump();
    await tester.pump();
    expect(start.selectType, DateSelectType.centre);
  });

  testWidgets('selected cell uses token color, radius, size, and text style',
      (tester) async {
    final token = TThemeData.defaultData();
    final selected = TCalendarCellModel(
      date: DateTime(2024, 1, 8),
      typeNotifier: DateSelectTypeNotifier(DateSelectType.selected),
      isLastDayOfMonth: false,
    );

    await tester.pumpWidget(wrap(TCalendarCell(
      cell: selected,
      height: 48,
      padding: 4,
      rowIndex: 0,
      colIndex: 0,
      dateList: [selected],
    )));

    expect(tester.getSize(_cellBackgroundFinder()), const Size(320, 48));
    final decoration = tester
        .widget<Container>(_cellBackgroundFinder())
        .decoration! as BoxDecoration;
    expect(decoration.color, token.brandNormalColor);
    expect(decoration.borderRadius, BorderRadius.circular(token.radiusDefault));

    final dayText = tester.widget<TText>(_calendarTextFinder('8'));
    expect(dayText.style?.color, token.textColorAnti);
    expect(dayText.style?.fontSize, token.fontTitleMedium?.size);
    expect(dayText.style?.height, token.fontTitleMedium?.height);
    expect(dayText.style?.fontWeight, token.fontTitleMedium?.fontWeight);
  });

  testWidgets('range bridge uses token light color and preserves cell height',
      (tester) async {
    final token = TThemeData.defaultData();
    final start = TCalendarCellModel(
      date: DateTime(2024, 1, 1),
      typeNotifier: DateSelectTypeNotifier(DateSelectType.start),
      isLastDayOfMonth: false,
    );
    final centre = TCalendarCellModel(
      date: DateTime(2024, 1, 2),
      typeNotifier: DateSelectTypeNotifier(DateSelectType.centre),
      isLastDayOfMonth: false,
    );

    await tester.pumpWidget(wrap(TCalendarCell(
      cell: start,
      height: 48,
      padding: 4,
      rowIndex: 0,
      colIndex: 0,
      dateList: [start, centre],
    )));

    final bridge = tester.widget<Container>(_rangeBridgeFinder());
    expect(bridge.color, token.brandLightColor);
    expect(tester.getSize(_rangeBridgeFinder()), const Size(4, 48));
  });
}

Finder _calendarTextFinder(String data) {
  return find.byWidgetPredicate(
    (widget) => widget is TText && widget.data == data,
  );
}

Finder _cellBackgroundFinder() {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Container &&
        widget.decoration is BoxDecoration &&
        widget.constraints?.minHeight == 48 &&
        widget.constraints?.maxHeight == 48,
  );
}

Finder _rangeBridgeFinder() {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Container &&
        widget.color != null &&
        widget.constraints?.minWidth == 4 &&
        widget.constraints?.maxWidth == 4 &&
        widget.constraints?.minHeight == 48 &&
        widget.constraints?.maxHeight == 48,
  );
}
