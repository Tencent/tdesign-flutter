import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child, {TInputThemeData? inputTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (inputTheme != null) {
      theme = theme.mergeExtension(inputTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  TextField field(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField));

  group('TInput v1 control', () {
    testWidgets('controller text and callbacks are forwarded', (tester) async {
      final controller = TextEditingController(text: 'initial');
      String? changed;
      String? submitted;
      var completed = false;
      await tester.pumpWidget(wrap(TInput(
        controller: controller,
        onChanged: (value) => changed = value,
        onSubmitted: (value) => submitted = value,
        onEditingComplete: () => completed = true,
        inputAction: TextInputAction.done,
      )));

      expect(find.text('initial'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'next');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(controller.text, 'next');
      expect(changed, 'next');
      expect(submitted, 'next');
      expect(completed, isTrue);
      controller.dispose();
    });

    testWidgets('initialValue initializes internal controller once',
        (tester) async {
      await tester.pumpWidget(wrap(const TInput(initialValue: 'first')));
      expect(find.text('first'), findsOneWidget);

      await tester.pumpWidget(wrap(const TInput(initialValue: 'second')));
      expect(find.text('first'), findsOneWidget);
      expect(find.text('second'), findsNothing);
    });

    testWidgets('switching external controllers updates rendered text',
        (tester) async {
      final first = TextEditingController(text: 'first');
      final second = TextEditingController(text: 'second');
      await tester.pumpWidget(wrap(TInput(controller: first)));
      await tester.pumpWidget(wrap(TInput(controller: second)));
      expect(find.text('second'), findsOneWidget);
      first.dispose();
      second.dispose();
    });

    test('controller and initialValue are mutually exclusive', () {
      final controller = TextEditingController();
      expect(
        () => TInput(controller: controller, initialValue: 'invalid'),
        throwsAssertionError,
      );
      controller.dispose();
    });
  });

  group('TInput Material semantics', () {
    testWidgets('content and decoration map to TextField', (tester) async {
      const base = InputDecoration(
        hintText: 'decoration hint',
        helperText: 'helper',
      );
      await tester.pumpWidget(wrap(TInput(
        label: 'label',
        hintText: 'property hint',
        prefix: const Icon(Icons.search),
        suffix: const Icon(Icons.info),
        maxLength: 20,
        autofocus: true,
        inputType: TextInputType.emailAddress,
        textAlign: TextAlign.center,
        inputFormatters: [LengthLimitingTextInputFormatter(5)],
        decoration: base,
      )));

      final textField = field(tester);
      expect(textField.decoration?.labelText, 'label');
      expect(textField.decoration?.hintText, 'decoration hint');
      expect(textField.decoration?.helperText, 'helper');
      expect(textField.decoration?.filled, isFalse);
      expect(textField.decoration?.fillColor, Colors.transparent);
      expect(textField.maxLength, 20);
      expect(textField.autofocus, isTrue);
      expect(textField.keyboardType, TextInputType.emailAddress);
      expect(textField.textAlign, TextAlign.center);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('explicit decoration fill is preserved', (tester) async {
      const fillColor = Color(0xFFE5E5E5);
      await tester.pumpWidget(wrap(const TInput(
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor,
        ),
      )));

      final decoration = field(tester).decoration;
      expect(decoration?.filled, isTrue);
      expect(decoration?.fillColor, fillColor);
    });

    testWidgets('global inputDecorationTheme does not leak into TInput',
        (tester) async {
      final token = TThemeData.defaultData();
      final theme = TThemeBuilder.light(token).copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.red,
          contentPadding: EdgeInsets.all(20),
        ),
      );

      await tester.pumpWidget(MaterialApp(
        theme: theme,
        home: const Scaffold(
          body: TInput(hintText: 'search'),
        ),
      ));

      final decoration = field(tester).decoration;
      expect(decoration?.filled, isFalse);
      expect(decoration?.fillColor, Colors.transparent);
      expect(decoration?.isCollapsed, isTrue);
      expect(decoration?.contentPadding, EdgeInsets.zero);
      expect(decoration?.hintMaxLines, 1);
    });

    testWidgets('enabled and readOnly follow TextField semantics',
        (tester) async {
      await tester.pumpWidget(wrap(const TInput(
        enabled: false,
        readOnly: true,
      )));
      expect(field(tester).enabled, isFalse);
      expect(field(tester).readOnly, isTrue);
    });

    testWidgets('obscureText remains independent from keyboard type',
        (tester) async {
      await tester.pumpWidget(wrap(const TInput(
        obscureText: true,
        inputType: TextInputType.visiblePassword,
      )));
      expect(field(tester).obscureText, isTrue);
      expect(field(tester).keyboardType, TextInputType.visiblePassword);
    });
  });

  group('TInput clear button', () {
    testWidgets('clears current controller and notifies onChanged',
        (tester) async {
      final controller = TextEditingController(text: 'content');
      String? changed;
      await tester.pumpWidget(wrap(TInput(
        controller: controller,
        onChanged: (value) => changed = value,
      )));

      await tester.tap(find.byIcon(TIcons.close_circle_filled));
      await tester.pump();
      expect(controller.text, isEmpty);
      expect(changed, '');
      controller.dispose();
    });

    testWidgets('suffix suppresses clear button', (tester) async {
      await tester.pumpWidget(wrap(const TInput(
        initialValue: 'content',
        suffix: Icon(Icons.info),
      )));
      expect(find.byIcon(TIcons.close_circle_filled), findsNothing);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('theme can hide or resize clear button', (tester) async {
      await tester.pumpWidget(wrap(
        const TInput(initialValue: 'content'),
        inputTheme: const TInputThemeData(showClearButton: false),
      ));
      expect(find.byIcon(TIcons.close_circle_filled), findsNothing);

      await tester.pumpWidget(wrap(
        const TInput(initialValue: 'content'),
        inputTheme: const TInputThemeData(clearIconSize: 28),
      ));
      await tester.pumpAndSettle();
      expect(
        tester.widget<IconButton>(find.byType(IconButton)).iconSize,
        28,
      );
    });

    testWidgets('disabled and readOnly clear buttons cannot mutate text',
        (tester) async {
      for (final input in const [
        TInput(initialValue: 'disabled', enabled: false),
        TInput(initialValue: 'readonly', readOnly: true),
      ]) {
        await tester.pumpWidget(wrap(input));
        expect(tester.widget<IconButton>(find.byType(IconButton)).onPressed,
            isNull);
      }
    });
  });
}
