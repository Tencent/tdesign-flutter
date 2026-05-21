import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/popup/_popup_layout.dart';
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
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                title: '仅标题行',
                cancel: null,
                confirm: null,
                child: const SizedBox(height: 60)),
          ).show(tester.element(find.text('open')));
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('仅标题行'), findsOneWidget);
      expect(find.text('取消'), findsNothing);
      expect(find.text('确定'), findsNothing);
    });

    testWidgets('bottom 仅标题且 titleAlignLeft', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                title: '左对齐标题',
                titleAlignLeft: true,
                cancel: null,
                confirm: null,
                child: const SizedBox(height: 60)),
          ).show(tester.element(find.text('open')));
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('左对齐标题'), findsOneWidget);
    });

    testWidgets('bottom 仅隐藏 confirm 槽位', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                confirm: null,
                child: const SizedBox(height: 60)),
          ).show(tester.element(find.text('open')));
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
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                cancel: null,
                child: const SizedBox(height: 60)),
          ).show(tester.element(find.text('open')));
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
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.center,
                width: 160,
                height: 120,
                closeBuilder: (_, close) => TextButton(
                      onPressed: close,
                      child: const Text('builder关闭'),
                    ),
                child: const SizedBox(height: 80, width: 120)),
          ).show(hostContext);
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('builder关闭'), findsOneWidget);
      await tester.tap(find.text('builder关闭'));
      await tester.pumpAndSettle();
    });

    testWidgets('center 默认关闭按钮触发 onCloseBtn', (tester) async {
      var closeBtnCount = 0;
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
                onCloseBtn: () => closeBtnCount++,
                child: const SizedBox(height: 80, width: 80)),
          ).show(hostContext);
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(TIcons.close_circle));
      await tester.pumpAndSettle();
      expect(closeBtnCount, 1);
    });

    testWidgets('bottom 无固定 height 贴底布局', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                cancel: null,
                confirm: null,
                child: const SizedBox(height: 80, width: 200)),
          ).show(tester.element(find.text('open')));
        },
      );
      await tester.pumpAndSettle();
      expect(find.byType(Positioned), findsWidgets);
    });

    testWidgets('top 无固定 height 可打开', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.top,
                child: const SizedBox(height: 60, width: 200)),
          ).show(tester.element(find.text('open')));
        },
      );
      await tester.pumpAndSettle();
      expect(find.byType(Positioned), findsWidgets);
    });

    testWidgets('center closeBtn false 无下方关闭', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.center,
                width: 100,
                height: 100,
                closeBuilder: null,
                child: const SizedBox(height: 80, width: 80)),
          ).show(tester.element(find.text('open')));
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
          handle = TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 80,
                cancel: null,
                confirm: null,
                child: const SizedBox(height: 40)),
          ).show(tester.element(find.text('open')));
        },
      );
      await tester.pumpAndSettle();
      handle!.close();
      handle!.close();
      await tester.pumpAndSettle();
      expect(handle!.isShowing, isFalse);
    });

    testWidgets('TPopupActionDefault 可构建', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: kPopupActionDefault,
          ),
        ),
      );
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('TToolbarPressable 按压与禁用', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: TTheme(
            data: TThemeData.defaultData(),
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
          home: TTheme(
            data: TThemeData.defaultData(),
            child: Scaffold(
              body: TToolbarPressable(
                onTap: null,
                mergeTextStyle: const TextStyle(color: Colors.red),
                mergeIconTheme: const IconThemeData(color: Colors.red),
                child: const Icon(Icons.add),
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
        TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.bottom,
          titleWidget: const Text('w'),
          cancel: null,
          confirm: null,
        ).hasBuiltInHeader,
        isTrue,
      );
    });

    test('isActionDefault 识别占位 Widget', () {
      expect(TPopupOptions.isActionDefault(kPopupActionDefault), isTrue);
      expect(TPopupOptions.isActionDefault(const Text('x')), isFalse);
      expect(TPopupOptions.isActionDefault(null), isFalse);
    });

    test('useCustomHeader 与 useTitleOnlyHeader 互斥于 useActionHeader', () {
      final custom = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
        headerBuilder: (_, __) => const Text('h'),
      );
      expect(custom.useCustomHeader, isTrue);
      expect(custom.useActionHeader, isFalse);

      final titleOnly = TPopupOptions(
        child: const SizedBox(),
        placement: TPopupPlacement.bottom,
        title: '仅标题',
        cancel: null,
        confirm: null,
      );
      expect(titleOnly.useTitleOnlyHeader, isTrue);
      expect(titleOnly.useActionHeader, isFalse);
    });

    test('isPopupDefaultHeader / isPopupDefaultClose 哨兵识别', () {
      expect(isPopupDefaultHeader(kPopupDefaultHeader), isTrue);
      expect(isPopupDefaultHeader(null), isFalse);
      expect(isPopupDefaultClose(kPopupDefaultClose), isTrue);
      expect(isPopupDefaultClose(null), isFalse);
    });

    testWidgets('kPopupDefaultHeader / kPopupDefaultClose 占位函数可调用',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final header = kPopupDefaultHeader(
                context,
                const TPopupHeaderData(),
              );
              final close = kPopupDefaultClose(context, () {});
              return Column(children: [header, close]);
            },
          ),
        ),
      );
      expect(find.byType(SizedBox), findsWidgets);
    });

    test('assertPlacementParams 覆盖 width 与 top 操作栏提示', () {
      expect(
        () => TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.bottom,
          width: 200,
        ).assertPlacementParams(),
        returnsNormally,
      );
      expect(
        () => TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.top,
          onCancel: () {},
        ).assertPlacementParams(),
        returnsNormally,
      );
      expect(
        () => TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.center,
          height: 100,
          closeBuilder: null,
        ).assertPlacementParams(),
        returnsNormally,
      );
      expect(
        () => TPopupOptions(
          child: const SizedBox(),
          placement: TPopupPlacement.center,
          onCancel: () {},
        ).assertPlacementParams(),
        returnsNormally,
      );
    });
  });

  group('TPopup 覆盖率深化', () {
    testWidgets('headerBuilder 透传 titleWidget 与 cancelBuilder 槽位',
        (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                titleWidget: const Text('头Widget'),
                cancelBuilder: (_) => const Text('builder左'),
                confirmBuilder: (_) => const Text('builder右'),
                headerBuilder: (_, data) => Column(
                      children: [
                        if (data.title != null) data.title!,
                        Row(
                          children: [
                            if (data.cancel != null) data.cancel!,
                            if (data.confirm != null) data.confirm!,
                          ],
                        ),
                      ],
                    ),
                child: const SizedBox(height: 60)),
          ).show(tester.element(find.text('open')));
        },
      );
      await tester.pumpAndSettle();
      expect(find.text('头Widget'), findsOneWidget);
      expect(find.text('builder左'), findsOneWidget);
      expect(find.text('builder右'), findsOneWidget);
    });

    testWidgets('headerBuilder 使用自定义 cancel/confirm Widget 槽位', (tester) async {
      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                cancel: const Text('左槽Widget'),
                confirm: const Text('右槽Widget'),
                headerBuilder: (_, data) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (data.cancel != null) data.cancel!,
                        if (data.confirm != null) data.confirm!,
                      ],
                    ),
                child: const SizedBox(height: 60)),
          ).show(tester.element(find.text('open')));
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
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                cancel: const Text('自定义左'),
                confirm: const Text('自定义右'),
                onCancel: () {},
                onConfirm: () {},
                child: const SizedBox(height: 60)),
          ).show(tester.element(find.text('open')));
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
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                title: '标题',
                onVisibleChange: (visible, trigger) {
                  if (!visible) {
                    hideTriggers.add(trigger);
                  }
                },
                child: const SizedBox(height: 60)),
          ).show(hostContext);
        },
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(hideTriggers.last, TPopupTrigger.cancelBtn);

      await openPopup(
        tester,
        onPressed: () {
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 160,
                onVisibleChange: (visible, trigger) {
                  if (!visible) {
                    hideTriggers.add(trigger);
                  }
                },
                child: const SizedBox(height: 60)),
          ).show(hostContext);
        },
      );
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(hideTriggers.last, TPopupTrigger.overlay);

      await openPopup(
        tester,
        onPressed: () {
          TPopup(
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
          ).show(hostContext);
        },
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(TIcons.close_circle));
      await tester.pumpAndSettle();
      expect(hideTriggers.last, TPopupTrigger.closeBtn);
    });

    testWidgets('Popup 内嵌套 show 可再开一层且先关内层', (tester) async {
      TPopupHandle? outerHandle;
      TPopupHandle? innerHandle;

      await openPopup(
        tester,
        onPressed: () {
          outerHandle = TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 200,
                cancel: null,
                confirm: null,
                child: Builder(
                  builder: (ctx) {
                    return ElevatedButton(
                      onPressed: () {
                        innerHandle = TPopup(
                          options: TPopupOptions(
                            placement: TPopupPlacement.bottom,
                            height: 120,
                            cancel: null,
                            confirm: null,
                            child: const Text('内层'),
                          ),
                        ).show(ctx);
                      },
                      child: const Text('开内层'),
                    );
                  },
                )),
          ).show(tester.element(find.text('open')));
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

    testWidgets('preventScrollThrough 为 false 仍可打开关闭', (tester) async {
      TPopupHandle? handle;
      await openPopup(
        tester,
        onPressed: () {
          handle = TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 120,
                preventScrollThrough: false,
                child: const SizedBox(height: 60)),
          ).show(tester.element(find.text('open')));
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
          TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.center,
                width: 100,
                height: 100,
                radius: 4,
                backgroundColor: Colors.red,
                child: const SizedBox(height: 60, width: 60)),
          ).show(tester.element(find.text('open')));
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

    testWidgets('bottom margin.bottom 与无 overlay 仍可关闭', (tester) async {
      TPopupHandle? handle;
      await openPopup(
        tester,
        onPressed: () {
          handle = TPopup(
            options: TPopupOptions(
                placement: TPopupPlacement.bottom,
                height: 100,
                margin: const EdgeInsets.only(bottom: 16),
                showOverlay: false,
                closeOnOverlayClick: false,
                cancel: null,
                confirm: null,
                child: const SizedBox(height: 60)),
          ).show(tester.element(find.text('open')));
        },
      );
      await tester.pumpAndSettle();
      handle!.close();
      await tester.pumpAndSettle();
    });
  });

  group('PopupLayout 覆盖率补充', () {
    const screen = Size(400, 800);

    testWidgets('bottom 无 height 且无 margin.top 贴底', (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.bottom,
        screenSize: screen,
        margin: EdgeInsets.zero,
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
      expect(positioned.height, isNull);
    });

    test('alignment center', () {
      expect(
        PopupLayout(
          placement: TPopupPlacement.center,
          screenSize: screen,
          margin: EdgeInsets.zero,
        ).alignment,
        Alignment.center,
      );
    });

    testWidgets('right 默认 drawer 宽度与 margin', (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.right,
        screenSize: screen,
        margin: const EdgeInsets.only(top: 8, bottom: 8, right: 4),
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
      expect(positioned.right, 4);
      expect(positioned.top, 8);
    });

    testWidgets('left 默认 drawer 宽度', (tester) async {
      final layout = PopupLayout(
        placement: TPopupPlacement.left,
        screenSize: screen,
        margin: EdgeInsets.zero,
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
}
