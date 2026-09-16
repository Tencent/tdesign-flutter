import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';

import 'demo_page_test_utils.dart';
import 'swipe_cell_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(swipeCellDemoPageTestSpec);

  testWidgets('SwipeCell 公开场景与契约双向一致', (tester) async {
    await pumpFullDemoPage(tester, swipeCellDemoPageTestSpec, ThemeMode.light);
    final page = tester.widget<ExamplePage>(find.byType(ExamplePage));
    expect(page.children.single.title, '组件类型');
    expect(
      page.children.single.children.map((item) => item.desc),
      swipeCellDemoItems,
    );
    expect(
      swipeCellDemoScenarios.map((scenario) => scenario.id).toSet(),
      hasLength(swipeCellDemoScenarios.length),
    );
    expect(find.byType(TSwipeCell), findsNWidgets(8));
    await disposeDemoPage(tester);
  });

  for (final scenario in swipeCellDemoScenarios) {
    testWidgets('SwipeCell ${scenario.id} 可通过手势打开', (tester) async {
      await pumpDemoPageAtPhoneViewport(
        tester,
        swipeCellDemoPageTestSpec,
        ThemeMode.light,
      );
      await openSwipeCellScenario(tester, scenario);
      final action = find.descendant(
        of: find.ancestor(
          of: find.descendant(
            of: find.byType(TSwipeCell),
            matching: find.text(scenario.label),
          ),
          matching: find.byType(TSwipeCell),
        ),
        matching: find.byType(TSwipeCellAction),
      );
      expect(action, findsAtLeastNWidgets(1));
      if (scenario.actionLabel case final label?) {
        expect(
          find.descendant(of: action, matching: find.text(label)),
          findsOneWidget,
        );
      }
      expect(tester.takeException(), isNull);
      await disposeDemoPage(tester);
    });
  }
}
