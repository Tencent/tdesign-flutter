import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  const rows = [
    _Row('Alice', 30),
    _Row('Bob', 20),
    _Row('Carol', 40),
  ];

  List<TTableColumn<_Row>> columns() => [
        TTableColumn<_Row>(
          id: 'name',
          header: const Text('Name'),
          cellBuilder: (_, row, __) => Text(row.name),
          comparator: (a, b) => a.name.compareTo(b.name),
        ),
        TTableColumn<_Row>(
          id: 'age',
          header: const Text('Age'),
          cellBuilder: (_, row, __) => Text('${row.age}'),
          comparator: (a, b) => a.age.compareTo(b.age),
          align: TTableColumnAlign.right,
        ),
      ];

  Widget app(
    Widget child, {
    TTableThemeData? tableTheme,
    ThemeData? materialTheme,
  }) {
    var theme = materialTheme ?? TThemeBuilder.light(TThemeData.defaultData());
    if (tableTheme != null) {
      theme = theme.mergeExtension(tableTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: SizedBox(width: 360, child: child)),
    );
  }

  group('TTable rendering', () {
    testWidgets('渲染表头和强类型单元格', (tester) async {
      await tester.pumpWidget(app(TTable(columns: columns(), data: rows)));
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('40'), findsOneWidget);
    });

    testWidgets('showHeader=false 隐藏表头', (tester) async {
      await tester.pumpWidget(app(TTable(
        columns: columns(),
        data: rows,
        showHeader: false,
      )));
      expect(find.text('Name'), findsNothing);
      expect(find.text('Alice'), findsOneWidget);
    });

    testWidgets('loading 优先于数据并支持自定义 Widget', (tester) async {
      await tester.pumpWidget(app(TTable(
        columns: columns(),
        data: rows,
        loading: true,
        loadingWidget: const Text('Loading'),
      )));
      expect(find.text('Loading'), findsOneWidget);
      expect(find.text('Alice'), findsNothing);
    });

    testWidgets('loading 默认显示 CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(app(TTable(
        columns: columns(),
        data: rows,
        loading: true,
      )));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('空数据使用 empty 槽位', (tester) async {
      await tester.pumpWidget(app(TTable<_Row>(
        columns: columns(),
        data: const [],
        empty: const Text('Empty'),
      )));
      expect(find.text('Empty'), findsOneWidget);
    });

    testWidgets('空数据无 empty 时保持空白', (tester) async {
      await tester.pumpWidget(app(TTable<_Row>(
        columns: columns(),
        data: const [],
      )));
      expect(find.byType(TTable<_Row>), findsOneWidget);
    });

    testWidgets('footer 渲染在表格底部', (tester) async {
      await tester.pumpWidget(app(TTable(
        columns: columns(),
        data: rows,
        footer: const Text('Footer'),
      )));
      expect(find.text('Footer'), findsOneWidget);
    });

    testWidgets('左中右固定列按分区渲染', (tester) async {
      final fixedColumns = [
        TTableColumn<_Row>(
          id: 'left',
          header: const Text('Left'),
          fixed: TTableColumnFixed.left,
          width: 60,
          cellBuilder: (_, row, __) => Text('L-${row.name}'),
        ),
        TTableColumn<_Row>(
          id: 'center',
          header: const Text('Center'),
          width: 200,
          cellBuilder: (_, row, __) => Text('C-${row.name}'),
        ),
        TTableColumn<_Row>(
          id: 'right',
          header: const Text('Right'),
          fixed: TTableColumnFixed.right,
          width: 60,
          cellBuilder: (_, row, __) => Text('R-${row.name}'),
        ),
      ];
      await tester.pumpWidget(app(TTable(columns: fixedColumns, data: rows)));
      expect(find.text('Left'), findsOneWidget);
      expect(find.text('Center'), findsOneWidget);
      expect(find.text('Right'), findsOneWidget);
    });

    testWidgets('三种对齐方式进入单元格布局', (tester) async {
      final alignColumns = [
        for (final align in TTableColumnAlign.values)
          TTableColumn<_Row>(
            id: align.name,
            header: Text(align.name),
            align: align,
            cellBuilder: (_, __, ___) => Text('cell-${align.name}'),
          ),
      ];
      await tester.pumpWidget(app(TTable(columns: alignColumns, data: rows)));
      expect(find.text('cell-left'), findsNWidgets(3));
      expect(find.text('cell-center'), findsNWidgets(3));
      expect(find.text('cell-right'), findsNWidgets(3));
    });
  });

  group('controlled sorting', () {
    testWidgets('sort 对副本排序且不修改输入列表', (tester) async {
      final input = List<_Row>.of(rows);
      await tester.pumpWidget(app(TTable(
        columns: columns(),
        data: input,
        sort: const TTableSort(
          columnId: 'age',
          direction: TTableSortDirection.ascending,
        ),
      )));
      final texts = tester
          .widgetList<Text>(find.byType(Text))
          .map((text) => text.data)
          .whereType<String>()
          .toList();
      expect(texts.indexOf('Bob'), lessThan(texts.indexOf('Alice')));
      expect(input, rows);
    });

    testWidgets('降序排序反转比较器', (tester) async {
      await tester.pumpWidget(app(TTable(
        columns: columns(),
        data: rows,
        sort: const TTableSort(
          columnId: 'age',
          direction: TTableSortDirection.descending,
        ),
      )));
      final texts = tester
          .widgetList<Text>(find.byType(Text))
          .map((text) => text.data)
          .whereType<String>()
          .toList();
      expect(texts.indexOf('Carol'), lessThan(texts.indexOf('Alice')));
    });

    testWidgets('点击排序列请求升序和降序', (tester) async {
      TTableSort? requested;
      await tester.pumpWidget(app(TTable(
        columns: columns(),
        data: rows,
        sort: const TTableSort(
          columnId: 'age',
          direction: TTableSortDirection.ascending,
        ),
        onSortChanged: (value) => requested = value,
      )));
      await tester.tap(find.text('Age'));
      expect(requested?.direction, TTableSortDirection.descending);
      await tester.tap(find.text('Name'));
      expect(requested?.columnId, 'name');
      expect(requested?.direction, TTableSortDirection.ascending);
    });

    testWidgets('未知或无 comparator 的 sort 保持原顺序', (tester) async {
      final plainColumns = [
        TTableColumn<_Row>(
          id: 'name',
          header: const Text('Name'),
          cellBuilder: (_, row, __) => Text(row.name),
        ),
      ];
      await tester.pumpWidget(app(TTable(
        columns: plainColumns,
        data: rows,
        sort: const TTableSort(
          columnId: 'unknown',
          direction: TTableSortDirection.ascending,
        ),
      )));
      expect(find.text('Alice'), findsOneWidget);
    });

    test('TTableSort 支持值相等', () {
      const a = TTableSort(
        columnId: 'age',
        direction: TTableSortDirection.ascending,
      );
      const b = TTableSort(
        columnId: 'age',
        direction: TTableSortDirection.ascending,
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(
          a,
          isNot(const TTableSort(
            columnId: 'name',
            direction: TTableSortDirection.ascending,
          )));
    });
  });

  group('controlled selection', () {
    testWidgets('行选择请求新 Set 且不修改输入 Set', (tester) async {
      const selected = <_Row>{};
      Set<_Row>? requested;
      await tester.pumpWidget(app(TTable(
        columns: columns(),
        data: rows,
        selectionMode: TTableSelectionMode.multiple,
        selectedRows: selected,
        onSelectionChanged: (value) => requested = value,
      )));
      await tester.tap(find.byType(Checkbox).at(1));
      expect(requested, contains(rows.first));
      expect(selected, isEmpty);
    });

    testWidgets('已选中行点击后请求移除', (tester) async {
      Set<_Row>? requested;
      await tester.pumpWidget(app(TTable(
        columns: columns(),
        data: rows,
        selectionMode: TTableSelectionMode.multiple,
        selectedRows: {rows.first},
        onSelectionChanged: (value) => requested = value,
      )));
      await tester.tap(find.byType(Checkbox).at(1));
      expect(requested, isNot(contains(rows.first)));
    });

    testWidgets('表头全选只包含可选行', (tester) async {
      Set<_Row>? requested;
      await tester.pumpWidget(app(TTable(
        columns: columns(),
        data: rows,
        selectionMode: TTableSelectionMode.multiple,
        rowSelectable: (_, index) => index != 1,
        onSelectionChanged: (value) => requested = value,
      )));
      await tester.tap(find.byType(Checkbox).first);
      expect(requested, {rows[0], rows[2]});
    });

    testWidgets('部分选中时表头显示 tristate 并可清空', (tester) async {
      Set<_Row>? requested;
      await tester.pumpWidget(app(TTable(
        columns: columns(),
        data: rows,
        selectionMode: TTableSelectionMode.multiple,
        selectedRows: {rows.first},
        onSelectionChanged: (value) => requested = value,
      )));
      final selectAll = tester.widget<Checkbox>(find.byType(Checkbox).first);
      expect(selectAll.value, isNull);
      expect(selectAll.tristate, isTrue);
      await tester.tap(find.byType(Checkbox).first);
      expect(requested, isEmpty);
    });

    testWidgets('不可选行 Checkbox 禁用', (tester) async {
      await tester.pumpWidget(app(TTable(
        columns: columns(),
        data: rows,
        selectionMode: TTableSelectionMode.multiple,
        rowSelectable: (_, index) => index != 0,
        onSelectionChanged: (_) {},
      )));
      expect(tester.widget<Checkbox>(find.byType(Checkbox).at(1)).onChanged,
          isNull);
    });

    testWidgets('空数据时全选 Checkbox 禁用', (tester) async {
      await tester.pumpWidget(app(TTable<_Row>(
        columns: columns(),
        data: const [],
        selectionMode: TTableSelectionMode.multiple,
        onSelectionChanged: (_) {},
      )));
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).onChanged, isNull);
    });

    testWidgets('选择框隔离页面级 CheckboxTheme 样式污染', (tester) async {
      final pollutedTheme =
          TThemeBuilder.light(TThemeData.defaultData()).copyWith(
        checkboxTheme: const CheckboxThemeData(
          fillColor: WidgetStatePropertyAll(Colors.purple),
          checkColor: WidgetStatePropertyAll(Colors.orange),
          shape: CircleBorder(),
          side: BorderSide(color: Colors.red, width: 4),
        ),
      );

      await tester.pumpWidget(app(
        TTable(
          columns: columns(),
          data: rows,
          selectionMode: TTableSelectionMode.multiple,
          onSelectionChanged: (_) {},
        ),
        materialTheme: pollutedTheme,
      ));

      final checkboxTheme =
          tester.widgetList<CheckboxTheme>(find.byType(CheckboxTheme)).first;
      expect(checkboxTheme.data.visualDensity, VisualDensity.compact);
      expect(
        checkboxTheme.data.materialTapTargetSize,
        MaterialTapTargetSize.shrinkWrap,
      );
      expect(checkboxTheme.data.fillColor, isNull);
      expect(checkboxTheme.data.checkColor, isNull);
      expect(checkboxTheme.data.shape, isNull);
      expect(checkboxTheme.data.side, isNull);
    });
  });

  group('callbacks and theme', () {
    testWidgets('点击单元格返回强类型 row 与 column', (tester) async {
      _Row? tappedRow;
      String? tappedColumn;
      await tester.pumpWidget(app(TTable(
        columns: columns(),
        data: rows,
        onCellTap: (_, row, column) {
          tappedRow = row;
          tappedColumn = column.id;
        },
      )));
      await tester.tap(find.text('Alice'));
      expect(tappedRow, rows.first);
      expect(tappedColumn, 'name');
    });

    testWidgets('固定高度产生垂直滚动并通知', (tester) async {
      var notifications = 0;
      await tester.pumpWidget(app(
        TTable(
          columns: columns(),
          data: List.generate(20, (index) => _Row('R$index', index)),
          onScroll: (_) => notifications++,
        ),
        tableTheme: const TTableThemeData(height: 160),
      ));
      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pump();
      expect(notifications, greaterThan(0));
    });

    testWidgets('Theme 控制边框、斑马纹、尺寸和颜色', (tester) async {
      await tester.pumpWidget(app(
        TTable(columns: columns(), data: rows),
        tableTheme: const TTableThemeData(
          bordered: true,
          stripe: true,
          rowHeight: 52,
          headerHeight: 44,
          width: 340,
          backgroundColor: Colors.white,
          headerColor: Colors.red,
          stripeColor: Colors.green,
          borderColor: Colors.blue,
          cellPadding: EdgeInsets.all(4),
        ),
      ));
      expect(find.byType(TTable<_Row>), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('TTableThemeData', () {
    const a = TTableThemeData(
      bordered: true,
      stripe: false,
      rowHeight: 40,
      headerHeight: 44,
      height: 200,
      width: 300,
      backgroundColor: Colors.white,
      headerColor: Colors.red,
      stripeColor: Colors.green,
      borderColor: Colors.black,
      cellPadding: EdgeInsets.all(4),
    );
    const b = TTableThemeData(
      bordered: false,
      stripe: true,
      rowHeight: 60,
      headerHeight: 64,
      height: 400,
      width: 500,
      backgroundColor: Colors.black,
      headerColor: Colors.blue,
      stripeColor: Colors.yellow,
      borderColor: Colors.white,
      cellPadding: EdgeInsets.all(8),
    );

    test('copyWith 覆盖并保留全部字段', () {
      final value = a.copyWith(rowHeight: 48, bordered: false);
      expect(value.bordered, false);
      expect(value.stripe, a.stripe);
      expect(value.rowHeight, 48);
      expect(value.headerHeight, a.headerHeight);
      expect(value.height, a.height);
      expect(value.width, a.width);
      expect(value.backgroundColor, a.backgroundColor);
      expect(value.headerColor, a.headerColor);
      expect(value.stripeColor, a.stripeColor);
      expect(value.borderColor, a.borderColor);
      expect(value.cellPadding, a.cellPadding);
      final all = a.copyWith(
        stripe: true,
        headerHeight: 50,
        height: 250,
        width: 350,
        backgroundColor: Colors.red,
        headerColor: Colors.green,
        stripeColor: Colors.blue,
        borderColor: Colors.yellow,
        cellPadding: const EdgeInsets.all(9),
      );
      expect(all.stripe, true);
      expect(all.headerHeight, 50);
      expect(all.height, 250);
      expect(all.width, 350);
      expect(all.backgroundColor, Colors.red);
      expect(all.headerColor, Colors.green);
      expect(all.stripeColor, Colors.blue);
      expect(all.borderColor, Colors.yellow);
      expect(all.cellPadding, const EdgeInsets.all(9));
    });

    test('lerp 插值全部视觉字段', () {
      final value = a.lerp(b, 0.5);
      expect(value.bordered, false);
      expect(value.stripe, true);
      expect(value.rowHeight, 50);
      expect(value.headerHeight, 54);
      expect(value.height, 300);
      expect(value.width, 400);
      expect(value.backgroundColor, isNotNull);
      expect(value.headerColor, isNotNull);
      expect(value.stripeColor, isNotNull);
      expect(value.borderColor, isNotNull);
      expect(value.cellPadding, const EdgeInsets.all(6));
      expect(a.lerp(null, 0.5), same(a));
    });
  });

  group('contracts', () {
    test('拒绝空列、无效列宽和无回调选择模式', () {
      expect(() => TTable<_Row>(columns: const [], data: rows),
          throwsAssertionError);
      expect(
        () => TTableColumn<_Row>(
          id: 'bad',
          header: const Text('Bad'),
          width: 0,
          cellBuilder: (_, __, ___) => const Text('bad'),
        ),
        throwsAssertionError,
      );
      expect(
        () => TTable(
          columns: columns(),
          data: rows,
          selectionMode: TTableSelectionMode.multiple,
        ),
        throwsAssertionError,
      );
    });
  });
}

class _Row {
  const _Row(this.name, this.age);

  final String name;
  final int age;
}
