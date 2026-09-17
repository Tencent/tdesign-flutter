import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  setUpAll(() async {
    final flutterBin = File(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    final robotoFont = FontLoader('Roboto')
      ..addFont(robotoFile.readAsBytes().then(ByteData.sublistView));
    await robotoFont.load();
  });

  for (final brightness in Brightness.values) {
    testWidgets('TTable API states ${brightness.name}', (tester) async {
      tester.view.physicalSize = const Size(420, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_TableApiScene(brightness: brightness));
      await tester.pumpAndSettle();

      await expectLater(
        find.byKey(const Key('table-api-scene')),
        matchesGoldenFile('goldens/t_table_api_${brightness.name}.png'),
      );
    }, tags: 'golden');
  }
}

class _TableApiScene extends StatelessWidget {
  const _TableApiScene({required this.brightness});

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
            key: const Key('table-api-scene'),
            child: ColoredBox(
              color: theme.colorScheme.surface,
              child: const SizedBox(
                width: 388,
                height: 688,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionTitle('Merged cells'),
                      _MergedTable(),
                      SizedBox(height: 20),
                      _SectionTitle('Fixed columns and minWidth'),
                      _OverflowTable(),
                      SizedBox(height: 20),
                      _SectionTitle('Fixed height and footer'),
                      _HeightTable(),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _MergedTable extends StatelessWidget {
  const _MergedTable();

  @override
  Widget build(BuildContext context) {
    final columns = List.generate(
      3,
      (columnIndex) => TTableColumn<_GoldenRow>(
        id: 'merged-$columnIndex',
        header: Text('Column ${columnIndex + 1}'),
        cellBuilder: (_, row, __) => Text(row.values[columnIndex]),
      ),
    );
    return TTable<_GoldenRow>(
      columns: columns,
      data: const [
        _GoldenRow(['2 x 2', 'covered', 'A3']),
        _GoldenRow(['covered', 'covered', 'B3']),
      ],
      bordered: true,
      cellSpanBuilder: (cell) => cell.rowIndex == 0 && cell.columnIndex == 0
          ? const TTableCellSpan(rowSpan: 2, columnSpan: 2)
          : null,
    );
  }
}

class _OverflowTable extends StatelessWidget {
  const _OverflowTable();

  @override
  Widget build(BuildContext context) {
    return TTable<_GoldenRow>(
      columns: [
        TTableColumn<_GoldenRow>(
          id: 'left',
          header: const Text('ID'),
          width: 56,
          fixed: TTableColumnFixed.left,
          cellBuilder: (_, row, __) => Text(row.values[0]),
        ),
        TTableColumn<_GoldenRow>(
          id: 'name',
          header: const Text('Name'),
          minWidth: 160,
          cellBuilder: (_, row, __) => Text(row.values[1]),
        ),
        TTableColumn<_GoldenRow>(
          id: 'detail',
          header: const Text('Detail'),
          minWidth: 160,
          cellBuilder: (_, row, __) => Text(row.values[2]),
        ),
        TTableColumn<_GoldenRow>(
          id: 'right',
          header: const Text('State'),
          width: 72,
          fixed: TTableColumnFixed.right,
          cellBuilder: (_, row, __) => Text(row.values[3]),
        ),
      ],
      data: const [
        _GoldenRow(['01', 'Alice', 'Long detail', 'Active']),
        _GoldenRow(['02', 'Bob', 'More detail', 'Paused']),
      ],
      bordered: true,
      stripe: true,
    );
  }
}

class _HeightTable extends StatelessWidget {
  const _HeightTable();

  @override
  Widget build(BuildContext context) {
    return TTable<_GoldenRow>(
      columns: [
        TTableColumn<_GoldenRow>(
          id: 'item',
          header: const Text('Item'),
          cellBuilder: (_, row, __) => Text(row.values[0]),
        ),
        TTableColumn<_GoldenRow>(
          id: 'value',
          header: const Text('Value'),
          align: TTableColumnAlign.right,
          cellBuilder: (_, row, __) => Text(row.values[1]),
        ),
      ],
      data: const [
        _GoldenRow(['First', '100']),
        _GoldenRow(['Second', '200']),
        _GoldenRow(['Third', '300']),
        _GoldenRow(['Fourth', '400']),
      ],
      height: 170,
      bordered: true,
      footer: const SizedBox(height: 28, child: Center(child: Text('4 rows'))),
    );
  }
}

class _GoldenRow {
  const _GoldenRow(this.values);

  final List<String> values;
}
