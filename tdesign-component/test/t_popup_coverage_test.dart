import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/popup/t_popup.dart'
    show PopupHeader, PopupLayout;
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'helpers/popup_test_helpers.dart';
import 'helpers/popup_test_resource.dart';

void main() {
  tearDown(resetPopupTestResource);

  group('TPopup 覆盖率补充', () {
    testWidgets('bottom 仅标题行（无操作栏）', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                titleWidget: TText('仅标题行'),
                cancelBuilder: null,
                confirmBuilder: null,
                child: SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('仅标题行'), findsOneWidget);
      expect(find.text('取消'), findsNothing);
      expect(find.text('确定'), findsNothing);
    });

    testWidgets('bottom 仅标题时可正常渲染标题内容', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                titleWidget: TText('左对齐标题'),
                cancelBuilder: null,
                confirmBuilder: null,
                child: SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('左对齐标题'), findsOneWidget);
    });

    testWidgets('bottom 仅隐藏 confirm 槽位', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                confirmBuilder: null,
                child: SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('取消'), findsOneWidget);
      expect(find.text('确定'), findsNothing);
    });

    testWidgets('bottom 仅隐藏 cancel 槽位', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                cancelBuilder: null,
                child: SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('取消'), findsNothing);
      expect(find.text('确定'), findsOneWidget);
    });

    testWidgets('center closeBuilder 自定义关闭区', (tester) async {
      late BuildContext hostContext;
      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          TPopup.show(
            hostContext,
            options: TPopupOptions(
                placement: TPopupPlacement.center,
                width: 160,
                height: 120,
                closeBuilder: (_, close) => TextButton(
                      onPressed: close,
                      child: const Text('builder关闭'),
                    ),
                child: const SizedBox(height: 80, width: 120)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('builder关闭'), findsOneWidget);
      await tester.tap(find.text('builder关闭'));
      await tester.pumpAndSettle();
    });

    testWidgets('center 默认关闭按钮点击关闭浮层', (tester) async {
      late BuildContext hostContext;
      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          TPopup.show(
            hostContext,
            options: const TPopupOptions(
                placement: TPopupPlacement.center,
                width: 120,
                height: 120,
                child: SizedBox(height: 80, width: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(TIcons.close_circle), findsOneWidget);
      await tester.tap(find.byIcon(TIcons.close_circle));
      await tester.pumpAndSettle();
      expect(find.byIcon(TIcons.close_circle), findsNothing);
    });

    testWidgets('bottom 无固定 height 贴底布局', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
                placement: TPopupPlacement.bottom,
                cancelBuilder: null,
                confirmBuilder: null,
                child: SizedBox(height: 80, width: 200)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.byType(Positioned), findsWidgets);
    });

    testWidgets('top 无固定 height 可打开', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
                placement: TPopupPlacement.top,
                child: SizedBox(height: 60, width: 200)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.byType(Positioned), findsWidgets);
    });

    testWidgets('center closeBuilder=null 无下方关闭', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
                placement: TPopupPlacement.center,
                width: 100,
                height: 100,
                closeBuilder: null,
                child: SizedBox(height: 80, width: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(TIcons.close_circle), findsNothing);
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('handle 重复 close 安全', (tester) async {
      TPopupHandle? handle;
      await openPopup(
        tester,
        onPressed: () {
          handle = TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 80,
                cancelBuilder: null,
                confirmBuilder: null,
                child: SizedBox(height: 40)),
          );
        },
      );
      await tester.pumpAndSettle();
      handle!.close();
      handle!.close();
      await tester.pumpAndSettle();
      expect(handle!.isShowing, isFalse);
    });

    testWidgets('handle.open 关闭后再次打开触发 onOpen / onOpened', (tester) async {
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
                height: 80,
                cancelBuilder: null,
                confirmBuilder: null,
                onOpen: () => openCount++,
                onOpened: () => openedCount++,
                child: const SizedBox(height: 40)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(openCount, 1);
      expect(openedCount, 1);

      handle!.close();
      await tester.pumpAndSettle();

      handle!.open(hostContext);
      await tester.pumpAndSettle();
      expect(openCount, 2);
      expect(openedCount, 2);
    });

    testWidgets('TToolbarPressable 按压与禁用', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Theme(
            data: ThemeData(extensions: [TThemeData.defaultData()]),
            child: Scaffold(
              body: TToolbarPressable(
                onTap: () => tapped = true,
                child: const Text('press'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('press'));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);

      await tester.pumpWidget(
        MaterialApp(
          home: Theme(
            data: ThemeData(extensions: [TThemeData.defaultData()]),
            child: const Scaffold(
              body: TToolbarPressable(
                onTap: null,
                mergeTextStyle: TextStyle(color: Colors.red),
                mergeIconTheme: IconThemeData(color: Colors.red),
                child: Icon(Icons.add),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
    });
  });

  group('TPopupOptions 覆盖率补充', () {
    test('hasBuiltInHeader 识别 titleWidget', () {
      expect(
        const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.bottom,
          titleWidget: Text('w'),
          cancelBuilder: null,
          confirmBuilder: null,
        ).hasBuiltInHeader,
        isTrue,
      );
    });

    test('useCustomHeader 与 useDefaultHeader 互斥', () {
      final custom = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
        headerBuilder: (_, __) => const Text('h'),
      );
      expect(custom.useCustomHeader, isTrue);
      expect(custom.useDefaultHeader, isFalse);

      const titleOnly = TPopupOptions(
        child: SizedBox(),
        placement: TPopupPlacement.bottom,
        titleWidget: TText('仅标题'),
        cancelBuilder: null,
        confirmBuilder: null,
      );
      expect(titleOnly.useDefaultHeader, isTrue);
      expect(titleOnly.useCustomHeader, isFalse);
      expect(titleOnly.hasBuiltInHeader, isTrue);
    });

    test('assertPlacementParams 覆盖各 placement 的字段提示', () {
      // bottom + width → 抛 FlutterError
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.bottom,
          width: 200,
        ).assertPlacementParams(),
        throwsA(isA<FlutterError>()),
      );
      // top 默认配置 → 不抛
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.top,
        ).assertPlacementParams(),
        returnsNormally,
      );
      // center 合法字段 → 不抛
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.center,
          height: 100,
          closeBuilder: null,
        ).assertPlacementParams(),
        returnsNormally,
      );
      expect(
        () => const TPopupOptions(
          child: SizedBox(),
          placement: TPopupPlacement.center,
        ).assertPlacementParams(),
        returnsNormally,
      );
    });
  });

  group('TPopup 覆盖率深化', () {
    testWidgets('headerBuilder 自定义内容可正常渲染', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                headerBuilder: (ctx, close) => const Column(
                      children: [
                        Text('头Widget'),
                        Row(
                          children: [
                            Text('builder左'),
                            Text('builder右'),
                          ],
                        ),
                      ],
                    ),
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('头Widget'), findsOneWidget);
      expect(find.text('builder左'), findsOneWidget);
      expect(find.text('builder右'), findsOneWidget);
    });

    testWidgets('headerBuilder 自定义行内内容可正常渲染', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                headerBuilder: (ctx, close) => const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('左槽Widget'),
                        Text('右槽Widget'),
                      ],
                    ),
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('左槽Widget'), findsOneWidget);
      expect(find.text('右槽Widget'), findsOneWidget);
    });

    testWidgets('操作栏使用自定义 cancel/confirm Widget（非 Builder）', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                cancelBuilder: (_, __) => const Text('自定义左'),
                confirmBuilder: (_, __) => const Text('自定义右'),
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('自定义左'), findsOneWidget);
      expect(find.text('自定义右'), findsOneWidget);
    });

    testWidgets('onVisibleChange 记录各关闭触发源', (tester) async {
      final hideTriggers = <TPopupTrigger>[];
      late BuildContext hostContext;

      await openPopup(
        tester,
        onPressed: () {
          hostContext = tester.element(find.text('open'));
          TPopup.show(
            hostContext,
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                titleWidget: const TText('标题'),
                onVisibleChange: (visible, trigger) {
                  if (!visible) {
                    hideTriggers.add(trigger);
                  }
                },
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(hideTriggers.last, TPopupTrigger.cancel);

      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            hostContext,
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                onVisibleChange: (visible, trigger) {
                  if (!visible) {
                    hideTriggers.add(trigger);
                  }
                },
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(hideTriggers.last, TPopupTrigger.overlay);

      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            hostContext,
            options: TPopupOptions(
                placement: TPopupPlacement.center,
                width: 120,
                height: 120,
                onVisibleChange: (visible, trigger) {
                  if (!visible) {
                    hideTriggers.add(trigger);
                  }
                },
                child: const SizedBox(height: 80, width: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(TIcons.close_circle));
      await tester.pumpAndSettle();
      expect(hideTriggers.last, TPopupTrigger.close);
    });

    testWidgets('Popup 内嵌套 show 可再开一层且先关内层', (tester) async {
      TPopupHandle? outerHandle;
      TPopupHandle? innerHandle;

      await openPopup(
        tester,
        onPressed: () {
          outerHandle = TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 200,
                cancelBuilder: null,
                confirmBuilder: null,
                child: Builder(
                  builder: (ctx) {
                    return ElevatedButton(
                      onPressed: () {
                        innerHandle = TPopup.show(
                          ctx,
                          options: const TPopupOptions(
                            placement: TPopupPlacement.bottom,
                            height: 120,
                            cancelBuilder: null,
                            confirmBuilder: null,
                            child: Text('内层'),
                          ),
                        );
                      },
                      child: const Text('开内层'),
                    );
                  },
                )),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('开内层'), findsOneWidget);

      await tester.tap(find.text('开内层'));
      await tester.pumpAndSettle();
      expect(find.text('内层'), findsOneWidget);

      innerHandle!.close();
      await tester.pumpAndSettle();
      expect(find.text('内层'), findsNothing);
      expect(find.text('开内层'), findsOneWidget);

      outerHandle!.close();
      await tester.pumpAndSettle();
    });

    testWidgets('modal 为 false 仍可打开关闭', (tester) async {
      TPopupHandle? handle;
      await openPopup(
        tester,
        onPressed: () {
          handle = TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 120,
                showOverlay: false,
                modal: false,
                child: SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      handle!.close();
      await tester.pumpAndSettle();
    });

    testWidgets('center 自定义 radius 与 backgroundColor', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
                placement: TPopupPlacement.center,
                width: 100,
                height: 100,
                radius: 4,
                backgroundColor: Colors.red,
                child: SizedBox(height: 60, width: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      final hasRedPanel =
          tester.widgetList<Container>(find.byType(Container)).any((c) {
        final d = c.decoration;
        return d is BoxDecoration && d.color == Colors.red;
      });
      expect(hasRedPanel, isTrue);
    });

    testWidgets('bottom inset.left/right 与无 overlay 仍可关闭', (tester) async {
      TPopupHandle? handle;
      await openPopup(
        tester,
        onPressed: () {
          handle = TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 100,
                inset: TPopupBottomInset(left: 16, right: 16),
                showOverlay: false,
                cancelBuilder: null,
                confirmBuilder: null,
                child: SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      handle!.close();
      await tester.pumpAndSettle();
    });
  });

  group('PopupLayout 覆盖率补充', () {
    testWidgets('bottom 无 height 时使用默认高度并贴底', (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.bottom,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                layout.wrapPositioned(child: const SizedBox(height: 1))
              ],
            ),
          ),
        ),
      );
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.bottom, 0);
      expect(positioned.top, isNull);
      expect(positioned.height, 240);
    });

    test('alignment center', () {
      expect(
        PopupLayout(
          placement: TPopupPlacement.center,
        ).alignment,
        Alignment.center,
      );
    });

    testWidgets('right 默认 drawer 宽度与 inset', (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.right,
        inset: const TPopupRightInset(top: 8, bottom: 8),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [layout.wrapPositioned(child: const SizedBox())],
            ),
          ),
        ),
      );
      final positioned = tester.widget<Positioned>(find.byType(Positioned));
      expect(positioned.width, PopupLayout.defaultDrawerWidth);
      expect(positioned.right, 0);
      expect(positioned.top, 8);
    });

    testWidgets('left 默认 drawer 宽度', (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.left,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [layout.wrapPositioned(child: const SizedBox())],
            ),
          ),
        ),
      );
      expect(
        tester.widget<Positioned>(find.byType(Positioned)).width,
        PopupLayout.defaultDrawerWidth,
      );
    });
  });

  // ============================================================
  // TPopupOptions 命名工厂（B 方案）：编译期挡误用 + 运行期与默认构造等价
  // ============================================================
  group('TPopupOptions 命名工厂', () {
    test('.bottom 生成的 options 等价于默认构造（含默认 sentinel）', () {
      final factoryOpts = TPopupOptions.bottom(
        child: const SizedBox(),
        height: 300,
      );
      const baseOpts = TPopupOptions(
        child: SizedBox(),
        placement: TPopupPlacement.bottom,
        height: 300,
      );
      expect(factoryOpts.placement, baseOpts.placement);
      expect(factoryOpts.height, 300);
      expect(factoryOpts.width, isNull);
      expect(factoryOpts.usesDefaultHeader, isTrue);
      expect(factoryOpts.usesDefaultCancel, isTrue);
      expect(factoryOpts.usesDefaultConfirm, isTrue);
    });

    test('.center 生成 placement=center + 默认 closeBuilder', () {
      final opts = TPopupOptions.center(
        child: const SizedBox(),
        width: 220,
        height: 220,
      );
      expect(opts.placement, TPopupPlacement.center);
      expect(opts.width, 220);
      expect(opts.height, 220);
      expect(opts.usesDefaultClose, isTrue);
      expect(opts.inset, isNull);
    });

    test('.top / .left / .right 生成对应 placement + 默认无头部', () {
      final top = TPopupOptions.top(child: const SizedBox(), height: 100);
      expect(top.placement, TPopupPlacement.top);
      expect(top.height, 100);
      expect(top.width, isNull);

      final left = TPopupOptions.left(child: const SizedBox(), width: 280);
      expect(left.placement, TPopupPlacement.left);
      expect(left.width, 280);
      expect(left.height, isNull);

      final right = TPopupOptions.right(child: const SizedBox(), width: 280);
      expect(right.placement, TPopupPlacement.right);
      expect(right.width, 280);
      expect(right.height, isNull);
    });

    test('factory 输出的合法配置在 assertPlacementParams 下零异常', () {
      final variants = [
        TPopupOptions.bottom(child: const SizedBox(), height: 300),
        TPopupOptions.center(child: const SizedBox(), width: 220, height: 220),
        TPopupOptions.top(child: const SizedBox(), height: 100),
        TPopupOptions.left(child: const SizedBox(), width: 280),
        TPopupOptions.right(child: const SizedBox(), width: 280),
      ];
      for (final opts in variants) {
        expect(opts.assertPlacementParams, returnsNormally,
            reason: 'placement=${opts.placement}');
      }
    });

    test('factory 透传通用字段：animationDuration / overlay / callbacks', () {
      var visibleChanges = 0;
      final opts = TPopupOptions.bottom(
        child: const SizedBox(),
        animationDuration: const Duration(milliseconds: 500),
        showOverlay: false,
        overlayOpacity: 0.5,
        destroyOnClose: true,
        onVisibleChange: (_, __) => visibleChanges++,
      );
      expect(opts.animationDuration, const Duration(milliseconds: 500));
      expect(opts.showOverlay, isFalse);
      expect(opts.closeOnOverlayClick, isFalse);
      expect(opts.overlayOpacity, 0.5);
      expect(opts.destroyOnClose, isTrue);
      opts.onVisibleChange?.call(false, TPopupTrigger.api);
      expect(visibleChanges, 1);
    });
  });

  // ============================================================
  // TPopupOptions.copyWith：处理 sentinel 三态
  // ============================================================
  group('TPopupOptions.copyWith', () {
    test('不传字段 → 完全继承原值（含 sentinel 默认 builder）', () {
      const base = TPopupOptions(child: SizedBox());
      final next = base.copyWith();
      expect(next.placement, base.placement);
      expect(next.height, base.height);
      // sentinel 身份延续
      expect(next.usesDefaultHeader, isTrue);
      expect(next.usesDefaultCancel, isTrue);
      expect(next.usesDefaultConfirm, isTrue);
      expect(next.usesDefaultClose, isTrue);
    });

    test('显式传 null → 把对应 builder 置为「隐藏」', () {
      const base = TPopupOptions(child: SizedBox());
      final next = base.copyWith(headerBuilder: null, cancelBuilder: null);
      expect(next.headerBuilder, isNull);
      expect(next.cancelBuilder, isNull);
      // 未传的字段仍是 sentinel
      expect(next.usesDefaultConfirm, isTrue);
      expect(next.usesDefaultClose, isTrue);
    });

    test('传自定义 builder → 替换为自定义', () {
      const base = TPopupOptions(child: SizedBox());
      const titleWidget = Text('t');
      final next = base.copyWith(titleWidget: titleWidget);
      expect(next.titleWidget, same(titleWidget));
      // 其它继承
      expect(next.usesDefaultHeader, isTrue);
    });

    test('值类字段（width / height / radius / 颜色 / Color?）三态正确', () {
      const base = TPopupOptions(
        child: SizedBox(),
        width: 100,
        height: 200,
        radius: 8,
        backgroundColor: Color(0xFF000000),
      );
      // 不传：继承
      expect(base.copyWith().width, 100);
      // 显式 null：清空
      expect(base.copyWith(width: null).width, isNull);
      expect(base.copyWith(backgroundColor: null).backgroundColor, isNull);
      // 替换
      expect(base.copyWith(width: 50).width, 50);
    });

    test('回调字段同样支持三态', () {
      hookA(bool _, TPopupTrigger __) {}
      final base = TPopupOptions(
        child: const SizedBox(),
        onVisibleChange: hookA,
      );
      expect(base.copyWith().onVisibleChange, same(hookA));
      expect(base.copyWith(onVisibleChange: null).onVisibleChange, isNull);
    });
  });

  // ============================================================
  // TPopupHandle.open(): 缓存 navigator，无 context 再开
  // ============================================================
  group('TPopupHandle.open() 无参复用缓存 navigator', () {
    testWidgets('close 后 open() 不传 context 仍可重新打开', (tester) async {
      late TPopupHandle handle;
      await openPopup(
        tester,
        onPressed: () {
          handle = TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                titleWidget: Text('再开测试'),
                child: SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(handle.isShowing, isTrue);

      handle.close();
      await tester.pumpAndSettle();
      expect(handle.isShowing, isFalse);

      // 关键：不传 context，使用首次缓存的 navigator
      handle.open();
      await tester.pumpAndSettle();
      expect(handle.isShowing, isTrue);
      expect(find.text('再开测试'), findsOneWidget);
    });

    testWidgets('已展示状态下 open() 重复调用无副作用', (tester) async {
      late TPopupHandle handle;
      await openPopup(
        tester,
        onPressed: () {
          handle = TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                child: SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      handle.open(); // 无参数重复
      await tester.pumpAndSettle();
      expect(handle.isShowing, isTrue);
      // 只有一个 popup route
      expect(find.byType(SizedBox), findsWidgets);
    });
  });

  // ============================================================
  // Header 三态行为 + 触发源精细化（覆盖 _popup_header.dart 短路 fix）
  // ============================================================
  group('Popup Header 三态完整对照', () {
    /// 拿到 popup 内 PopupHeader 实际占用的高度。
    /// - 无头部（headerBuilder=null 或三槽全 null）：== 0
    /// - 默认 sentinel header：== PopupHeader.headerHeight（58）
    /// - 自定义 headerBuilder：取决于自定义 widget 的高度
    double popupHeaderHeight(WidgetTester tester) {
      return tester.getSize(find.byType(PopupHeader)).height;
    }

    testWidgets('headerBuilder=null 同时传 title/cancel/confirmBuilder 也不渲染',
        (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 180,
                headerBuilder: null, // 一票否决
                titleWidget: const Text('应隐藏-标题'),
                cancelBuilder: (_, close) =>
                    GestureDetector(onTap: close, child: const Text('应隐藏-左')),
                confirmBuilder: (_, close) =>
                    GestureDetector(onTap: close, child: const Text('应隐藏-右')),
                child:
                    const SizedBox(key: ValueKey('popup-child'), height: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('应隐藏-标题'), findsNothing);
      expect(find.text('应隐藏-左'), findsNothing);
      expect(find.text('应隐藏-右'), findsNothing);
      // 也不应该有内置文案
      expect(find.text('取消'), findsNothing);
      expect(find.text('确定'), findsNothing);
    });

    testWidgets('headerBuilder=null → PopupHeader 高度精确为 0', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 180,
                headerBuilder: null,
                child: SizedBox(height: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(popupHeaderHeight(tester), 0);
    });

    testWidgets(
        '默认 sentinel + 三槽全 null → PopupHeader 高度精确为 0（_popup_header.dart 修复回归）',
        (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 180,
                cancelBuilder: null,
                confirmBuilder: null,
                child: SizedBox(height: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(popupHeaderHeight(tester), 0);
      expect(find.text('取消'), findsNothing);
      expect(find.text('确定'), findsNothing);
    });

    testWidgets('对照：默认 sentinel header（含标题）PopupHeader 高度 == 58',
        (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 180,
                titleWidget: Text('标题'),
                child: SizedBox(height: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(popupHeaderHeight(tester), PopupHeader.headerHeight);
    });

    testWidgets('仅 cancelBuilder=null → 隐藏左槽，标题与右槽仍渲染', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 180,
                cancelBuilder: null,
                titleWidget: Text('标题在'),
                child: SizedBox(height: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('标题在'), findsOneWidget);
      expect(find.text('取消'), findsNothing);
      expect(find.text('确定'), findsOneWidget);
    });

    testWidgets('仅 confirmBuilder=null → 隐藏右槽，标题与左槽仍渲染', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: const TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 180,
                confirmBuilder: null,
                titleWidget: Text('标题在'),
                child: SizedBox(height: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('标题在'), findsOneWidget);
      expect(find.text('取消'), findsOneWidget);
      expect(find.text('确定'), findsNothing);
    });

    testWidgets(
        'headerBuilder 自定义 → titleWidget / cancelBuilder / confirmBuilder 全部被忽略',
        (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 180,
                headerBuilder: (_, __) => const Text('唯一头部'),
                titleWidget: const Text('不该出现-标题'),
                cancelBuilder: (_, __) => const Text('不该出现-左'),
                confirmBuilder: (_, __) => const Text('不该出现-右'),
                child: const SizedBox(height: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('唯一头部'), findsOneWidget);
      expect(find.text('不该出现-标题'), findsNothing);
      expect(find.text('不该出现-左'), findsNothing);
      expect(find.text('不该出现-右'), findsNothing);
      // 也找不到内置默认文案
      expect(find.text('取消'), findsNothing);
      expect(find.text('确定'), findsNothing);
    });
  });

  // ============================================================
  // 触发源精细化：sentinel vs 自定义 builder 的 close 上报区分
  // ============================================================
  group('Popup 触发源细分（sentinel vs 自定义 builder）', () {
    testWidgets('内置 cancel 按钮点击 → cancel（与 confirm 区分）', (tester) async {
      TPopupTrigger? lastTrigger;
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                onVisibleChange: (visible, trigger) {
                  if (!visible) {
                    lastTrigger = trigger;
                  }
                },
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(lastTrigger, TPopupTrigger.cancel);
    });

    testWidgets('自定义 cancelBuilder 内调 close → cancel', (tester) async {
      TPopupTrigger? lastTrigger;
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                cancelBuilder: (_, close) => GestureDetector(
                      onTap: close,
                      child: const Text('我自己的取消'),
                    ),
                onVisibleChange: (visible, trigger) {
                  if (!visible) {
                    lastTrigger = trigger;
                  }
                },
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('我自己的取消'));
      await tester.pumpAndSettle();
      expect(lastTrigger, TPopupTrigger.cancel);
    });

    testWidgets('自定义 confirmBuilder 内调 close → confirm', (tester) async {
      TPopupTrigger? lastTrigger;
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                confirmBuilder: (_, close) => GestureDetector(
                      onTap: close,
                      child: const Text('我自己的确定'),
                    ),
                onVisibleChange: (visible, trigger) {
                  if (!visible) {
                    lastTrigger = trigger;
                  }
                },
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('我自己的确定'));
      await tester.pumpAndSettle();
      expect(lastTrigger, TPopupTrigger.confirm);
    });

    testWidgets('center 自定义 closeBuilder 内调 close → close', (tester) async {
      TPopupTrigger? lastTrigger;
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.center,
                width: 200,
                height: 200,
                closeBuilder: (_, close) => GestureDetector(
                      onTap: close,
                      child: const Text('我自己的关闭'),
                    ),
                onVisibleChange: (visible, trigger) {
                  if (!visible) {
                    lastTrigger = trigger;
                  }
                },
                child: const SizedBox(height: 80, width: 80)),
          );
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('我自己的关闭'));
      await tester.pumpAndSettle();
      expect(lastTrigger, TPopupTrigger.close);
    });

    testWidgets('headerBuilder 自定义内调 close → custom（无预设动作语义）', (tester) async {
      TPopupTrigger? lastTrigger;
      await openPopup(
        tester,
        onPressed: () {
          TPopup.show(
            tester.element(find.text('open')),
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                headerBuilder: (_, close) => GestureDetector(
                      onTap: close,
                      child: const Text('整行自定义头部'),
                    ),
                onVisibleChange: (visible, trigger) {
                  if (!visible) {
                    lastTrigger = trigger;
                  }
                },
                child: const SizedBox(height: 60)),
          );
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('整行自定义头部'));
      await tester.pumpAndSettle();
      expect(lastTrigger, TPopupTrigger.custom);
    });

    testWidgets('left/right 默认无圆角（对齐官方全高矩形）', (tester) async {
      for (final placement in [
        TPopupPlacement.left,
        TPopupPlacement.right,
      ]) {
        await openPopup(
          tester,
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: TPopupOptions(
                placement: placement,
                width: 200,
                child: const SizedBox(height: 40),
              ),
            );
          },
        );
        await tester.pumpAndSettle();
        // 默认：面板 Container 不应携带任何内缘圆角。
        final hasLeftRightRadius = tester
            .widgetList<Container>(find.byType(Container))
            .any((c) {
          final d = c.decoration;
          if (d is! BoxDecoration) {
            return false;
          }
          final b = d.borderRadius;
          if (b == null) {
            return false;
          }
          // 面板内缘圆角按从左到右布局解析为具体 BorderRadius 后判断。
          final resolved = b.resolve(TextDirection.ltr);
          final hasRightCorner = resolved.topRightRadius != Radius.zero ||
              resolved.bottomRightRadius != Radius.zero;
          final hasLeftCorner = resolved.topLeftRadius != Radius.zero ||
              resolved.bottomLeftRadius != Radius.zero;
          return hasRightCorner || hasLeftCorner;
        });
        expect(hasLeftRightRadius, isFalse,
            reason: 'placement=$placement 默认不应有圆角');
        Navigator.of(tester.element(find.text('open'))).pop();
        await tester.pumpAndSettle();
      }
    });

    testWidgets('left/right 设置 radius 后应用内缘圆角', (tester) async {
      for (final placement in [
        TPopupPlacement.left,
        TPopupPlacement.right,
      ]) {
        await openPopup(
          tester,
          onPressed: () {
            TPopup.show(
              tester.element(find.text('open')),
              options: TPopupOptions(
                placement: placement,
                width: 200,
                radius: 8,
                child: const SizedBox(height: 40),
              ),
            );
          },
        );
        await tester.pumpAndSettle();
        // 显式 radius 时，内缘（left=右缘 / right=左缘）应用圆角。
        final expected = placement == TPopupPlacement.left
            ? const BorderRadius.horizontal(right: Radius.circular(8))
            : const BorderRadius.horizontal(left: Radius.circular(8));
        final hasRadius = tester
            .widgetList<Container>(find.byType(Container))
            .any((c) {
          final d = c.decoration;
          return d is BoxDecoration && d.borderRadius == expected;
        });
        expect(hasRadius, isTrue,
            reason: 'placement=$placement 设置 radius 后应有内缘圆角');
        Navigator.of(tester.element(find.text('open'))).pop();
        await tester.pumpAndSettle();
      }
    });

    testWidgets('默认动画时长为 300ms（对齐官方与其他组件）', (tester) async {
      bindPopupTestResource(PopupTestResourceDelegate.zh());
      final observer = _CapturingNavigatorObserver();
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [observer],
          theme: ThemeData(extensions: [TThemeData.defaultData()]),
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                TPopup.show(
                  context,
                  options: const TPopupOptions(
                      placement: TPopupPlacement.bottom,
                      height: 160,
                      child: SizedBox(height: 60)),
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pump();
      expect(observer.lastPushedRoute, isNotNull);
      expect(
        (observer.lastPushedRoute! as TransitionRoute).transitionDuration,
        const Duration(milliseconds: 300),
      );
      await tester.pumpAndSettle();
    });
  });
}

/// 测试辅助：捕获最近一次 push 的路由，用于断言默认动画时长。
class _CapturingNavigatorObserver extends NavigatorObserver {
  Route<dynamic>? lastPushedRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    lastPushedRoute = route;
    super.didPush(route, previousRoute);
  }
}
