import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/picker/t_picker_types.dart';
import 'package:tdesign_flutter/src/components/picker/wheel_column.dart';

void main() {
  _customScrollRegression();
  const options = [
    TPickerOption(label: 'A', value: 'a'),
    TPickerOption(label: 'B', value: 'b'),
  ];

  test('nearestEnabledIndex searches both directions', () {
    const values = [
      TPickerOption(label: 'A', value: 0),
      TPickerOption(label: 'B', value: 1, disabled: true),
      TPickerOption(label: 'C', value: 2),
    ];
    expect(WheelColumnState.nearestEnabledIndex(values, 1), 2);
    expect(WheelColumnState.nearestEnabledIndex(values, 2), 0);
    expect(
      WheelColumnState.nearestEnabledIndex(
        const [TPickerOption(label: 'A', value: 0, disabled: true)],
        0,
      ),
      -1,
    );
  });

  testWidgets('nudge moves one item and respects boundaries', (tester) async {
    final key = GlobalKey<WheelColumnState>();
    final controller = FixedExtentScrollController();
    var selected = -1;
    await tester.pumpWidget(MaterialApp(
      home: SizedBox(
        height: 200,
        child: WheelColumn(
          key: key,
          colIndex: 0,
          options: options,
          controller: controller,
          itemHeight: 40,
          disabled: false,
          onItemSelected: (_, index, __) => selected = index,
        ),
      ),
    ));

    expect(key.currentState?.nudge(-1), isFalse);
    expect(key.currentState?.nudge(1), isTrue);
    expect(selected, 1);
    expect(key.currentState?.nudge(1), isFalse);
    controller.dispose();
  });

  testWidgets('updates options and controller without owning disposal',
      (tester) async {
    final key = GlobalKey<WheelColumnState>();
    final first = FixedExtentScrollController();
    final second = FixedExtentScrollController(initialItem: 1);
    await tester.pumpWidget(MaterialApp(
      home: SizedBox(
        height: 200,
        child: WheelColumn(
          key: key,
          colIndex: 0,
          options: options,
          controller: first,
          itemHeight: 40,
          disabled: false,
          onItemSelected: (_, __, ___) {},
        ),
      ),
    ));
    key.currentState?.applyColumnUpdate(options: options, controller: first);
    key.currentState?.applyColumnUpdate(
      options: const [
        TPickerOption(label: 'C', value: 'c'),
        TPickerOption(label: 'D', value: 'd'),
      ],
      controller: second,
    );
    await tester.pump();

    expect(find.text('D'), findsOneWidget);
    first.dispose();
    second.dispose();
  });

  testWidgets('empty and disabled columns do not move', (tester) async {
    final key = GlobalKey<WheelColumnState>();
    final controller = FixedExtentScrollController();
    await tester.pumpWidget(MaterialApp(
      home: WheelColumn(
        key: key,
        colIndex: 0,
        options: const [],
        controller: controller,
        itemHeight: 40,
        disabled: true,
        onItemSelected: (_, __, ___) {},
      ),
    ));

    expect(find.byType(ListWheelScrollView), findsNothing);
    expect(key.currentState?.nudge(1), isFalse);
    controller.dispose();
  });
}

class _CallerScrollBehavior extends ScrollBehavior {
  const _CallerScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const NeverScrollableScrollPhysics();
}

void _customScrollRegression() {
  for (final m3 in [false, true]) {
    for (final platform in [TargetPlatform.android, TargetPlatform.macOS]) {
      testWidgets('custom item scroll stays caller-owned m3=$m3 $platform', (
        tester,
      ) async {
        final nested = ScrollController();
        final wheel = FixedExtentScrollController();
        addTearDown(nested.dispose);
        addTearDown(wheel.dispose);
        var selected = 0;
        final caller = ThemeData(
          useMaterial3: m3,
          platform: platform,
          iconTheme: const IconThemeData(size: 70, color: Colors.green),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 31, letterSpacing: 12),
          ),
        );
        final seen = <ThemeData>[];
        await tester.pumpWidget(
          MaterialApp(
            theme: caller,
            builder: (context, child) => ScrollConfiguration(
              behavior: const _CallerScrollBehavior(),
              child: child!,
            ),
            home: Center(
              child: SizedBox(
                width: 300,
                height: 200,
                child: WheelColumn(
                  key: GlobalKey<WheelColumnState>(),
                  colIndex: 0,
                  options: List.generate(
                    10,
                    (i) => TPickerOption(label: '$i', value: i),
                  ),
                  controller: wheel,
                  itemHeight: 40,
                  disabled: false,
                  onItemSelected: (_, index, __) => selected = index,
                  itemBuilder: (context, option, column, index, distance) {
                    seen.add(Theme.of(context));
                    if (index != 0) {
                      return Text(option.label);
                    }
                    return SizedBox(
                      width: 22,
                      height: 22,
                      child: SingleChildScrollView(
                        key: const Key('custom-scroll'),
                        controller: nested,
                        scrollDirection: Axis.horizontal,
                        child: const SizedBox(width: 100, height: 22),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
        await tester.drag(
          find.byKey(const Key('custom-scroll')),
          const Offset(-40, 0),
        );
        await tester.pumpAndSettle();
        expect(nested.offset, 0);
        expect(seen, isNotEmpty);
        for (final theme in seen) {
          expect(theme.useMaterial3, caller.useMaterial3);
          expect(theme.platform, caller.platform);
          expect(theme.textTheme.bodyMedium!.fontSize, 31);
          expect(theme.textTheme.bodyMedium!.letterSpacing, 12);
          expect(theme.iconTheme, caller.iconTheme);
        }
        // 外部 NeverScrollable 仅约束自定义内容，内置滚轮仍可原生拖动。
        await tester.dragFrom(const Offset(450, 300), const Offset(0, -80));
        await tester.pumpAndSettle();
        expect(wheel.selectedItem, greaterThan(0));
        expect(selected, wheel.selectedItem);
        await tester.pumpWidget(const SizedBox());
      });
    }
  }
}
