import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'demo_page_test_utils.dart';
import 'image_viewer_demo_test_spec.dart';

void main() {
  registerDemoGoldenTests(imageViewerDemoPageTestSpec);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
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
