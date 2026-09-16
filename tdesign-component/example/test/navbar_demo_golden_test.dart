import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'navbar_demo_test_spec.dart';

void main() {
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
        matchesGoldenFile('goldens/navbar_search_entered_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('navbar action toast ${mode.name} golden', (tester) async {
      await pumpDemoPageAtPhoneViewport(tester, navbarDemoPageTestSpec, mode);
      final moreAction = find.descendant(
        of: find.byKey(const Key('navbar-demo-left-multi-action')),
        matching: find.byIcon(TIcons.ellipsis),
      );
      await tester.tap(moreAction);
      await tester.pump(const Duration(milliseconds: 300));

      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile('goldens/navbar_action_toast_${mode.name}.png'),
      );
      await tester.pump(const Duration(seconds: 3));
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
