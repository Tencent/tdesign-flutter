import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'pull_down_refresh_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(pullDownRefreshDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('pull down refresh basic ${mode.name} post action golden', (
      tester,
    ) async {
      await pumpDemoPageAtPhoneViewport(
        tester,
        pullDownRefreshDemoPageTestSpec,
        mode,
      );
      await tester.tap(find.text('拖拽该区域演示 顶部下拉刷新'));
      for (var index = 0; index < 8; index++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.text('正在刷新'), findsOneWidget);
      await expectLater(
        find.byKey(const ValueKey('pull_down_refresh-demo-page')),
        matchesGoldenFile(
          'goldens/pull_down_refresh_basic_post_action_${mode.name}.png',
        ),
      );
      await tester.pump(const Duration(seconds: 2));
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets(
      'pull down refresh custom text ${mode.name} post action golden',
      (tester) async {
        await pumpDemoPageAtPhoneViewport(
          tester,
          pullDownRefreshDemoPageTestSpec,
          mode,
        );
        final target = find.text('自定义提示语刷新次数：0');
        await _reveal(tester, target, 760);
        await _pullToRefresh(tester, target);
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('加载中...'), findsOneWidget);
        await expectLater(
          find.byKey(const ValueKey('pull_down_refresh-demo-page')),
          matchesGoldenFile(
            'goldens/pull_down_refresh_custom_text_post_action_${mode.name}.png',
          ),
        );
        await tester.pump(const Duration(seconds: 2));
        await disposeDemoPage(tester);
      },
      tags: 'golden',
    );

    testWidgets('pull down refresh timeout ${mode.name} post action golden', (
      tester,
    ) async {
      await pumpDemoPageAtPhoneViewport(
        tester,
        pullDownRefreshDemoPageTestSpec,
        mode,
      );
      final target = find.text('超时刷新次数：0');
      await _reveal(tester, target, 1120);
      final refresh = tester.widget<TPullDownRefresh>(
        find.ancestor(of: target, matching: find.byType(TPullDownRefresh)),
      );
      refresh.onStateChanged!(TPullDownRefreshState.timeout);
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('已超时'), findsOneWidget);
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile(
          'goldens/pull_down_refresh_timeout_post_action_${mode.name}.png',
        ),
      );
      TToast.dismissAll();
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}

Future<void> _pullToRefresh(WidgetTester tester, Finder target) async {
  final refresh = find.ancestor(
    of: target,
    matching: find.byType(TPullDownRefresh),
  );
  final handle = find.descendant(of: refresh, matching: find.text('下拉刷新'));
  expect(handle, findsWidgets);
  final gesture = await tester.startGesture(tester.getCenter(handle.first));
  for (var step = 0; step < 6; step++) {
    await gesture.moveBy(const Offset(0, 30));
    await tester.pump(const Duration(milliseconds: 50));
  }
  await gesture.up();
  for (var step = 0; step < 5; step++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _reveal(WidgetTester tester, Finder target, double offset) async {
  final outerScrollable = find
      .descendant(
        of: find.byType(CustomScrollView).first,
        matching: find.byType(Scrollable),
      )
      .first;
  final position = tester.state<ScrollableState>(outerScrollable).position;
  position.jumpTo(offset.clamp(0, position.maxScrollExtent));
  await tester.pump(const Duration(milliseconds: 300));
  expect(target, findsOneWidget);
  final bottomOverflow = tester.getRect(target).bottom - 760;
  if (bottomOverflow > 0) {
    position.jumpTo(
      (position.pixels + bottomOverflow + 24).clamp(
        0,
        position.maxScrollExtent,
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
  }
}
