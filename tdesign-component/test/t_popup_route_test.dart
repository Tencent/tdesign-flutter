import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'helpers/popup_test_helpers.dart';
import 'helpers/popup_test_resource.dart' show resetPopupTestResource;

void main() {
  tearDown(resetPopupTestResource);

  group('Popup 路由层行为（通过 TPopup.show 验证）', () {
    testWidgets('无蒙层 + modal=true 时阻断底层点击与滚动',
        (tester) async {
      final controller = ScrollController();
      var backgroundTapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Theme(
            data: ThemeData(extensions: [TThemeData.defaultData()]),
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
                              modal: true,
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

    testWidgets('无蒙层 + modal=false 时允许底层点击与滚动',
        (tester) async {
      final controller = ScrollController();
      var backgroundTapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Theme(
            data: ThemeData(extensions: [TThemeData.defaultData()]),
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
                              modal: false,
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

    group('useSafeArea 安全区', () {
      testWidgets('MediaQuery.padding 全零时 bottom 贴屏幕底', (tester) async {
        await openPopup(
          tester,
          mediaPadding: EdgeInsets.zero,
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: TPopupOptions.bottom(
                height: 100,
                cancelBuilder: null,
                confirmBuilder: null,
                child: const SizedBox(height: 60),
              ),
            );
          },
        );
        await tester.pumpAndSettle();

        final positioned = findPopupPanelPositioned(tester);
        expect(positioned.bottom, 0);
      });

      testWidgets('bottom 默认避让 MediaQuery.padding.bottom', (tester) async {
        const safeBottom = 34.0;
        await openPopup(
          tester,
          mediaPadding: const EdgeInsets.only(bottom: safeBottom),
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: TPopupOptions.bottom(
                height: 120,
                cancelBuilder: null,
                confirmBuilder: null,
                child: const SizedBox(height: 60),
              ),
            );
          },
        );
        await tester.pumpAndSettle();

        final positioned = findPopupPanelPositioned(tester);
        expect(positioned.bottom, safeBottom);
        expect(positioned.height, 120);
      });

      testWidgets('bottom useSafeArea=false 时贴屏幕底边', (tester) async {
        await openPopup(
          tester,
          mediaPadding: const EdgeInsets.only(bottom: 34),
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: TPopupOptions.bottom(
                height: 120,
                useSafeArea: false,
                cancelBuilder: null,
                confirmBuilder: null,
                child: const SizedBox(height: 60),
              ),
            );
          },
        );
        await tester.pumpAndSettle();

        final positioned = findPopupPanelPositioned(tester);
        expect(positioned.bottom, 0);
      });

      testWidgets('bottom 无固定 height 时仍避让底部安全区', (tester) async {
        const safeBottom = 34.0;
        await openPopup(
          tester,
          mediaPadding: const EdgeInsets.only(bottom: safeBottom),
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: TPopupOptions.bottom(
                cancelBuilder: null,
                confirmBuilder: null,
                child: const SizedBox(height: 80, width: 200),
              ),
            );
          },
        );
        await tester.pumpAndSettle();

        final positioned = findPopupPanelPositioned(tester);
        expect(positioned.bottom, safeBottom);
        expect(positioned.height, isNull);
      });

      testWidgets('bottom inset 与安全区在路由层叠加', (tester) async {
        const safeBottom = 34.0;
        await openPopup(
          tester,
          mediaPadding: const EdgeInsets.only(bottom: safeBottom),
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: TPopupOptions.bottom(
                height: 160,
                inset: const TPopupBottomInset(left: 12, right: 20),
                cancelBuilder: null,
                confirmBuilder: null,
                child: const SizedBox(height: 60),
              ),
            );
          },
        );
        await tester.pumpAndSettle();

        final positioned = findPopupPanelPositioned(tester);
        expect(positioned.bottom, safeBottom);
        expect(positioned.left, 12);
        expect(positioned.right, 20);
        expect(positioned.height, 160);
      });

      testWidgets('top 避让 MediaQuery.padding.top', (tester) async {
        const safeTop = 44.0;
        await openPopup(
          tester,
          mediaPadding: const EdgeInsets.only(top: safeTop),
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: TPopupOptions.top(
                height: 100,
                child: const SizedBox(height: 60),
              ),
            );
          },
        );
        await tester.pumpAndSettle();

        final positioned = findPopupPanelPositioned(tester);
        expect(positioned.top, safeTop);
        expect(positioned.height, 100);
        expect(positioned.bottom, isNull);
      });

      testWidgets('top useSafeArea=false 时贴屏幕顶边', (tester) async {
        await openPopup(
          tester,
          mediaPadding: const EdgeInsets.only(top: 44),
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: TPopupOptions.top(
                height: 100,
                useSafeArea: false,
                child: const SizedBox(height: 60),
              ),
            );
          },
        );
        await tester.pumpAndSettle();

        final positioned = findPopupPanelPositioned(tester);
        expect(positioned.top, 0);
      });

      testWidgets('top 不受 bottom padding 影响', (tester) async {
        await openPopup(
          tester,
          mediaPadding: const EdgeInsets.only(bottom: 50),
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: TPopupOptions.top(
                height: 80,
                child: const SizedBox(height: 40),
              ),
            );
          },
        );
        await tester.pumpAndSettle();

        final positioned = findPopupPanelPositioned(tester);
        expect(positioned.top, 0);
      });

      testWidgets('bottom 不受 top padding 影响', (tester) async {
        await openPopup(
          tester,
          mediaPadding: const EdgeInsets.only(top: 50),
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: TPopupOptions.bottom(
                height: 100,
                cancelBuilder: null,
                confirmBuilder: null,
                child: const SizedBox(height: 60),
              ),
            );
          },
        );
        await tester.pumpAndSettle();

        final positioned = findPopupPanelPositioned(tester);
        expect(positioned.bottom, 0);
      });

      testWidgets('left 避让侧栏与上下安全区', (tester) async {
        await openPopup(
          tester,
          mediaPadding: kPopupTestMediaPadding,
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: TPopupOptions.left(
                width: 280,
                inset: const TPopupLeftInset(top: 8, bottom: 12),
                child: const SizedBox(height: 120),
              ),
            );
          },
        );
        await tester.pumpAndSettle();

        final positioned = findPopupPanelPositioned(tester);
        expect(positioned.left, 11);
        expect(positioned.top, 30);
        expect(positioned.bottom, 56);
        expect(positioned.width, 280);
      });

      testWidgets('left useSafeArea=false 时贴屏幕左缘', (tester) async {
        await openPopup(
          tester,
          mediaPadding: kPopupTestMediaPadding,
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: TPopupOptions.left(
                width: 280,
                useSafeArea: false,
                child: const SizedBox(height: 120),
              ),
            );
          },
        );
        await tester.pumpAndSettle();

        final positioned = findPopupPanelPositioned(tester);
        expect(positioned.left, 0);
        expect(positioned.top, 0);
        expect(positioned.bottom, 0);
      });

      testWidgets('right 避让侧栏与上下安全区', (tester) async {
        await openPopup(
          tester,
          mediaPadding: kPopupTestMediaPadding,
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: TPopupOptions.right(
                width: 260,
                inset: const TPopupRightInset(top: 5, bottom: 7),
                child: const SizedBox(height: 120),
              ),
            );
          },
        );
        await tester.pumpAndSettle();

        final positioned = findPopupPanelPositioned(tester);
        expect(positioned.right, 33);
        expect(positioned.top, 27);
        expect(positioned.bottom, 51);
        expect(positioned.width, 260);
      });

      testWidgets('right useSafeArea=false 时贴屏幕右缘', (tester) async {
        await openPopup(
          tester,
          mediaPadding: kPopupTestMediaPadding,
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: TPopupOptions.right(
                width: 260,
                useSafeArea: false,
                child: const SizedBox(height: 120),
              ),
            );
          },
        );
        await tester.pumpAndSettle();

        final positioned = findPopupPanelPositioned(tester);
        expect(positioned.right, 0);
        expect(positioned.top, 0);
        expect(positioned.bottom, 0);
      });

      testWidgets('通用 TPopupOptions 指定 top 时仍应用安全区', (tester) async {
        const safeTop = 30.0;
        await openPopup(
          tester,
          mediaPadding: const EdgeInsets.only(top: safeTop),
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: const TPopupOptions(
                placement: TPopupPlacement.top,
                height: 90,
                child: SizedBox(height: 50),
              ),
            );
          },
        );
        await tester.pumpAndSettle();

        final positioned = findPopupPanelPositioned(tester);
        expect(positioned.top, safeTop);
      });

      testWidgets('center 忽略 useSafeArea', (tester) async {
        await openPopup(
          tester,
          mediaPadding: const EdgeInsets.only(bottom: 34, top: 44),
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: TPopupOptions.center(
                width: 120,
                height: 120,
                closeBuilder: null,
                child: const SizedBox(height: 80, width: 80),
              ),
            );
          },
        );
        await tester.pumpAndSettle();

        expect(find.byType(Positioned), findsOneWidget);
        final positioned = tester.widget<Positioned>(find.byType(Positioned));
        expect(positioned.left, 0);
        expect(positioned.top, 0);
        expect(positioned.right, 0);
        expect(positioned.bottom, 0);
      });

      testWidgets('center 在 useSafeArea=false 时仍为全屏 fill', (tester) async {
        await openPopup(
          tester,
          mediaPadding: kPopupTestMediaPadding,
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: TPopupOptions.center(
                width: 100,
                height: 100,
                useSafeArea: false,
                closeBuilder: null,
                child: const SizedBox(height: 80, width: 80),
              ),
            );
          },
        );
        await tester.pumpAndSettle();

        expect(find.byType(Positioned), findsOneWidget);
        final positioned = tester.widget<Positioned>(find.byType(Positioned));
        expect(positioned.left, 0);
        expect(positioned.top, 0);
        expect(positioned.right, 0);
        expect(positioned.bottom, 0);
      });
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
