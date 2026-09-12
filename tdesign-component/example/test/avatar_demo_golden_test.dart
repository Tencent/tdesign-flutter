import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'avatar_demo_test_spec.dart';
import 'demo_page_test_utils.dart';

void main() {
  setUpAll(() => loadDemoGoldenFonts(avatarDemoPageTestSpec));

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('avatar ${mode.name} Demo golden', (tester) async {
      PaintingBinding.instance.imageCache
        ..clear()
        ..clearLiveImages();
      await pumpFullDemoPage(tester, avatarDemoPageTestSpec, mode);
      await tester.pumpAndSettle();

      await expectLater(
        find.byKey(const ValueKey('avatar-demo-page')),
        matchesGoldenFile('goldens/avatar_page_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
