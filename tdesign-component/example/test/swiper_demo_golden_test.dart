import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'swiper_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(swiperDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('swiper changed ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, swiperDemoPageTestSpec, mode);
      final swiper = find.byType(TSwiper).first;
      await tester.fling(
        find.descendant(of: swiper, matching: find.byType(PageView)).first,
        const Offset(-400, 0),
        1000,
      );
      await tester.pumpAndSettle();
      expect(
        find.descendant(of: swiper, matching: find.bySemanticsLabel('2 / 6')),
        findsOneWidget,
      );

      await expectLater(
        find.byKey(const ValueKey('swiper-demo-page')),
        matchesGoldenFile('goldens/swiper_changed_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
