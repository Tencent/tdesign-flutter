import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'sidebar_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(sidebarDemoPageTestSpec);
  registerDemoGoldenTests(sidebarAnchorDemoTestSpec);
  registerDemoGoldenTests(sidebarTagDemoTestSpec);
  registerDemoGoldenTests(sidebarPaginationDemoTestSpec);
  registerDemoGoldenTests(sidebarIconDemoTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final spec in const [
      sidebarAnchorDemoTestSpec,
      sidebarPaginationDemoTestSpec,
      sidebarIconDemoTestSpec,
      sidebarTagDemoTestSpec,
    ]) {
      testWidgets('${spec.name} selected item ${mode.name} golden', (
        tester,
      ) async {
        await pumpDemoPageAtPhoneViewport(tester, spec, mode);
        await tester.tap(
          find
              .descendant(of: find.byType(TSideBar), matching: find.text('选项'))
              .at(3),
        );
        await tester.pumpAndSettle();

        await expectLater(
          find.byKey(ValueKey('${spec.name}-demo-page')),
          matchesGoldenFile(
            'goldens/${spec.name}_selected_item_${mode.name}.png',
          ),
        );
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}
