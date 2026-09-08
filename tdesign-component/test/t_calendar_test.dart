import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tdesign_flutter/tdesign_flutter.dart';

Widget _buildTestApp(Widget child) {
  return Theme(
    data: ThemeData(extensions: [TThemeData.defaultData()]),
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
    testWidgets('点击日期触发 onChanged', (tester) async {
      final day15 = _day(2024, 6, 15);
      final day20 = _day(2024, 6, 20);
      final minDate = _day(2024, 6, 1);
      final maxDate = _day(2024, 6, 30);
      List<DateTime>? result;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            variant: TCalendarVariant.single,
            value: [day15],
            minDate: minDate,
            maxDate: maxDate,
            onChanged: (v) => result = v,
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

    testWidgets('点击已选中日期不重复触发 onChanged', (tester) async {
      final day15 = _day(2024, 6, 15);
      final minDate = _day(2024, 6, 1);
      final maxDate = _day(2024, 6, 30);
      var callCount = 0;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            variant: TCalendarVariant.single,
            value: [day15],
            minDate: minDate,
            maxDate: maxDate,
            onChanged: (_) => callCount++,
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
            variant: TCalendarVariant.single,
            value: [day15],
            minDate: minDate,
            maxDate: maxDate,
            onChanged: (v) => result = v,
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

      // onChanged 不应被触发
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
            variant: TCalendarVariant.multiple,
            value: [day15],
            minDate: minDate,
            maxDate: maxDate,
            onChanged: (v) => result = v,
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
            variant: TCalendarVariant.multiple,
            value: [day15, day20],
            minDate: minDate,
            maxDate: maxDate,
            onChanged: (v) => result = v,
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
    testWidgets('选择 start 和 end 触发 onChanged', (tester) async {
      final day15 = _day(2024, 6, 15);
      final day20 = _day(2024, 6, 20);
      final minDate = _day(2024, 6, 1);
      final maxDate = _day(2024, 6, 30);
      List<DateTime>? result;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            variant: TCalendarVariant.range,
            value: const [],
            minDate: minDate,
            maxDate: maxDate,
            onChanged: (v) => result = v,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('15'));
      await tester.pump();
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            variant: TCalendarVariant.range,
            value: result!,
            minDate: minDate,
            maxDate: maxDate,
            onChanged: (v) => result = v,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('20'));
      await tester.pump();

      expect(result, isNotNull);
      expect(result!.length, 2);
      expect(result![0], day15);
      expect(result![1], day20);
    });

    testWidgets('end 在 start 之前时重置为新 start', (tester) async {
      final day10 = _day(2024, 6, 10);
      final minDate = _day(2024, 6, 1);
      final maxDate = _day(2024, 6, 30);
      List<DateTime>? result;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            variant: TCalendarVariant.range,
            value: const [],
            minDate: minDate,
            maxDate: maxDate,
            onChanged: (v) => result = v,
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
  // value / anchorDate
  // -----------------------------------------------------------------------
  group('TCalendar — value 与 anchorDate', () {
    testWidgets('运行期变更 value 会同步受控选中态', (tester) async {
      final day15 = _day(2024, 6, 15);
      final day10 = _day(2024, 6, 10);
      final minDate = _day(2024, 6, 1);
      final maxDate = _day(2024, 6, 30);
      var onChangeCount = 0;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            variant: TCalendarVariant.single,
            value: [day15],
            minDate: minDate,
            maxDate: maxDate,
            onChanged: (_) => onChangeCount++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 父级改 value 为 10，受控高亮同步更新。
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            variant: TCalendarVariant.single,
            value: [day10],
            minDate: minDate,
            maxDate: maxDate,
            onChanged: (_) => onChangeCount++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('10'));
      await tester.pump();
      expect(onChangeCount, 0);

      await tester.tap(find.text('15'));
      await tester.pump();
      expect(onChangeCount, 1);
      expect(find.text('20'), findsWidgets);
    });

    testWidgets('更换 Key 后仍使用当前受控 value', (tester) async {
      final day15 = _day(2024, 6, 15);
      final day10 = _day(2024, 6, 10);
      final minDate = _day(2024, 6, 1);
      final maxDate = _day(2024, 6, 30);
      var onChangeCount = 0;

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            key: const Key('cal-a'),
            variant: TCalendarVariant.single,
            value: [day15],
            minDate: minDate,
            maxDate: maxDate,
            onChanged: (_) => onChangeCount++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            key: const Key('cal-b'),
            variant: TCalendarVariant.single,
            value: [day10],
            minDate: minDate,
            maxDate: maxDate,
            onChanged: (_) => onChangeCount++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('10'));
      await tester.pump();
      expect(onChangeCount, 0);
    });

    testWidgets('空 value 时首屏定位到 anchorDate', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            variant: TCalendarVariant.single,
            value: const [],
            anchorDate: _day(2026, 1, 1),
            onChanged: (_) {},
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
            value: const [],
            anchorDate: _day(2024, 1, 1),
            minDate: _day(2024, 1, 1),
            maxDate: _day(2024, 12, 31),
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            value: const [],
            anchorDate: _day(2024, 6, 1),
            minDate: _day(2024, 1, 1),
            maxDate: _day(2024, 12, 31),
            onChanged: (_) {},
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
    testWidgets('空 value 时正常渲染', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            variant: TCalendarVariant.single,
            value: const [],
            minDate: _day(2024, 6, 1),
            maxDate: _day(2024, 6, 30),
            onChanged: (_) {},
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
            variant: TCalendarVariant.single,
            value: const [],
            minDate: _day(2024, 6, 1),
            maxDate: _day(2024, 6, 30),
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('可选范围仅相邻两天时正常渲染', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            variant: TCalendarVariant.single,
            value: const [],
            minDate: _day(2024, 6, 1),
            maxDate: _day(2024, 6, 2),
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1'), findsWidgets);
      expect(find.text('2'), findsWidgets);
    });

    testWidgets('运行期收窄 maxDate 后超出范围日期不可选', (tester) async {
      List<DateTime>? result;

      await tester.pumpWidget(
        _buildTestApp(
          _RuntimeMaxDateHarness(onChanged: (v) => result = v),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('15'));
      await tester.pump();
      expect(result, isNotNull);
      expect(result!.single, _day(2024, 6, 15));

      await tester.tap(find.text('收窄范围'));
      await tester.pumpAndSettle();

      result = null;
      await tester.tap(find.text('25'));
      await tester.pump();
      expect(result, isNull);
    });

    testWidgets('运行期变更 firstDayOfWeek 后仍可正常点选', (tester) async {
      List<DateTime>? result;

      await tester.pumpWidget(
        _buildTestApp(
          _RuntimeWeekStartHarness(onChanged: (v) => result = v),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('切到周一'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('15'));
      await tester.pump();
      expect(result, isNotNull);
      expect(result!.single, _day(2024, 6, 15));
    });

    testWidgets('运行期变更 style.cellHeight 后格高更新', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(const _RuntimeStyleHarness()),
      );
      await tester.pumpAndSettle();

      final cellGesture = find
          .descendant(
            of: find.byType(TCalendar),
            matching: find.byType(GestureDetector),
          )
          .first;
      final heightBefore = tester.getSize(cellGesture).height;

      await tester.tap(find.text('加高'));
      await tester.pumpAndSettle();

      final heightAfter = tester.getSize(cellGesture).height;
      expect(heightAfter, greaterThan(heightBefore));
    });

    testWidgets('firstDayOfWeek = monday（周一开始）正常渲染', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          TCalendar(
            variant: TCalendarVariant.single,
            value: const [],
            firstDayOfWeek: TCalendarFirstDayOfWeek.monday,
            minDate: _day(2024, 6, 1),
            maxDate: _day(2024, 6, 30),
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('15'), findsOneWidget);
    });
  });
}

/// 运行期收窄 [TCalendar.maxDate] 的测试夹具。
class _RuntimeMaxDateHarness extends StatefulWidget {
  const _RuntimeMaxDateHarness({required this.onChanged});

  final ValueChanged<List<DateTime>> onChanged;

  @override
  State<_RuntimeMaxDateHarness> createState() => _RuntimeMaxDateHarnessState();
}

class _RuntimeMaxDateHarnessState extends State<_RuntimeMaxDateHarness> {
  DateTime _maxDate = _day(2024, 6, 30);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () => setState(() => _maxDate = _day(2024, 6, 20)),
          child: const Text('收窄范围'),
        ),
        Expanded(
          child: TCalendar(
            variant: TCalendarVariant.single,
            value: const [],
            minDate: _day(2024, 6, 1),
            maxDate: _maxDate,
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}

/// 运行期切换 [TCalendar.firstDayOfWeek] 的测试夹具。
class _RuntimeWeekStartHarness extends StatefulWidget {
  const _RuntimeWeekStartHarness({required this.onChanged});

  final ValueChanged<List<DateTime>> onChanged;

  @override
  State<_RuntimeWeekStartHarness> createState() =>
      _RuntimeWeekStartHarnessState();
}

class _RuntimeWeekStartHarnessState extends State<_RuntimeWeekStartHarness> {
  TCalendarFirstDayOfWeek _firstDayOfWeek = TCalendarFirstDayOfWeek.sunday;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () => setState(
            () => _firstDayOfWeek = TCalendarFirstDayOfWeek.monday,
          ),
          child: const Text('切到周一'),
        ),
        Expanded(
          child: TCalendar(
            variant: TCalendarVariant.single,
            value: const [],
            firstDayOfWeek: _firstDayOfWeek,
            minDate: _day(2024, 6, 1),
            maxDate: _day(2024, 6, 30),
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}

/// 运行期变更 TCalendar.style 的测试夹具。
class _RuntimeStyleHarness extends StatefulWidget {
  const _RuntimeStyleHarness();

  @override
  State<_RuntimeStyleHarness> createState() => _RuntimeStyleHarnessState();
}

class _RuntimeStyleHarnessState extends State<_RuntimeStyleHarness> {
  double _cellHeight = 60;

  /// 与 [TCalendar] 内联默认高度公式一致，避免格高变大后 body 溢出。
  double _calendarHeightFor(double cellHeight) {
    const weekdayHeight = 46.0;
    const monthTitleHeight = 22.0;
    const bodyPadding = 16.0;
    const verticalGap = 8.0;
    const visibleRows = 5;
    return weekdayHeight +
        monthTitleHeight +
        visibleRows * (cellHeight + verticalGap) +
        bodyPadding * 2;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () => setState(() => _cellHeight = 80),
          child: const Text('加高'),
        ),
        SizedBox(
          height: _calendarHeightFor(_cellHeight),
          child: Theme(
            data: Theme.of(context).mergeExtension(
              TCalendarThemeData(cellHeight: _cellHeight),
            ),
            child: TCalendar(
              variant: TCalendarVariant.single,
              value: const [],
              minDate: _day(2024, 6, 1),
              maxDate: _day(2024, 6, 30),
              onChanged: (_) {},
            ),
          ),
        ),
      ],
    );
  }
}
