import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'indexes_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(indexesDemoPageTestSpec);

  void configurePhoneSafeArea(WidgetTester tester) {
    tester.view.padding = const FakeViewPadding(top: 24);
    addTearDown(tester.view.resetPadding);
  }

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('indexes letter ${mode.name} opened golden', (tester) async {
      configurePhoneSafeArea(tester);
      await pumpDemoPageAtPhoneViewport(tester, indexesDemoPageTestSpec, mode);
      await tester.tap(find.byKey(const ValueKey('indexes-letter-trigger')));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile('goldens/indexes_letter_opened_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('indexes number ${mode.name} opened golden', (tester) async {
      configurePhoneSafeArea(tester);
      await pumpDemoPageAtPhoneViewport(tester, indexesDemoPageTestSpec, mode);
      await tester.tap(find.byKey(const ValueKey('indexes-number-trigger')));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile('goldens/indexes_number_opened_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('indexes capsule ${mode.name} opened golden', (tester) async {
      configurePhoneSafeArea(tester);
      await pumpDemoPageAtPhoneViewport(tester, indexesDemoPageTestSpec, mode);
      await tester.tap(find.byKey(const ValueKey('indexes-capsule-trigger')));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile('goldens/indexes_capsule_opened_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    for (final entry in const {
      'letter_selected': (trigger: 'indexes-letter-trigger', target: 'C'),
      'number_selected': (trigger: 'indexes-number-trigger', target: '5'),
      'capsule_selected': (trigger: 'indexes-capsule-trigger', target: '5'),
    }.entries) {
      testWidgets('indexes ${entry.key} ${mode.name} golden', (tester) async {
        configurePhoneSafeArea(tester);
        await pumpDemoPageAtPhoneViewport(
          tester,
          indexesDemoPageTestSpec,
          mode,
        );
        await tester.tap(find.byKey(ValueKey(entry.value.trigger)));
        await tester.pumpAndSettle();
        await tester.tap(
          find.descendant(
            of: find.byType(TIndexesList),
            matching: find.text(entry.value.target),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(Overlay),
          matchesGoldenFile('goldens/indexes_${entry.key}_${mode.name}.png'),
        );
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}
