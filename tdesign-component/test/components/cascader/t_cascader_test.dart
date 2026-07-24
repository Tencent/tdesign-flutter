import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  const options = [
    TCascaderOption(
      label: 'Guangdong',
      value: 'gd',
      children: [
        TCascaderOption(
          label: 'Shenzhen',
          value: 'sz',
          children: [
            TCascaderOption(label: 'Nanshan', value: 'ns'),
            TCascaderOption(label: 'Futian', value: 'ft', disabled: true),
          ],
        ),
        TCascaderOption(label: 'Guangzhou', value: 'gz'),
      ],
    ),
    TCascaderOption(label: 'Disabled', value: 'disabled', disabled: true),
  ];

  Widget wrap(Widget child, {TCascaderThemeData? cascaderTheme}) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          TThemeData.defaultData(),
          if (cascaderTheme != null) cascaderTheme,
        ],
      ),
      home: Scaffold(body: child),
    );
  }

  group('TCascader controlled behavior', () {
    testWidgets('selects a complete path through controlled rebuilds',
        (tester) async {
      var value = <Object?>[];
      late StateSetter update;
      await tester.pumpWidget(wrap(StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return TCascader(
            options: options,
            value: value,
            onChanged: (next) => setState(() => value = next),
          );
        },
      )));
      expect(find.text('Guangdong'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('cascader-gd')));
      await tester.pump();
      expect(value, ['gd']);
      expect(find.text('Shenzhen'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('cascader-sz')));
      await tester.pump();
      expect(value, ['gd', 'sz']);
      expect(find.text('Nanshan'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('cascader-ns')));
      await tester.pump();
      expect(value, ['gd', 'sz', 'ns']);

      value = ['gd'];
      update(() {});
      await tester.pump();
      expect(find.text('Shenzhen'), findsOneWidget);

      await tester.tap(find.text('Guangdong'));
      await tester.pump();
      expect(find.text('Disabled'), findsOneWidget);
    });

    testWidgets('onChanged null disables all interaction', (tester) async {
      await tester.pumpWidget(wrap(const TCascader(
        options: options,
        value: [],
      )));
      final cascader = find.byType(TCascader);
      expect(
        tester
            .widget<AbsorbPointer>(
              find.descendant(
                  of: cascader, matching: find.byType(AbsorbPointer)),
            )
            .absorbing,
        isTrue,
      );
      expect(
        tester
            .widget<AnimatedOpacity>(
              find.descendant(
                  of: cascader, matching: find.byType(AnimatedOpacity)),
            )
            .opacity,
        0.5,
      );
    });

    testWidgets('disabled option does not emit changes', (tester) async {
      var changed = false;
      await tester.pumpWidget(wrap(TCascader(
        options: options,
        value: const [],
        onChanged: (_) => changed = true,
      )));
      final tile = tester.widget<ListTile>(
        find.ancestor(
          of: find.text('Disabled'),
          matching: find.byType(ListTile),
        ),
      );
      expect(tile.enabled, isFalse);
      await tester.tap(find.text('Disabled'), warnIfMissed: false);
      expect(changed, isFalse);
    });

    testWidgets('external invalid path safely falls back to root',
        (tester) async {
      await tester.pumpWidget(wrap(TCascader(
        options: options,
        value: const ['missing'],
        onChanged: (_) {},
      )));
      expect(find.text('Guangdong'), findsOneWidget);
    });

    testWidgets('complete leaf path opens the leaf level', (tester) async {
      await tester.pumpWidget(wrap(
        TCascader(
          options: options,
          value: const ['gd', 'sz', 'ns'],
          onChanged: (_) {},
        ),
        cascaderTheme: const TCascaderThemeData(
          activeTextStyle: TextStyle(color: Colors.red),
        ),
      ));

      final selectedTile = tester.widget<ListTile>(
        find.byKey(const ValueKey('cascader-ns')),
      );
      expect(selectedTile.selected, isTrue);
      await tester.tap(find.text('Shenzhen'));
      await tester.pump();
      expect(find.text('Guangzhou'), findsOneWidget);
    });

    testWidgets('disabled theme style is applied', (tester) async {
      const disabledStyle = TextStyle(color: Colors.purple);
      await tester.pumpWidget(wrap(
        TCascader(
          options: options,
          value: const [],
          onChanged: (_) {},
        ),
        cascaderTheme: const TCascaderThemeData(
          disabledTextStyle: disabledStyle,
        ),
      ));

      expect(tester.widget<Text>(find.text('Disabled')).style, disabledStyle);
    });
  });

  group('TCascader variants and theme', () {
    testWidgets('step variant renders vertical navigation', (tester) async {
      await tester.pumpWidget(wrap(TCascader(
        options: options,
        value: const ['gd'],
        variant: TCascaderVariant.step,
        onChanged: (_) {},
      )));
      expect(find.byType(Column), findsWidgets);
      expect(find.text('请选择'), findsOneWidget);
    });

    testWidgets('theme controls panel and text styles', (tester) async {
      const active = TextStyle(color: Colors.red);
      await tester.pumpWidget(wrap(
        TCascader(
          options: options,
          value: const ['gd'],
          placeholder: 'Next',
          onChanged: (_) {},
        ),
        cascaderTheme: const TCascaderThemeData(
          height: 280,
          backgroundColor: Colors.yellow,
          borderRadius: 12,
          textStyle: TextStyle(color: Colors.black),
          activeTextStyle: active,
          disabledTextStyle: TextStyle(color: Colors.grey),
          navigationPadding: EdgeInsets.all(6),
          dividerColor: Colors.blue,
        ),
      ));
      expect(find.text('Next'), findsOneWidget);
      expect(tester.widget<Text>(find.text('Next')).style, active);
      expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Container && widget.constraints?.maxHeight == 280,
          ),
          findsOneWidget);
    });
  });

  test('TCascaderThemeData copyWith and lerp', () {
    const base = TCascaderThemeData(
      height: 300,
      backgroundColor: Colors.white,
      borderRadius: 4,
      textStyle: TextStyle(fontSize: 12),
      activeTextStyle: TextStyle(fontSize: 14),
      disabledTextStyle: TextStyle(color: Colors.grey),
      navigationPadding: EdgeInsets.all(4),
      dividerColor: Colors.black,
    );
    const other = TCascaderThemeData(
      height: 400,
      backgroundColor: Colors.black,
      borderRadius: 8,
      textStyle: TextStyle(fontSize: 16),
      activeTextStyle: TextStyle(fontSize: 18),
      disabledTextStyle: TextStyle(color: Colors.white),
      navigationPadding: EdgeInsets.all(8),
      dividerColor: Colors.white,
    );
    expect(base.copyWith().height, 300);
    expect(base.copyWith(height: 320).height, 320);
    expect(base.lerp(null, 0.5), same(base));
    expect(base.lerp(other, 0.5).height, 350);
  });
}
