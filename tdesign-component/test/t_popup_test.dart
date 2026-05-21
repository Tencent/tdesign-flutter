import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'helpers/popup_test_helpers.dart';
import 'helpers/popup_test_resource.dart';

void main() {
  tearDown(resetPopupTestResource);

  group('TPopup 国际化文案', () {
    for (final resource in [
      PopupTestResourceDelegate.zh(),
      PopupTestResourceDelegate.en(),
    ]) {
      testWidgets(
        '${resource.locale.languageCode} 底部操作栏默认 cancel / confirm',
        (tester) async {
          var cancelCount = 0;
          var confirmCount = 0;
          late BuildContext hostContext;

          await openPopup(
            tester,
            resource: resource,
            onPressed: () {
              hostContext = tester.element(find.text('open'));
              TPopup(
                options: TPopupOptions(
                    placement: TPopupPlacement.bottom,
                    height: 200,
                    onCancel: () => cancelCount++,
                    onConfirm: () => confirmCount++,
                    child: const SizedBox(height: 80)),
              ).show(hostContext);
            },
          );
          await tester.pumpAndSettle();
          expect(find.text(resource.cancelText), findsOneWidget);
          expect(find.text(resource.confirmText), findsOneWidget);

          await tester.tap(find.text(resource.cancelText));
          await tester.pumpAndSettle();
          expect(cancelCount, 1);

          await openPopup(
            tester,
            resource: resource,
            onPressed: () {
              TPopup(
                options: TPopupOptions(
                    placement: TPopupPlacement.bottom,
                    height: 200,
                    onConfirm: () => confirmCount++,
                    child: const SizedBox(height: 80)),
              ).show(hostContext);
            },
          );
          await tester.pumpAndSettle();
          await tester.tap(find.text(resource.confirmText));
          await tester.pumpAndSettle();
          expect(confirmCount, 1);
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
            handle = TPopup(
              options: TPopupOptions(
                  placement: TPopupPlacement.bottom,
                  height: 160,
                  onCancel: () {},
                  child: const SizedBox(height: 60)),
            ).show(hostContext);
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
          handle = TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 120,
                onOpen: () => openCount++,
                onOpened: () => openedCount++,
                child: const SizedBox(height: 80)),
          ).show(hostContext);
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
          handle = TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 120,
                onClose: () => closeCount++,
                onClosed: () => closedCount++,
                onVisibleChange: (v, _) => visibleChanges.add(v),
                child: const SizedBox(height: 80)),
          ).show(hostContext);
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
          handle = TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 100,
                onClose: () => closeCount++,
                child: const SizedBox(height: 60)),
          ).show(hostContext);
        },
      );
      await tester.pumpAndSettle();
      handle!.close();
      handle!.close();
      await tester.pumpAndSettle();
      expect(closeCount, 1);
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
            handle = TPopup(
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
            ).show(hostContext);
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
    testWidgets('底部操作栏：取消与确认', (tester) async {
      var cancelCount = 0;
      var confirmCount = 0;
      late BuildContext hostContext;

      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 200,
                title: '标题',
                onCancel: () => cancelCount++,
                onConfirm: () => confirmCount++,
                child: const SizedBox(height: 80)),
          ).show(hostContext);
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('标题'), findsOneWidget);
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(cancelCount, 1);

      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 200,
                onConfirm: () => confirmCount++,
                child: const SizedBox(height: 80)),
          ).show(hostContext);
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(confirmCount, 1);
    });

    testWidgets('autoCloseOnCancel 为 false 时不自动关闭', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 200,
                autoCloseOnCancel: false,
                onCancel: () {},
                child: const SizedBox(height: 80)),
          ).show(tester.element(find.text('open')));
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('取消'));
      await tester.pump();
      expect(find.text('取消'), findsOneWidget);
    });

    testWidgets('autoCloseOnConfirm 为 false 时不自动关闭', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 200,
                autoCloseOnConfirm: false,
                onConfirm: () {},
                child: const SizedBox(height: 80)),
          ).show(tester.element(find.text('open')));
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('确定'));
      await tester.pump();
      expect(find.text('确定'), findsOneWidget);
    });

    testWidgets('bottom headerBuilder null 无头部', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 180,
                title: '不应出现',
                headerBuilder: null,
                child: const SizedBox(height: 80)),
          ).show(tester.element(find.text('open')));
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
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 180,
                title: '仅标题',
                cancel: null,
                confirm: null,
                child: const SizedBox(height: 80)),
          ).show(tester.element(find.text('open')));
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
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                title: '传入标题',
                headerBuilder: (_, data) => Text('自定义:${data.title}'),
                child: const SizedBox(height: 60)),
          ).show(tester.element(find.text('open')));
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
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.center,
                width: 120,
                height: 120,
                child: const SizedBox(height: 80, width: 80)),
          ).show(hostContext);
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
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.center,
                width: 240,
                height: 240,
                child: const SizedBox.expand()),
          ).show(tester.element(find.text('open')));
        },
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(TIcons.close_circle), findsOneWidget);
    });

    testWidgets('center 默认显示下方关闭 closeBuilder null 隐藏', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.center,
                width: 120,
                height: 120,
                closeBuilder: null,
                child: const SizedBox(height: 80, width: 80)),
          ).show(tester.element(find.text('open')));
        },
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(TIcons.close_circle), findsNothing);
    });

    testWidgets('cancelBuilder / confirmBuilder', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                cancelBuilder: (_) => const Text('自定义取消'),
                confirmBuilder: (_) => const Text('自定义确认'),
                onCancel: () {},
                onConfirm: () {},
                child: const SizedBox(height: 60)),
          ).show(tester.element(find.text('open')));
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
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 100,
                onClosed: () => overlayClose++,
                child: const SizedBox(height: 60)),
          ).show(hostContext);
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
          handle = TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 100,
                closeOnOverlayClick: false,
                onCancel: () {},
                onOverlayClick: () {},
                child: const SizedBox(height: 60)),
          ).show(hostContext);
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

    testWidgets('showOverlay false 且 preventScrollThrough', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 100,
                showOverlay: false,
                preventScrollThrough: true,
                child: const SizedBox(height: 60)),
          ).show(tester.element(find.text('open')));
        },
      );
      await tester.pumpAndSettle();
      expect(
        find.byType(NotificationListener<ScrollNotification>),
        findsWidgets,
      );
    });

    testWidgets('overlayOpacity 与自定义颜色', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 80,
                overlayColor: Colors.red,
                overlayOpacity: 0.5,
                child: const SizedBox(height: 40)),
          ).show(tester.element(find.text('open')));
        },
      );
      await tester.pumpAndSettle();
      await tester.pump();
    });

    testWidgets('margin.top 底部日历式布局', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                margin: const EdgeInsets.only(top: 80),
                child: const SizedBox(height: 200)),
          ).show(tester.element(find.text('open')));
        },
      );
      await tester.pumpAndSettle();
    });
  });

  group('TPopup 声明式', () {
    testWidgets('initialVisible 自动打开', (tester) async {
      await tester.pumpWidget(
        wrapPopupTest(
          TPopup(
            initialVisible: true,
            options: TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 100,
              child: SizedBox(height: 60),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('dispose 时关闭弹层', (tester) async {
      await tester.pumpWidget(
        wrapPopupTest(
          TPopup(
            initialVisible: true,
            options: TPopupOptions(
              placement: TPopupPlacement.bottom,
              height: 100,
              child: SizedBox(height: 60),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    });
  });

  group('TPopupHandle / Tracker', () {
    testWidgets('外层重复 show 第二次无效（返回同一 handle）', (tester) async {
      TPopupHandle? first;
      await openPopup(
        tester,
        onPressed: () {
          final ctx = tester.element(find.text('open'));
          first = TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 80,
                child: const SizedBox(height: 40)),
          ).show(ctx);
          final second = TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 80,
                child: const SizedBox(height: 40)),
          ).show(ctx);
          expect(second.isShowing, isTrue);
          expect(identical(first, second), isTrue);
        },
      );
      await tester.pumpAndSettle();
      first?.close();
      await tester.pumpAndSettle();
    });

    testWidgets('系统返回键关闭', (tester) async {
      var closedCount = 0;
      late BuildContext hostContext;

      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 100,
                onClosed: () => closedCount++,
                child: const SizedBox(height: 60)),
          ).show(hostContext);
        },
      );
      await tester.pumpAndSettle();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(closedCount, 1);
    });
  });

  group('TPopup 扩展场景', () {
    testWidgets('top 忽略 title 仅 child', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.top,
                height: 120,
                title: '顶部标题',
                child: const Text('内容')),
          ).show(tester.element(find.text('open')));
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('顶部标题'), findsNothing);
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
            handle = TPopup(
              options: TPopupOptions(
                  placement: placement,
                  width: 240,
                  child: const SizedBox(height: 40)),
            ).show(hostContext);
          },
        );
        await tester.pumpAndSettle();
        expect(find.byType(Expanded), findsOneWidget);
        handle!.close();
        await tester.pumpAndSettle();
      }
    });

    testWidgets('titleWidget 与 cancelBtn / confirmBtn 文案', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 180,
                titleWidget: const Text('Widget标题'),
                cancelBtn: '左',
                confirmBtn: '右',
                child: const SizedBox(height: 40)),
          ).show(tester.element(find.text('open')));
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
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.center,
                width: 140,
                destroyOnClose: true,
                closeBuilder: (_, close) => GestureDetector(
                      onTap: close,
                      child: const Text('关'),
                    ),
                onCloseBtn: () {},
                child: const SizedBox(height: 60, width: 120)),
          ).show(hostContext);
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
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 100,
                onOverlayClick: () => overlayClick++,
                child: const SizedBox(height: 60)),
          ).show(hostContext);
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
          handle = TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 80,
                child: const SizedBox(height: 40)),
          ).show(tester.element(find.text('open')));
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
    testWidgets('handle.close 触发 programmatic', (tester) async {
      TPopupTrigger? hideTrigger;
      TPopupHandle? handle;

      await openPopup(
        tester,
        onPressed: () {
          handle = TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 100,
                onVisibleChange: (v, t) {
                  if (!v) {
                    hideTrigger = t;
                  }
                },
                child: const SizedBox(height: 60)),
          ).show(tester.element(find.text('open')));
        },
      );
      await tester.pumpAndSettle();
      handle!.close();
      await tester.pumpAndSettle();
      expect(hideTrigger, TPopupTrigger.programmatic);
    });

    testWidgets('confirm 点击触发 confirmBtn', (tester) async {
      TPopupTrigger? hideTrigger;
      late BuildContext hostContext;

      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 120,
                onVisibleChange: (v, t) {
                  if (!v) {
                    hideTrigger = t;
                  }
                },
                child: const SizedBox(height: 60)),
          ).show(hostContext);
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(hideTrigger, TPopupTrigger.confirmBtn);
    });

    testWidgets('destroyOnClose 路由关闭后可再次 show', (tester) async {
      late BuildContext hostContext;
      TPopupHandle? first;

      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          first = TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 80,
                destroyOnClose: true,
                cancel: null,
                confirm: null,
                child: const SizedBox(height: 40)),
          ).show(hostContext);
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
          second = TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 80,
                destroyOnClose: true,
                cancel: null,
                confirm: null,
                child: const SizedBox(height: 40)),
          ).show(hostContext);
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
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 200,
                cancel: const Text('自定义取消'),
                confirm: const Text('自定义确认'),
                onCancel: () {},
                onConfirm: () {},
                child: const SizedBox(height: 60)),
          ).show(tester.element(find.text('open')));
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('自定义取消'), findsOneWidget);
      expect(find.text('自定义确认'), findsOneWidget);
    });
  });
}
