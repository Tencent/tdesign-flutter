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
    testWidgets('provides its own TDesign surface for popup composition', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: TCascader(
            options: options,
            value: const ['gd', 'sz', 'ns'],
            onChanged: (_) {},
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(
        find.descendant(
          of: find.byType(TCascader),
          matching: find.byType(Material),
        ),
        findsNothing,
      );
      final surface = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(TCascader),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(
        (surface.decoration as BoxDecoration).color,
        TThemeData.defaultData().bgColorContainer,
      );
    });

    testWidgets('selects a complete path through controlled rebuilds', (
      tester,
    ) async {
      var value = <Object?>[];
      late StateSetter update;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return TCascader(
                options: options,
                value: value,
                onChanged: (next) => setState(() => value = next),
              );
            },
          ),
        ),
      );
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
      await tester.pumpWidget(
        wrap(const TCascader(options: options, value: [])),
      );
      final cascader = find.byType(TCascader);
      expect(
        tester
            .widget<AbsorbPointer>(
              find.descendant(
                of: cascader,
                matching: find.byType(AbsorbPointer),
              ),
            )
            .absorbing,
        isTrue,
      );
      expect(
        tester
            .widget<AnimatedOpacity>(
              find.descendant(
                of: cascader,
                matching: find.byType(AnimatedOpacity),
              ),
            )
            .opacity,
        0.5,
      );
    });

    testWidgets('disabled option does not emit changes', (tester) async {
      var changed = false;
      await tester.pumpWidget(
        wrap(
          TCascader(
            options: options,
            value: const [],
            onChanged: (_) => changed = true,
          ),
        ),
      );
      final tile = tester.widget<GestureDetector>(
        find.byKey(const ValueKey('cascader-disabled')),
      );
      expect(tile.onTap, isNull);
      await tester.tap(find.text('Disabled'), warnIfMissed: false);
      expect(changed, isFalse);
    });

    testWidgets('external invalid path safely falls back to root', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          TCascader(
            options: options,
            value: const ['missing'],
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Guangdong'), findsOneWidget);
    });

    testWidgets('complete leaf path opens the leaf level', (tester) async {
      await tester.pumpWidget(
        wrap(
          TCascader(
            options: options,
            value: const ['gd', 'sz', 'ns'],
            onChanged: (_) {},
          ),
          cascaderTheme: const TCascaderThemeData(
            activeTextStyle: TextStyle(color: Colors.red),
          ),
        ),
      );

      final selectedSemantics = tester.widget<Semantics>(
        find
            .ancestor(
              of: find.byKey(const ValueKey('cascader-ns')),
              matching: find.byType(Semantics),
            )
            .first,
      );
      expect(selectedSemantics.properties.selected, isTrue);
      final indicator = tester.widget<Icon>(find.byIcon(TIcons.check));
      expect(indicator.size, 24);
      expect(indicator.color, TThemeData.defaultData().brandNormalColor);
      await tester.tap(find.text('Shenzhen'));
      await tester.pump();
      expect(find.text('Guangzhou'), findsOneWidget);
      expect(find.byIcon(TIcons.check), findsNothing);
      expect(find.byIcon(TIcons.chevron_right), findsOneWidget);
    });

    testWidgets('only the selected leaf shows the check indicator', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          TCascader(
            options: options,
            value: const ['gd', 'sz', 'ns'],
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byIcon(TIcons.check), findsOneWidget);
      final selectedTile = find.byKey(const ValueKey('cascader-ns'));
      expect(
        find.descendant(of: selectedTile, matching: find.byIcon(TIcons.check)),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('cascader-ft')),
          matching: find.byIcon(TIcons.check),
        ),
        findsNothing,
      );
    });

    testWidgets('default selected text stays on neutral TDesign text color', (
      tester,
    ) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrap(
          TCascader(
            options: options,
            value: const ['gd', 'sz', 'ns'],
            onChanged: (_) {},
          ),
        ),
      );

      final selectedText = tester.widget<Text>(
        find.descendant(
          of: find.byKey(const ValueKey('cascader-ns')),
          matching: find.text('Nanshan'),
        ),
      );
      expect(selectedText.style?.color, token.textColorPrimary);
      expect(selectedText.style?.color, isNot(token.brandNormalColor));
      expect(selectedText.style?.fontWeight, FontWeight.w400);
    });

    testWidgets('disabled theme style is applied', (tester) async {
      const disabledStyle = TextStyle(color: Colors.purple);
      await tester.pumpWidget(
        wrap(
          TCascader(options: options, value: const [], onChanged: (_) {}),
          cascaderTheme: const TCascaderThemeData(
            disabledTextStyle: disabledStyle,
          ),
        ),
      );

      expect(
        tester.widget<Text>(find.text('Disabled')).style?.color,
        disabledStyle.color,
      );
    });
  });

  group('TCascader variants and theme', () {
    testWidgets('step variant renders vertical navigation', (tester) async {
      await tester.pumpWidget(
        wrap(
          TCascader(
            options: options,
            value: const ['gd'],
            variant: TCascaderVariant.step,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.byType(Column), findsWidgets);
      expect(find.text('请选择'), findsOneWidget);
    });

    testWidgets('theme controls panel and text styles', (tester) async {
      const active = TextStyle(color: Colors.red);
      await tester.pumpWidget(
        wrap(
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
        ),
      );
      expect(find.text('Next'), findsOneWidget);
      expect(tester.widget<Text>(find.text('Next')).style?.color, active.color);
      expect(tester.getSize(find.byType(TCascader)).height, 280);
    });

    testWidgets('component theme controls the indicator color', (tester) async {
      await tester.pumpWidget(
        wrap(
          TCascader(
            options: options,
            value: const ['gd', 'sz', 'ns'],
            onChanged: (_) {},
          ),
          cascaderTheme: const TCascaderThemeData(indicatorColor: Colors.green),
        ),
      );

      expect(
        tester.widget<Icon>(find.byIcon(TIcons.check)).color,
        Colors.green,
      );
    });

    testWidgets(
      'implicit Material component defaults do not replace TD colors',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              listTileTheme: const ListTileThemeData(
                selectedColor: Colors.green,
              ),
              extensions: [TThemeData.defaultData()],
            ),
            home: Scaffold(
              body: TCascader(
                options: options,
                value: const ['gd', 'sz', 'ns'],
                onChanged: (_) {},
              ),
            ),
          ),
        );

        final selectedText = tester.widget<Text>(
          find.descendant(
            of: find.byKey(const ValueKey('cascader-ns')),
            matching: find.text('Nanshan'),
          ),
        );
        expect(
          selectedText.style?.color,
          TThemeData.defaultData().textColorPrimary,
        );
        expect(
          tester.widget<Icon>(find.byIcon(TIcons.check)).color,
          TThemeData.defaultData().brandNormalColor,
        );
      },
    );

    testWidgets('subtitle follows the internal active level', (tester) async {
      var value = <Object?>[];
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) => TCascader(
              options: options,
              value: value,
              subtitles: const ['Province', 'City', 'District'],
              onChanged: (next) => setState(() => value = next),
            ),
          ),
        ),
      );

      expect(find.text('Province'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('cascader-gd')));
      await tester.pump();
      expect(find.text('City'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('cascader-sz')));
      await tester.pump();
      expect(find.text('District'), findsOneWidget);

      await tester.tap(find.text('Guangdong'));
      await tester.pump();
      expect(find.text('Province'), findsOneWidget);
      expect(find.text('District'), findsNothing);
    });

    testWidgets('locks design-critical row and separator defaults', (
      tester,
    ) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            dividerTheme: const DividerThemeData(),
            listTileTheme: const ListTileThemeData(
              minVerticalPadding: 40,
              iconColor: Colors.orange,
            ),
            extensions: [token],
          ),
          home: Scaffold(
            body: TCascader(
              options: options,
              value: const [],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(
        tester.getSize(find.byKey(const ValueKey('cascader-gd'))).height,
        56,
      );
      expect(
        tester.widget<Divider>(find.byType(Divider)).color,
        token.componentStrokeColor,
      );
      expect(
        tester.widget<Icon>(find.byIcon(TIcons.chevron_right).last).color,
        token.textColorPlaceholder,
      );
    });

    testWidgets('does not apply the device top inset to option rows', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          MediaQuery(
            data: const MediaQueryData(padding: EdgeInsets.only(top: 64)),
            child: TCascader(
              options: options,
              value: const [],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      final dividerBottom = tester.getBottomLeft(find.byType(Divider)).dy;
      final firstOptionTop = tester
          .getTopLeft(find.byKey(const ValueKey('cascader-gd')))
          .dy;
      expect(firstOptionTop, dividerBottom);
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
      indicatorColor: Colors.red,
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
      indicatorColor: Colors.blue,
      navigationPadding: EdgeInsets.all(8),
      dividerColor: Colors.white,
    );
    expect(base.copyWith().height, 300);
    expect(base.copyWith(height: 320).height, 320);
    expect(
      base.copyWith(indicatorColor: Colors.green).indicatorColor,
      Colors.green,
    );
    expect(base.lerp(null, 0.5), same(base));
    expect(base.lerp(other, 0.5).height, 350);
    expect(
      base.lerp(other, 0.5).indicatorColor,
      Color.lerp(Colors.red, Colors.blue, 0.5),
    );
  });
}
