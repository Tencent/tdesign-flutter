import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'demo_page_test_utils.dart';
import 'popup_demo_test_spec.dart';

class _OpenedPopupGoldenCase {
  const _OpenedPopupGoldenCase({
    required this.name,
    required this.triggerKey,
    this.visibleText,
    this.visibleTextCount = 1,
    this.tooltip,
  });

  final String name;
  final String triggerKey;
  final String? visibleText;
  final int visibleTextCount;
  final String? tooltip;
}

void main() {
  registerDemoGoldenTests(popupDemoPageTestSpec);

  const openedPopupCases = [
    _OpenedPopupGoldenCase(
      name: 'basic_top',
      triggerKey: 'popup-top-trigger',
      visibleText: '顶部弹出',
      visibleTextCount: 2,
    ),
    _OpenedPopupGoldenCase(
      name: 'basic_left',
      triggerKey: 'popup-left-trigger',
      visibleText: '左侧弹出',
      visibleTextCount: 2,
    ),
    _OpenedPopupGoldenCase(
      name: 'basic_center',
      triggerKey: 'popup-center-trigger',
      visibleText: '中间弹出',
      visibleTextCount: 2,
    ),
    _OpenedPopupGoldenCase(
      name: 'basic_bottom',
      triggerKey: 'popup-bottom-trigger',
      visibleText: '底部弹出',
      visibleTextCount: 2,
    ),
    _OpenedPopupGoldenCase(
      name: 'basic_right',
      triggerKey: 'popup-right-trigger',
      visibleText: '右侧弹出',
      visibleTextCount: 2,
    ),
    _OpenedPopupGoldenCase(
      name: 'application_with_title',
      triggerKey: 'popup-with-title-trigger',
      visibleText: '标题文字',
    ),
    _OpenedPopupGoldenCase(
      name: 'application_custom_close',
      triggerKey: 'popup-custom-close-trigger',
      tooltip: '关闭',
    ),
  ];

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final popupCase in openedPopupCases) {
      testWidgets('popup ${popupCase.name} ${mode.name} opened golden', (
        tester,
      ) async {
        await pumpDemoPageAtPhoneViewport(tester, popupDemoPageTestSpec, mode);

        final trigger = find.byKey(ValueKey(popupCase.triggerKey));
        expect(trigger, findsOneWidget);
        await tester.tap(trigger);
        await tester.pumpAndSettle();

        if (popupCase.visibleText case final visibleText?) {
          expect(
            find.text(visibleText),
            findsNWidgets(popupCase.visibleTextCount),
          );
        }
        if (popupCase.tooltip case final tooltip?) {
          expect(find.byTooltip(tooltip), findsOneWidget);
        }
        await expectLater(
          find.byType(Overlay),
          matchesGoldenFile(
            'goldens/popup_${popupCase.name}_opened_${mode.name}.png',
          ),
        );
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}
