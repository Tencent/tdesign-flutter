import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/calendar/t_calendar_cell.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  setUpAll(() async {
    final flutterBin =
        File(Platform.resolvedExecutable).parent.parent.parent.parent.parent;
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    await (FontLoader('Roboto')
          ..addFont(robotoFile.readAsBytes().then(ByteData.sublistView)))
        .load();
  });

  for (final brightness in Brightness.values) {
    testWidgets('Calendar state matrix ${brightness.name}', (tester) async {
      tester.view.physicalSize = const Size(420, 180);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_CalendarStateScene(brightness: brightness));

      await expectLater(
        find.byKey(const Key('calendar-state-scene')),
        matchesGoldenFile(
          'goldens/t_calendar_states_${brightness.name}.png',
        ),
      );
    }, tags: 'golden');
  }
}

class _CalendarStateScene extends StatelessWidget {
  const _CalendarStateScene({required this.brightness});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final token = TThemeData.defaultData();
    final baseTheme = brightness == Brightness.light
        ? TThemeBuilder.light(token)
        : TThemeBuilder.dark(token);
    final theme = baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(fontFamily: 'Roboto'),
      primaryTextTheme: baseTheme.primaryTextTheme.apply(fontFamily: 'Roboto'),
    );

    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Center(
          child: RepaintBoundary(
            key: const Key('calendar-state-scene'),
            child: ColoredBox(
              color: theme.colorScheme.surface,
              child: const SizedBox(
                width: 380,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _CellRow(
                        types: [
                          DateSelectType.empty,
                          DateSelectType.selected,
                          DateSelectType.disabled,
                        ],
                        days: [8, 9, 10],
                      ),
                      SizedBox(height: 12),
                      _CellRow(
                        types: [
                          DateSelectType.start,
                          DateSelectType.centre,
                          DateSelectType.end,
                        ],
                        days: [16, 17, 18],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CellRow extends StatelessWidget {
  const _CellRow({
    required this.types,
    required this.days,
  });

  final List<DateSelectType> types;
  final List<int> days;

  @override
  Widget build(BuildContext context) {
    final cells = List.generate(
      types.length,
      (index) => TCalendarCellModel(
        date: DateTime(2026, 6, days[index]),
        typeNotifier: DateSelectTypeNotifier(types[index]),
        isLastDayOfMonth: false,
      ),
    );
    return Row(
      children: List.generate(
        cells.length,
        (index) => Expanded(
          child: TCalendarCell(
            cell: cells[index],
            height: 56,
            padding: 4,
            rowIndex: 0,
            colIndex: index,
            dateList: cells,
          ),
        ),
      ),
    );
  }
}
