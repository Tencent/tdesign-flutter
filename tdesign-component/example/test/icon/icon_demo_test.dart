import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart' hide TIcons;
import 'package:tdesign_flutter_example/page/t_icon_page.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';

import '../demo_page_test_utils.dart';

void main() {
  const spec = DemoPageTestSpec(
    name: 'icon',
    title: 'Icon 图标',
    page: TIconPage(),
    expectedTexts: ['01 主题与图标', '02 icon示例'],
    componentType: TIcon,
  );
  registerDemoPageTests(spec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('icon copied ${mode.name} golden', (tester) async {
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async => null,
      );
      addTearDown(
        () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
      );

      await pumpFullDemoPage(tester, spec, mode);
      final firstName = TIcons.allIconsMap.keys.first;
      final item = find.byKey(ValueKey('icon-catalog-item-$firstName'));
      await tester.tap(find.ancestor(of: item, matching: find.byType(InkWell)));
      await tester.pump();

      expect(find.text('已复制 TIcon(TIcons.$firstName)'), findsOneWidget);
      await expectLater(
        find.byKey(const ValueKey('icon-demo-page')),
        matchesGoldenFile('goldens/icon_copied_${mode.name}.png'),
      );
      await tester.pump(const Duration(seconds: 3));
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
