import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../demo_page_test_utils.dart';
import 'navbar_demo_test_spec.dart';

void main() {
  const toastCases = [
    (
      id: 'close',
      sceneKey: Key('navbar-demo-scene-left-multi'),
      icon: TIcons.close,
      fileName: 'navbar_close_toast',
    ),
    (
      id: 'home',
      sceneKey: Key('navbar-demo-scene-right-multi'),
      icon: TIcons.home,
      fileName: 'navbar_home_toast',
    ),
    (
      id: 'more',
      sceneKey: Key('navbar-demo-scene-left-multi'),
      icon: TIcons.ellipsis,
      fileName: 'navbar_action_toast',
    ),
    (
      id: 'back',
      sceneKey: Key('navbar-demo-scene-title-below'),
      icon: TIcons.chevron_left,
      fileName: 'navbar_back_toast',
    ),
  ];
  final registeredGoldenCases = {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) ...{
      'navbar:page:${mode.name}',
      'search:entered:${mode.name}',
      for (final toastCase in toastCases) 'toast:${toastCase.id}:${mode.name}',
    },
  };

  test('Navbar Golden 注册集合覆盖全部页面与独立视觉结果', () {
    expect(registeredGoldenCases, expectedNavBarGoldenCases());
  });

  registerDemoPageTests(navbarDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('navbar search entered ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, navbarDemoPageTestSpec, mode);
      final searchField = find.descendant(
        of: find.byKey(const Key('navbar-demo-search')),
        matching: find.byType(EditableText),
      );
      await tester.enterText(searchField, 'Navbar');
      await tester.pump();
      tester.testTextInput.hide();
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();

      await expectLater(
        find.byKey(const ValueKey('navbar-demo-page')),
        matchesGoldenFile(
          'goldens/navbar_search_entered_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    for (final toastCase in toastCases) {
      testWidgets('navbar ${toastCase.id} toast ${mode.name} golden', (
        tester,
      ) async {
        await pumpDemoPageAtPhoneViewport(tester, navbarDemoPageTestSpec, mode);
        final scene = find.byKey(toastCase.sceneKey);
        if (toastCase.id == 'back') {
          await tester.scrollUntilVisible(
            scene,
            300,
            scrollable: find.byType(Scrollable).first,
          );
        }
        final action = find.descendant(
          of: scene,
          matching: find.byIcon(toastCase.icon),
        );
        await tester.tap(action);
        await tester.pump(const Duration(milliseconds: 300));

        await expectLater(
          find.byType(Overlay),
          matchesGoldenFile(
            'goldens/${toastCase.fileName}_${mode.name}.png',
          ),
        );
        await tester.pump(const Duration(seconds: 3));
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}
