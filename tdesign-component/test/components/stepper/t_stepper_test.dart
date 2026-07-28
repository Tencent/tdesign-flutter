import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(
    Widget child, {
    TStepperThemeData? stepperTheme,
    TThemeData? token,
    bool bareTheme = false,
  }) {
    final resolvedToken = token ?? TThemeData.defaultData();
    var theme = bareTheme
        ? ThemeData(extensions: [resolvedToken])
        : TThemeBuilder.light(resolvedToken);
    if (stepperTheme != null) {
      theme = theme.mergeExtension(stepperTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: Center(child: child)),
    );
  }

  EditableText editableText(WidgetTester tester) =>
      tester.widget<EditableText>(find.byType(EditableText));

  Size stepperSize(WidgetTester tester) {
    final row = find.descendant(
      of: find.byType(TStepper),
      matching: find.byType(Row),
    );
    return tester.getSize(row);
  }

  BoxDecoration iconDecoration(WidgetTester tester, IconData icon) {
    final finder = find.ancestor(
      of: find.byIcon(icon),
      matching: find.byType(DecoratedBox),
    );
    return tester.widget<DecoratedBox>(finder).decoration as BoxDecoration;
  }

  BoxDecoration inputDecoration(WidgetTester tester) {
    final finder = find.ancestor(
      of: find.byType(EditableText),
      matching: find.byType(DecoratedBox),
    );
    return tester.widget<DecoratedBox>(finder).decoration as BoxDecoration;
  }

  group('TStepper controlled behavior', () {
    testWidgets('renders controlled value and TDesign icons', (tester) async {
      await tester.pumpWidget(wrap(TStepper(value: 5, onChanged: (_) {})));

      expect(find.byIcon(TIcons.minus), findsOneWidget);
      expect(find.byIcon(TIcons.plus), findsOneWidget);
      expect(editableText(tester).controller.text, '5');
    });

    testWidgets('rejected change restores controlled value', (tester) async {
      num? changed;
      await tester.pumpWidget(wrap(TStepper(
        value: 5,
        onChanged: (value) => changed = value,
      )));

      await tester.tap(find.byIcon(TIcons.plus));
      await tester.pump();

      expect(changed, 6);
      expect(editableText(tester).controller.text, '5');
    });

    testWidgets('accepted change follows parent rebuild', (tester) async {
      num value = 5;
      await tester.pumpWidget(wrap(
        StatefulBuilder(
          builder: (context, setState) => TStepper(
            value: value,
            onChanged: (next) => setState(() => value = next),
          ),
        ),
      ));

      await tester.tap(find.byIcon(TIcons.plus));
      await tester.pump();

      expect(value, 6);
      expect(editableText(tester).controller.text, '6');
    });

    testWidgets('buttons clamp at bounds and emit once', (tester) async {
      var calls = 0;
      num? changed;
      await tester.pumpWidget(wrap(TStepper(
        value: 2,
        min: 0,
        max: 10,
        step: 5,
        onChanged: (value) {
          calls += 1;
          changed = value;
        },
      )));

      await tester.tap(find.byIcon(TIcons.minus));
      await tester.pump();

      expect(calls, 1);
      expect(changed, 0);
    });

    testWidgets('onChanged null disables buttons and input', (tester) async {
      await tester.pumpWidget(wrap(const TStepper(value: 5)));

      expect(editableText(tester).readOnly, isTrue);
      final disabledControls = find.byWidgetPredicate(
        (widget) => widget is GestureDetector && widget.onTap == null,
      );
      expect(disabledControls, findsNWidgets(2));
    });

    testWidgets('submitted input emits once and restores rejected value',
        (tester) async {
      var calls = 0;
      num? changed;
      await tester.pumpWidget(wrap(TStepper(
        value: 5,
        min: 0,
        max: 10,
        onChanged: (value) {
          calls += 1;
          changed = value;
        },
      )));

      await tester.enterText(find.byType(EditableText), '8');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(calls, 1);
      expect(changed, 8);
      expect(editableText(tester).controller.text, '5');
    });

    testWidgets('focus loss submits valid draft', (tester) async {
      num? changed;
      await tester.pumpWidget(wrap(TStepper(
        value: 5,
        onChanged: (value) => changed = value,
      )));

      await tester.enterText(find.byType(EditableText), '8');
      await tester.tapAt(const Offset(8, 8));
      await tester.pump();

      expect(changed, 8);
      expect(editableText(tester).controller.text, '5');
    });

    testWidgets('button uses valid draft as its base value', (tester) async {
      var calls = 0;
      num? changed;
      await tester.pumpWidget(wrap(TStepper(
        value: 5,
        onChanged: (value) {
          calls += 1;
          changed = value;
        },
      )));

      await tester.enterText(find.byType(EditableText), '7');
      await tester.tap(find.byIcon(TIcons.plus));
      await tester.pump();

      expect(calls, 1);
      expect(changed, 8);
    });

    testWidgets('invalid input restores current value', (tester) async {
      num? changed;
      await tester.pumpWidget(wrap(TStepper(
        value: 5,
        min: -10,
        onChanged: (value) => changed = value,
      )));

      await tester.enterText(find.byType(EditableText), '-');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(changed, isNull);
      expect(editableText(tester).controller.text, '5');
    });

    testWidgets('decimal step normalizes floating point precision',
        (tester) async {
      num value = 0.2;
      await tester.pumpWidget(wrap(
        StatefulBuilder(
          builder: (context, setState) => TStepper(
            value: value,
            min: 0,
            max: 1,
            step: 0.1,
            onChanged: (next) => setState(() => value = next),
          ),
        ),
      ));

      await tester.tap(find.byIcon(TIcons.plus));
      await tester.pump();

      expect(value, 0.3);
      expect(editableText(tester).controller.text, '0.3');
    });

    testWidgets('external value changes always sync input', (tester) async {
      await tester.pumpWidget(wrap(TStepper(value: 1, onChanged: (_) {})));
      await tester.enterText(find.byType(EditableText), '8');

      await tester.pumpWidget(wrap(TStepper(value: 9, onChanged: (_) {})));

      expect(editableText(tester).controller.text, '9');
    });

    test('rejects invalid configuration', () {
      expect(
        () => TStepper(value: 11, min: 0, max: 10),
        throwsAssertionError,
      );
      expect(
        () => TStepper(value: 0, min: 1, max: 0),
        throwsAssertionError,
      );
      expect(() => TStepper(value: 0, step: 0), throwsAssertionError);
    });
  });

  group('TStepper layout and theme', () {
    testWidgets('default medium normal geometry matches V2', (tester) async {
      await tester.pumpWidget(wrap(TStepper(value: 1, onChanged: (_) {})));

      expect(stepperSize(tester), const Size(94, 24));
      expect(tester.getSize(find.byIcon(TIcons.minus)), const Size(16, 16));
      expect(tester.getSize(find.byIcon(TIcons.plus)), const Size(16, 16));
    });

    testWidgets('small medium and large geometry matches V2', (tester) async {
      const cases = [
        (TStepperSize.small, Size(82, 20), Size(12, 12)),
        (TStepperSize.medium, Size(94, 24), Size(16, 16)),
        (TStepperSize.large, Size(105, 26), Size(20, 20)),
      ];

      for (final entry in cases) {
        await tester.pumpWidget(wrap(TStepper(
          value: 1,
          size: entry.$1,
          onChanged: (_) {},
        )));
        expect(stepperSize(tester), entry.$2);
        expect(tester.getSize(find.byIcon(TIcons.minus)), entry.$3);
      }
    });

    testWidgets('instance size and variant override component theme',
        (tester) async {
      await tester.pumpWidget(wrap(
        TStepper(
          value: 1,
          size: TStepperSize.small,
          variant: TStepperVariant.outline,
          onChanged: (_) {},
        ),
        stepperTheme: const TStepperThemeData(
          size: TStepperSize.large,
          variant: TStepperVariant.filled,
        ),
      ));

      expect(stepperSize(tester), const Size(74, 20));
      expect(iconDecoration(tester, TIcons.minus).border, isNotNull);
    });

    testWidgets('normal and filled variants keep 4px segment spacing',
        (tester) async {
      for (final variant in [
        TStepperVariant.normal,
        TStepperVariant.filled,
      ]) {
        await tester.pumpWidget(wrap(TStepper(
          value: 1,
          variant: variant,
          onChanged: (_) {},
        )));
        expect(stepperSize(tester).width, 94);
      }
    });

    testWidgets('filled applies radiusSmall to every segment', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrap(TStepper(
        value: 1,
        variant: TStepperVariant.filled,
        onChanged: (_) {},
      )));

      final expected = BorderRadius.circular(token.radiusSmall);
      expect(
        iconDecoration(tester, TIcons.minus).borderRadius,
        expected,
      );
      expect(inputDecoration(tester).borderRadius, expected);
      expect(
        iconDecoration(tester, TIcons.plus).borderRadius,
        expected,
      );
    });

    testWidgets('outline uses contiguous borders', (tester) async {
      await tester.pumpWidget(wrap(TStepper(
        value: 1,
        variant: TStepperVariant.outline,
        onChanged: (_) {},
      )));

      expect(stepperSize(tester), const Size(86, 24));
      expect(iconDecoration(tester, TIcons.minus).border, isA<Border>());
      final inputBorder = inputDecoration(tester).border! as Border;
      expect(inputBorder.top.style, BorderStyle.solid);
      expect(inputBorder.bottom.style, BorderStyle.solid);
      expect(inputBorder.left.style, BorderStyle.none);
      expect(inputBorder.right.style, BorderStyle.none);
    });

    testWidgets('min action disabled keeps filled segment background',
        (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrap(TStepper(
        value: 0,
        min: 0,
        variant: TStepperVariant.filled,
        onChanged: (_) {},
      )));

      expect(
        iconDecoration(tester, TIcons.minus).color,
        token.bgColorSecondaryContainer,
      );
      expect(
        iconDecoration(tester, TIcons.plus).color,
        token.bgColorSecondaryContainer,
      );
      expect(
        tester.widget<Icon>(find.byIcon(TIcons.minus)).color,
        token.textDisabledColor,
      );
    });

    testWidgets('whole disabled uses disabled background on every segment',
        (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrap(const TStepper(
        value: 5,
        variant: TStepperVariant.filled,
      )));

      expect(
        iconDecoration(tester, TIcons.minus).color,
        token.bgColorComponentDisabled,
      );
      expect(
        inputDecoration(tester).color,
        token.bgColorComponentDisabled,
      );
      expect(
        iconDecoration(tester, TIcons.plus).color,
        token.bgColorComponentDisabled,
      );
    });

    testWidgets('component theme controls geometry and colors', (tester) async {
      await tester.pumpWidget(wrap(
        TStepper(value: 1, onChanged: (_) {}),
        stepperTheme: const TStepperThemeData(
          variant: TStepperVariant.filled,
          controlSize: 32,
          inputWidth: 70,
          iconSize: 18,
          spacing: 6,
          foregroundColor: Colors.red,
          backgroundColor: Colors.yellow,
        ),
      ));

      expect(stepperSize(tester), const Size(146, 32));
      expect(tester.getSize(find.byIcon(TIcons.minus)), const Size(18, 18));
      expect(tester.widget<Icon>(find.byIcon(TIcons.plus)).color, Colors.red);
      expect(inputDecoration(tester).color, Colors.yellow);
    });

    testWidgets(
        'default line height is centered and component theme can override it',
        (tester) async {
      await tester.pumpWidget(wrap(
        TStepper(value: 1, onChanged: (_) {}),
      ));
      expect(editableText(tester).style.height, 1);

      await tester.pumpWidget(wrap(
        TStepper(value: 1, onChanged: (_) {}),
        stepperTheme: const TStepperThemeData(
          textStyle: TextStyle(height: 1.25),
        ),
      ));
      await tester.pumpAndSettle();
      expect(editableText(tester).style.height, 1.25);
    });

    testWidgets('DefaultTextStyle and IconTheme control unset foregrounds',
        (tester) async {
      await tester.pumpWidget(wrap(
        DefaultTextStyle(
          style: const TextStyle(color: Colors.red),
          child: IconTheme(
            data: const IconThemeData(color: Colors.green),
            child: TStepper(value: 1, onChanged: (_) {}),
          ),
        ),
      ));

      expect(editableText(tester).style.color, Colors.red);
      expect(
        tester.widget<Icon>(find.byIcon(TIcons.plus)).color,
        Colors.green,
      );
    });

    testWidgets('bare TThemeData supplies token background fallback',
        (tester) async {
      final token = TThemeData.defaultData().copyWithTThemeData(
        'stepper-test',
        colorMap: {
          'bgColorSecondaryContainer': Colors.orange,
        },
      );
      await tester.pumpWidget(wrap(
        TStepper(
          value: 1,
          variant: TStepperVariant.filled,
          onChanged: (_) {},
        ),
        token: token,
        bareTheme: true,
      ));

      expect(inputDecoration(tester).color, Colors.orange);
    });

    test('TStepperThemeData validates, copies and interpolates all fields', () {
      const base = TStepperThemeData(
        size: TStepperSize.small,
        variant: TStepperVariant.normal,
        inputWidth: 60,
        controlSize: 20,
        iconSize: 12,
        spacing: 4,
        borderRadius: BorderRadius.all(Radius.circular(3)),
        borderWidth: 1,
        foregroundColor: Colors.red,
        disabledForegroundColor: Colors.grey,
        backgroundColor: Colors.white,
        disabledBackgroundColor: Colors.black12,
        borderColor: Colors.black,
        textStyle: TextStyle(fontSize: 10),
      );
      const other = TStepperThemeData(
        size: TStepperSize.large,
        variant: TStepperVariant.outline,
        inputWidth: 100,
        controlSize: 26,
        iconSize: 20,
        spacing: 8,
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderWidth: 2,
        foregroundColor: Colors.blue,
        disabledForegroundColor: Colors.blueGrey,
        backgroundColor: Colors.yellow,
        disabledBackgroundColor: Colors.brown,
        borderColor: Colors.green,
        textStyle: TextStyle(fontSize: 16),
      );

      expect(
          base.copyWith(size: TStepperSize.medium).size, TStepperSize.medium);
      expect(
        base.copyWith(variant: TStepperVariant.filled).variant,
        TStepperVariant.filled,
      );
      expect(base.copyWith(inputWidth: 72).inputWidth, 72);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.75).size, TStepperSize.large);
      expect(base.lerp(other, 0.75).variant, TStepperVariant.outline);
      expect(base.lerp(other, 0.5).inputWidth, 80);
      expect(base.lerp(other, 0.5).controlSize, 23);
      expect(base.lerp(other, 0.5).iconSize, 16);
      expect(base.lerp(other, 0.5).spacing, 6);
      expect(base.lerp(other, 0.5).borderWidth, 1.5);
      expect(base.lerp(other, 0.5).textStyle?.fontSize, 13);
      expect(
        () => TStepperThemeData(inputWidth: 0),
        throwsAssertionError,
      );
    });
  });
}
