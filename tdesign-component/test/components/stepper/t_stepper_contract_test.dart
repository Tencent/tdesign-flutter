import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget host(Widget child, {TStepperThemeData? theme, TThemeData? token}) =>
      MaterialApp(
        themeAnimationDuration: Duration.zero,
        theme: TThemeBuilder.light(
          token ?? TThemeData.defaultData(),
        ).mergeExtension(theme ?? const TStepperThemeData()),
        home: Scaffold(body: Center(child: child)),
      );

  EditableText input(WidgetTester tester) =>
      tester.widget<EditableText>(find.byType(EditableText));

  Size size(WidgetTester tester) => tester.getSize(
    find.descendant(of: find.byType(TStepper), matching: find.byType(Row)),
  );

  BoxDecoration inputDecoration(WidgetTester tester) =>
      tester
              .widget<DecoratedBox>(
                find.ancestor(
                  of: find.byType(EditableText),
                  matching: find.byType(DecoratedBox),
                ),
              )
              .decoration
          as BoxDecoration;

  for (final entry in [(0, TIcons.minus, 4), (10, TIcons.plus, 6)]) {
    for (final accepts in [true, false]) {
      testWidgets('draft at ${entry.$1}, parent accepts: $accepts', (
        tester,
      ) async {
        num value = entry.$1;
        final requests = <num>[];
        await tester.pumpWidget(
          host(
            StatefulBuilder(
              builder: (context, setState) => TStepper(
                value: value,
                max: 10,
                onChanged: (next) {
                  requests.add(next);
                  if (accepts) {
                    setState(() => value = next);
                  }
                },
              ),
            ),
          ),
        );
        await tester.enterText(find.byType(EditableText), '5');
        await tester.pump();
        await tester.tap(find.byIcon(entry.$2));
        await tester.pump();
        expect(requests, [entry.$3]);
        expect(
          input(tester).controller.text,
          '${accepts ? entry.$3 : entry.$1}',
        );
        if (!accepts) {
          await tester.tap(find.byIcon(entry.$2));
          await tester.pump();
          expect(requests, hasLength(1));
        }
      });
    }
  }

  testWidgets('draft boundaries disable the matching action immediately', (
    tester,
  ) async {
    final requests = <num>[];
    await tester.pumpWidget(
      host(TStepper(value: 5, max: 10, onChanged: requests.add)),
    );
    await tester.enterText(find.byType(EditableText), '0');
    await tester.pump();
    await tester.tap(find.byIcon(TIcons.minus));
    expect(requests, isEmpty);
    await tester.tap(find.byIcon(TIcons.plus));
    await tester.pump();
    expect(requests, [1]);
    await tester.enterText(find.byType(EditableText), '10');
    await tester.pump();
    await tester.tap(find.byIcon(TIcons.plus));
    expect(requests, [1]);
    await tester.tap(find.byIcon(TIcons.minus));
    await tester.pump();
    expect(requests, [1, 9]);
  });

  testWidgets('invalid draft falls back to the controlled button bounds', (
    tester,
  ) async {
    final requests = <num>[];
    await tester.pumpWidget(
      host(TStepper(value: 0, max: 10, onChanged: requests.add)),
    );
    await tester.enterText(find.byType(EditableText), '-');
    await tester.pump();
    await tester.tap(find.byIcon(TIcons.minus));
    expect(requests, isEmpty);
    await tester.tap(find.byIcon(TIcons.plus));
    await tester.pump();
    expect(requests, [1]);
    expect(input(tester).controller.text, '0');
  });

  test('theme interpolation keeps exact endpoints and unset fields', () {
    const a = TStepperThemeData();
    const b = TStepperThemeData(controlSize: 40);
    expect(a.lerp(b, 0), same(a));
    expect(a.lerp(b, 1), same(b));
    final unset = a.lerp(a, 0.5);
    expect(unset.size, isNull);
    expect(unset.variant, isNull);
    expect(unset.inputWidth, isNull);
    expect(unset.controlSize, isNull);
    expect(unset.iconSize, isNull);
    expect(unset.spacing, isNull);
    expect(unset.borderWidth, isNull);
    expect(unset.borderRadius, isNull);
    expect(unset.foregroundColor, isNull);
    expect(unset.disabledForegroundColor, isNull);
    expect(unset.backgroundColor, isNull);
    expect(unset.disabledBackgroundColor, isNull);
    expect(unset.borderColor, isNull);
    expect(unset.textStyle, isNull);
  });

  for (final entry in [
    (TStepperSize.small, 20.0, 34.0, 12.0),
    (TStepperSize.medium, 24.0, 38.0, 16.0),
    (TStepperSize.large, 26.0, 45.0, 20.0),
  ]) {
    test('nullable geometry uses ${entry.$1} defaults in both directions', () {
      final a = TStepperThemeData(size: entry.$1);
      final b = TStepperThemeData(
        size: entry.$1,
        controlSize: 40,
        inputWidth: 80,
        iconSize: 24,
        spacing: 8,
        borderWidth: 3,
      );
      for (final t in [0.25, 0.5, 0.75]) {
        final forward = a.lerp(b, t);
        final reverse = b.lerp(a, 1 - t);
        expect(forward.controlSize, entry.$2 + (40 - entry.$2) * t);
        expect(reverse.controlSize, forward.controlSize);
        expect(forward.inputWidth, entry.$3 + (80 - entry.$3) * t);
        expect(reverse.inputWidth, forward.inputWidth);
        expect(forward.iconSize, entry.$4 + (24 - entry.$4) * t);
        expect(reverse.iconSize, forward.iconSize);
        expect(forward.spacing, 4 + 4 * t);
        expect(reverse.spacing, forward.spacing);
        expect(forward.borderWidth, 1 + 2 * t);
        expect(reverse.borderWidth, forward.borderWidth);
      }
    });
  }

  testWidgets(
    'rendered interpolation uses the instance size and can be copied',
    (tester) async {
      const a = TStepperThemeData(size: TStepperSize.large);
      const b = TStepperThemeData(
        controlSize: 40,
        inputWidth: 80,
        iconSize: 24,
        spacing: 8,
      );
      final middle = a.lerp(b, 0.5).copyWith(foregroundColor: Colors.red);
      await tester.pumpWidget(
        host(
          TStepper(value: 3, size: TStepperSize.small, onChanged: (_) {}),
          theme: middle,
        ),
      );
      expect(size(tester), const Size(129, 30));
      expect(tester.widget<Icon>(find.byIcon(TIcons.plus)).size, 18);
      expect(
        tester.widget<Icon>(find.byIcon(TIcons.plus)).color,
        const Color(0xfff44336),
      );
      expect(input(tester).style.color, const Color(0xfff44336));
    },
  );

  testWidgets('nullable visual styles interpolate from effective tokens', (
    tester,
  ) async {
    final token = TThemeData.defaultData().copyWithTThemeData(
      'stepper-lerp',
      colorMap: {
        'textColorPrimary': Colors.red,
        'textDisabledColor': Colors.green,
        'bgColorSecondaryContainer': Colors.yellow,
        'bgColorComponentDisabled': Colors.orange,
        'componentBorderColor': Colors.blue,
      },
    );
    const a = TStepperThemeData();
    const b = TStepperThemeData(
      foregroundColor: Colors.black,
      disabledForegroundColor: Colors.black,
      backgroundColor: Colors.black,
      disabledBackgroundColor: Colors.black,
      borderColor: Colors.black,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      textStyle: TextStyle(fontSize: 20, height: 1.5),
    );
    for (final reverse in [false, true]) {
      final theme = reverse ? b.lerp(a, 0.5) : a.lerp(b, 0.5);
      for (final disabled in [false, true]) {
        await tester.pumpWidget(
          host(
            TStepper(
              value: 3,
              variant: TStepperVariant.filled,
              onChanged: disabled ? null : (_) {},
            ),
            theme: theme,
            token: token,
          ),
        );
        expect(
          input(tester).style.color,
          Color.lerp(disabled ? Colors.green : Colors.red, Colors.black, 0.5),
        );
        expect(input(tester).style.fontSize, 16);
        expect(input(tester).style.height, 1.25);
        expect(
          inputDecoration(tester).color,
          Color.lerp(
            disabled ? Colors.orange : Colors.yellow,
            Colors.black,
            0.5,
          ),
        );
        expect(
          inputDecoration(tester).borderRadius,
          BorderRadius.circular((token.radiusSmall + 10) / 2),
        );
      }
      await tester.pumpWidget(
        host(
          TStepper(
            value: 3,
            variant: TStepperVariant.outline,
            onChanged: (_) {},
          ),
          theme: theme,
          token: token,
        ),
      );
      expect(
        (inputDecoration(tester).border! as Border).top.color,
        Color.lerp(Colors.blue, Colors.black, 0.5),
      );
    }
  });

  testWidgets('inherited text and icon defaults survive nested interpolation', (
    tester,
  ) async {
    const a = TStepperThemeData();
    const b = TStepperThemeData(controlSize: 40, foregroundColor: Colors.black);
    final theme = a
        .lerp(b, 0.5)
        .lerp(
          const TStepperThemeData(
            controlSize: 48,
            foregroundColor: Colors.white,
          ),
          0.5,
        );
    await tester.pumpWidget(
      host(
        DefaultTextStyle(
          style: const TextStyle(color: Colors.red),
          child: IconTheme(
            data: const IconThemeData(color: Colors.green),
            child: TStepper(value: 3, onChanged: (_) {}),
          ),
        ),
        theme: theme,
      ),
    );
    expect(size(tester).height, 40);
    expect(
      input(tester).style.color,
      Color.lerp(Color.lerp(Colors.red, Colors.black, 0.5), Colors.white, 0.5),
    );
    expect(
      tester.widget<Icon>(find.byIcon(TIcons.plus)).color,
      Color.lerp(
        Color.lerp(Colors.green, Colors.black, 0.5),
        Colors.white,
        0.5,
      ),
    );
  });

  testWidgets('AnimatedTheme renders valid endpoint and midpoint geometry', (
    tester,
  ) async {
    Widget scene(TStepperThemeData theme) => MaterialApp(
      themeAnimationDuration: const Duration(milliseconds: 200),
      themeAnimationCurve: Curves.linear,
      theme: TThemeBuilder.light(
        TThemeData.defaultData(),
      ).mergeExtension(theme),
      home: Scaffold(body: TStepper(value: 3, onChanged: (_) {})),
    );
    await tester.pumpWidget(scene(const TStepperThemeData()));
    expect(size(tester).height, 24);
    await tester.pumpWidget(scene(const TStepperThemeData(controlSize: 40)));
    expect(size(tester).height, 24);
    await tester.pump(const Duration(milliseconds: 100));
    expect(size(tester).height, 32);
    await tester.pumpAndSettle();
    expect(size(tester).height, 40);
    expect(tester.takeException(), isNull);
  });
}
