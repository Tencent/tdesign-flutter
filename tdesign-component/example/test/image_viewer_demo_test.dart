import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'image_viewer_demo_test_spec.dart';

void main() {
  registerDemoStructureTests(imageViewerDemoPageTestSpec);

  testWidgets('公开 Demo 仅展示两个设计入口及正确按钮样式', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      imageViewerDemoPageTestSpec,
      ThemeMode.light,
    );

    final buttons = tester.widgetList<TButton>(find.byType(TButton)).toList();
    expect(buttons, hasLength(2));
    for (final button in buttons) {
      expect(button.size, TButtonSize.large);
      expect(button.variant, TButtonVariant.outline);
      expect(button.colorScheme, TButtonColorScheme.primary);
      expect(tester.getSize(find.byWidget(button)).width, 343);
    }
  });

  testWidgets('基础入口打开页码但不展示操作按钮', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      imageViewerDemoPageTestSpec,
      ThemeMode.light,
    );

    await tester.tap(find.widgetWithText(TButton, '基础图片预览'));
    await tester.pumpAndSettle();
    expect(find.text('1/2'), findsOneWidget);
    expect(find.byTooltip('Close'), findsNothing);
    expect(find.byTooltip('Delete'), findsNothing);
  });

  testWidgets('操作入口展示关闭和删除并打开删除确认', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      imageViewerDemoPageTestSpec,
      ThemeMode.light,
    );

    await tester.tap(find.widgetWithText(TButton, '带操作图片预览'));
    await tester.pumpAndSettle();
    expect(find.text('1/2'), findsOneWidget);
    expect(find.byTooltip('Close'), findsOneWidget);
    expect(find.byTooltip('Delete'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('要删除这张照片吗？'), findsOneWidget);
    expect(find.text('删除'), findsOneWidget);
  });
}
