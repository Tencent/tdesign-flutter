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

  testWidgets('日期居中，副标题独立定位且继承选中颜色', (tester) async {
    final model = TCalendarCellModel(
      date: DateTime(2022, 2, 18),
      selectType: DateSelectType.selected,
      isLastDayOfMonth: false,
    );
    Widget cell({TCalendarSubtitleBuilder? subtitle}) => wrap(
      TCalendarCell(
        cell: model,
        height: 60,
        padding: 4,
        rowIndex: 0,
        colIndex: 0,
        dateList: [model],
        subtitleBuilder: subtitle,
      ),
    );
    await tester.pumpWidget(cell());
    final before = tester.getCenter(find.text('18'));
    await tester.pumpWidget(cell(subtitle: (_, __) => const Text('¥60')));
    expect(tester.getCenter(find.text('18')), before);
    expect(
      tester.getCenter(find.text('¥60')).dy,
      greaterThan(tester.getCenter(find.text('18')).dy),
    );
    final style = DefaultTextStyle.of(tester.element(find.text('¥60'))).style;
    expect(style.color, TThemeData.defaultData().textColorAnti);
  });

  testWidgets('更新日期格快照后重建内容和区间连接，旧快照保持不变', (tester) async {
    final start = TCalendarCellModel(
      date: DateTime(2024, 1, 1),
      selectType: DateSelectType.start,
      isLastDayOfMonth: false,
    );
    final end = TCalendarCellModel(
      date: DateTime(2024, 1, 2),
      selectType: DateSelectType.end,
      isLastDayOfMonth: false,
    );
    Widget build(TCalendarCellModel cell) => wrap(
      TCalendarCell(
        cell: cell,
        height: 48,
        padding: 4,
        rowIndex: 0,
        colIndex: 0,
        dateList: [cell, end],
        cellBuilder: (_, snapshot) => Text(snapshot.selectType.name),
      ),
    );
    await tester.pumpWidget(build(start));
    expect(find.text('start'), findsOneWidget);
    final centre = TCalendarCellModel(
      date: start.date,
      selectType: DateSelectType.centre,
      isLastDayOfMonth: false,
    );
    await tester.pumpWidget(build(centre));
    expect(find.text('centre'), findsOneWidget);
    expect(start.selectType, DateSelectType.start);
    expect(
      tester.widget<Container>(_rangeBridgeFinder()).color,
      TThemeData.defaultData().brandLightColor,
    );
  });

  testWidgets('selected cell uses token color, radius, size, and text style',
      (tester) async {
    final token = TThemeData.defaultData();
    final selected = TCalendarCellModel(
      date: DateTime(2024, 1, 8),
      selectType: DateSelectType.selected,
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

  testWidgets('selected today keeps selected contrast instead of today color',
      (tester) async {
    final token = TThemeData.defaultData();
    final now = DateTime.now();
    final today = TCalendarCellModel(
      date: DateTime(now.year, now.month, now.day),
      selectType: DateSelectType.selected,
      isLastDayOfMonth: false,
    );

    await tester.pumpWidget(wrap(TCalendarCell(
      cell: today,
      height: 48,
      padding: 4,
      rowIndex: 0,
      colIndex: 0,
      dateList: [today],
    )));

    final dayText =
        tester.widget<TText>(_calendarTextFinder(today.date.day.toString()));
    expect(dayText.style?.color, token.textColorAnti);
    expect(dayText.style?.color, isNot(token.brandNormalColor));
  });

  testWidgets('component cell styles reach selected content and decoration',
      (tester) async {
    final token = TThemeData.defaultData();
    final selected = TCalendarCellModel(
      date: DateTime(2024, 1, 8),
      selectType: DateSelectType.selected,
      isLastDayOfMonth: false,
    );

    await tester.pumpWidget(wrap(TCalendarCell(
      cell: selected,
      height: 48,
      padding: 4,
      rowIndex: 0,
      colIndex: 0,
      dateList: [selected],
      dayStyle: const TextStyle(
        fontFamily: 'custom',
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: Colors.red,
      ),
      cellDecoration: const BoxDecoration(color: Colors.orange),
    )));

    final dayText = tester.widget<TText>(_calendarTextFinder('8'));
    expect(dayText.style?.fontFamily, 'custom');
    expect(dayText.style?.fontSize, 19);
    expect(dayText.style?.fontWeight, FontWeight.w700);
    expect(dayText.style?.color, token.textColorAnti);

    final decoration = tester
        .widget<Container>(_cellBackgroundFinder())
        .decoration! as BoxDecoration;
    expect(decoration.color, Colors.orange);
    expect(decoration.borderRadius, BorderRadius.circular(token.radiusDefault));
  });

  testWidgets('subtitle inherits the resolved state subtitle style',
      (tester) async {
    final selected = TCalendarCellModel(
      date: DateTime(2024, 1, 8),
      selectType: DateSelectType.selected,
      isLastDayOfMonth: false,
    );

    await tester.pumpWidget(wrap(TCalendarCell(
      cell: selected,
      height: 48,
      padding: 4,
      rowIndex: 0,
      colIndex: 0,
      dateList: [selected],
      subtitleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      subtitleBuilder: (context, value) => const Text('subtitle'),
    )));

    final inherited = tester.widget<DefaultTextStyle>(
      find
          .ancestor(
            of: find.text('subtitle'),
            matching: find.byType(DefaultTextStyle),
          )
          .first,
    );
    expect(inherited.style.fontSize, 11);
    expect(inherited.style.fontWeight, FontWeight.w600);
    expect(inherited.style.color, TThemeData.defaultData().textColorAnti);
  });

  testWidgets('range bridge uses token light color and preserves cell height',
      (tester) async {
    final token = TThemeData.defaultData();
    final start = TCalendarCellModel(
      date: DateTime(2024, 1, 1),
      selectType: DateSelectType.start,
      isLastDayOfMonth: false,
    );
    final centre = TCalendarCellModel(
      date: DateTime(2024, 1, 2),
      selectType: DateSelectType.centre,
      isLastDayOfMonth: false,
    );

    await tester.pumpWidget(wrap(TCalendarCell(
      cell: start,
      height: 48,
      padding: 4,
      rowIndex: 0,
      colIndex: 0,
      dateList: [start, centre],
      centreColor: Colors.green,
    )));

    final bridge = tester.widget<Container>(_rangeBridgeFinder());
    expect(bridge.color, Colors.green);
    expect(bridge.color, isNot(token.brandLightColor));
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
