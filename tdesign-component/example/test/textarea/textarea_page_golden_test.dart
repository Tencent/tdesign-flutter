import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../demo_page_test_utils.dart';
import 'textarea_demo_test_spec.dart';

const textareaPageGoldenScenarioIds = [
  'basic',
  'label',
  'autosize',
  'max_length',
  'disabled',
  'vertical',
  'card',
  'custom',
];

const textareaPostActionGoldenScenarioIds = [
  'basic',
  'label',
  'autosize',
  'max_length',
  'vertical',
  'card',
  'custom',
];

void main() {
  registerDemoGoldenTests(textareaDemoPageTestSpec);

  test('page 和输入后 Golden 覆盖全部公开场景', () {
    expect(
      textareaPageGoldenScenarioIds.toSet(),
      textareaPublicScenarios.map((scenario) => scenario.id).toSet(),
    );
    expect(
      textareaPostActionGoldenScenarioIds.toSet(),
      textareaPublicScenarios
          .where(
            (scenario) =>
                scenario.goldenPolicy == TextareaGoldenPolicy.postAction,
          )
          .map((scenario) => scenario.id)
          .toSet(),
    );
  });

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('textarea all editable ${mode.name} post-action golden', (
      tester,
    ) async {
      await pumpFullDemoPage(tester, textareaDemoPageTestSpec, mode);

      final fields = find.byType(TextField);
      for (var index = 0; index < textareaPublicScenarios.length; index++) {
        final text = textareaPublicScenarios[index].postActionText;
        if (text == null) {
          continue;
        }
        await tester.enterText(fields.at(index), text);
        await tester.pump();
      }
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();

      final scrollable = find.descendant(
        of: find.byType(CustomScrollView),
        matching: find.byType(Scrollable),
      );
      final extent = tester
          .state<ScrollableState>(scrollable.first)
          .position
          .maxScrollExtent;
      if (extent > 0.01) {
        tester.view.physicalSize = Size(
          tester.view.physicalSize.width,
          tester.view.physicalSize.height + extent,
        );
        await tester.pump();
      }

      await expectLater(
        find.byKey(const ValueKey('textarea-demo-page')),
        matchesGoldenFile(
          'goldens/textarea_all_editable_post_action_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
