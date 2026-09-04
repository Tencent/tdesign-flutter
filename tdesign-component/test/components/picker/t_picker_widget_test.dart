import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/picker/picker_item.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child, {TPickerThemeData? pickerTheme}) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          TThemeData.defaultData(),
          if (pickerTheme != null) pickerTheme,
        ],
      ),
      home: Scaffold(body: child),
    );
  }

  const columns = TPickerColumns([
    [
      TPickerOption(label: 'A', value: 'a'),
      TPickerOption(label: 'B', value: 'b'),
      TPickerOption(label: 'C', value: 'c'),
    ],
    [
      TPickerOption(label: 'One', value: 1),
      TPickerOption(label: 'Two', value: 2),
    ],
  ]);

  testWidgets('滚轮统一字号并继承 TextTheme，禁用项可自定义内容', (tester) async {
    final control = FixedExtentScrollController(initialItem: 2);
    addTearDown(control.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          textTheme: const TextTheme(bodyLarge: TextStyle(fontSize: 19)),
          extensions: [TThemeData.defaultData()],
        ),
        home: Column(
          children: [
            for (var index = 0; index < 5; index++)
              SizedBox(
                height: 40,
                child: PickerItemWidget(
                  fixedExtentScrollController: control,
                  colIndex: 0,
                  index: index,
                  option: TPickerOption(label: 'item-$index', value: index),
                  itemHeight: 40,
                ),
              ),
            SizedBox(
              height: 40,
              child: PickerItemWidget(
                fixedExtentScrollController: control,
                colIndex: 0,
                index: 5,
                option: const TPickerOption(
                  label: 'disabled',
                  value: 5,
                  disabled: true,
                ),
                disabled: true,
                itemHeight: 40,
                itemBuilder: (_, option, __, ___, ____) =>
                    Text('custom-${option.label}'),
              ),
            ),
          ],
        ),
      ),
    );
    final labels = tester.widgetList<TText>(find.byType(TText)).toList();
    expect(labels, hasLength(5));
    expect(labels.map((label) => label.style!.fontSize), everyElement(19));
    expect(labels[2].style!.fontWeight, FontWeight.w600);
    expect(labels[1].style!.fontWeight, FontWeight.w400);
    expect(labels[1].style!.color, TThemeData.defaultData().textColorSecondary);
    expect(find.text('custom-disabled'), findsOneWidget);
  });

  group('TPicker controlled behavior', () {
    testWidgets('linked feedback preserves drag and fling activity', (
      tester,
    ) async {
      final items = TPickerLinked(
        List.generate(
          30,
          (index) => TPickerOption(
            label: 'Root $index',
            value: index,
            children: [
              TPickerOption(label: 'Child $index', value: 'child-$index'),
            ],
          ),
        ),
      );
      var value = <Object?>[0, 'child-0'];
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (_, setState) => TPicker(
              items: items,
              value: value,
              onChanged: (next) => setState(() => value = next.values),
            ),
          ),
        ),
      );
      final wheel = find.byType(ListWheelScrollView).first;
      final controller =
          tester.widget<ListWheelScrollView>(wheel).controller!
              as FixedExtentScrollController;
      final gesture = await tester.startGesture(tester.getCenter(wheel));
      await gesture.moveBy(const Offset(0, -60));
      await tester.pump();
      expect(
        tester.widget<ListWheelScrollView>(wheel).controller,
        same(controller),
      );
      final firstValue = value.first as int;
      await gesture.moveBy(const Offset(0, -80));
      await tester.pump();
      expect(value.first as int, greaterThan(firstValue));
      expect(value.last, 'child-${value.first}');
      await gesture.up();
      await tester.pumpAndSettle();
      await tester.fling(wheel, const Offset(0, -80), 1000);
      await tester.pump(const Duration(milliseconds: 16));
      expect(
        tester.widget<ListWheelScrollView>(wheel).controller,
        same(controller),
      );
      final releaseOffset = controller.offset;
      await tester.pump(const Duration(milliseconds: 100));
      expect(controller.offset, greaterThan(releaseOffset));
      await tester.pumpAndSettle();
      expect(value.last, 'child-${value.first}');
    });

    testWidgets('renders controlled values and emits a complete snapshot', (
      tester,
    ) async {
      TPickerValue? changed;
      await tester.pumpWidget(
        wrap(
          TPicker(
            items: columns,
            value: const ['b', 2],
            onChanged: (value) => changed = value,
          ),
        ),
      );
      final wheels = tester.widgetList<ListWheelScrollView>(
        find.byType(ListWheelScrollView),
      );
      expect(wheels, hasLength(2));
      expect(
        (wheels.first.controller as FixedExtentScrollController).selectedItem,
        1,
      );

      await tester.drag(
        find.byType(ListWheelScrollView).first,
        const Offset(0, -80),
      );
      await tester.pumpAndSettle();
      expect(changed, isNotNull);
      expect(changed!.values, hasLength(2));
    });

    testWidgets('external value updates synchronize wheel selection', (
      tester,
    ) async {
      var value = <dynamic>['a', 1];
      late StateSetter update;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return TPicker(
                items: columns,
                value: value,
                onChanged: (next) => value = next.values,
              );
            },
          ),
        ),
      );

      value = ['c', 2];
      update(() {});
      await tester.pump();
      final wheels = tester.widgetList<ListWheelScrollView>(
        find.byType(ListWheelScrollView),
      );
      expect(
        (wheels.first.controller as FixedExtentScrollController).selectedItem,
        2,
      );
    });

    testWidgets(
      'nested page scrolling does not interrupt controlled wheel drag',
      (tester) async {
        final pageController = ScrollController();
        final options = List<TPickerOption>.generate(
          8,
          (index) => TPickerOption(label: 'Item $index', value: index),
        );
        var value = <Object?>[0];
        var changes = 0;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [TThemeData.defaultData()]),
            home: Scaffold(
              body: CustomScrollView(
                controller: pageController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 240),
                        StatefulBuilder(
                          builder: (context, setState) => TPicker(
                            items: TPickerColumns([options]),
                            value: value,
                            onChanged: (next) => setState(() {
                              value = next.values;
                              changes++;
                            }),
                          ),
                        ),
                        const SizedBox(height: 480),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.fling(
          find.byType(ListWheelScrollView),
          const Offset(0, -240),
          1200,
        );
        await tester.pumpAndSettle();

        expect(pageController.offset, 0);
        expect(changes, greaterThan(1));
        expect(value.single, isNot(0));
      },
    );

    testWidgets('onChanged null disables interaction', (tester) async {
      await tester.pumpWidget(
        wrap(const TPicker(items: columns, value: ['a', 1])),
      );
      expect(
        tester
            .widgetList<AbsorbPointer>(find.byType(AbsorbPointer))
            .any((widget) => widget.absorbing),
        isTrue,
      );
      expect(
        tester
            .widgetList<Opacity>(find.byType(Opacity))
            .any((widget) => widget.opacity == 0.5),
        isTrue,
      );
    });

    testWidgets('item builder and column scroll end remain available', (
      tester,
    ) async {
      var ended = false;
      await tester.pumpWidget(
        wrap(
          TPicker(
            items: const TPickerColumns([
              [
                TPickerOption(label: 'A', value: 'a'),
                TPickerOption(label: 'B', value: 'b', disabled: true),
              ],
            ]),
            value: const ['a'],
            itemBuilder: (context, option, column, index, distance) {
              return distance == 0 ? Text('selected-${option.label}') : null;
            },
            onColumnScrollEnd: (_, __) => ended = true,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('selected-A'), findsOneWidget);
      await tester.drag(find.byType(ListWheelScrollView), const Offset(0, -40));
      await tester.pumpAndSettle();
      expect(ended, isTrue);
    });

    testWidgets('theme owns viewport dimensions', (tester) async {
      await tester.pumpWidget(
        wrap(
          TPicker(items: columns, value: const ['a', 1], onChanged: (_) {}),
          pickerTheme: const TPickerThemeData(height: 240, itemCount: 3),
        ),
      );
      expect(
        find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.height == 240,
        ),
        findsWidgets,
      );
    });
  });

  testWidgets('linked and raw data sources render', (tester) async {
    const linked = TPickerLinked([
      TPickerOption(
        label: 'Guangdong',
        value: 'Guangdong',
        children: [
          TPickerOption(
            label: 'Shenzhen',
            value: 'Shenzhen',
            children: [
              TPickerOption(label: 'Nanshan', value: 'Nanshan'),
              TPickerOption(label: 'Futian', value: 'Futian'),
            ],
          ),
        ],
      ),
      TPickerOption(
        label: 'Zhejiang',
        value: 'Zhejiang',
        children: [
          TPickerOption(
            label: 'Hangzhou',
            value: 'Hangzhou',
            children: [TPickerOption(label: 'Xihu', value: 'Xihu')],
          ),
        ],
      ),
    ]);
    await tester.pumpWidget(
      wrap(
        TPicker(
          items: linked,
          value: const ['Guangdong', 'Shenzhen', 'Nanshan'],
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.byType(ListWheelScrollView), findsNWidgets(3));

    await tester.pumpWidget(
      wrap(
        TPicker(
          items: const TPickerColumns([
            [
              TPickerOption(label: 'A', value: 'A'),
              TPickerOption(label: 'B', value: 'B'),
            ],
          ]),
          value: const ['B'],
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('linked selection emits a complete path for the new branch', (
    tester,
  ) async {
    const linked = TPickerLinked([
      TPickerOption(
        label: 'A',
        value: 'a',
        children: [
          TPickerOption(
            label: 'A1',
            value: 'a1',
            children: [TPickerOption(label: 'A11', value: 'a11')],
          ),
        ],
      ),
      TPickerOption(
        label: 'B',
        value: 'b',
        children: [
          TPickerOption(
            label: 'B1',
            value: 'b1',
            children: [
              TPickerOption(label: 'B11', value: 'b11', disabled: true),
              TPickerOption(label: 'B12', value: 'b12'),
            ],
          ),
        ],
      ),
    ]);
    TPickerValue? changed;
    await tester.pumpWidget(
      wrap(
        TPicker(
          items: linked,
          value: const ['a', 'a1', 'a11'],
          onChanged: (value) => changed = value,
        ),
      ),
    );

    await tester.drag(
      find.byType(ListWheelScrollView).first,
      const Offset(0, -100),
    );
    await tester.pumpAndSettle();

    expect(changed?.values, ['b', 'b1', 'b12']);
    expect(changed?.indexes, [1, 0, 1]);
  });

  testWidgets('linked controlled value rebuilds dependent columns', (
    tester,
  ) async {
    const linked = TPickerLinked([
      TPickerOption(
        label: 'A',
        value: 'a',
        children: [TPickerOption(label: 'A1', value: 'a1')],
      ),
      TPickerOption(
        label: 'B',
        value: 'b',
        children: [
          TPickerOption(label: 'B1', value: 'b1'),
          TPickerOption(label: 'B2', value: 'b2'),
        ],
      ),
    ]);
    var value = <Object?>['a', 'a1'];
    late StateSetter setState;
    await tester.pumpWidget(
      wrap(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return TPicker(
              items: linked,
              value: value,
              onChanged: (next) => setState(() => value = next.values),
            );
          },
        ),
      ),
    );

    await tester.drag(
      find.byType(ListWheelScrollView).first,
      const Offset(0, -100),
    );
    await tester.pumpAndSettle();

    expect(value, ['b', 'b1']);
    expect(find.text('B2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('invalid and short values use the first enabled item', (
    tester,
  ) async {
    const data = TPickerColumns([
      [
        TPickerOption(label: 'disabled', value: 0, disabled: true),
        TPickerOption(label: 'enabled', value: 1),
      ],
      [TPickerOption(label: 'only', value: 2)],
    ]);
    await tester.pumpWidget(
      wrap(TPicker(items: data, value: const ['missing'], onChanged: (_) {})),
    );

    final wheels = tester.widgetList<ListWheelScrollView>(
      find.byType(ListWheelScrollView),
    );
    expect(
      (wheels.first.controller as FixedExtentScrollController).selectedItem,
      1,
    );
    expect(
      (wheels.last.controller as FixedExtentScrollController).selectedItem,
      0,
    );
  });

  testWidgets('empty columns and empty linked roots render safely', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        TPicker(
          items: const TPickerColumns([[]]),
          value: const [],
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.byType(ListWheelScrollView), findsNothing);

    await tester.pumpWidget(
      wrap(
        TPicker(
          items: const TPickerLinked([]),
          value: const [],
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.byType(ListWheelScrollView), findsNothing);
  });
}
