import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'image_viewer_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(imageViewerDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('image viewer zoomed ${mode.name} golden', (tester) async {
      await pumpDemoPageAtPhoneViewport(
        tester,
        imageViewerDemoPageTestSpec,
        mode,
      );
      final context = tester.element(find.byType(MaterialApp));
      await tester.runAsync(
        () => precacheImage(const AssetImage('assets/img/image.png'), context),
      );
      await tester.pump();

      await tester.tap(find.widgetWithText(TButton, '基础图片预览'));
      await tester.pumpAndSettle();
      final viewer = find.byType(InteractiveViewer);
      final center = tester.getCenter(viewer);
      final first = await tester.createGesture(pointer: 1);
      final second = await tester.createGesture(pointer: 2);
      await first.down(center - const Offset(10, 0));
      await second.down(center + const Offset(10, 0));
      await first.moveTo(center - const Offset(80, 0));
      await second.moveTo(center + const Offset(80, 0));
      await first.up();
      await second.up();
      await tester.pumpAndSettle();

      final controller = tester
          .widget<InteractiveViewer>(viewer)
          .transformationController!;
      expect(controller.value.getMaxScaleOnAxis(), greaterThan(1));
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile('goldens/image_viewer_zoomed_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('image viewer delete confirm ${mode.name} golden', (
      tester,
    ) async {
      await pumpDemoPageAtPhoneViewport(
        tester,
        imageViewerDemoPageTestSpec,
        mode,
      );
      final context = tester.element(find.byType(MaterialApp));
      await tester.runAsync(
        () => precacheImage(const AssetImage('assets/img/image.png'), context),
      );
      await tester.pump();

      await tester.tap(find.widgetWithText(TButton, '带操作图片预览'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Delete'));
      await tester.pumpAndSettle();
      expect(find.text('要删除这张照片吗？'), findsOneWidget);
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile(
          'goldens/image_viewer_delete_confirm_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');

    testWidgets('image viewer actions opened ${mode.name} golden', (
      tester,
    ) async {
      await pumpDemoPageAtPhoneViewport(
        tester,
        imageViewerDemoPageTestSpec,
        mode,
      );
      final context = tester.element(find.byType(MaterialApp));
      await tester.runAsync(
        () => precacheImage(const AssetImage('assets/img/image.png'), context),
      );
      await tester.pump();

      await tester.tap(find.widgetWithText(TButton, '带操作图片预览'));
      await tester.pumpAndSettle();
      await tester.runAsync(
        () => precacheImage(
          const AssetImage('assets/img/image.png'),
          tester.element(find.byType(InteractiveViewer)),
        ),
      );
      await tester.pump();
      expect(find.text('1/2'), findsOneWidget);
      expect(find.byTooltip('Close'), findsOneWidget);
      expect(find.byTooltip('Delete'), findsOneWidget);
      await expectLater(
        find.byType(Overlay),
        matchesGoldenFile(
          'goldens/image_viewer_actions_opened_${mode.name}.png',
        ),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}
