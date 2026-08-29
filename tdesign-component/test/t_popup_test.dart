import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'helpers/popup_test_helpers.dart';
import 'helpers/popup_test_resource.dart';

void main() {
  tearDown(resetPopupTestResource);

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
                height:
                    placement == TPopupPlacement.left ||
                        placement == TPopupPlacement.right
                    ? null
                    : 120,
                width:
                    placement == TPopupPlacement.top ||
                        placement == TPopupPlacement.bottom
                    ? null
                    : 200,
                child: const SizedBox(height: 60, width: 60),
              ),
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
    testWidgets('bottom 默认不渲染头部', (tester) async {
      await openPopup(
        tester,
        onPressed: () => TPopup.show(
          tester.element(find.text('open')),
          options: const TPopupOptions(
            placement: TPopupPlacement.bottom,
            height: 180,
            child: SizedBox(key: ValueKey('bottom-body')),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TPopupHeader), findsNothing);
      expect(find.byKey(const ValueKey('bottom-body')), findsOneWidget);
    });

    testWidgets('显式 TPopupHeader 组合内容并可调用 close', (tester) async {
      TPopupTrigger? trigger;
      await openPopup(
        tester,
        onPressed: () => TPopup.show(
          tester.element(find.text('open')),
          options: TPopupOptions.bottom(
            height: 180,
            headerBuilder: (_, close) => TPopupHeader(
              cancelButton: TextButton(
                onPressed: close,
                child: const Text('取消'),
              ),
              title: const Text('标题'),
              confirmButton: const Text('确定'),
            ),
            onVisibleChange: (visible, source) {
              if (!visible) {
                trigger = source;
              }
            },
            child: const SizedBox(height: 80),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('标题'), findsOneWidget);
      expect(find.text('确定'), findsOneWidget);
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(trigger, TPopupTrigger.custom);
    });

    testWidgets('center 仅显式 closeBuilder 时显示关闭区', (tester) async {
      await openPopup(
        tester,
        onPressed: () => TPopup.show(
          tester.element(find.text('open')),
          options: TPopupOptions.center(
            width: 120,
            height: 100,
            closeBuilder: (_, close) => IconButton(
              onPressed: close,
              icon: const Icon(TIcons.close_circle),
            ),
            child: const SizedBox(height: 80),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(TIcons.close_circle), findsOneWidget);
      await tester.tap(find.byIcon(TIcons.close_circle));
      await tester.pumpAndSettle();
      expect(find.byIcon(TIcons.close_circle), findsNothing);
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
              child: const SizedBox(height: 60),
            ),
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
              overlay: TPopupOverlayConfig(closeOnClick: false, onClick: () {}),
              child: const SizedBox(height: 60),
            ),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(handle!.isShowing, isTrue);
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
      expect(handle!.isShowing, isTrue);
      handle!.close();
      await tester.pumpAndSettle();
    });

    testWidgets('showOverlay false 且 preventTap=true（透明模态）', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 100,
              overlay: TPopupOverlayConfig(
                showOverlay: false,
                preventTap: true,
              ),
              child: SizedBox(height: 60),
            ),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.byType(ModalBarrier), findsWidgets);
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
          child: const SizedBox(height: 60, child: Text('标准模态默认关闭')),
        ),
      );
      await expectShowAndClose(
        '标准模态显式禁止蒙层关闭',
        TPopupOptions.bottom(
          height: 100,
          overlay: const TPopupOverlayConfig(closeOnClick: false),
          child: const SizedBox(height: 60, child: Text('标准模态显式禁止蒙层关闭')),
        ),
      );
      await expectShowAndClose(
        '透明模态默认关闭策略',
        TPopupOptions.bottom(
          height: 100,
          overlay: const TPopupOverlayConfig(
            showOverlay: false,
            preventTap: true,
          ),
          child: const SizedBox(height: 60, child: Text('透明模态默认关闭策略')),
        ),
      );
      await expectShowAndClose(
        '非模态浮层默认关闭策略',
        TPopupOptions.bottom(
          height: 100,
          overlay: const TPopupOverlayConfig(
            showOverlay: false,
            preventTap: false,
          ),
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
            options: const TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 80,
              overlay: TPopupOverlayConfig(color: Colors.red, opacity: 0.5),
              child: SizedBox(height: 40),
            ),
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
            options: const TPopupOptions(
              placement: TPopupPlacement.right,
              inset: TPopupRightInset(top: 80),
              child: SizedBox(height: 200),
            ),
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
            options: const TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 80,
              child: SizedBox(height: 40, child: Text('first')),
            ),
          );
          second = TPopup.show(
            ctx,
            options: const TPopupOptions(
              placement: TPopupPlacement.center,
              width: 120,
              height: 80,
              closeBuilder: null,
              child: SizedBox(width: 120, height: 80, child: Text('second')),
            ),
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
              child: Builder(
                builder: (ctx) {
                  return Column(
                    children: [
                      const Text('outer'),
                      ElevatedButton(
                        onPressed: () {
                          innerHandle = TPopup.show(
                            ctx,
                            options: const TPopupOptions(
                              placement: TPopupPlacement.center,
                              width: 120,
                              height: 80,
                              closeBuilder: null,
                              child: SizedBox(
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
              ),
            ),
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
              child: const SizedBox(height: 60),
            ),
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
            options: const TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 100,
              child: SizedBox(height: 60, child: Text('panel')),
            ),
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
              animationDuration: const Duration(milliseconds: 300),
              onVisibleChange: (visible, _) {
                if (visible) {
                  openCount++;
                }
              },
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

    testWidgets('navigatorContext 失效后 handle.open 仍优先复用缓存 navigator', (
      tester,
    ) async {
      TPopupHandle? handle;
      var showLauncher = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Theme(
            data: ThemeData(extensions: [TThemeData.defaultData()]),
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
            options: const TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 80,
              child: SizedBox(height: 40),
            ),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(handle!.isShowing, isTrue);

      handle!.open(hostContext);
      await tester.pumpAndSettle();
      expect(handle!.isShowing, isTrue);
    });

    testWidgets('蒙层组合矩阵都可正常 show / close', (tester) async {
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

      void expectShow(String reason, TPopupOptions options) {
        expect(
          () => TPopup.show(hostContext, options: options),
          returnsNormally,
          reason: reason,
        );
      }

      expectShow(
        '显示蒙层且拦截交互（标准模态）',
        TPopupOptions.bottom(
          child: const SizedBox(height: 40),
          overlay: const TPopupOverlayConfig(
            showOverlay: true,
            preventTap: true,
          ),
        ),
      );
      expectShow(
        '显示蒙层但不拦截交互',
        TPopupOptions.bottom(
          child: const SizedBox(height: 40),
          overlay: const TPopupOverlayConfig(
            showOverlay: true,
            preventTap: false,
          ),
        ),
      );
      expectShow(
        '透明模态（拦截但不显示蒙层）',
        TPopupOptions.bottom(
          child: const SizedBox(height: 40),
          overlay: const TPopupOverlayConfig(
            showOverlay: false,
            preventTap: true,
          ),
        ),
      );
      expectShow(
        '非模态浮层（不拦截不显示）',
        TPopupOptions.bottom(
          child: const SizedBox(height: 40),
          overlay: const TPopupOverlayConfig(
            showOverlay: false,
            preventTap: false,
          ),
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
            // .top factory 不暴露 headerBuilder：编译期杜绝错位
            options: TPopupOptions.top(height: 120, child: const Text('内容')),
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
      for (final placement in [TPopupPlacement.left, TPopupPlacement.right]) {
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
                child: const SizedBox(height: 40),
              ),
            );
          },
        );
        await tester.pumpAndSettle();
        expect(find.byType(Expanded), findsOneWidget);
        handle!.close();
        await tester.pumpAndSettle();
      }
    });

    testWidgets('TPopupHeader 自定义取消、标题、确认文案', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 180,
              headerBuilder: (_, close) => TPopupHeader(
                cancelButton: GestureDetector(
                  onTap: close,
                  child: const Text('左'),
                ),
                title: const Text('Widget标题'),
                confirmButton: GestureDetector(
                  onTap: close,
                  child: const Text('右'),
                ),
              ),
              child: const SizedBox(height: 40),
            ),
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
              closeBuilder: (_, close) =>
                  GestureDetector(onTap: close, child: const Text('关')),
              child: const SizedBox(height: 60, width: 120),
            ),
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
              overlay: TPopupOverlayConfig(onClick: () => overlayClick++),
              child: const SizedBox(height: 60),
            ),
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
            options: const TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 80,
              child: SizedBox(height: 40),
            ),
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
              child: const SizedBox(height: 60),
            ),
          );
        },
      );
      await tester.pumpAndSettle();
      handle!.close();
      await tester.pumpAndSettle();
      expect(hideTrigger, TPopupTrigger.api);
    });

    testWidgets('headerBuilder 内按钮关闭触发 custom', (tester) async {
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
              headerBuilder: (_, close) =>
                  TextButton(onPressed: close, child: const Text('确定')),
              child: const SizedBox(height: 60),
            ),
          );
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(hideTrigger, TPopupTrigger.custom);
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
            options: const TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 80,
              destroyOnClose: true,
              child: SizedBox(height: 40),
            ),
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
            options: const TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 80,
              destroyOnClose: true,
              child: SizedBox(height: 40),
            ),
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
    testWidgets('TPopupHeader 自定义取消和确认组件', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 200,
              headerBuilder: (_, __) => const TPopupHeader(
                cancelButton: Text('自定义取消'),
                confirmButton: Text('自定义确认'),
              ),
              child: const SizedBox(height: 60),
            ),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('自定义取消'), findsOneWidget);
      expect(find.text('自定义确认'), findsOneWidget);
    });

    testWidgets('TPopupHeader 自定义按钮保留业务侧语义', (tester) async {
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
                headerBuilder: (_, close) => TPopupHeader(
                  cancelButton: Semantics(
                    container: true,
                    label: '自定义取消语义',
                    button: true,
                    child: GestureDetector(
                      onTap: close,
                      child: const Text('自定义取消'),
                    ),
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

  group('TPopup 默认内容状态', () {
    testWidgets('bottom 不传任何 builder 不渲染头部', (tester) async {
      TPopupHandle? handle;
      await openPopup(
        tester,
        onPressed: () {
          handle = TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 120,
              child: SizedBox(height: 40),
            ),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(handle!.isShowing, isTrue);
      expect(find.byType(TPopupHeader), findsNothing);
      handle!.close();
      await tester.pumpAndSettle();
    });

    testWidgets('center 不传 closeBuilder 不渲染关闭区', (tester) async {
      TPopupHandle? handle;
      await openPopup(
        tester,
        onPressed: () {
          handle = TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
              placement: TPopupPlacement.center,
              width: 120,
              height: 80,
              child: SizedBox(height: 60),
            ),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(handle!.isShowing, isTrue);
      expect(find.byType(IconButton), findsNothing);
      handle!.close();
      await tester.pumpAndSettle();
    });
  });
}
