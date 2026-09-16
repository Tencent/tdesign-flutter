import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';

import 'demo_page_test_utils.dart';
import 'textarea_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(textareaDemoPageTestSpec);

  testWidgets('公开分组、场景顺序与参数和场景契约完全一致', (tester) async {
    await pumpFullDemoPage(tester, textareaDemoPageTestSpec, ThemeMode.light);

    final page = tester.widget<ExamplePage>(find.byType(ExamplePage));
    final actualScenarioEntries = [
      for (final module in page.children)
        for (final item in module.children)
          (module: module.title, description: item.desc),
    ];
    expect(
      actualScenarioEntries,
      textareaPublicScenarios
          .map(
            (scenario) =>
                (module: scenario.module, description: scenario.description),
          )
          .toList(growable: false),
    );

    final textareas = tester
        .widgetList<TTextarea>(find.byType(TTextarea))
        .toList(growable: false);
    expect(textareas, hasLength(textareaPublicScenarios.length));
    for (var index = 0; index < textareaPublicScenarios.length; index++) {
      final actual = textareas[index];
      final expected = textareaPublicScenarios[index];
      expect(actual.label, expected.label, reason: expected.id);
      expect(actual.hintText, expected.hintText, reason: expected.id);
      expect(actual.layout, expected.layout, reason: expected.id);
      expect(actual.enabled, expected.enabled, reason: expected.id);
      expect(actual.minLines, expected.minLines, reason: expected.id);
      expect(actual.initialValue, expected.initialValue, reason: expected.id);
      expect(actual.maxLength, expected.maxLength, reason: expected.id);
      expect(actual.maxCharacter, expected.maxCharacter, reason: expected.id);
      expect(actual.indicator, expected.indicator, reason: expected.id);
      expect(actual.bordered, expected.bordered, reason: expected.id);
    }

    expect(find.text('按字符权重限制'), findsNothing);
    expect(find.text('单元测试'), findsNothing);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('全部可编辑场景可输入，禁用场景保持不可编辑', (tester) async {
    await pumpFullDemoPage(tester, textareaDemoPageTestSpec, ThemeMode.light);

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(textareaPublicScenarios.length));
    for (var index = 0; index < textareaPublicScenarios.length; index++) {
      final scenario = textareaPublicScenarios[index];
      final field = tester.widget<TextField>(fields.at(index));
      expect(field.enabled, scenario.enabled, reason: scenario.id);
      final postActionText = scenario.postActionText;
      if (postActionText == null) {
        expect(
          field.controller?.text,
          scenario.initialValue,
          reason: scenario.id,
        );
        continue;
      }
      await tester.enterText(fields.at(index), postActionText);
      await tester.pump();
      expect(field.controller?.text, postActionText, reason: scenario.id);
    }

    expect(find.text('6/200'), findsOneWidget);
    expect(find.text('4/500'), findsOneWidget);
    expect(find.text('6/100'), findsOneWidget);
    await disposeDemoPage(tester);
  }, tags: 'demo');
}
