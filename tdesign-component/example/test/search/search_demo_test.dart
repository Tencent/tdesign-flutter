import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_search_bar_page.dart';

import '../demo_page_test_utils.dart';

void main() {
  const spec = DemoPageTestSpec(
    name: 'search',
    title: 'Search 搜索框',
    page: TSearchBarPage(),
    expectedTexts: ['01 组件类型', '02 组件样式'],
    componentType: TSearchBar,
  );
  registerDemoPageTests(spec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('search result ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, spec, mode);
      final textField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == '输入tdesign，有预览结果',
      );
      await tester.tap(textField);
      await tester.enterText(textField, 'mobile');
      await tester.pump();

      expect(find.text('tdesign-mobile-vue'), findsOneWidget);
      expect(find.text('tdesign-mobile-react'), findsOneWidget);
      await expectLater(
        find.byKey(const ValueKey('search-demo-page')),
        matchesGoldenFile('goldens/search_result_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
