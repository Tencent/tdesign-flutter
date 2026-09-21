import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'swiper_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(swiperDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('swiper next page ${mode.name} golden', (tester) async {
      await pumpFullDemoPage(tester, swiperDemoPageTestSpec, mode);
      final swiper = find.byWidgetPredicate(
        (widget) =>
            widget is TSwiper &&
            widget.pagination == TSwiperPaginationVariant.dots &&
            !widget.autoplay &&
            widget.paginationPlacement == null,
      );
      final pageViewFinder = find.descendant(
        of: swiper,
        matching: find.byType(PageView),
      );
      final pageView = tester.widget<PageView>(pageViewFinder);
      final initialPage = pageView.controller!.page!;
      await tester.drag(pageViewFinder, const Offset(-220, 0));
      await tester.pumpAndSettle();
      expect(pageView.controller?.page, initialPage + 1);
      await expectLater(
        find.byKey(const ValueKey('swiper-demo-page')),
        matchesGoldenFile('goldens/swiper_next_page_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
