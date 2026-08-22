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

    test('password toggle only supports single-line input', () {
      expect(
        () => TInput(maxLines: 2, showPasswordToggle: true),
        throwsAssertionError,
      );
    });
  });

  group('TInput Material semantics', () {
    testWidgets('content and behavior map to TextField', (tester) async {
      await tester.pumpWidget(
        wrap(
          TInput(
            hintText: 'property hint',
            prefix: const Icon(Icons.search),
            suffix: const Icon(Icons.info),
            maxLength: 20,
            autofocus: true,
            inputType: TextInputType.emailAddress,
            textAlign: TextAlign.center,
            inputFormatters: [LengthLimitingTextInputFormatter(5)],
          ),
        ),
      );

      final textField = field(tester);
      expect(textField.decoration?.hintText, 'property hint');
      expect(textField.decoration?.filled, isFalse);
      expect(textField.decoration?.fillColor, Colors.transparent);
      expect(textField.maxLength, isNull);
      expect(
        textField.inputFormatters,
        contains(isA<LengthLimitingTextInputFormatter>()),
      );
      expect(textField.autofocus, isTrue);
      expect(textField.keyboardType, TextInputType.emailAddress);
      expect(textField.textAlign, TextAlign.center);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
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

    testWidgets('文本和提示词遵循 TDesign 颜色契约', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrap(const TInput(hintText: 'hint')));

      expect(field(tester).style?.color, token.textColorPrimary);
      expect(
        field(tester).decoration?.hintStyle?.color,
        token.textColorPlaceholder,
      );

      await tester.pumpWidget(
        wrap(const TInput(hintText: 'hint', enabled: false)),
      );
      expect(field(tester).style?.color, token.textDisabledColor);
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).style.color,
        token.textDisabledColor,
      );

      await tester.pumpWidget(
        wrap(
          const TInput(initialValue: 'disabled', enabled: false),
          inputTheme: const TInputThemeData(
            textStyle: TextStyle(color: Colors.black),
          ),
        ),
      );
      expect(field(tester).style?.color, token.textDisabledColor);
      expect(
        field(tester).decoration?.hintStyle?.color,
        token.textDisabledColor,
      );

      for (final status in const [
        TInputStatus.success,
        TInputStatus.warning,
        TInputStatus.error,
      ]) {
        await tester.pumpWidget(
          wrap(TInput(initialValue: 'status', status: status)),
        );
        expect(field(tester).style?.color, token.textColorPrimary);
      }

      await tester.pumpWidget(
        wrap(const TInput(initialValue: 'readonly', readOnly: true)),
      );
      expect(field(tester).style?.color, token.textColorPrimary);
    });

    testWidgets('explicit Flutter typography precedes token defaults', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontSize: 19, height: 1.5),
            ),
            extensions: [TThemeData.defaultData()],
          ),
          home: const Scaffold(body: TInput(hintText: 'hint')),
        ),
      );

      expect(field(tester).style?.fontSize, 19);
      expect(field(tester).style?.height, 1.5);
      expect(field(tester).decoration?.hintStyle?.fontSize, 19);
      expect(field(tester).decoration?.hintStyle?.height, 1.5);
    });

    testWidgets('partial component styles preserve token typography', (
      tester,
    ) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrap(
          const TInput(hintText: 'hint', initialValue: 'value'),
          inputTheme: const TInputThemeData(
            textStyle: TextStyle(color: Colors.white),
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      );

      final inputStyle = field(tester).style;
      final hintStyle = field(tester).decoration?.hintStyle;
      expect(inputStyle?.color, Colors.white);
      expect(inputStyle?.fontSize, token.fontBodyLarge?.size);
      expect(inputStyle?.height, token.fontBodyLarge?.height);
      expect(inputStyle?.fontWeight, token.fontBodyLarge?.fontWeight);
      expect(hintStyle?.color, Colors.grey);
      expect(hintStyle?.fontSize, token.fontBodyLarge?.size);
      expect(hintStyle?.height, token.fontBodyLarge?.height);
      expect(hintStyle?.fontWeight, token.fontBodyLarge?.fontWeight);
    });

    testWidgets('component text color applies across semantic statuses', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TInput(initialValue: 'error', status: TInputStatus.error),
          inputTheme: const TInputThemeData(
            textStyle: TextStyle(color: Colors.white),
          ),
        ),
      );
      expect(field(tester).style?.color, Colors.white);

      await tester.pumpWidget(
        wrap(
          const TInput(
            initialValue: 'explicit error',
            status: TInputStatus.error,
            style: TextStyle(color: Colors.purple),
          ),
          inputTheme: const TInputThemeData(
            textStyle: TextStyle(color: Colors.white),
          ),
        ),
      );
      expect(field(tester).style?.color, Colors.purple);
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

    testWidgets('focus and text changes do not recreate the TextField', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TInput(
            initialValue: 'content',
            clearButtonMode: TInputClearButtonMode.focused,
          ),
        ),
      );
      final editor = field(tester);

      await tester.tap(find.byType(TextField));
      await tester.pump();
      expect(identical(editor, field(tester)), isTrue);

      await tester.enterText(find.byType(TextField), 'changed');
      await tester.pump();
      expect(identical(editor, field(tester)), isTrue);
    });

    testWidgets(
      'disabled color is not overridden by Material body text color',
      (tester) async {
        final token = TThemeData.defaultData();
        final baseTheme = TThemeBuilder.light(token);
        final theme = baseTheme.copyWith(
          textTheme: baseTheme.textTheme.copyWith(
            bodyLarge: const TextStyle(color: Colors.black),
          ),
        );
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: const Scaffold(
              body: TInput(initialValue: '不可编辑', enabled: false),
            ),
          ),
        );

        expect(field(tester).style?.color, token.textDisabledColor);
      },
    );

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

    testWidgets(
      'password toggle owns visibility state and uses TDesign icons',
      (tester) async {
        await tester.pumpWidget(
          wrap(
            const TInput(
              initialValue: 'secret',
              obscureText: true,
              showPasswordToggle: true,
            ),
          ),
        );

        expect(field(tester).obscureText, isTrue);
        expect(find.byIcon(TIcons.browse_off), findsOneWidget);
        expect(find.byTooltip('显示密码'), findsOneWidget);
        final passwordButton = find.ancestor(
          of: find.byIcon(TIcons.browse_off),
          matching: find.byType(IconButton),
        );
        final inputShell = find
            .descendant(
              of: find.byType(TInput),
              matching: find.byType(DecoratedBox),
            )
            .first;
        expect(tester.getSize(passwordButton), const Size.square(24));
        expect(tester.getSize(inputShell).height, 56);

        await tester.tap(find.byTooltip('显示密码'));
        await tester.pump();

        expect(field(tester).obscureText, isFalse);
        expect(find.byIcon(TIcons.browse), findsOneWidget);
        expect(find.byTooltip('隐藏密码'), findsOneWidget);

        await tester.tap(find.byTooltip('隐藏密码'));
        await tester.pump();
        expect(field(tester).obscureText, isTrue);
      },
    );

    testWidgets('maxLength indicator counts user-perceived characters', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TInput(
            initialValue: '👨‍👩‍👧‍👦',
            maxLength: 10,
            indicator: true,
          ),
        ),
      );

      expect(find.text('1/10'), findsOneWidget);
      expect(find.text('7/10'), findsNothing);
    });

    testWidgets('prefix and suffix icons use the 24dp input icon size', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TInput(prefix: Icon(Icons.search), suffix: Icon(Icons.info)),
        ),
      );

      expect(tester.getSize(find.byIcon(Icons.search)), const Size(24, 24));
      expect(tester.getSize(find.byIcon(Icons.info)), const Size(24, 24));
      final inputShell = find
          .descendant(
            of: find.byType(TInput),
            matching: find.byType(DecoratedBox),
          )
          .first;
      expect(tester.getSize(inputShell).height, 56);
      expect(
        tester
            .widget<IconTheme>(
              find
                  .ancestor(
                    of: find.byIcon(Icons.search),
                    matching: find.byType(IconTheme),
                  )
                  .first,
            )
            .data
            .color,
        TThemeData.defaultData().textColorPrimary,
      );
      expect(
        tester
            .widget<IconTheme>(
              find
                  .ancestor(
                    of: find.byIcon(Icons.info),
                    matching: find.byType(IconTheme),
                  )
                  .first,
            )
            .data
            .color,
        TThemeData.defaultData().textColorPlaceholder,
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
          TInput(
            controller: controller,
            clearButtonMode: TInputClearButtonMode.always,
            onChanged: (value) => changed = value,
          ),
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
        wrap(
          const TInput(
            initialValue: 'content',
            clearButtonMode: TInputClearButtonMode.always,
            suffix: Icon(Icons.info),
          ),
        ),
      );
      expect(find.byIcon(TIcons.close_circle_filled), findsNothing);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('theme can hide or resize clear button', (tester) async {
      await tester.pumpWidget(
        wrap(
          const TInput(initialValue: 'content'),
          inputTheme: const TInputThemeData(
            clearButtonMode: TInputClearButtonMode.never,
          ),
        ),
      );
      expect(find.byIcon(TIcons.close_circle_filled), findsNothing);

      await tester.pumpWidget(
        wrap(
          const TInput(
            initialValue: 'content',
            clearButtonMode: TInputClearButtonMode.always,
          ),
          inputTheme: const TInputThemeData(clearIconSize: 28),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.widget<IconButton>(find.byType(IconButton)).iconSize, 28);
    });

    testWidgets(
      'status keeps the default clear color and theme can override it',
      (tester) async {
        final token = TThemeData.defaultData();
        for (final status in TInputStatus.values) {
          await tester.pumpWidget(
            wrap(
              TInput(
                initialValue: 'content',
                status: status,
                clearButtonMode: TInputClearButtonMode.always,
              ),
            ),
          );
          expect(
            tester.widget<Icon>(find.byIcon(TIcons.close_circle_filled)).color,
            token.textColorPlaceholder,
          );
        }

        await tester.pumpWidget(
          wrap(
            const TInput(
              initialValue: 'invalid',
              status: TInputStatus.error,
              clearButtonMode: TInputClearButtonMode.always,
            ),
            inputTheme: TInputThemeData(clearIconColor: token.errorNormalColor),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester.widget<Icon>(find.byIcon(TIcons.close_circle_filled)).color,
          token.errorNormalColor,
        );
      },
    );

    testWidgets('focused mode only shows clear button while focused', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TInput(
            initialValue: 'content',
            clearButtonMode: TInputClearButtonMode.focused,
          ),
        ),
      );
      expect(find.byIcon(TIcons.close_circle_filled), findsNothing);

      await tester.tap(find.byType(TextField));
      await tester.pump();
      expect(find.byIcon(TIcons.close_circle_filled), findsOneWidget);
    });

    testWidgets('disabled and readOnly clear buttons cannot mutate text', (
      tester,
    ) async {
      for (final input in const [
        TInput(
          initialValue: 'disabled',
          enabled: false,
          clearButtonMode: TInputClearButtonMode.always,
        ),
        TInput(
          initialValue: 'readonly',
          readOnly: true,
          clearButtonMode: TInputClearButtonMode.always,
        ),
      ]) {
        await tester.pumpWidget(wrap(input));
        expect(
          tester.widget<IconButton>(find.byType(IconButton)).onPressed,
          isNull,
        );
      }
    });
  });

  group('TInput TDesign shell', () {
    testWidgets('status colors shell without recoloring input text', (
      tester,
    ) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrap(const TInput(status: TInputStatus.error, initialValue: 'error')),
      );

      expect(field(tester).style?.color, token.textColorPrimary);
      final borderedShell = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .firstWhere(
            (shell) =>
                shell.decoration is BoxDecoration &&
                (shell.decoration as BoxDecoration).border != null,
          );
      final border = (borderedShell.decoration as BoxDecoration).border!;
      expect((border as Border).bottom.color, token.errorNormalColor);

      await tester.pumpWidget(
        wrap(
          const TInput(
            status: TInputStatus.error,
            borderless: true,
            initialValue: 'error',
          ),
        ),
      );

      final shells = tester.widgetList<DecoratedBox>(find.byType(DecoratedBox));
      expect(
        shells.any(
          (shell) =>
              shell.decoration is BoxDecoration &&
              (shell.decoration as BoxDecoration).border == null,
        ),
        isTrue,
      );
      expect(field(tester).decoration?.border, InputBorder.none);
    });

    testWidgets('rounded single-line input uses a complete outer border', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const TInput(),
          inputTheme: const TInputThemeData(borderRadius: 6),
        ),
      );

      final shell = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .whereType<DecoratedBox>()
          .firstWhere((box) => box.decoration is BoxDecoration);
      final decoration = shell.decoration as BoxDecoration;
      expect(decoration.border, isA<Border>());
      final border = decoration.border! as Border;
      expect(border.top.style, BorderStyle.solid);
      expect(border.right.style, BorderStyle.solid);
      expect(border.bottom.style, BorderStyle.solid);
      expect(border.left.style, BorderStyle.solid);
    });

    testWidgets('maxCharacter uses weighted ASCII and non-ASCII length', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const TInput(maxCharacter: 4, initialValue: 'a中')),
      );

      final formatter = field(tester).inputFormatters!.last;
      expect(
        formatter
            .formatEditUpdate(
              const TextEditingValue(),
              const TextEditingValue(text: 'ab中'),
            )
            .text,
        'ab中',
      );
      expect(
        formatter
            .formatEditUpdate(
              const TextEditingValue(),
              const TextEditingValue(text: 'ab中x'),
            )
            .text,
        isEmpty,
      );
    });
  });
}
