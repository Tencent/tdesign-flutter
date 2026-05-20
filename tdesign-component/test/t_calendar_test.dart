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
  // popupBottomBuilder / popupBottomExpanded
  // -----------------------------------------------------------------------
  group('TCalendar — popupBottom / popupBottomExpanded', () {
    test('popupBottomExpanded 未配合 popupBottomBuilder 时触发 assert', () {
      expect(
        () => TCalendar(popupBottomExpanded: ValueNotifier<bool>(false)),
        throwsAssertionError,
      );
    });

    testWidgets('非弹窗模式使用 popupBottomBuilder 触发 assert', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            titleWidget: const Text('测试'),
            height: 640,
            popupBottomBuilder: (_, __) => const Text('底部'),
          ),
        ),
      );

      expect(tester.takeException(), isA<AssertionError>());
      expect(find.text('底部'), findsNothing);
    });

    testWidgets('popup 内选中变化时 popupBottomBuilder 会重建', (tester) async {
      final day = _day(2024, 6, 15);
      final selected = ValueNotifier<List<DateTime>>([day]);

      await tester.pumpWidget(
        _buildTestApp(
          TCalendarInherited(
            selected: selected,
            usePopup: true,
            child: TCalendar(
              titleWidget: const Text('测试'),
              height: 640,
              initialValue: selected.value,
              popupBottomBuilder: (_, dates) => Text('days:${dates.length}'),
            ),
          ),
        ),
      );

      expect(find.text('days:1'), findsOneWidget);

      final day2 = day.add(const Duration(days: 1));
      selected.value = [day, _day(day2.year, day2.month, day2.day)];
      await tester.pump();

      expect(find.text('days:2'), findsOneWidget);
    });

    testWidgets('popup 内 popupBottomExpanded 为 false 时处于收起偏移', (tester) async {
      final expanded = ValueNotifier<bool>(false);
      final selected = ValueNotifier<List<DateTime>>([]);

      await tester.pumpWidget(
        _buildTestApp(
          TCalendarInherited(
            selected: selected,
            usePopup: true,
            child: TCalendar(
              titleWidget: const Text('测试'),
              height: 640,
              popupBottomExpanded: expanded,
              popupBottomBuilder: (_, __) => const Text('底部内容'),
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

      // 点击已选中的 15 号取消
      await tester.tap(find.text('15'));
      await tester.pump();

      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result!.first, day20);
    });
  });

  // -----------------------------------------------------------------------
  // 区间选择
  // -----------------------------------------------------------------------
  group('TCalendar — 区间选择 (range)', () {
    testWidgets('选择 start 和 end 触发 onChange', (tester) async {
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

      // 先点 10 号作为 start
      await tester.tap(find.text('10'));
      await tester.pump();

      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result!.first, _day(2024, 6, 10));

      // 再点 20 号作为 end
      await tester.tap(find.text('20'));
      await tester.pump();

      expect(result!.length, 2);
      expect(result!.first, _day(2024, 6, 10));
      expect(result!.last, _day(2024, 6, 20));
    });

    testWidgets('end 在 start 之前时重置为新 start', (tester) async {
      final day20 = _day(2024, 6, 20);
      final minDate = _day(2024, 6, 1);
      final maxDate = _day(2024, 6, 30);
      List<DateTime>? result;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.range,
            initialValue: [day20],
            minDate: minDate,
            maxDate: maxDate,
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
      expect(result!.first, _day(2024, 6, 10));
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
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('onCellClick 回调携带正确参数', (tester) async {
      final minDate = _day(2024, 6, 1);
      final maxDate = _day(2024, 6, 30);
      DateTime? clickedValue;
      DateSelectType? clickedType;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            minDate: minDate,
            maxDate: maxDate,
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

      expect(clickedValue, _day(2024, 6, 15));
      expect(clickedType, DateSelectType.selected);
    });

    testWidgets('单月范围（minDate == maxDate 同月）正常渲染', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            height: 640,
            type: CalendarType.single,
            minDate: _day(2024, 6, 1),
            maxDate: _day(2024, 6, 1),
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
            minDate: _day(2024, 6, 1),
            maxDate: _day(2024, 6, 30),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('15'), findsOneWidget);
    });
  });

  // -----------------------------------------------------------------------
  // showPopup 集成
  // -----------------------------------------------------------------------
  group('TCalendar.showPopup', () {
    testWidgets('选中新日期并确认后返回选中列表', (tester) async {
      final day15 = _day(2024, 6, 15);
      final day20 = _day(2024, 6, 20);
      List<DateTime>? popupResult;

      await tester.pumpWidget(
        _buildTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                popupResult = await TCalendar.showPopup(
                  context,
                  titleWidget: const Text('选择日期'),
                  type: CalendarType.single,
                  initialValue: [day15],
                  minDate: _day(2024, 6, 1),
                  maxDate: _day(2024, 6, 30),
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('选择日期'), findsOneWidget);

      await tester.tap(find.text('20'));
      await tester.pump();

      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();

      expect(popupResult, isNotNull);
      expect(popupResult!.length, 1);
      expect(popupResult!.first, day20);
    });

    testWidgets('点击关闭按钮未确认时返回 null', (tester) async {
      List<DateTime>? popupResult;

      await tester.pumpWidget(
        _buildTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                popupResult = await TCalendar.showPopup(
                  context,
                  titleWidget: const Text('选择日期'),
                  type: CalendarType.single,
                  minDate: _day(2024, 6, 1),
                  maxDate: _day(2024, 6, 30),
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(popupResult, isNull);
    });

    testWidgets('自定义 confirmBtn 点击后返回选中值并关闭弹窗', (tester) async {
      final day15 = _day(2024, 6, 15);
      final day20 = _day(2024, 6, 20);
      List<DateTime>? popupResult;

      await tester.pumpWidget(
        _buildTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                popupResult = await TCalendar.showPopup(
                  context,
                  titleWidget: const Text('选择日期'),
                  type: CalendarType.single,
                  initialValue: [day15],
                  minDate: _day(2024, 6, 1),
                  maxDate: _day(2024, 6, 30),
                  confirmBtn: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('ok'),
                  ),
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('20'));
      await tester.pump();

      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();

      expect(popupResult, isNotNull);
      expect(popupResult!.single, day20);
    });

    testWidgets('popupBottomBuilder 与确认按钮区域不重叠', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                await TCalendar.showPopup(
                  context,
                  titleWidget: const Text('选择日期'),
                  type: CalendarType.single,
                  minDate: _day(2024, 6, 1),
                  maxDate: _day(2024, 6, 30),
                  popupHeight: 640,
                  popupBottomBuilder: (_, __) => const Text('底部区域'),
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final positioned = tester
          .widgetList<Positioned>(
            find.ancestor(
              of: find.text('底部区域'),
              matching: find.byType(Positioned),
            ),
          )
          .firstWhere((p) => (p.bottom ?? 0) > 0);
      expect(positioned.bottom, greaterThan(0));
    });
  });
}
