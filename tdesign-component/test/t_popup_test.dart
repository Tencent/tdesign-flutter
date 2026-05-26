import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'helpers/popup_test_helpers.dart';
import 'helpers/popup_test_resource.dart';

class _RecordingNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushedRoutes = <Route<dynamic>>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }

  int get popupPushCount =>
      pushedRoutes.where((route) => route is PopupRoute<dynamic>).length;
}

void main() {
  tearDown(resetPopupTestResource);

  group('TPopup 国际化文案', () {
    for (final resource in [
      PopupTestResourceDelegate.zh(),
      PopupTestResourceDelegate.en(),
    ]) {
      testWidgets(
        '${resource.locale.languageCode} 底部默认 cancel / confirm 按钮点击关闭浮层',
        (tester) async {
          late BuildContext hostContext;

          await openPopup(
            tester,
            resource: resource,
            onPressed: () {
              hostContext = tester.element(find.text('open'));
              TPopup.show(
                hostContext,
                options: TPopupOptions(
                    placement: TPopupPlacement.bottom,
                    height: 200,
                    child: const SizedBox(height: 80)),
              );
            },
          );
          await tester.pumpAndSettle();
          expect(find.text(resource.cancelText), findsOneWidget);
          expect(find.text(resource.confirmText), findsOneWidget);

          await tester.tap(find.text(resource.cancelText));
          await tester.pumpAndSettle();
          expect(find.text(resource.cancelText), findsNothing);

          await openPopup(
            tester,
            resource: resource,
            onPressed: () {
              TPopup.show(
                hostContext,
                options: TPopupOptions(
                    placement: TPopupPlacement.bottom,
                    height: 200,
                    child: const SizedBox(height: 80)),
              );
            },
          );
          await tester.pumpAndSettle();
          await tester.tap(find.text(resource.confirmText));
          await tester.pumpAndSettle();
          expect(find.text(resource.confirmText), findsNothing);
        },
      );
    }

    testWidgets('同一用例内切换中英文资源', (tester) async {
      late BuildContext hostContext;

      for (final resource in [
        PopupTestResourceDelegate.zh(),
        PopupTestResourceDelegate.en(),
      ]) {
        TPopupHandle? handle;
        await openPopup(
          tester,
          resource: resource,
          onPressed: () {
            hostContext = tester.element(find.text('open'));
            handle = TPopup.show(
              hostContext,
              options: TPopupOptions(
                  placement: TPopupPlacement.bottom,
                  height: 160,
                  child: const SizedBox(height: 60)),
            );
          },
        );
        await tester.pumpAndSettle();
        expect(find.text(resource.cancelText), findsOneWidget);
        expect(find.text(resource.confirmText), findsOneWidget);
        handle!.close();
        await tester.pumpAndSettle();
      }
    });
  });

  group('TPopup 生命周期', () {
    testWidgets('show 触发 onOpen / onOpened 各一次', (tester) async {
      var openCount = 0;
      var openedCount = 0;
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
                height: 120,
                onOpen: () => openCount++,
                onOpened: () => openedCount++,
                child: const SizedBox(height: 80)),
          );
        },
      );
      await tester.pump();
      expect(openCount, 1);
      await tester.pumpAndSettle();
      expect(openedCount, 1);

      handle!.close();
      await tester.pumpAndSettle();
    });

    testWidgets('handle.close 触发 onClose / onClosed', (tester) async {
      var closeCount = 0;
      var closedCount = 0;
      var visibleChanges = <bool>[];
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
                height: 120,
                onClose: () => closeCount++,
                onClosed: () => closedCount++,
                onVisibleChange: (v, _) => visibleChanges.add(v),
                child: const SizedBox(height: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      handle!.close();
      await tester.pumpAndSettle();
      expect(closeCount, 1);
      expect(closedCount, 1);
      expect(visibleChanges, [true, false]);
      expect(handle!.isShowing, false);
    });

    testWidgets('重复 close 不会重复触发 onClose', (tester) async {
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
      handle!.close();
      await tester.pumpAndSettle();
      expect(closeCount, 1);
    });
  });

  group('TPopup Navigator 选择', () {
    testWidgets('navigatorContext 首次 show 挂载到指定 Navigator，且 handle.open 复用缓存',
        (tester) async {
      final rootObserver = _RecordingNavigatorObserver();
      final nestedObserver = _RecordingNavigatorObserver();
      late BuildContext rootContext;
      late BuildContext nestedContext;
      late TPopupHandle handle;

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [rootObserver],
          home: TTheme(
            data: TThemeData.defaultData(),
            child: Builder(
              builder: (rootCtx) {
                rootContext = rootCtx;
                return Navigator(
                  observers: [nestedObserver],
                  onGenerateRoute: (_) {
                    return MaterialPageRoute<void>(
                      builder: (nestedCtx) {
                        nestedContext = nestedCtx;
                        return Scaffold(
                          body: ElevatedButton(
                            onPressed: () {
                              handle = TPopup.show(
                                nestedContext,
                                navigatorContext: rootContext,
                                options: TPopupOptions.bottom(
                                  height: 120,
                                  cancelBuilder: null,
                                  confirmBuilder: null,
                                  child: const SizedBox(
                                    height: 60,
                                    child: Text('root popup'),
                                  ),
                                ),
                              );
                            },
                            child: const Text('open via root'),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('open via root'));
      await tester.pumpAndSettle();
      expect(rootObserver.popupPushCount, 1);
      expect(nestedObserver.popupPushCount, 0);
      expect(find.text('root popup'), findsOneWidget);

      handle.close();
      await tester.pumpAndSettle();
      expect(find.text('root popup'), findsNothing);

      handle.open();
      await tester.pumpAndSettle();
      expect(rootObserver.popupPushCount, 2);
      expect(nestedObserver.popupPushCount, 0);
      expect(find.text('root popup'), findsOneWidget);
    });

    testWidgets('useRootNavigator=true 会挂载到根 Navigator', (tester) async {
      final rootObserver = _RecordingNavigatorObserver();
      final nestedObserver = _RecordingNavigatorObserver();
      late BuildContext nestedContext;

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [rootObserver],
          home: TTheme(
            data: TThemeData.defaultData(),
            child: Navigator(
              observers: [nestedObserver],
              onGenerateRoute: (_) {
                return MaterialPageRoute<void>(
                  builder: (ctx) {
                    nestedContext = ctx;
                    return Scaffold(
                      body: ElevatedButton(
                        onPressed: () {
                          TPopup.show(
                            nestedContext,
                            useRootNavigator: true,
                            options: TPopupOptions.center(
                              width: 120,
                              height: 80,
                              closeBuilder: null,
                              child: const SizedBox(
                                width: 120,
                                height: 80,
                                child: Text('root navigator popup'),
                              ),
                            ),
                          );
                        },
                        child: const Text('open root navigator'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('open root navigator'));
      await tester.pumpAndSettle();
      expect(rootObserver.popupPushCount, 1);
      expect(nestedObserver.popupPushCount, 0);
      expect(find.text('root navigator popup'), findsOneWidget);
    });
  });

  group('TPopup placement', () {
    const placements = [
      TPopupPlacement.top,
      TPopupPlacement.bottom,
      TPopupPlacement.left,
      TPopupPlacement.right,
      TPopupPlacement.center,
    ];
    for (final placement in placements) {
      testWidgets('$placement 可正常打开关闭', (tester) async {
        late BuildContext hostContext;
        TPopupHandle? handle;
        await openPopup(
          tester,
          onPressed: () {
            hostContext = tester.element(find.text('open'));
            handle = TPopup.show(
              hostContext,
              options: TPopupOptions(
                  placement: placement,
                  height: placement == TPopupPlacement.left ||
                          placement == TPopupPlacement.right
                      ? null
                      : 120,
                  width: placement == TPopupPlacement.top ||
                          placement == TPopupPlacement.bottom
                      ? null
                      : 200,
                  child: const SizedBox(height: 60, width: 60)),
            );
          },
        );
        await tester.pumpAndSettle();
        expect(find.byType(Stack), findsWidgets);
        handle!.close();
        await tester.pumpAndSettle();
      });
    }
  });

  group('TPopup Header', () {
    testWidgets('底部默认头部：title / cancel / confirm 按钮渲染', (tester) async {
      late BuildContext hostContext;

      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          TPopup.show(
            hostContext,
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 200,
                titleWidget: TText('标题'),
                child: const SizedBox(height: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('标题'), findsOneWidget);
      expect(find.text('取消'), findsOneWidget);
      expect(find.text('确定'), findsOneWidget);

      // 点取消默认 sentinel 自带 close → 浮层关闭
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(find.text('标题'), findsNothing);

      // 重新打开点确定 → 同样关闭
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            hostContext,
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 200,
                child: const SizedBox(height: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(find.text('确定'), findsNothing);
    });

    testWidgets('cancelBuilder 自定义可选择不调 close → 浮层保持展示', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 200,
                cancelBuilder: (_, __) => GestureDetector(
                      onTap: () {}, // 不调 close
                      child: const Text('自定义取消'),
                    ),
                child: const SizedBox(height: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('自定义取消'));
      await tester.pump();
      expect(find.text('自定义取消'), findsOneWidget);
    });

    testWidgets('bottom headerBuilder=null 不渲染头部', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 180,
                titleWidget: TText('不应出现'),
                headerBuilder: null,
                child: const SizedBox(height: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('不应出现'), findsNothing);
      expect(find.text('取消'), findsNothing);
    });

    testWidgets('bottom 仅标题无操作栏', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 180,
                titleWidget: TText('仅标题'),
                cancelBuilder: null,
                confirmBuilder: null,
                child: const SizedBox(height: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('仅标题'), findsOneWidget);
      expect(find.text('取消'), findsNothing);
      expect(find.text('确定'), findsNothing);
      expect(find.byIcon(TIcons.close), findsNothing);
    });

    testWidgets('headerBuilder 自定义头部', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                headerBuilder: (_, __) => const Text('自定义:传入标题'),
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('自定义'), findsOneWidget);
    });

    testWidgets('居中关闭在内容与下方', (tester) async {
      late BuildContext hostContext;

      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          TPopup.show(
            hostContext,
            options: TPopupOptions(
                placement: TPopupPlacement.center,
                width: 120,
                height: 120,
                child: const SizedBox(height: 80, width: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(TIcons.close_circle), findsOneWidget);
      await tester.tap(find.byIcon(TIcons.close_circle));
      await tester.pumpAndSettle();
    });

    testWidgets('居中关闭在下方与示例一致 expand 不报错', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.center,
                width: 240,
                height: 240,
                child: const SizedBox.expand()),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(TIcons.close_circle), findsOneWidget);
    });

    testWidgets('center closeBuilder=null 不显示关闭区', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.center,
                width: 120,
                height: 120,
                closeBuilder: null,
                child: const SizedBox(height: 80, width: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(TIcons.close_circle), findsNothing);
    });

    testWidgets('cancelBuilder / confirmBuilder', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                cancelBuilder: (_, __) => const Text('自定义取消'),
                confirmBuilder: (_, __) => const Text('自定义确认'),
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('自定义取消'), findsOneWidget);
      expect(find.text('自定义确认'), findsOneWidget);
    });
  });

  group('TPopup 蒙层与行为', () {
    testWidgets('点击蒙层关闭', (tester) async {
      var overlayClose = 0;
      late BuildContext hostContext;

      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          TPopup.show(
            hostContext,
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 100,
                onClosed: () => overlayClose++,
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      // 点击蒙层区域（屏幕上方）
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(overlayClose, 1);
    });

    testWidgets('closeOnOverlayClick 为 false 点击蒙层不关闭', (tester) async {
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
                closeOnOverlayClick: false,
                onOverlayClick: () {},
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('取消'), findsOneWidget);
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
      expect(find.text('取消'), findsOneWidget);
      handle!.close();
      await tester.pumpAndSettle();
    });

    testWidgets('showOverlay false 且 modal=true', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 100,
                showOverlay: false,
                modal: true,
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(
        find.byType(ModalBarrier),
        findsWidgets,
      );
    });

    testWidgets('模态与蒙层合法组合矩阵都可正常 show / close', (tester) async {
      late BuildContext hostContext;

      await tester.pumpWidget(
        wrapPopupTest(
          Builder(
            builder: (context) {
              hostContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      Future<void> expectShowAndClose(
        String label,
        TPopupOptions options,
      ) async {
        late TPopupHandle handle;
        expect(
          () => handle = TPopup.show(hostContext, options: options),
          returnsNormally,
          reason: label,
        );
        await tester.pumpAndSettle();
        expect(find.text(label), findsOneWidget, reason: label);

        handle.close();
        await tester.pumpAndSettle();
        expect(find.text(label), findsNothing, reason: label);
      }

      await expectShowAndClose(
        '标准模态默认关闭',
        TPopupOptions.bottom(
          height: 100,
          showOverlay: true,
          modal: true,
          cancelBuilder: null,
          confirmBuilder: null,
          child: const SizedBox(height: 60, child: Text('标准模态默认关闭')),
        ),
      );
      await expectShowAndClose(
        '标准模态显式禁止蒙层关闭',
        TPopupOptions.bottom(
          height: 100,
          showOverlay: true,
          modal: true,
          closeOnOverlayClick: false,
          cancelBuilder: null,
          confirmBuilder: null,
          child: const SizedBox(height: 60, child: Text('标准模态显式禁止蒙层关闭')),
        ),
      );
      await expectShowAndClose(
        '透明模态默认关闭策略',
        TPopupOptions.bottom(
          height: 100,
          showOverlay: false,
          modal: true,
          cancelBuilder: null,
          confirmBuilder: null,
          child: const SizedBox(height: 60, child: Text('透明模态默认关闭策略')),
        ),
      );
      await expectShowAndClose(
        '非模态浮层默认关闭策略',
        TPopupOptions.bottom(
          height: 100,
          showOverlay: false,
          modal: false,
          cancelBuilder: null,
          confirmBuilder: null,
          child: const SizedBox(height: 60, child: Text('非模态浮层默认关闭策略')),
        ),
      );
    });

    testWidgets('overlayOpacity 与自定义颜色', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 80,
                overlayColor: Colors.red,
                overlayOpacity: 0.5,
                child: const SizedBox(height: 40)),
          );
        },
      );
      await tester.pumpAndSettle();
      await tester.pump();
    });

    testWidgets('right inset.top 可控制顶部留白', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.right,
                inset: const TPopupRightInset(top: 80),
                child: const SizedBox(height: 200)),
          );
        },
      );
      await tester.pumpAndSettle();
    });
  });

  group('TPopupHandle / Tracker', () {
    testWidgets('重复 show 可叠加打开（返回不同 handle）', (tester) async {
      TPopupHandle? first;
      TPopupHandle? second;
      await openPopup(
        tester,
        onPressed: () {
          final ctx = tester.element(find.text('open'));
          first = TPopup.show(
            ctx,
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 80,
                cancelBuilder: null,
                confirmBuilder: null,
                child: const SizedBox(height: 40, child: Text('first'))),
          );
          second = TPopup.show(
            ctx,
            options: TPopupOptions(
                placement: TPopupPlacement.center,
                width: 120,
                height: 80,
                closeBuilder: null,
                child: const SizedBox(width: 120, height: 80, child: Text('second'))),
          );
          expect(second!.isShowing, isTrue);
          expect(identical(first, second), isFalse);
        },
      );
      await tester.pumpAndSettle();
      expect(first!.isShowing, isTrue);
      expect(second!.isShowing, isTrue);
      expect(find.text('first'), findsOneWidget);
      expect(find.text('second'), findsOneWidget);

      second!.close();
      await tester.pumpAndSettle();
      expect(second!.isShowing, isFalse);
      expect(first!.isShowing, isTrue);
      expect(find.text('second'), findsNothing);
      expect(find.text('first'), findsOneWidget);

      first!.close();
      await tester.pumpAndSettle();
    });

    testWidgets('外层 handle.close 在内层展示时只关闭外层', (tester) async {
      TPopupHandle? outerHandle;
      TPopupHandle? innerHandle;

      await openPopup(
        tester,
        onPressed: () {
          outerHandle = TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                cancelBuilder: null,
                confirmBuilder: null,
                child: Builder(
                  builder: (ctx) {
                    return Column(
                      children: [
                        const Text('outer'),
                        ElevatedButton(
                          onPressed: () {
                            innerHandle = TPopup.show(
                              ctx,
                              options: TPopupOptions(
                                placement: TPopupPlacement.center,
                                width: 120,
                                height: 80,
                                closeBuilder: null,
                                child: const SizedBox(
                                  width: 120,
                                  height: 80,
                                  child: Text('inner'),
                                ),
                              ),
                            );
                          },
                          child: const Text('open inner'),
                        ),
                      ],
                    );
                  },
                )),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('outer'), findsOneWidget);

      await tester.tap(find.text('open inner'));
      await tester.pumpAndSettle();
      expect(find.text('outer'), findsOneWidget);
      expect(find.text('inner'), findsOneWidget);

      outerHandle!.close();
      await tester.pumpAndSettle();
      expect(outerHandle!.isShowing, isFalse);
      expect(innerHandle!.isShowing, isTrue);
      expect(find.text('outer'), findsNothing);
      expect(find.text('inner'), findsOneWidget);

      innerHandle!.close();
      await tester.pumpAndSettle();
      expect(find.text('inner'), findsNothing);
    });

    testWidgets('系统返回键关闭并上报 systemBack trigger', (tester) async {
      var closedCount = 0;
      TPopupTrigger? hideTrigger;
      late BuildContext hostContext;

      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          TPopup.show(
            hostContext,
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 100,
                onClosed: () => closedCount++,
                onVisibleChange: (visible, trigger) {
                  if (!visible) {
                    hideTrigger = trigger;
                  }
                },
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(closedCount, 1);
      expect(hideTrigger, TPopupTrigger.systemBack);
    });

    testWidgets('handle.close 后 handle.open 可再次展示', (tester) async {
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
                cancelBuilder: null,
                confirmBuilder: null,
                child: const SizedBox(height: 60, child: Text('panel'))),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('panel'), findsOneWidget);

      handle!.close();
      await tester.pumpAndSettle();
      expect(handle!.isShowing, isFalse);
      expect(find.text('panel'), findsNothing);

      handle!.open(hostContext);
      await tester.pumpAndSettle();
      expect(handle!.isShowing, isTrue);
      expect(find.text('panel'), findsOneWidget);
    });

    testWidgets('关闭动画未结束时重新 open 不会被旧 route 回调误清理', (tester) async {
      late BuildContext hostContext;
      TPopupHandle? handle;
      var openCount = 0;
      var closedCount = 0;

      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          handle = TPopup.show(
            hostContext,
            options: TPopupOptions.bottom(
              height: 100,
              cancelBuilder: null,
              confirmBuilder: null,
              animationDuration: const Duration(milliseconds: 300),
              onOpen: () => openCount++,
              onClosed: () => closedCount++,
              child: const SizedBox(height: 60, child: Text('race panel')),
            ),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(handle!.isShowing, isTrue);
      expect(openCount, 1);
      expect(closedCount, 0);

      handle!.close();
      await tester.pump(const Duration(milliseconds: 100));

      handle!.open(hostContext);
      await tester.pump();
      expect(handle!.isShowing, isTrue);
      expect(openCount, 2);

      await tester.pumpAndSettle();
      expect(handle!.isShowing, isTrue);
      expect(find.text('race panel'), findsOneWidget);
      expect(closedCount, 0);

      handle!.close();
      await tester.pumpAndSettle();
      expect(closedCount, 1);
    });

    testWidgets('navigatorContext 失效后 handle.open 仍优先复用缓存 navigator',
        (tester) async {
      TPopupHandle? handle;
      var showLauncher = true;

      await tester.pumpWidget(
        MaterialApp(
          home: TTheme(
            data: TThemeData.defaultData(),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: Column(
                    children: [
                      if (showLauncher)
                        Builder(
                          builder: (launcherContext) {
                            return ElevatedButton(
                              onPressed: () {
                                handle = TPopup.show(
                                  launcherContext,
                                  navigatorContext: launcherContext,
                                  options: TPopupOptions.bottom(
                                    height: 100,
                                    cancelBuilder: null,
                                    confirmBuilder: null,
                                    child: const SizedBox(
                                      height: 60,
                                      child: Text('cached navigator popup'),
                                    ),
                                  ),
                                );
                              },
                              child: const Text('open popup'),
                            );
                          },
                        ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() => showLauncher = false);
                        },
                        child: const Text('dispose launcher'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('open popup'));
      await tester.pumpAndSettle();
      expect(find.text('cached navigator popup'), findsOneWidget);

      handle!.close();
      await tester.pumpAndSettle();
      expect(find.text('cached navigator popup'), findsNothing);

      await tester.tap(find.text('dispose launcher'));
      await tester.pumpAndSettle();

      expect(() => handle!.open(), returnsNormally);
      await tester.pumpAndSettle();
      expect(handle!.isShowing, isTrue);
      expect(find.text('cached navigator popup'), findsOneWidget);
    });

    testWidgets('非栈顶 handle.close 会立即移除 route 并触发 onClosed', (tester) async {
      TPopupHandle? outerHandle;
      TPopupHandle? innerHandle;
      var outerClosedCount = 0;

      await openPopup(
        tester,
        onPressed: () {
          outerHandle = TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions.bottom(
              height: 160,
              animationDuration: const Duration(milliseconds: 300),
              cancelBuilder: null,
              confirmBuilder: null,
              onClosed: () => outerClosedCount++,
              child: Builder(
                builder: (ctx) {
                  return Column(
                    children: [
                      const Text('outer immediate remove'),
                      ElevatedButton(
                        onPressed: () {
                          innerHandle = TPopup.show(
                            ctx,
                            options: TPopupOptions.center(
                              width: 120,
                              height: 80,
                              closeBuilder: null,
                              child: const SizedBox(
                                width: 120,
                                height: 80,
                                child: Text('inner immediate remove'),
                              ),
                            ),
                          );
                        },
                        child: const Text('open inner immediate'),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('open inner immediate'));
      await tester.pumpAndSettle();

      outerHandle!.close();
      await tester.pump();
      expect(find.text('outer immediate remove'), findsNothing);
      expect(find.text('inner immediate remove'), findsOneWidget);
      expect(outerClosedCount, 1);

      innerHandle!.close();
      await tester.pumpAndSettle();
    });

    testWidgets('handle.open 在已展示时无副作用', (tester) async {
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
                height: 80,
                cancelBuilder: null,
                confirmBuilder: null,
                child: const SizedBox(height: 40)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(handle!.isShowing, isTrue);

      handle!.open(hostContext);
      await tester.pumpAndSettle();
      expect(handle!.isShowing, isTrue);
    });

    testWidgets('非法参数组合矩阵在 show 时直接抛 FlutterError', (tester) async {
      late BuildContext hostContext;

      await tester.pumpWidget(
        wrapPopupTest(
          Builder(
            builder: (context) {
              hostContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      void expectInvalidShow(String reason, TPopupOptions options) {
        expect(
          () => TPopup.show(hostContext, options: options),
          throwsA(isA<FlutterError>()),
          reason: reason,
        );
      }

      expectInvalidShow(
        '有蒙层但非模态（默认关闭策略）',
        TPopupOptions.bottom(
          child: const SizedBox(height: 40),
          showOverlay: true,
          modal: false,
        ),
      );
      expectInvalidShow(
        '有蒙层但非模态（显式 false）',
        TPopupOptions.bottom(
          child: const SizedBox(height: 40),
          showOverlay: true,
          modal: false,
          closeOnOverlayClick: false,
        ),
      );
      expectInvalidShow(
        '透明模态显式要求蒙层关闭',
        TPopupOptions.bottom(
          child: const SizedBox(height: 40),
          showOverlay: false,
          modal: true,
          closeOnOverlayClick: true,
        ),
      );
      expectInvalidShow(
        '非模态浮层显式要求蒙层关闭',
        TPopupOptions.bottom(
          child: const SizedBox(height: 40),
          showOverlay: false,
          modal: false,
          closeOnOverlayClick: true,
        ),
      );
    });
  });

  group('TPopup 扩展场景', () {
    testWidgets('top 不渲染头部、仅显示 child（用 .top factory）', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            // .top factory 根本不暴露 titleWidget：编译期就杜绝错位
            options: TPopupOptions.top(
              height: 120,
              child: const Text('内容'),
            ),
          );
        },
      );
      await tester.pumpAndSettle();
      // 不应出现默认头部文案（zh 资源）
      expect(find.text('取消'), findsNothing);
      expect(find.text('确定'), findsNothing);
      expect(find.text('内容'), findsOneWidget);
    });

    testWidgets('left / right 侧栏展开内容', (tester) async {
      for (final placement in [
        TPopupPlacement.left,
        TPopupPlacement.right,
      ]) {
        late BuildContext hostContext;
        TPopupHandle? handle;
        await openPopup(
          tester,
          onPressed: () {
            hostContext = tester.element(find.text('open'));
            handle = TPopup.show(
              hostContext,
              options: TPopupOptions(
                  placement: placement,
                  width: 240,
                  child: const SizedBox(height: 40)),
            );
          },
        );
        await tester.pumpAndSettle();
        expect(find.byType(Expanded), findsOneWidget);
        handle!.close();
        await tester.pumpAndSettle();
      }
    });

    testWidgets('titleWidget + 自定义 cancel/confirm Builder 文案', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 180,
                titleWidget: const Text('Widget标题'),
                cancelBuilder: (_, close) =>
                    GestureDetector(onTap: close, child: const Text('左')),
                confirmBuilder: (_, close) =>
                    GestureDetector(onTap: close, child: const Text('右')),
                child: const SizedBox(height: 40)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('Widget标题'), findsOneWidget);
      expect(find.text('左'), findsOneWidget);
      expect(find.text('右'), findsOneWidget);
    });

    testWidgets('destroyOnClose 与自定义 close 组件', (tester) async {
      late BuildContext hostContext;
      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          TPopup.show(
            hostContext,
            options: TPopupOptions(
                placement: TPopupPlacement.center,
                width: 140,
                destroyOnClose: true,
                closeBuilder: (_, close) => GestureDetector(
                      onTap: close,
                      child: const Text('关'),
                    ),
                child: const SizedBox(height: 60, width: 120)),
          );
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('关'));
      await tester.pumpAndSettle();
    });

    testWidgets('onOverlayClick 且点击蒙层关闭', (tester) async {
      var overlayClick = 0;
      late BuildContext hostContext;
      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          TPopup.show(
            hostContext,
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 100,
                onOverlayClick: () => overlayClick++,
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(overlayClick, 1);
    });

    testWidgets('show 返回的 handle 关闭后 isShowing 为 false', (tester) async {
      TPopupHandle? handle;
      await openPopup(
        tester,
        onPressed: () {
          handle = TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 80,
                child: const SizedBox(height: 40)),
          );
        },
      );
      await tester.pumpAndSettle();
      handle!.close();
      await tester.pumpAndSettle();
      expect(handle!.isShowing, isFalse);
      handle!.close();
    });
  });

  group('TPopup 触发源与配置', () {
    testWidgets('handle.close 触发 api', (tester) async {
      TPopupTrigger? hideTrigger;
      TPopupHandle? handle;

      await openPopup(
        tester,
        onPressed: () {
          handle = TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 100,
                onVisibleChange: (v, t) {
                  if (!v) {
                    hideTrigger = t;
                  }
                },
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      handle!.close();
      await tester.pumpAndSettle();
      expect(hideTrigger, TPopupTrigger.api);
    });

    testWidgets('confirm 点击触发 confirm', (tester) async {
      TPopupTrigger? hideTrigger;
      late BuildContext hostContext;

      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          TPopup.show(
            hostContext,
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 120,
                onVisibleChange: (v, t) {
                  if (!v) {
                    hideTrigger = t;
                  }
                },
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(hideTrigger, TPopupTrigger.confirm);
    });

    testWidgets('destroyOnClose 路由关闭后可再次 show', (tester) async {
      late BuildContext hostContext;
      TPopupHandle? first;

      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          first = TPopup.show(
            hostContext,
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 80,
                destroyOnClose: true,
                cancelBuilder: null,
                confirmBuilder: null,
                child: const SizedBox(height: 40)),
          );
        },
      );
      await tester.pumpAndSettle();
      first!.close();
      await tester.pumpAndSettle();
      expect(first!.isShowing, isFalse);

      TPopupHandle? second;
      await openPopup(
        tester,
        onPressed: () {
          second = TPopup.show(
            hostContext,
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 80,
                destroyOnClose: true,
                cancelBuilder: null,
                confirmBuilder: null,
                child: const SizedBox(height: 40)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(second!.isShowing, isTrue);
      second!.close();
      await tester.pumpAndSettle();
    });
  });

  group('TPopup 自定义控件', () {
    testWidgets('自定义 cancel / confirm / close 组件', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 200,
                cancelBuilder: (_, __) => const Text('自定义取消'),
                confirmBuilder: (_, __) => const Text('自定义确认'),
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('自定义取消'), findsOneWidget);
      expect(find.text('自定义确认'), findsOneWidget);
    });

    testWidgets('自定义 cancelBuilder 保留业务侧语义', (tester) async {
      final semanticsHandle = tester.ensureSemantics();
      try {
        await openPopup(
          tester,
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 200,
                confirmBuilder: null,
                cancelBuilder: (_, close) => Semantics(
                  container: true,
                  label: '自定义取消语义',
                  button: true,
                  child: GestureDetector(
                    onTap: close,
                    child: const Text('自定义取消'),
                  ),
                ),
                child: const SizedBox(height: 60),
              ),
            );
          },
        );
        await tester.pumpAndSettle();
        final semanticsNode = tester.getSemantics(find.text('自定义取消'));
        expect(semanticsNode.label, contains('自定义取消语义'));
        expect(semanticsNode.label, isNot('取消'));
      } finally {
        semanticsHandle.dispose();
      }
    });
  });
}
