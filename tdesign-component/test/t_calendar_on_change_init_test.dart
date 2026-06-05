import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  testWidgets('挂载时 onChange 不应在 build 阶段触发', (tester) async {
    var onChangeCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TCalendar(
            type: CalendarType.multiple,
            initialValue: const [],
            onChange: (_) => onChangeCount++,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(onChangeCount, 0);
  });

  /// 弹层内 [TCalendar] 为独立实例；多选靠组件内部态累加，勿在 onChange 中回写 initialValue 受控。
  testWidgets('弹层内多选可累加选中', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TCell(
                title: '打开',
                onClick: (_) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const _TestMultipleSheet(),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    final day15 = find.descendant(
      of: find.byType(TCalendar),
      matching: find.text('15'),
    );
    final day16 = find.descendant(
      of: find.byType(TCalendar),
      matching: find.text('16'),
    );
    expect(day15, findsWidgets);
    expect(day16, findsWidgets);

    await tester.tap(day15.first);
    await tester.pump();
    await tester.tap(day16.first);
    await tester.pump();

    final sheetState =
        tester.state(find.byType(_TestMultipleSheet)) as _TestMultipleSheetState;
    expect(sheetState.pending.length, 2);
  });
}

class _TestMultipleSheet extends StatefulWidget {
  const _TestMultipleSheet();

  @override
  State<_TestMultipleSheet> createState() => _TestMultipleSheetState();
}

class _TestMultipleSheetState extends State<_TestMultipleSheet> {
  List<DateTime> pending = const [];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        height: 500,
        child: TCalendar(
          type: CalendarType.multiple,
          initialValue: pending,
          onChange: (v) => setState(() => pending = v),
        ),
      ),
    );
  }
}
