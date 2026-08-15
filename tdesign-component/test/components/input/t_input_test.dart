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
    testWidgets('multiline 较小 maxLines 会收敛默认 minLines', (tester) async {
      await tester.pumpWidget(wrap(const TInput.multiline(maxLines: 2)));

      expect(field(tester).minLines, 2);
      expect(field(tester).maxLines, 2);
      expect(tester.takeException(), isNull);
    });

    testWidgets('controller text and callbacks are forwarded', (tester) async {
      final controller = TextEditingController(text: 'initial');
      String? changed;
      String? submitted;
      var completed = false;
      await tester.pumpWidget(
        wrap(
          TInput(
            controller: controller,
            onChanged: (value) => changed = value,
            onSubmitted: (value) => submitted = value,
            onEditingComplete: () => completed = true,
            inputAction: TextInputAction.done,
          ),
        ),
      );

      expect(find.text('initial'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'next');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(controller.text, 'next');
      expect(changed, 'next');
      expect(submitted, 'next');
      expect(completed, isTrue);
      controller.dispose();
    });

    testWidgets('initialValue initializes internal controller once', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const TInput(initialValue: 'first')));
      expect(find.text('first'), findsOneWidget);

      await tester.pumpWidget(wrap(const TInput(initialValue: 'second')));
      expect(find.text('first'), findsOneWidget);
      expect(find.text('second'), findsNothing);
    });

    testWidgets('switching external controllers updates rendered text', (
      tester,
    ) async {
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
      await tester.pumpWidget(
        wrap(
          TInput(
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
          ),
        ),
      );

      final textField = field(tester);
      // label 现在渲染为左侧固定标签，而非 Material 浮动标签（labelText）。
      expect(textField.decoration?.labelText, isNull);
      expect(find.text('label'), findsOneWidget);
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
      await tester.pumpWidget(
        wrap(
          const TInput(
            decoration: InputDecoration(filled: true, fillColor: fillColor),
          ),
        ),
      );

      final decoration = field(tester).decoration;
      expect(decoration?.filled, isTrue);
      expect(decoration?.fillColor, fillColor);
    });

    testWidgets('global inputDecorationTheme does not leak into TInput', (
      tester,
    ) async {
      final token = TThemeData.defaultData();
      final theme = TThemeBuilder.light(token).copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.red,
          contentPadding: EdgeInsets.all(20),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(body: TInput(hintText: 'search')),
        ),
      );

      final decoration = field(tester).decoration;
      expect(decoration?.filled, isFalse);
      expect(decoration?.fillColor, Colors.transparent);
      expect(decoration?.isCollapsed, isTrue);
      expect(decoration?.contentPadding, EdgeInsets.zero);
      expect(decoration?.hintMaxLines, 1);
    });

    testWidgets('enabled and readOnly follow TextField semantics', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const TInput(enabled: false, readOnly: true)),
      );
      expect(field(tester).enabled, isFalse);
      expect(field(tester).readOnly, isTrue);
    });

    testWidgets('obscureText remains independent from keyboard type', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TInput(
            obscureText: true,
            inputType: TextInputType.visiblePassword,
          ),
        ),
      );
      expect(field(tester).obscureText, isTrue);
      expect(field(tester).keyboardType, TextInputType.visiblePassword);
    });
  });

  group('TInput label layout', () {
    testWidgets('label renders as left-fixed label, not Material floating', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const TInput(label: '标签文字')));
      expect(find.text('标签文字'), findsOneWidget);
      // 未走 Material 浮动标签。
      expect(field(tester).decoration?.labelText, isNull);
      expect(field(tester).decoration?.hintText, isNull);
    });

    testWidgets('required renders red asterisk after label', (tester) async {
      await tester.pumpWidget(
        wrap(const TInput(label: '标签文字', required: true)),
      );
      expect(find.text('标签文字 *'), findsOneWidget);
    });

    testWidgets('required without label keeps plain input', (tester) async {
      await tester.pumpWidget(wrap(const TInput(required: true)));
      expect(find.text(' *'), findsNothing);
      expect(field(tester), isNotNull);
    });

    testWidgets('vertical layout places label in a Column', (tester) async {
      await tester.pumpWidget(
        wrap(const TInput(label: '标签文字', layout: TInputLayout.vertical)),
      );
      expect(find.text('标签文字'), findsOneWidget);
      // 纵向布局中 label 与输入区不在同一 Row。
      expect(
        find.ancestor(
          of: find.text('标签文字'),
          matching: find.byType(Column),
        ),
        findsWidgets,
      );
    });

    testWidgets('horizontal layout keeps label and input in same Row', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const TInput(label: '标签文字', hintText: '请输入文字')),
      );
      final row = find.ancestor(
        of: find.byType(TextField),
        matching: find.byType(Row),
      );
      expect(
        find.descendant(of: row, matching: find.text('标签文字')),
        findsOneWidget,
      );
    });
  });

  group('TInput clear button', () {
    testWidgets('clears current controller and notifies onChanged', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'content');
      String? changed;
      await tester.pumpWidget(
        wrap(
          TInput(controller: controller, onChanged: (value) => changed = value),
        ),
      );

      await tester.tap(find.byIcon(TIcons.close_circle_filled));
      await tester.pump();
      expect(controller.text, isEmpty);
      expect(changed, '');
      controller.dispose();
    });

    testWidgets('suffix suppresses clear button', (tester) async {
      await tester.pumpWidget(
        wrap(const TInput(initialValue: 'content', suffix: Icon(Icons.info))),
      );
      expect(find.byIcon(TIcons.close_circle_filled), findsNothing);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('theme can hide or resize clear button', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TInput(initialValue: 'content'),
          inputTheme: const TInputThemeData(showClearButton: false),
        ),
      );
      expect(find.byIcon(TIcons.close_circle_filled), findsNothing);

      await tester.pumpWidget(
        wrap(
          const TInput(initialValue: 'content'),
          inputTheme: const TInputThemeData(clearIconSize: 28),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.widget<IconButton>(find.byType(IconButton)).iconSize, 28);
    });

    testWidgets('disabled and readOnly clear buttons cannot mutate text', (
      tester,
    ) async {
      for (final input in const [
        TInput(initialValue: 'disabled', enabled: false),
        TInput(initialValue: 'readonly', readOnly: true),
      ]) {
        await tester.pumpWidget(wrap(input));
        expect(
          tester.widget<IconButton>(find.byType(IconButton)).onPressed,
          isNull,
        );
      }
    });
  });

  group('TInput H5-aligned capabilities', () {
    testWidgets('tips renders as helper text with status color', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TInput(
            status: TInputStatus.error,
            tips: '辅助说明',
            label: '标签文字',
          ),
        ),
      );
      final decoration = field(tester).decoration;
      expect(decoration?.helperText, '辅助说明');
      expect(
        decoration?.helperStyle?.color,
        isNotNull,
      );
    });

    testWidgets('status maps to error border color', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TInput(
            status: TInputStatus.error,
            label: '标签文字',
          ),
        ),
      );
      final decoration = field(tester).decoration;
      expect(decoration?.errorBorder, isNotNull);
      expect(decoration?.focusedErrorBorder, isNotNull);
    });

    testWidgets('align overrides textAlign on TextField', (tester) async {
      await tester.pumpWidget(
        wrap(const TInput(align: TInputAlign.right, label: '价格')),
      );
      expect(field(tester).textAlign, TextAlign.end);
    });

    testWidgets('clearable false hides clear button', (tester) async {
      await tester.pumpWidget(
        wrap(const TInput(initialValue: 'content', clearable: false)),
      );
      expect(find.byIcon(TIcons.close_circle_filled), findsNothing);
    });

    testWidgets('clearTrigger focus hides clear until focused', (tester) async {
      await tester.pumpWidget(
        wrap(const TInput(initialValue: 'content', clearTrigger: TInputClearTrigger.focus)),
      );
      // 未聚焦时不显示。
      expect(find.byIcon(TIcons.close_circle_filled), findsNothing);

      await tester.tap(find.byType(TextField));
      await tester.pump();
      expect(find.byIcon(TIcons.close_circle_filled), findsOneWidget);
    });

    testWidgets('maxcharacter truncates Chinese as 2 characters', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const TInput(maxcharacter: 4)),
      );
      await tester.enterText(find.byType(TextField), '汉字abc');
      // 汉字(2+2=4)已满，后续 'a' 无法输入。
      expect(find.text('汉字'), findsOneWidget);
    });

    testWidgets('allowInputOverMax permits over-limit input', (tester) async {
      await tester.pumpWidget(
        wrap(const TInput(maxLength: 2, allowInputOverMax: true)),
      );
      await tester.enterText(find.byType(TextField), '12345');
      expect(find.text('12345'), findsOneWidget);
    });

    testWidgets('borderless sets all borders to none', (tester) async {
      await tester.pumpWidget(
        wrap(const TInput(borderless: true, label: '标签文字')),
      );
      final decoration = field(tester).decoration;
      expect(decoration?.border, InputBorder.none);
      expect(decoration?.enabledBorder, InputBorder.none);
      expect(decoration?.focusedBorder, InputBorder.none);
    });
  });
}
