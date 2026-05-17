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

  group('TCalendarPopup', () {
    testWidgets('已有弹窗时再次 show 不会叠加', (tester) async {
      late BuildContext context;
      await tester.pumpWidget(
        _buildTestApp(
          Builder(
            builder: (ctx) {
              context = ctx;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      TCalendarPopup(
        context,
        child: const TCalendar(title: '日历A', height: 400),
      ).show();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        () => TCalendarPopup(
          context,
          child: const TCalendar(title: '日历B', height: 400),
        ).show(),
        throwsAssertionError,
      );
      await tester.pump();

      expect(find.text('日历A'), findsOneWidget);
      expect(find.text('日历B'), findsNothing);
    });
  });
}
