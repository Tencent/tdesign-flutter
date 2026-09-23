import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../demo_page_test_utils.dart';
import 'notice_bar_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(noticeBarDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('notice bar close ${mode.name} post action golden', (
      tester,
    ) async {
      await pumpFullDemoPage(tester, noticeBarDemoPageTestSpec, mode);
      final notice = find.byType(TNoticeBar).at(2);
      await tester.tap(
        find.descendant(of: notice, matching: find.byIcon(TIcons.close)),
      );
      await tester.pump();
      expect(find.text('点击了关闭按钮'), findsOneWidget);
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile(
          'goldens/notice_bar_close_post_action_${mode.name}.png',
        ),
      );
      TToast.dismissAll();
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('notice bar entrance ${mode.name} post action golden', (
      tester,
    ) async {
      await pumpFullDemoPage(tester, noticeBarDemoPageTestSpec, mode);
      final notice = find.byType(TNoticeBar).at(4);
      await tester.tap(
        find.descendant(
          of: notice,
          matching: find.byIcon(TIcons.chevron_right),
        ),
      );
      await tester.pump();
      expect(find.text('点击了入口图标'), findsOneWidget);
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile(
          'goldens/notice_bar_entrance_post_action_${mode.name}.png',
        ),
      );
      TToast.dismissAll();
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('notice bar scroll ${mode.name} post action golden', (
      tester,
    ) async {
      await pumpFullDemoPage(tester, noticeBarDemoPageTestSpec, mode);
      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('高堂明镜悲白发'), findsWidgets);
      await expectLater(
        find.byKey(const ValueKey('notice_bar-demo-page')),
        matchesGoldenFile(
          'goldens/notice_bar_scroll_post_action_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
