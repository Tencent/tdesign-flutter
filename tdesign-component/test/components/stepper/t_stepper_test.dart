import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child, {TStepperThemeData? stepperTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (stepperTheme != null) {
      theme = theme.mergeExtension(stepperTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: Center(child: child)),
    );
  }

  TextField textField(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField));

  group('TStepper v1 controlled behavior', () {
    testWidgets('renders controlled value and icons', (tester) async {
      await tester.pumpWidget(wrap(TStepper(value: 5, onChanged: (_) {})));

      expect(find.byType(TStepper), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(textField(tester).controller?.text, '5');
    });

    testWidgets('add increments by step', (tester) async {
      num? changed;
      await tester.pumpWidget(wrap(TStepper(
        value: 5,
        step: 2,
        onChanged: (value) => changed = value,
      )));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(changed, 7);
      expect(textField(tester).controller?.text, '7');
    });

    testWidgets('remove decrements by step', (tester) async {
      num? changed;
      await tester.pumpWidget(wrap(TStepper(
        value: 5,
        step: 2,
        onChanged: (value) => changed = value,
      )));

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(changed, 3);
      expect(textField(tester).controller?.text, '3');
    });

    testWidgets('buttons clamp at min and max without duplicate callback',
        (tester) async {
      var calls = 0;
      num? changed;
      await tester.pumpWidget(wrap(TStepper(
        value: 10,
        min: 0,
        max: 10,
        step: 5,
        onChanged: (value) {
          calls += 1;
          changed = value;
        },
      )));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(calls, 0);
      expect(changed, isNull);

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
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(calls, 1);
      expect(changed, 0);
      expect(textField(tester).controller?.text, '0');
    });

    testWidgets('onChanged null disables buttons and input', (tester) async {
      await tester.pumpWidget(wrap(const TStepper(value: 5)));

      expect(textField(tester).enabled, isFalse);
      final disabledControls = find.byWidgetPredicate(
        (widget) => widget is GestureDetector && widget.onTap == null,
      );
      expect(disabledControls, findsNWidgets(2));
    });

    testWidgets('submitted input parses and clamps', (tester) async {
      num? changed;
      await tester.pumpWidget(wrap(TStepper(
        value: 5,
        min: 0,
        max: 10,
        onChanged: (value) => changed = value,
      )));

      await tester.enterText(find.byType(TextField), '8');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(changed, 8);

      await tester.enterText(find.byType(TextField), '99');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(changed, 10);
      expect(textField(tester).controller?.text, '10');
    });

    testWidgets('invalid input restores current value', (tester) async {
      num? changed;
      await tester.pumpWidget(wrap(TStepper(
        value: 5,
        onChanged: (value) => changed = value,
      )));

      await tester.enterText(find.byType(TextField), '-');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(changed, isNull);
      expect(textField(tester).controller?.text, '5');
    });

    testWidgets('decimal values are supported and formatted', (tester) async {
      num? changed;
      await tester.pumpWidget(wrap(TStepper(
        value: 1.5,
        step: 0.25,
        min: 0,
        max: 2,
        onChanged: (value) => changed = value,
      )));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(changed, 1.75);
      expect(textField(tester).controller?.text, '1.75');

      await tester.pumpWidget(wrap(TStepper(
        value: 2.0,
        onChanged: (_) {},
      )));
      expect(textField(tester).controller?.text, '2');
    });

    testWidgets('didUpdateWidget syncs external value changes', (tester) async {
      await tester.pumpWidget(wrap(TStepper(value: 1, onChanged: (_) {})));
      expect(textField(tester).controller?.text, '1');

      await tester.pumpWidget(wrap(TStepper(value: 9, onChanged: (_) {})));
      expect(textField(tester).controller?.text, '9');
    });
  });

  group('TStepper theme', () {
    testWidgets('default layout matches the 24px TDesign stepper geometry',
        (tester) async {
      await tester.pumpWidget(wrap(TStepper(value: 1, onChanged: (_) {})));

      final inputBox = tester.getSize(
        find.ancestor(
          of: find.byType(TextField),
          matching: find.byType(SizedBox),
        ),
      );
      expect(inputBox, const Size(38, 24));
      expect(tester.getSize(find.byIcon(Icons.remove)), const Size(16, 16));
      expect(tester.getSize(find.byIcon(Icons.add)), const Size(16, 16));
    });

    testWidgets('filled variant and inputWidth come from theme',
        (tester) async {
      await tester.pumpWidget(wrap(
        TStepper(value: 1, onChanged: (_) {}),
        stepperTheme: const TStepperThemeData(
          variant: TStepperVariant.filled,
          inputWidth: 88,
        ),
      ));

      final inputBox = tester.getSize(
        find.ancestor(
            of: find.byType(TextField), matching: find.byType(SizedBox)),
      );
      expect(inputBox.width, 88);
      expect(textField(tester).decoration?.filled, isTrue);
      expect(
        textField(tester).decoration?.fillColor,
        TThemeData.defaultData().bgColorSecondaryContainer,
      );
    });

    testWidgets('normal variant keeps transparent input decoration',
        (tester) async {
      await tester.pumpWidget(wrap(
        TStepper(value: 1, onChanged: (_) {}),
        stepperTheme: const TStepperThemeData(variant: TStepperVariant.normal),
      ));

      expect(textField(tester).decoration?.filled, isFalse);
    });

    test('TStepperThemeData copyWith and lerp', () {
      const base = TStepperThemeData(
        variant: TStepperVariant.normal,
        inputWidth: 60,
      );
      const other = TStepperThemeData(
        variant: TStepperVariant.filled,
        inputWidth: 100,
      );

      expect(base.copyWith(variant: TStepperVariant.filled).variant,
          TStepperVariant.filled);
      expect(base.copyWith(inputWidth: 72).inputWidth, 72);
      expect(base.lerp(null, 0.5), same(base));
      expect(base.lerp(other, 0.25).variant, TStepperVariant.normal);
      expect(base.lerp(other, 0.75).variant, TStepperVariant.filled);
      expect(base.lerp(other, 0.5).inputWidth, 80);
    });
  });
}
