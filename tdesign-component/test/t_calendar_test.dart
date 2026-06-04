import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

Widget _buildTestApp(Widget child) {
  return TTheme(
    data: TThemeData.defaultData(),
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

/// 把 [DateTime] 归一化到当天 00:00（与 TCalendar 内部 `_getValue` 行为一致），
/// 便于在断言中比较。测试 fixture 都使用 `DateTime(y, m, d)` 字面量构造，
/// 因此默认即为归一化值。
DateTime _day(int y, int m, int d) => DateTime(y, m, d);

void main() {
  // -----------------------------------------------------------------------
  // 单选
  // -----------------------------------------------------------------------
  group('TCalendar — 单选 (single)', () {
    testWidgets('点击日期触发 onChange', (tester) async {
      final day15 = _day(2024, 6, 15);
      final day20 = _day(2024, 6, 20);
      final minDate = _day(2024, 6, 1);
      final maxDate = _day(2024, 6, 30);
      List<DateTime>? result;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            initialValue: [day15],
            minDate: minDate,
            maxDate: maxDate,
            onChange: (v) => result = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 点击 20 号
      await tester.tap(find.text('20'));
      await tester.pump();

      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result!.first, day20);
    });

    testWidgets('点击已选中日期不重复触发 onChange', (tester) async {
      final day15 = _day(2024, 6, 15);
      final minDate = _day(2024, 6, 1);
      final maxDate = _day(2024, 6, 30);
      var callCount = 0;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            initialValue: [day15],
            minDate: minDate,
            maxDate: maxDate,
            onChange: (_) => callCount++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 点击已选中的 15 号
      await tester.tap(find.text('15'));
      await tester.pump();

      expect(callCount, 0);
    });

    testWidgets('点击 disabled 日期不改变选中状态', (tester) async {
      final day15 = _day(2024, 6, 15);
      final minDate = _day(2024, 6, 10);
      final maxDate = _day(2024, 6, 25);
      List<DateTime>? result;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            initialValue: [day15],
            minDate: minDate,
            maxDate: maxDate,
            onChange: (v) => result = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 点击超出范围的 5 号（disabled）
      final finder5 = find.text('5');
      if (finder5.evaluate().isNotEmpty) {
        await tester.tap(finder5.first);
        await tester.pump();
      }

      // onChange 不应被触发
      expect(result, isNull);
    });
  });

  // -----------------------------------------------------------------------
  // 多选
  // -----------------------------------------------------------------------
  group('TCalendar — 多选 (multiple)', () {
    testWidgets('点击新日期添加选中', (tester) async {
      final day15 = _day(2024, 6, 15);
      final minDate = _day(2024, 6, 1);
      final maxDate = _day(2024, 6, 30);
      List<DateTime>? result;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.multiple,
            initialValue: [day15],
            minDate: minDate,
            maxDate: maxDate,
            onChange: (v) => result = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('20'));
      await tester.pump();

      expect(result, isNotNull);
      expect(result!.length, 2);
      expect(result!.contains(day15), isTrue);
      expect(result!.contains(_day(2024, 6, 20)), isTrue);
    });

    testWidgets('再次点击已选日期取消选中', (tester) async {
      final day15 = _day(2024, 6, 15);
      final day20 = _day(2024, 6, 20);
      final minDate = _day(2024, 6, 1);
      final maxDate = _day(2024, 6, 30);
      List<DateTime>? result;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.multiple,
            initialValue: [day15, day20],
            minDate: minDate,
            maxDate: maxDate,
            onChange: (v) => result = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('20'));
      await tester.pump();

      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result!.first, day15);
    });
  });

  // -----------------------------------------------------------------------
  // 区间选择
  // -----------------------------------------------------------------------
  group('TCalendar — 区间选择 (range)', () {
    testWidgets('选择 start 和 end 触发 onChange', (tester) async {
      final day15 = _day(2024, 6, 15);
      final day20 = _day(2024, 6, 20);
      final minDate = _day(2024, 6, 1);
      final maxDate = _day(2024, 6, 30);
      List<DateTime>? result;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.range,
            minDate: minDate,
            maxDate: maxDate,
            onChange: (v) => result = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('15'));
      await tester.pump();
      await tester.tap(find.text('20'));
      await tester.pump();

      expect(result, isNotNull);
      expect(result!.length, 2);
      expect(result![0], day15);
      expect(result![1], day20);
    });

    testWidgets('end 在 start 之前时重置为新 start', (tester) async {
      final day15 = _day(2024, 6, 15);
      final day10 = _day(2024, 6, 10);
      final minDate = _day(2024, 6, 1);
      final maxDate = _day(2024, 6, 30);
      List<DateTime>? result;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.range,
            minDate: minDate,
            maxDate: maxDate,
            onChange: (v) => result = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('15'));
      await tester.pump();
      await tester.tap(find.text('10'));
      await tester.pump();

      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result!.first, day10);
    });
  });

  // -----------------------------------------------------------------------
  // initialValue / anchorDate
  // -----------------------------------------------------------------------
  group('TCalendar — initialValue 与 anchorDate', () {
    testWidgets('运行期变更 initialValue 不会覆盖内部选中态', (tester) async {
      final day15 = _day(2024, 6, 15);
      final day10 = _day(2024, 6, 10);
      final day20 = _day(2024, 6, 20);
      final minDate = _day(2024, 6, 1);
      final maxDate = _day(2024, 6, 30);
      var onChangeCount = 0;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            initialValue: [day15],
            minDate: minDate,
            maxDate: maxDate,
            onChange: (_) => onChangeCount++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 父级改 initialValue 为 10，但内部仍保持挂载时的 15
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            initialValue: [day10],
            minDate: minDate,
            maxDate: maxDate,
            onChange: (_) => onChangeCount++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('15'));
      await tester.pump();
      expect(onChangeCount, 0);

      await tester.tap(find.text('20'));
      await tester.pump();
      expect(onChangeCount, 1);
      expect(find.text('20'), findsWidgets);
    });

    testWidgets('更换 Key 后 initialValue 重新生效', (tester) async {
      final day15 = _day(2024, 6, 15);
      final day10 = _day(2024, 6, 10);
      final minDate = _day(2024, 6, 1);
      final maxDate = _day(2024, 6, 30);
      var onChangeCount = 0;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            key: const Key('cal-a'),
            height: 640,
            type: CalendarType.single,
            initialValue: [day15],
            minDate: minDate,
            maxDate: maxDate,
            onChange: (_) => onChangeCount++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            key: const Key('cal-b'),
            height: 640,
            type: CalendarType.single,
            initialValue: [day10],
            minDate: minDate,
            maxDate: maxDate,
            onChange: (_) => onChangeCount++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('10'));
      await tester.pump();
      expect(onChangeCount, 0);
    });

    testWidgets('仅 anchorDate、无 initialValue 时首屏定位到锚点月', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            anchorDate: _day(2026, 1, 1),
            onChange: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 默认 minDate 为 1970-01；若 anchor 未下发 body，首屏会停在 1970 年。
      expect(find.textContaining('1970'), findsNothing);
      expect(find.textContaining('2026'), findsWidgets);
    });

    testWidgets('运行期更新 anchorDate 可重新滚动到目标月', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            anchorDate: _day(2024, 1, 1),
            minDate: _day(2024, 1, 1),
            maxDate: _day(2024, 12, 31),
            onChange: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            anchorDate: _day(2024, 6, 1),
            minDate: _day(2024, 1, 1),
            maxDate: _day(2024, 12, 31),
            onChange: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('6'), findsWidgets);
    });
  });

  // -----------------------------------------------------------------------
  // 边界条件
  // -----------------------------------------------------------------------
  group('TCalendar — 边界条件', () {
    testWidgets('不传 initialValue 时正常渲染', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            minDate: _day(2024, 6, 1),
            maxDate: _day(2024, 6, 30),
            onChange: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 应能看到日期
      expect(find.text('1'), findsWidgets);
      expect(find.text('30'), findsOneWidget);
    });

    testWidgets('空 initialValue 列表正常渲染', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            initialValue: const [],
            minDate: _day(2024, 6, 1),
            maxDate: _day(2024, 6, 30),
            onChange: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('onCellTap 回调携带正确 cell 模型', (tester) async {
      final minDate = _day(2024, 6, 1);
      final maxDate = _day(2024, 6, 30);
      TCalendarCellModel? tappedCell;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            minDate: minDate,
            maxDate: maxDate,
            onChange: (_) {},
            onCellTap: (cell) => tappedCell = cell,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('15'));
      await tester.pump();

      expect(tappedCell, isNotNull);
      expect(tappedCell!.date, _day(2024, 6, 15));
      expect(tappedCell!.selectType, DateSelectType.selected);
    });

    testWidgets('可选范围仅相邻两天时正常渲染', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            minDate: _day(2024, 6, 1),
            maxDate: _day(2024, 6, 2),
            onChange: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1'), findsWidgets);
      expect(find.text('2'), findsWidgets);
    });

    testWidgets('firstDayOfWeek = 1（周一开始）正常渲染', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            firstDayOfWeek: 1,
            minDate: _day(2024, 6, 1),
            maxDate: _day(2024, 6, 30),
            onChange: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('15'), findsOneWidget);
    });
  });
}
