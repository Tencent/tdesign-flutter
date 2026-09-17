import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_cell_page.dart';

import '../demo_page_test_utils.dart';

void main() {
  const spec = DemoPageTestSpec(
    name: 'cell',
    title: 'Cell 单元格',
    page: TCellPage(),
    expectedTexts: ['01 组件类型', '单行单元格', '多行单元格', '02 组件样式', '卡片单元格'],
    componentType: TCell,
    precacheAssetImages: ['assets/img/t_avatar_1.png'],
  );
  registerDemoGoldenTests(spec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('cell switches changed ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, spec, mode);
      final switches = find.byType(TSwitch);
      expect(switches, findsNWidgets(2));
      await tester.tap(switches.first);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(switches.last);
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        tester.widgetList<TSwitch>(switches).map((item) => item.value),
        everyElement(isFalse),
      );
      await expectLater(
        find.byKey(const ValueKey('cell-demo-page')),
        matchesGoldenFile(
          'goldens/cell_switches_changed_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('cell pressed ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, spec, mode);
      final cell = find.byType(TCell).first;
      final gesture = await tester.startGesture(tester.getCenter(cell));
      await tester.pump();

      await expectLater(
        find.byKey(const ValueKey('cell-demo-page')),
        matchesGoldenFile('goldens/cell_pressed_${mode.name}.png'),
      );
      await gesture.cancel();
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
