import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  const options = [
    TTreeSelectOption(
      label: 'Fruit',
      value: 'fruit',
      children: [
        TTreeSelectOption(label: 'Apple', value: 'apple'),
        TTreeSelectOption(label: 'Banana', value: 'banana'),
      ],
    ),
    TTreeSelectOption(
      label: 'Region',
      value: 'region',
      children: [
        TTreeSelectOption(
          label: 'China',
          value: 'china',
          children: [
            TTreeSelectOption(
              label: 'Guangdong',
              value: 'guangdong',
              children: [
                TTreeSelectOption(label: 'Shenzhen', value: 'shenzhen'),
              ],
            ),
          ],
        ),
      ],
    ),
    TTreeSelectOption(label: 'Disabled', value: 'disabled', disabled: true),
  ];

  Widget wrap(Widget child, {TTreeSelectThemeData? treeTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (treeTheme != null) {
      theme = theme.mergeExtension(treeTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  testWidgets('single selection is controlled and only leaves emit',
      (tester) async {
    var value = <List<Object?>>[];
    var calls = 0;
    await tester.pumpWidget(wrap(StatefulBuilder(
      builder: (context, setState) => TTreeSelect(
        options: options,
        value: value,
        onChanged: (next) {
          calls += 1;
          setState(() => value = next);
        },
      ),
    )));

    await tester.tap(find.text('Fruit'));
    await tester.pump();
    expect(find.text('Apple'), findsOneWidget);
    expect(calls, 0);

    await tester.tap(find.text('Apple'));
    await tester.pump();
    expect(value, [
      ['fruit', 'apple'],
    ]);
    expect(calls, 1);
  });

  testWidgets('multiple mode toggles complete leaf paths', (tester) async {
    var value = <List<Object?>>[];
    await tester.pumpWidget(wrap(StatefulBuilder(
      builder: (context, setState) => TTreeSelect(
        options: options,
        value: value,
        multiple: true,
        onChanged: (next) => setState(() => value = next),
      ),
    )));
    await tester.tap(find.text('Fruit'));
    await tester.pump();
    await tester.tap(find.text('Apple'));
    await tester.pump();
    await tester.tap(find.text('Banana'));
    await tester.pump();
    expect(value, [
      ['fruit', 'apple'],
      ['fruit', 'banana'],
    ]);

    await tester.tap(find.text('Apple'));
    await tester.pump();
    expect(value, [
      ['fruit', 'banana'],
    ]);
  });

  testWidgets('supports arbitrary tree depth', (tester) async {
    List<List<Object?>>? changed;
    await tester.pumpWidget(wrap(TTreeSelect(
      options: options,
      value: const [],
      onChanged: (value) => changed = value,
    )));
    await tester.tap(find.text('Region'));
    await tester.pump();
    await tester.tap(find.text('China'));
    await tester.pump();
    await tester.tap(find.text('Guangdong'));
    await tester.pump();
    expect(find.text('Shenzhen'), findsOneWidget);
    await tester.tap(find.text('Shenzhen'));
    expect(changed, [
      ['region', 'china', 'guangdong', 'shenzhen'],
    ]);
  });

  testWidgets('external value chooses the visible branch', (tester) async {
    await tester.pumpWidget(wrap(const TTreeSelect(
      options: options,
      value: [
        ['fruit', 'banana'],
      ],
      onChanged: _ignore,
    )));
    expect(find.text('Banana'), findsOneWidget);
    expect(find.byIcon(TIcons.check), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('Fruit')).style?.color,
      TThemeData.defaultData().brandNormalColor,
    );
    expect(
      tester.widget<Text>(find.text('Banana')).style?.color,
      TThemeData.defaultData().textColorPrimary,
    );

    await tester.pumpWidget(wrap(const TTreeSelect(
      options: options,
      value: [
        ['missing'],
      ],
      onChanged: _ignore,
    )));
    expect(find.text('Fruit'), findsOneWidget);
    expect(find.text('Apple'), findsNothing);
  });

  testWidgets('default visual style matches develop tree select layout',
      (tester) async {
    final token = TThemeData.defaultData();
    await tester.pumpWidget(wrap(const Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 375,
        child: TTreeSelect(
          options: options,
          value: [
            ['fruit', 'apple'],
          ],
          onChanged: _ignore,
        ),
      ),
    )));

    expect(tester.getSize(find.byType(TTreeSelect)), const Size(375, 336));
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints?.minWidth == 106 &&
            widget.constraints?.maxWidth == 106 &&
            widget.color == token.bgColorSecondaryContainer,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints?.minWidth == 269 &&
            widget.constraints?.maxWidth == 269 &&
            widget.color == token.bgColorContainer,
      ),
      findsOneWidget,
    );
    expect(
      tester.widget<Text>(find.text('Fruit')).style,
      TextStyle(
        color: token.brandNormalColor,
        fontSize: token.fontBodyLarge?.size ?? 16,
        fontWeight: FontWeight.w600,
      ),
    );
    expect(
      tester.widget<Text>(find.text('Apple')).style,
      TextStyle(
        color: token.textColorPrimary,
        fontSize: token.fontBodyLarge?.size ?? 16,
        fontWeight: FontWeight.w400,
      ),
    );
    final checkIcon = tester.widget<Icon>(find.byIcon(TIcons.check));
    expect(checkIcon.size, 24);
    expect(checkIcon.color, token.brandNormalColor);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is CustomPaint && widget.size == const Size(9, 9),
      ),
      findsOneWidget,
    );
  });

  testWidgets('deep tree keeps narrow intermediate columns and fills leaf',
      (tester) async {
    await tester.pumpWidget(wrap(const Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 375,
        child: TTreeSelect(
          options: options,
          value: [
            ['region', 'china', 'guangdong', 'shenzhen'],
          ],
          onChanged: _ignore,
        ),
      ),
    )));

    expect(find.text('Shenzhen'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints?.minWidth == 106 &&
            widget.constraints?.maxWidth == 106,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints?.minWidth == 103 &&
            widget.constraints?.maxWidth == 103,
      ),
      findsNWidgets(2),
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints?.minWidth == 184 &&
            widget.constraints?.maxWidth == 184,
      ),
      findsOneWidget,
    );
  });

  testWidgets('does not auto-select and null onChanged disables the panel',
      (tester) async {
    await tester.pumpWidget(wrap(const TTreeSelect(
      options: options,
      value: [],
    )));
    expect(find.text('Apple'), findsNothing);
    final tree = find.byType(TTreeSelect);
    expect(
      tester
          .widget<AbsorbPointer>(
            find.descendant(of: tree, matching: find.byType(AbsorbPointer)),
          )
          .absorbing,
      isTrue,
    );
  });

  testWidgets('disabled options do not emit', (tester) async {
    var changed = false;
    await tester.pumpWidget(wrap(TTreeSelect(
      options: options,
      value: const [],
      onChanged: (_) => changed = true,
    )));
    await tester.tap(find.text('Disabled'));
    expect(changed, isFalse);
  });

  testWidgets('theme controls dimensions, colors, and text styles',
      (tester) async {
    const selectedStyle = TextStyle(color: Colors.red);
    await tester.pumpWidget(wrap(
      const TTreeSelect(
        options: options,
        value: [
          ['fruit', 'apple'],
        ],
        onChanged: _ignore,
      ),
      treeTheme: const TTreeSelectThemeData(
        height: 280,
        rootColumnWidth: 120,
        columnWidth: 200,
        itemHeight: 60,
        backgroundColor: Colors.white,
        rootBackgroundColor: Colors.grey,
        selectedBackgroundColor: Colors.yellow,
        textStyle: TextStyle(color: Colors.black),
        selectedTextStyle: selectedStyle,
        disabledTextStyle: TextStyle(color: Colors.blueGrey),
        indicatorColor: Colors.green,
      ),
    ));

    expect(tester.widget<Text>(find.text('Apple')).style, selectedStyle);
    expect(find.byIcon(TIcons.check), findsOneWidget);
    expect(tester.widget<Icon>(find.byIcon(TIcons.check)).color, Colors.green);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints?.minWidth == 120 &&
            widget.constraints?.maxWidth == 120 &&
            widget.color == Colors.grey,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.constraints?.minWidth == 200 &&
            widget.constraints?.maxWidth == 200 &&
            widget.color == Colors.white,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Container && widget.constraints?.maxHeight == 280,
      ),
      findsOneWidget,
    );
  });

  test('TTreeSelectThemeData copyWith and lerp', () {
    const base = TTreeSelectThemeData(
      height: 300,
      rootColumnWidth: 100,
      columnWidth: 180,
      itemHeight: 50,
      backgroundColor: Colors.white,
      rootBackgroundColor: Colors.grey,
      selectedBackgroundColor: Colors.yellow,
      textStyle: TextStyle(fontSize: 12),
      selectedTextStyle: TextStyle(fontSize: 14),
      disabledTextStyle: TextStyle(color: Colors.grey),
      indicatorColor: Colors.blue,
    );
    const other = TTreeSelectThemeData(
      height: 400,
      rootColumnWidth: 140,
      columnWidth: 220,
      itemHeight: 70,
      backgroundColor: Colors.black,
      rootBackgroundColor: Colors.white,
      selectedBackgroundColor: Colors.green,
      textStyle: TextStyle(fontSize: 16),
      selectedTextStyle: TextStyle(fontSize: 18),
      disabledTextStyle: TextStyle(color: Colors.black),
      indicatorColor: Colors.red,
    );

    expect(base.copyWith().height, 300);
    expect(base.copyWith().indicatorColor, Colors.blue);
    expect(base.copyWith(height: 320).height, 320);
    expect(base.lerp(null, 0.5), same(base));
    expect(base.lerp(other, 0.5).height, 350);
  });
}

void _ignore(List<List<Object?>> _) {}
