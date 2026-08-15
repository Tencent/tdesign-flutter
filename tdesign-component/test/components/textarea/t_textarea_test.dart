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

  testWidgets('TInput.multiline uses multiline defaults and callbacks',
      (tester) async {
    String? changed;
    await tester.pumpWidget(wrap(TInput.multiline(
      initialValue: 'line',
      onChanged: (value) => changed = value,
    )));
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.maxLines, isNull);
    expect(field.minLines, 4);
    expect(field.keyboardType, TextInputType.multiline);
    await tester.enterText(find.byType(TextField), 'updated');
    expect(changed, 'updated');
  });

  testWidgets('TTextarea delegates every public option to TInput.multiline',
      (tester) async {
    final controller = TextEditingController(text: 'initial');
    final focusNode = FocusNode();
    await tester.pumpWidget(wrap(TTextarea(
      controller: controller,
      enabled: true,
      readOnly: true,
      label: 'label',
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
      decoration: const InputDecoration(helperText: 'helper'),
    )));

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller, same(controller));
    expect(field.readOnly, isTrue);
    expect(field.maxLines, 8);
    expect(field.minLines, 2);
    expect(field.maxLength, 50);
    expect(field.autofocus, isTrue);
    expect(field.focusNode, same(focusNode));
    expect(field.textInputAction, TextInputAction.newline);
    expect(field.textAlign, TextAlign.center);
    // label 渲染为左侧固定标签，而非 Material 浮动标签（labelText）。
    expect(field.decoration?.labelText, isNull);
    expect(find.text('label'), findsOneWidget);
    expect(field.decoration?.helperText, 'helper');
    expect(field.decoration?.filled, isFalse);
    expect(field.decoration?.fillColor, Colors.transparent);
    controller.dispose();
    focusNode.dispose();
  });

  testWidgets('TTextarea preserves explicit decoration fill', (tester) async {
    const fillColor = Color(0xFFE5E5E5);
    await tester.pumpWidget(wrap(const TTextarea(
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
      ),
    )));

    final decoration =
        tester.widget<TextField>(find.byType(TextField)).decoration;
    expect(decoration?.filled, isTrue);
    expect(decoration?.fillColor, fillColor);
  });

  testWidgets('TTextarea forwards submission and editing completion',
      (tester) async {
    String? submitted;
    var completed = false;
    await tester.pumpWidget(wrap(TTextarea(
      initialValue: 'text',
      inputAction: TextInputAction.done,
      onSubmitted: (value) => submitted = value,
      onEditingComplete: () => completed = true,
    )));
    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(submitted, 'text');
    expect(completed, isTrue);
  });

  testWidgets('multiline minimum rows can come from theme', (tester) async {
    await tester.pumpWidget(wrap(
      const TTextarea(),
      inputTheme: const TInputThemeData(multilineMinLines: 6),
    ));
    expect(tester.widget<TextField>(find.byType(TextField)).minLines, 6);
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
