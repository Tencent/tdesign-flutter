import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'helpers/popup_test_helpers.dart';
import 'helpers/popup_test_resource.dart';

void main() {
  tearDown(resetPopupTestResource);

  group('Popup 路由层行为（通过 TPopup.show 验证）', () {
    testWidgets('无蒙层 + preventScrollThrough=true 时阻断底层点击与滚动',
        (tester) async {
      final controller = ScrollController();
      var backgroundTapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: TTheme(
            data: TThemeData.defaultData(),
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => backgroundTapCount++,
                        child: const Text('background button'),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: controller,
                          itemCount: 30,
                          itemBuilder: (_, index) => SizedBox(
                            height: 48,
                            child: Text('item-$index'),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          TPopup.show(
                            context,
                            options: TPopupOptions.bottom(
                              height: 120,
                              showOverlay: false,
                              preventScrollThrough: true,
                              cancelBuilder: null,
                              confirmBuilder: null,
                              child: const SizedBox(height: 60),
                            ),
                          );
                        },
                        child: const Text('open popup'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final backgroundButtonCenter =
          tester.getCenter(find.text('background button'));
      final listDragStart = tester.getCenter(find.text('item-3'));

      await tester.tap(find.text('open popup'));
      await tester.pumpAndSettle();

      await tester.tapAt(backgroundButtonCenter);
      await tester.pump();
      expect(backgroundTapCount, 0);

      await tester.dragFrom(listDragStart, const Offset(0, -200));
      await tester.pump();
      expect(controller.offset, 0);
    });

    testWidgets('无蒙层 + preventScrollThrough=false 时允许底层点击与滚动',
        (tester) async {
      final controller = ScrollController();
      var backgroundTapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: TTheme(
            data: TThemeData.defaultData(),
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  return Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => backgroundTapCount++,
                        child: const Text('background button'),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: controller,
                          itemCount: 30,
                          itemBuilder: (_, index) => SizedBox(
                            height: 48,
                            child: Text('item-$index'),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          TPopup.show(
                            context,
                            options: TPopupOptions.bottom(
                              height: 120,
                              showOverlay: false,
                              preventScrollThrough: false,
                              cancelBuilder: null,
                              confirmBuilder: null,
                              child: const SizedBox(height: 60),
                            ),
                          );
                        },
                        child: const Text('open popup'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final backgroundButtonCenter =
          tester.getCenter(find.text('background button'));
      final listDragStart = tester.getCenter(find.text('item-3'));

      await tester.tap(find.text('open popup'));
      await tester.pumpAndSettle();

      await tester.tapAt(backgroundButtonCenter);
      await tester.pump();
      expect(backgroundTapCount, 1);

      await tester.dragFrom(listDragStart, const Offset(0, -200));
      await tester.pump();
      expect(controller.offset, greaterThan(0));
    });

    testWidgets('fireCloseStart 仅触发一次 onClose', (tester) async {
      var closeCount = 0;
      late BuildContext hostContext;
      TPopupHandle? handle;

      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          handle = TPopup.show(
            hostContext,
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 100,
                onClose: () => closeCount++,
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      handle!.close();
      await tester.pumpAndSettle();
      expect(closeCount, 1);
    });
  });
}
