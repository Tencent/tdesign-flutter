import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/dropdown_menu/dropdown_menu_sorting_example.dart';

import '../demo_page_test_utils.dart';
import 'dropdown_menu_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(dropdownMenuDemoPageTestSpec);

  const openedGoldenScenarioIds = [
    'product',
    'sorter',
    'single_column',
    'double_column',
    'triple_column',
  ];
  final openedGoldenScenarios = openedGoldenScenarioIds
      .map(
        (id) => dropdownMenuPublicScenarios.singleWhere(
          (scenario) => scenario.id == id,
        ),
      )
      .toList(growable: false);

  test('opened Goldens cover every public expandable menu', () {
    final expectedIds = dropdownMenuPublicScenarios
        .where(
          (scenario) =>
              scenario.goldenPolicy == DropdownMenuGoldenPolicy.opened,
        )
        .map((scenario) => scenario.id)
        .toSet();
    expect(openedGoldenScenarioIds.toSet(), expectedIds);
  });

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('dropdown menu committed selection ${mode.name} golden', (
      tester,
    ) async {
      await pumpDemoPageAtPhoneViewport(
        tester,
        dropdownMenuDemoPageTestSpec,
        mode,
      );
      await tester.tap(find.text('最火产品').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('最新产品'));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('t-dropdown-menu-panel-surface')),
        findsNothing,
      );
      expect(find.text('最新产品'), findsOneWidget);
      await expectLater(
        find.byKey(const ValueKey('dropdown_menu-demo-page')),
        matchesGoldenFile(
          'goldens/dropdown_menu_single_selected_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('dropdown menu overscroll ${mode.name} opened golden', (
      tester,
    ) async {
      await pumpDemoPageAtPhoneViewport(
        tester,
        dropdownMenuDemoPageTestSpec,
        mode,
      );
      final theme = Theme.of(tester.element(find.byType(TDropdownMenu).first));
      // The public Demo uses bouncing physics. Keep its six baselines intact
      // and exercise Android's filtered stretch in a separate component scene.
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: Scaffold(
            body: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 200),
                  TDropdownMenu(
                    animationDuration: Duration.zero,
                    items: [
                      TDropdownMenuItem(
                        label: '全部产品',
                        panelBuilder: (context, controller) =>
                            TDropdownSingleSelectPanel<String>(
                              controller: controller,
                              value: 'all',
                              options:
                                  DropdownMenuSortingExample.productOptions,
                              onChanged: (_) {},
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 1000),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('全部产品').last);
      await tester.pumpAndSettle();
      final gesture = await tester.startGesture(const Offset(20, 80));
      for (var step = 0; step < 5; step++) {
        await gesture.moveBy(const Offset(0, 40));
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(find.text('最新产品'), findsOneWidget);
      final stretches = tester
          .widgetList<Transform>(find.byType(Transform))
          .where(
            (transform) =>
                transform.filterQuality != null &&
                transform.transform.storage[5] > 1,
          );
      expect(
        stretches,
        isNotEmpty,
        reason: 'Capture the active platform stretch, not a settled frame.',
      );
      final barRect = tester.getRect(find.byType(TDropdownMenu).first);
      final panelRect = tester.getRect(
        find.byKey(const ValueKey<String>('t-dropdown-menu-panel-surface')),
      );
      expect(panelRect.top, closeTo(barRect.bottom, 0.001));
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile(
          'goldens/dropdown_menu_overscroll_opened_${mode.name}.png',
        ),
      );
      await gesture.up();
      await disposeDemoPage(tester);
    }, tags: 'golden');

    for (final scenario in openedGoldenScenarios) {
      testWidgets('dropdown menu ${scenario.id} ${mode.name} opened golden', (
        tester,
      ) async {
        await pumpDemoPageAtPhoneViewport(
          tester,
          dropdownMenuDemoPageTestSpec,
          mode,
        );

        final trigger = find.text(scenario.label);
        final scrollable = find.descendant(
          of: find.byType(CustomScrollView).first,
          matching: find.byType(Scrollable),
        );
        await tester.scrollUntilVisible(
          trigger,
          200,
          scrollable: scrollable.first,
        );
        await tester.tap(trigger);
        await tester.pumpAndSettle();

        expect(
          find.text(scenario.expectedPanelText),
          findsNWidgets(scenario.expectedPanelTextCount),
        );
        await expectLater(
          find.byType(Overlay),
          matchesGoldenFile(
            'goldens/dropdown_menu_${scenario.goldenName}_opened_${mode.name}.png',
          ),
        );
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}
