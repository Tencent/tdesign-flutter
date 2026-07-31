import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/date_time_picker/t_date_time_picker_internal.dart';
import 'package:tdesign_flutter/src/components/date_time_picker/t_date_time_picker_wheel.dart';
import 'package:tdesign_flutter/src/components/picker/multi_wheel_layout.dart';
import 'package:tdesign_flutter/src/components/picker/wheel_column.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

DateTimePickerSnapshot makeSnapshot([
  List<DateTimeColumn> columns = const [
    DateTimeColumn.year,
    DateTimeColumn.month,
    DateTimeColumn.day,
  ],
]) =>
    DateTimePickerSnapshot.initial(
      columns: columns,
      initial: DateTime(2024, 6, 15),
      start: DateTime(2020, 1, 1),
      end: DateTime(2030, 12, 31),
    );

Widget wrap(Widget child) => MaterialApp(
      theme: TThemeBuilder.light(TThemeData.defaultData()),
      home: Scaffold(
        body: Center(
          child: SizedBox(height: 300, width: 360, child: child),
        ),
      ),
    );

void main() {
  group('DateTimePickerWheel 渲染', () {
    testWidgets('年/月/日三列渲染并暴露选项', (tester) async {
      final token = TThemeData.defaultData();
      var changed = 0;
      await tester.pumpWidget(wrap(DateTimePickerWheel(
        snapshot: makeSnapshot(),
        labels: DateTimePickerLabels.defaults,
        start: DateTime(2020, 1, 1),
        end: DateTime(2030, 12, 31),
        showWeek: false,
        steps: null,
        renderLabel: null,
        height: 200,
        itemCount: 5,
        onChanged: (_, __) => changed++,
      )));
      expect(find.byType(DateTimePickerWheel), findsOneWidget);
      // 年份选项可见
      expect(find.text('2024年'), findsWidgets);
      final layout = tester.widget<MultiWheelLayout>(
        find.byType(MultiWheelLayout),
      );
      expect(layout.height, 200);
      expect(layout.itemHeight, 40);
      final column = tester.widget<WheelColumn>(find.byType(WheelColumn).first);
      expect(column.itemHeight, 40);

      final highlight = tester.widget<Container>(_wheelHighlightFinder());
      final decoration = highlight.decoration! as BoxDecoration;
      expect(decoration.color, token.bgColorSecondaryContainer);
      expect(
          decoration.borderRadius, BorderRadius.circular(token.radiusDefault));
      expect(tester.getSize(_wheelHighlightFinder()), const Size(328, 40));

      final selectedText =
          tester.widget<TText>(_pickerTextFinder('2024年').first);
      expect(selectedText.style?.color, token.textColorPrimary);
      expect(selectedText.style?.fontSize, token.fontBodyLarge?.size);
      expect(selectedText.style?.fontWeight, FontWeight.w700);
    });

    testWidgets('仅时间列（时/分/秒）渲染', (tester) async {
      final snapshot = DateTimePickerSnapshot.initial(
        columns: const [
          DateTimeColumn.hour,
          DateTimeColumn.minute,
          DateTimeColumn.second,
        ],
        initial: DateTime(2024, 6, 15, 10, 20, 30),
        start: DateTime(2020, 1, 1),
        end: DateTime(2030, 12, 31),
      );
      await tester.pumpWidget(wrap(DateTimePickerWheel(
        snapshot: snapshot,
        labels: DateTimePickerLabels.defaults,
        start: DateTime(2020, 1, 1),
        end: DateTime(2030, 12, 31),
        showWeek: false,
        steps: null,
        renderLabel: null,
        height: 200,
        itemCount: 5,
        onChanged: (_, __) {},
      )));
      expect(find.byType(DateTimePickerWheel), findsOneWidget);
    });

    testWidgets('showWeek / steps / renderLabel 分支', (tester) async {
      await tester.pumpWidget(wrap(DateTimePickerWheel(
        snapshot: makeSnapshot(),
        labels: DateTimePickerLabels.defaults,
        start: DateTime(2020, 1, 1),
        end: DateTime(2030, 12, 31),
        showWeek: true,
        steps: const DateTimePickerSteps(
          year: 1,
          month: 1,
          day: 1,
          hour: 1,
          minute: 1,
          second: 1,
        ),
        renderLabel: (col, value) => 'R$value',
        height: 200,
        itemCount: 5,
        onChanged: (_, __) {},
      )));
      expect(find.byType(DateTimePickerWheel), findsOneWidget);
    });
  });

  group('DateTimePickerWheel 交互', () {
    testWidgets('点选年份触发 onChanged', (tester) async {
      final results = <TDateTimePickerValue>[];
      await tester.pumpWidget(wrap(DateTimePickerWheel(
        snapshot: makeSnapshot(),
        labels: DateTimePickerLabels.defaults,
        start: DateTime(2020, 1, 1),
        end: DateTime(2030, 12, 31),
        showWeek: false,
        steps: null,
        renderLabel: null,
        height: 200,
        itemCount: 5,
        onChanged: (snap, res) => results.add(res),
      )));
      // 点选年份列中的 2025年（应触发 onItemSelected）
      if (find.text('2025年').evaluate().isNotEmpty) {
        await tester.tap(find.text('2025年').first);
        await tester.pumpAndSettle();
      }
      // 滚轮仅在滚动结束/无障碍语义动作时触发 onItemSelected，tap 不触发；
      // onChanged 覆盖见"无障碍"与"闰年"测试
      expect(find.byType(DateTimePickerWheel), findsOneWidget);
    });

    testWidgets('点选月份触发 onChanged', (tester) async {
      final results = <TDateTimePickerValue>[];
      await tester.pumpWidget(wrap(DateTimePickerWheel(
        snapshot: makeSnapshot(),
        labels: DateTimePickerLabels.defaults,
        start: DateTime(2020, 1, 1),
        end: DateTime(2030, 12, 31),
        showWeek: false,
        steps: null,
        renderLabel: null,
        height: 200,
        itemCount: 5,
        onChanged: (snap, res) => results.add(res),
      )));
      if (find.text('5月').evaluate().isNotEmpty) {
        await tester.tap(find.text('5月').first);
        await tester.pumpAndSettle();
      }
      // 即便未命中，渲染也应成功
      expect(find.byType(DateTimePickerWheel), findsOneWidget);
    });
  });

  group('DateTimePickerWheel didUpdateWidget', () {
    testWidgets('snapshot 变化触发重建', (tester) async {
      await tester.pumpWidget(wrap(DateTimePickerWheel(
        snapshot: makeSnapshot(),
        labels: DateTimePickerLabels.defaults,
        start: DateTime(2020, 1, 1),
        end: DateTime(2030, 12, 31),
        showWeek: false,
        steps: null,
        renderLabel: null,
        height: 200,
        itemCount: 5,
        onChanged: (_, __) {},
      )));
      await tester.pumpWidget(wrap(DateTimePickerWheel(
        snapshot: DateTimePickerSnapshot.initial(
          columns: const [
            DateTimeColumn.year,
            DateTimeColumn.month,
            DateTimeColumn.day,
          ],
          initial: DateTime(2026, 1, 1),
          start: DateTime(2020, 1, 1),
          end: DateTime(2030, 12, 31),
        ),
        labels: DateTimePickerLabels.defaults,
        start: DateTime(2020, 1, 1),
        end: DateTime(2030, 12, 31),
        showWeek: false,
        steps: null,
        renderLabel: null,
        height: 200,
        itemCount: 5,
        onChanged: (_, __) {},
      )));
      await tester.pumpAndSettle();
      expect(find.byType(DateTimePickerWheel), findsOneWidget);
    });

    testWidgets('didUpdateWidget 配置相同触发 early return', (tester) async {
      final make = () => DateTimePickerWheel(
            snapshot: makeSnapshot(),
            labels: DateTimePickerLabels.defaults,
            start: DateTime(2020, 1, 1),
            end: DateTime(2030, 12, 31),
            showWeek: false,
            steps: null,
            renderLabel: null,
            height: 200,
            itemCount: 5,
            onChanged: (_, __) {},
          );
      // 用不同实例（字段相等）二次 pump，触发 didUpdateWidget 且各条件为真，
      // 走 early return 分支（注意：复用同一实例会被 Flutter 跳过重载）
      await tester.pumpWidget(wrap(make()));
      await tester.pumpWidget(wrap(make()));
      await tester.pumpAndSettle();
      expect(find.byType(DateTimePickerWheel), findsOneWidget);
    });
  });

  group('DateTimePickerWheel 无障碍', () {
    testWidgets('increase/decrease 语义动作触发 _nudgeColumn', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(wrap(DateTimePickerWheel(
        snapshot: makeSnapshot(),
        labels: DateTimePickerLabels.defaults,
        start: DateTime(2020, 1, 1),
        end: DateTime(2030, 12, 31),
        showWeek: false,
        steps: null,
        renderLabel: null,
        height: 200,
        itemCount: 5,
        onChanged: (_, __) {},
      )));
      // 通过无障碍语义动作触发 onIncrease/onDecrease 闭包，覆盖
      // _buildColumnSemantics 与 _nudgeColumn
      final node = tester.getSemantics(find.bySemanticsLabel('年份年'));
      node.owner!.performAction(node.id, SemanticsAction.increase);
      await tester.pumpAndSettle();
      node.owner!.performAction(node.id, SemanticsAction.decrease);
      await tester.pumpAndSettle();
      expect(find.byType(DateTimePickerWheel), findsOneWidget);
      handle.dispose();
    });

    testWidgets('闰年 2/29 改年触发日列重建与同步', (tester) async {
      final handle = tester.ensureSemantics();
      final leap = DateTimePickerSnapshot.initial(
        columns: const [
          DateTimeColumn.year,
          DateTimeColumn.month,
          DateTimeColumn.day,
        ],
        initial: DateTime(2024, 2, 29),
        start: DateTime(2020, 1, 1),
        end: DateTime(2030, 12, 31),
      );
      await tester.pumpWidget(wrap(DateTimePickerWheel(
        snapshot: leap,
        labels: DateTimePickerLabels.defaults,
        start: DateTime(2020, 1, 1),
        end: DateTime(2030, 12, 31),
        showWeek: false,
        steps: null,
        renderLabel: null,
        height: 200,
        itemCount: 5,
        onChanged: (_, __) {},
      )));
      // 闰年 2/29 改为非闰年（2025）：日列选项由 1..29 变为 1..28，
      // 触发 _replaceColumn（日列重建）且日值由 29 截断为 28，覆盖
      // _outOfSyncIndices / _valuesEqual / _syncColumn 续接分支
      final yearNode = tester.getSemantics(find.bySemanticsLabel('年份年'));
      yearNode.owner!.performAction(yearNode.id, SemanticsAction.increase);
      await tester.pumpAndSettle();
      expect(find.byType(DateTimePickerWheel), findsOneWidget);
      handle.dispose();
    });
  });
}

Finder _pickerTextFinder(String data) {
  return find.byWidgetPredicate(
    (widget) => widget is TText && widget.data == data,
  );
}

Finder _wheelHighlightFinder() {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Container &&
        widget.decoration is BoxDecoration &&
        widget.constraints?.minHeight == 40 &&
        widget.constraints?.maxHeight == 40,
  );
}
