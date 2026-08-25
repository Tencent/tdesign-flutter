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

  testWidgets('TTextarea delegates every public editing option to TInput', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'initial');
    final focusNode = FocusNode();
    await tester.pumpWidget(
      wrap(
        TTextarea(
          controller: controller,
          label: '标题',
          enabled: true,
          readOnly: true,
          hintText: 'hint',
          prefix: const Icon(Icons.search),
          suffix: const Icon(Icons.info),
          maxLines: 8,
          minLines: 2,
          maxLength: 50,
          autofocus: true,
          focusNode: focusNode,
          inputType: TextInputType.multiline,
          inputAction: TextInputAction.newline,
          textAlign: TextAlign.center,
          inputFormatters: [LengthLimitingTextInputFormatter(20)],
        ),
      ),
    );

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller, same(controller));
    expect(field.readOnly, isTrue);
    expect(field.maxLines, 8);
    expect(field.minLines, 2);
    expect(field.maxLength, isNull);
    expect(
      field.inputFormatters,
      contains(isA<LengthLimitingTextInputFormatter>()),
    );
    expect(field.autofocus, isTrue);
    expect(field.focusNode, same(focusNode));
    expect(field.textInputAction, TextInputAction.newline);
    expect(field.textAlign, TextAlign.center);
    expect(find.text('标题'), findsOneWidget);
    expect(field.decoration?.filled, isFalse);
    expect(field.decoration?.fillColor, Colors.transparent);
    controller.dispose();
    focusNode.dispose();
  });

  testWidgets('TTextarea forwards submission and editing completion', (
    tester,
  ) async {
    String? submitted;
    var completed = false;
    await tester.pumpWidget(
      wrap(
        TTextarea(
          initialValue: 'text',
          inputAction: TextInputAction.done,
          onSubmitted: (value) => submitted = value,
          onEditingComplete: () => completed = true,
        ),
      ),
    );
    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(submitted, 'text');
    expect(completed, isTrue);
  });

  testWidgets('multiline minimum rows can come from theme', (tester) async {
    await tester.pumpWidget(
      wrap(
        const TTextarea(),
        inputTheme: const TInputThemeData(multilineMinLines: 6),
      ),
    );
    expect(tester.widget<TextField>(find.byType(TextField)).minLines, 6);
  });

  testWidgets('bordered, indicator and maxCharacter map to TInput shell', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        const TTextarea(
          initialValue: 'a中',
          bordered: true,
          maxCharacter: 8,
          indicator: true,
        ),
      ),
    );

    expect(find.text('3/8'), findsOneWidget);
    final shell = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .first;
    expect((shell.decoration as BoxDecoration).border, isNotNull);
    expect(
      tester.widget<TextField>(find.byType(TextField)).inputFormatters,
      contains(isNot(isA<LengthLimitingTextInputFormatter>())),
    );
  });

  testWidgets('label, placeholder and indicator use textarea tokens', (
    tester,
  ) async {
    final token = TThemeData.defaultData();
    await tester.pumpWidget(
      wrap(
        const TTextarea(
          label: '标签文字',
          hintText: '请输入文字',
          maxLength: 200,
          indicator: true,
        ),
      ),
    );

    final label = tester.widget<Text>(find.text('标签文字'));
    expect(label.style?.fontSize, token.fontBodyMedium?.size);
    expect(label.style?.height, token.fontBodyMedium?.height);
    expect(label.style?.color, token.textColorPrimary);

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.decoration?.hintStyle?.fontSize, token.fontBodyMedium?.size);
    expect(field.decoration?.hintStyle?.height, token.fontBodyMedium?.height);
    expect(field.decoration?.hintStyle?.color, token.textColorPlaceholder);

    final indicator = tester.widget<Text>(find.text('0/200'));
    expect(indicator.style?.fontSize, token.fontBodySmall?.size);
    expect(indicator.style?.height, token.fontBodySmall?.height);
    expect(indicator.style?.color, token.textColorPlaceholder);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is SizedBox && widget.height == token.spacer8,
      ),
      findsAtLeastNWidgets(2),
    );
  });

  testWidgets('textarea label uses text theme and disabled semantics', (
    tester,
  ) async {
    final token = TThemeData.defaultData();
    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(token).copyWith(
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: const Scaffold(body: TTextarea(label: 'enabled')),
      ),
    );

    final enabled = tester.widget<Text>(find.text('enabled')).style;
    expect(enabled?.color, Colors.purple);
    expect(enabled?.fontWeight, FontWeight.bold);

    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(token).copyWith(
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.purple),
          ),
        ),
        home: const Scaffold(
          body: TTextarea(label: 'disabled', enabled: false),
        ),
      ),
    );
    expect(
      tester.widget<Text>(find.text('disabled')).style?.color,
      token.textDisabledColor,
    );
  });

  testWidgets('textarea owns default padding and form item removes it', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(const TTextarea(hintText: 'standalone')));
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Padding && widget.padding == const EdgeInsets.all(16),
      ),
      findsOneWidget,
    );

    await tester.pumpWidget(
      wrap(
        const TFormItem(
          label: '字段',
          child: TTextarea(hintText: 'in form'),
        ),
      ),
    );
    expect(find.text('字段'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Padding && widget.padding == const EdgeInsets.all(16),
      ),
      findsOneWidget,
    );
  });

  test('TTextarea rejects controller with initialValue', () {
    final controller = TextEditingController();
    expect(
      () => TTextarea(controller: controller, initialValue: 'invalid'),
      throwsAssertionError,
    );
    controller.dispose();
  });
}
