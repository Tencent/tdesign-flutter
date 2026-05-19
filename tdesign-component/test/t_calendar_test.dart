import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

Widget _buildTestApp(Widget child) {
  return TTheme(
    data: TThemeData.defaultData(),
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('TCalendar — bottom / bottomExpanded', () {
    test('bottomExpanded 未配合 bottom 时触发 assert', () {
      expect(
        () => TCalendar(bottomExpanded: ValueNotifier<bool>(false)),
        throwsAssertionError,
      );
    });

    testWidgets('非 popup 使用 bottom 触发 assert', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            title: '测试',
            height: 640,
            bottom: (_, __) => const Text('底部'),
          ),
        ),
      );

      expect(tester.takeException(), isA<AssertionError>());
      expect(find.text('底部'), findsNothing);
    });

    testWidgets('popup 内选中变化时 bottom 会重建', (tester) async {
      final day = DateTime(2024, 6, 15);
      final dayMs =
          DateTime(day.year, day.month, day.day).millisecondsSinceEpoch;
      final selected = ValueNotifier<List<int>>([dayMs]);

      await tester.pumpWidget(
        _buildTestApp(
          TCalendarInherited(
            selected: selected,
            usePopup: true,
            child: TCalendar(
              title: '测试',
              height: 640,
              value: selected.value,
              bottom: (_, dates) => Text('days:${dates.length}'),
            ),
          ),
        ),
      );

      expect(find.text('days:1'), findsOneWidget);

      final day2 = day.add(const Duration(days: 1));
      selected.value = [
        dayMs,
        DateTime(day2.year, day2.month, day2.day).millisecondsSinceEpoch,
      ];
      await tester.pump();

      expect(find.text('days:2'), findsOneWidget);
    });

    testWidgets('popup 内 bottomExpanded 为 false 时处于收起偏移', (tester) async {
      final expanded = ValueNotifier<bool>(false);
      final selected = ValueNotifier<List<int>>([]);

      await tester.pumpWidget(
        _buildTestApp(
          TCalendarInherited(
            selected: selected,
            usePopup: true,
            child: TCalendar(
              title: '测试',
              height: 640,
              bottomExpanded: expanded,
              bottom: (_, __) => const Text('底部内容'),
            ),
          ),
        ),
      );
      await tester.pump();

      var slide = tester.widget<SlideTransition>(
        find.descendant(
          of: find.byType(TCalendar),
          matching: find.byType(SlideTransition),
        ),
      );
      expect(slide.position.value.dy, 1.0);

      expanded.value = true;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      slide = tester.widget<SlideTransition>(
        find.descendant(
          of: find.byType(TCalendar),
          matching: find.byType(SlideTransition),
        ),
      );
      expect(slide.position.value.dy, 0.0);
    });
  });

  // -----------------------------------------------------------------------
  // 辅助：将 DateTime 转为日毫秒时间戳（去除时分秒）
  // -----------------------------------------------------------------------
  int _ms(DateTime d) =>
      DateTime(d.year, d.month, d.day).millisecondsSinceEpoch;

  // -----------------------------------------------------------------------
  // 单选
  // -----------------------------------------------------------------------
  group('TCalendar — 单选 (single)', () {
    testWidgets('点击日期触发 onChange', (tester) async {
      final day15 = DateTime(2024, 6, 15);
      final day20 = DateTime(2024, 6, 20);
      final minMs = _ms(DateTime(2024, 6, 1));
      final maxMs = _ms(DateTime(2024, 6, 30));
      List<int>? result;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            value: [_ms(day15)],
            minDate: minMs,
            maxDate: maxMs,
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
      expect(result!.first, _ms(day20));
    });

    testWidgets('点击已选中日期不重复触发 onChange', (tester) async {
      final day15 = DateTime(2024, 6, 15);
      final minMs = _ms(DateTime(2024, 6, 1));
      final maxMs = _ms(DateTime(2024, 6, 30));
      var callCount = 0;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            value: [_ms(day15)],
            minDate: minMs,
            maxDate: maxMs,
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
      final day15 = DateTime(2024, 6, 15);
      final minMs = _ms(DateTime(2024, 6, 10));
      final maxMs = _ms(DateTime(2024, 6, 25));
      List<int>? result;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            value: [_ms(day15)],
            minDate: minMs,
            maxDate: maxMs,
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
      final day15 = DateTime(2024, 6, 15);
      final minMs = _ms(DateTime(2024, 6, 1));
      final maxMs = _ms(DateTime(2024, 6, 30));
      List<int>? result;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.multiple,
            value: [_ms(day15)],
            minDate: minMs,
            maxDate: maxMs,
            onChange: (v) => result = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('20'));
      await tester.pump();

      expect(result, isNotNull);
      expect(result!.length, 2);
      expect(result!.contains(_ms(day15)), isTrue);
      expect(result!.contains(_ms(DateTime(2024, 6, 20))), isTrue);
    });

    testWidgets('再次点击已选日期取消选中', (tester) async {
      final day15 = DateTime(2024, 6, 15);
      final day20 = DateTime(2024, 6, 20);
      final minMs = _ms(DateTime(2024, 6, 1));
      final maxMs = _ms(DateTime(2024, 6, 30));
      List<int>? result;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.multiple,
            value: [_ms(day15), _ms(day20)],
            minDate: minMs,
            maxDate: maxMs,
            onChange: (v) => result = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 点击已选中的 15 号取消
      await tester.tap(find.text('15'));
      await tester.pump();

      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result!.first, _ms(day20));
    });
  });

  // -----------------------------------------------------------------------
  // 区间选择
  // -----------------------------------------------------------------------
  group('TCalendar — 区间选择 (range)', () {
    testWidgets('选择 start 和 end 触发 onChange', (tester) async {
      final minMs = _ms(DateTime(2024, 6, 1));
      final maxMs = _ms(DateTime(2024, 6, 30));
      List<int>? result;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.range,
            minDate: minMs,
            maxDate: maxMs,
            onChange: (v) => result = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 先点 10 号作为 start
      await tester.tap(find.text('10'));
      await tester.pump();

      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result!.first, _ms(DateTime(2024, 6, 10)));

      // 再点 20 号作为 end
      await tester.tap(find.text('20'));
      await tester.pump();

      expect(result!.length, 2);
      expect(result!.first, _ms(DateTime(2024, 6, 10)));
      expect(result!.last, _ms(DateTime(2024, 6, 20)));
    });

    testWidgets('end 在 start 之前时重置为新 start', (tester) async {
      final day20 = DateTime(2024, 6, 20);
      final minMs = _ms(DateTime(2024, 6, 1));
      final maxMs = _ms(DateTime(2024, 6, 30));
      List<int>? result;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.range,
            value: [_ms(day20)],
            minDate: minMs,
            maxDate: maxMs,
            onChange: (v) => result = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 点击 10 号（在 start=20 之前）应重置
      await tester.tap(find.text('10'));
      await tester.pump();

      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result!.first, _ms(DateTime(2024, 6, 10)));
    });
  });

  // -----------------------------------------------------------------------
  // 边界条件
  // -----------------------------------------------------------------------
  group('TCalendar — 边界条件', () {
    testWidgets('不传 value 时正常渲染', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            minDate: _ms(DateTime(2024, 6, 1)),
            maxDate: _ms(DateTime(2024, 6, 30)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 应能看到日期
      expect(find.text('1'), findsWidgets);
      expect(find.text('30'), findsOneWidget);
    });

    testWidgets('空 value 列表正常渲染', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            value: const [],
            minDate: _ms(DateTime(2024, 6, 1)),
            maxDate: _ms(DateTime(2024, 6, 30)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('onCellClick 回调携带正确参数', (tester) async {
      final minMs = _ms(DateTime(2024, 6, 1));
      final maxMs = _ms(DateTime(2024, 6, 30));
      int? clickedValue;
      DateSelectType? clickedType;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            minDate: minMs,
            maxDate: maxMs,
            onCellClick: (value, type, tdate) {
              clickedValue = value;
              clickedType = type;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('15'));
      await tester.pump();

      expect(clickedValue, _ms(DateTime(2024, 6, 15)));
      expect(clickedType, DateSelectType.selected);
    });

    testWidgets('单月范围（minDate == maxDate 同月）正常渲染', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            minDate: _ms(DateTime(2024, 6, 1)),
            maxDate: _ms(DateTime(2024, 6, 1)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 只有 1 号可选，其余 disabled
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('firstDayOfWeek = 1（周一开始）正常渲染', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            firstDayOfWeek: 1,
            minDate: _ms(DateTime(2024, 6, 1)),
            maxDate: _ms(DateTime(2024, 6, 30)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('15'), findsOneWidget);
    });
  });
}
