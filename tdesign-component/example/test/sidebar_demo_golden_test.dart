import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'sidebar_demo_test_spec.dart';

void main() {
  const detailSpecs = [
    ('anchor', sidebarAnchorDemoTestSpec),
    ('pagination', sidebarPaginationDemoTestSpec),
    ('icon', sidebarIconDemoTestSpec),
    ('tag', sidebarTagDemoTestSpec),
  ];
  final registeredGoldenCases = {
    for (final mode in [ThemeMode.light, ThemeMode.dark])
      'sidebar:page:${mode.name}',
    for (final entry in detailSpecs)
      for (final mode in [ThemeMode.light, ThemeMode.dark]) ...{
        '${entry.$1}:page:${mode.name}',
        '${entry.$1}:selected_item:${mode.name}',
      },
  };

  test('SideBar Golden 注册集合覆盖全部公开场景和操作后状态', () {
    expect(
      detailSpecs.map((entry) => (entry.$1, entry.$2.name)),
      sideBarDemoScenes.map((scene) => (scene.id, scene.pageSpecName)),
    );
    expect(registeredGoldenCases, expectedSideBarGoldenCases());
  });

  registerDemoGoldenTests(sidebarDemoPageTestSpec);
  registerDemoGoldenTests(sidebarAnchorDemoTestSpec);
  registerDemoGoldenTests(sidebarTagDemoTestSpec);
  registerDemoGoldenTests(sidebarPaginationDemoTestSpec);
  registerDemoGoldenTests(sidebarIconDemoTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final entry in detailSpecs) {
      final spec = entry.$2;
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
