import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_grid.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../demo_page_test_utils.dart';
import 'action_sheet_demo_test_spec.dart';

void main() {
  final registeredGoldenCases = {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) ...{
      'page:initial:${mode.name}',
      for (final scene in actionSheetDemoGoldenScenes)
        '${scene.id}:opened:${mode.name}',
      'paged_grid:next_page:${mode.name}',
      'scroll_grid:scrolled:${mode.name}',
    },
  };

  test('ActionSheet Golden 注册集合覆盖全部公开场景和稳定操作后状态', () {
    expect(registeredGoldenCases, expectedActionSheetGoldenCases());
  });

  registerDemoGoldenTests(actionSheetDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final scene in actionSheetDemoGoldenScenes) {
      testWidgets('action sheet ${scene.id} ${mode.name} opened golden', (
        tester,
      ) async {
        await _openScene(tester, mode, scene.trigger);

        await expectLater(
          find.byType(Overlay),
          matchesGoldenFile(
            'goldens/action_sheet_${scene.id}_opened_${mode.name}.png',
          ),
        );
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }

    testWidgets('action sheet paged grid next page ${mode.name} golden', (
      tester,
    ) async {
      await _openScene(tester, mode, '带翻页宫格型');
      await tester.drag(find.byType(PageView), const Offset(-375, 0));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile(
          'goldens/action_sheet_paged_grid_next_page_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('action sheet scroll grid scrolled ${mode.name} golden', (
      tester,
    ) async {
      await _openScene(tester, mode, '多行滚动宫格型');
      final gridScroll = find.descendant(
        of: find.byType(TActionSheetGrid<String>),
        matching: find.byType(Scrollable),
      );
      await tester.drag(gridScroll.first, const Offset(-100, 0));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile(
          'goldens/action_sheet_scroll_grid_scrolled_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}

Future<void> _openScene(
  WidgetTester tester,
  ThemeMode mode,
  String triggerLabel,
) async {
  await pumpDemoPageAtPhoneViewport(tester, actionSheetDemoPageTestSpec, mode);
  final trigger = find.widgetWithText(TButton, triggerLabel);
  final scrollable = find.descendant(
    of: find.byType(CustomScrollView).first,
    matching: find.byType(Scrollable),
  );
  await tester.scrollUntilVisible(trigger, 200, scrollable: scrollable.first);
  await tester.ensureVisible(trigger);
  await tester.pumpAndSettle();
  await tester.tap(trigger);
  await tester.pumpAndSettle();
}
