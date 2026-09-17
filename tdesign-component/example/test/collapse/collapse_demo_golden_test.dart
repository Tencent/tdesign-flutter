import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../demo_page_test_utils.dart';
import 'collapse_demo_test.dart' show collapseDemoSpec;

void main() {
  registerDemoGoldenTests(collapseDemoSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('collapse accordion changed ${mode.name} golden', (
      tester,
    ) async {
      await pumpFullDemoPage(tester, collapseDemoSpec, mode);
      final accordion = find.byWidgetPredicate(
        (widget) =>
            widget is TCollapse && widget.mode == TCollapseMode.accordion,
      );
      final headers = find.descendant(
        of: accordion,
        matching: find.text('折叠面板标题'),
      );
      await tester.tap(headers.last);
      await tester.pumpAndSettle();

      expect(tester.widget<TCollapse<String>>(accordion).value, ['2']);
      await expectLater(
        find.byKey(const ValueKey('collapse-demo-page')),
        matchesGoldenFile(
          'goldens/collapse_accordion_changed_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
