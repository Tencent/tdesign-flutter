import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'popover_demo_test_spec.dart';

class _OpenedPopoverGoldenCase {
  const _OpenedPopoverGoldenCase({
    required this.name,
    required this.triggerText,
    this.visibleTexts = const ['弹出气泡内容'],
  });

  final String name;
  final String triggerText;
  final List<String> visibleTexts;
}

void main() {
  registerDemoGoldenTests(popoverDemoPageTestSpec);

  const openedPopoverCases = [
    _OpenedPopoverGoldenCase(name: 'type_arrow', triggerText: '带箭头'),
    _OpenedPopoverGoldenCase(name: 'type_no_arrow', triggerText: '不带箭头'),
    _OpenedPopoverGoldenCase(
      name: 'type_custom_content',
      triggerText: '自定义内容',
      visibleTexts: ['选项1', '选项2', '选项3'],
    ),
    _OpenedPopoverGoldenCase(name: 'theme_default', triggerText: '深色'),
    _OpenedPopoverGoldenCase(name: 'theme_light', triggerText: '浅色'),
    _OpenedPopoverGoldenCase(name: 'theme_primary', triggerText: '品牌色'),
    _OpenedPopoverGoldenCase(name: 'theme_success', triggerText: '成功色'),
    _OpenedPopoverGoldenCase(name: 'theme_warning', triggerText: '警告色'),
    _OpenedPopoverGoldenCase(name: 'theme_danger', triggerText: '错误色'),
    _OpenedPopoverGoldenCase(name: 'placement_top_left', triggerText: '顶部左'),
    _OpenedPopoverGoldenCase(name: 'placement_top', triggerText: '顶部中'),
    _OpenedPopoverGoldenCase(name: 'placement_top_right', triggerText: '顶部右'),
    _OpenedPopoverGoldenCase(name: 'placement_bottom_left', triggerText: '底部左'),
    _OpenedPopoverGoldenCase(name: 'placement_bottom', triggerText: '底部中'),
    _OpenedPopoverGoldenCase(
      name: 'placement_bottom_right',
      triggerText: '底部右',
    ),
    _OpenedPopoverGoldenCase(
      name: 'placement_right_top',
      triggerText: '右侧上',
      visibleTexts: ['气泡内容'],
    ),
    _OpenedPopoverGoldenCase(
      name: 'placement_right',
      triggerText: '右侧中',
      visibleTexts: ['气泡内容'],
    ),
    _OpenedPopoverGoldenCase(
      name: 'placement_right_bottom',
      triggerText: '右侧下',
      visibleTexts: ['气泡内容'],
    ),
    _OpenedPopoverGoldenCase(
      name: 'placement_left_top',
      triggerText: '左侧上',
      visibleTexts: ['气泡内容'],
    ),
    _OpenedPopoverGoldenCase(
      name: 'placement_left',
      triggerText: '左侧中',
      visibleTexts: ['气泡内容'],
    ),
    _OpenedPopoverGoldenCase(
      name: 'placement_left_bottom',
      triggerText: '左侧下',
      visibleTexts: ['气泡内容'],
    ),
  ];

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final popoverCase in openedPopoverCases) {
      testWidgets('popover ${popoverCase.name} ${mode.name} opened golden', (
        tester,
      ) async {
        await pumpDemoPageAtPhoneViewport(
          tester,
          popoverDemoPageTestSpec,
          mode,
        );
        await tester.pumpAndSettle();

        final trigger = find.widgetWithText(TButton, popoverCase.triggerText);
        final pageScrollable = find
            .descendant(
              of: find.byType(CustomScrollView),
              matching: find.byType(Scrollable),
            )
            .first;
        await tester.scrollUntilVisible(
          trigger,
          240,
          scrollable: pageScrollable,
        );
        await tester.pumpAndSettle();
        expect(trigger, findsOneWidget);

        final triggerCenterY = tester.getRect(trigger).center.dy;
        final distanceToCenter = triggerCenterY - 406;
        if (distanceToCenter.abs() > 1) {
          await tester.drag(pageScrollable, Offset(0, -distanceToCenter));
          await tester.pumpAndSettle();
        }

        await tester.tap(trigger);
        await tester.pumpAndSettle();

        expect(find.byType(TPopoverWidget), findsOneWidget);
        for (final visibleText in popoverCase.visibleTexts) {
          expect(find.text(visibleText), findsOneWidget);
        }
        await expectLater(
          find.byType(Overlay),
          matchesGoldenFile(
            'goldens/popover_${popoverCase.name}_opened_${mode.name}.png',
          ),
        );
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}
