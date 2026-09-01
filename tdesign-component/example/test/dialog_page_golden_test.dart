import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'dialog_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(dialogDemoPageTestSpec);

  const openedScenarios = {
    'input': '输入类-带描述',
    'image': '图片置顶-带标题描述',
    'text_actions': '文字按钮',
    'multi_actions': '多按钮',
    'close_button': '带关闭按钮的对话框',
  };

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final scenario in openedScenarios.entries) {
      testWidgets('dialog ${scenario.key} ${mode.name} opened golden', (
        tester,
      ) async {
        await pumpDemoPageAtPhoneViewport(tester, dialogDemoPageTestSpec, mode);

        final trigger = find.widgetWithText(TButton, scenario.value);
        for (
          var attempt = 0;
          attempt < 10 && trigger.evaluate().isEmpty;
          attempt++
        ) {
          await tester.drag(
            find.byType(CustomScrollView).first,
            const Offset(0, -400),
          );
          await tester.pumpAndSettle();
        }
        expect(trigger, findsOneWidget);
        if (scenario.key == 'image') {
          await tester.runAsync(
            () => precacheImage(
              const AssetImage('assets/img/image.png'),
              tester.element(trigger),
            ),
          );
        }
        for (
          var attempt = 0;
          attempt < 5 && tester.getRect(trigger).bottom > 760;
          attempt++
        ) {
          await tester.drag(
            find.byType(CustomScrollView).first,
            const Offset(0, -200),
          );
          await tester.pumpAndSettle();
        }
        await tester.tap(trigger);
        await tester.pumpAndSettle();

        expect(find.byType(TDialog), findsOneWidget);
        if (scenario.key == 'close_button') {
          expect(find.byIcon(TIcons.close), findsOneWidget);
        }
        await expectLater(
          find.byType(Overlay),
          matchesGoldenFile(
            'goldens/dialog_${scenario.key}_opened_${mode.name}.png',
          ),
        );
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}
