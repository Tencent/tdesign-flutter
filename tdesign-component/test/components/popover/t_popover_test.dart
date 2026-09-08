import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/popover/t_popover_widget.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TPopover 组件 Widget 测试
///
/// 覆盖 TPopoverColorScheme、TPopoverPlacement、内容渲染、箭头、回调等。
void main() {
  /// 构建带主题的测试壳
  Widget wrapWithTheme(Widget child, {TPopoverThemeData? popoverTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (popoverTheme != null) {
      theme = theme.mergeExtension(popoverTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  Finder arrowContainerFinder() => find.byWidgetPredicate(
    (widget) =>
        widget is Container &&
        widget.decoration is BoxDecoration &&
        (widget.decoration as BoxDecoration).border != null,
  );

  // ============================================================
  // 枚举验证
  // ============================================================
  group('枚举', () {
    test('TPopoverColorScheme 有六个值', () {
      expect(TPopoverColorScheme.values.length, 6);
      expect(
        TPopoverColorScheme.values,
        contains(TPopoverColorScheme.defaultTheme),
      );
      expect(TPopoverColorScheme.values, contains(TPopoverColorScheme.light));
      expect(TPopoverColorScheme.values, contains(TPopoverColorScheme.primary));
      expect(TPopoverColorScheme.values, contains(TPopoverColorScheme.success));
      expect(TPopoverColorScheme.values, contains(TPopoverColorScheme.warning));
      expect(TPopoverColorScheme.values, contains(TPopoverColorScheme.danger));
    });

    test('TPopoverPlacement 有十二个值', () {
      expect(TPopoverPlacement.values.length, 12);
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.top));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.bottom));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.left));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.right));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.topLeft));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.topRight));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.bottomLeft));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.bottomRight));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.leftTop));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.leftBottom));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.rightTop));
      expect(TPopoverPlacement.values, contains(TPopoverPlacement.rightBottom));
    });
  });

  // ============================================================
  // TPopoverWidget 基础渲染
  // ============================================================
  group('TPopoverWidget 基础渲染', () {
    testWidgets('渲染文本内容', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              return Center(
                child: TPopoverWidget(
                  context: context,
                  content: const Text('气泡内容'),
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(TPopoverWidget), findsOneWidget);
      expect(find.text('气泡内容'), findsOneWidget);
    });

    testWidgets('默认文本样式和背景色来自 token', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              return Center(
                child: TPopoverWidget(
                  context: context,
                  content: const Text('默认气泡'),
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();

      final textStyle = DefaultTextStyle.of(
        tester.element(find.text('默认气泡')),
      ).style;
      expect(textStyle.color, token.textColorAnti);
      expect(textStyle.fontSize, token.fontBodyLarge?.size);
      expect(textStyle.height, token.fontBodyLarge?.height);

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(TPopoverWidget),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is Container && widget.decoration is BoxDecoration,
              ),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, token.grayColor14);
    });

    testWidgets('主题 backgroundColor 覆盖语义色的背景 token', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              return Center(
                child: TPopoverWidget(
                  context: context,
                  content: const Text('自定义背景'),
                  colorScheme: TPopoverColorScheme.primary,
                ),
              );
            },
          ),
          popoverTheme: const TPopoverThemeData(backgroundColor: Colors.black),
        ),
      );
      await tester.pump();

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(TPopoverWidget),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is Container && widget.decoration is BoxDecoration,
              ),
            )
            .first,
      );
      expect((container.decoration! as BoxDecoration).color, Colors.black);
    });

    testWidgets('长文本默认限制在测量宽度内并允许换行', (tester) async {
      const longContent = '这是一段非常非常非常非常非常非常非常长的气泡内容，用于验证默认宽度不会横向无限延伸';
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              return Center(
                child: TPopoverWidget(
                  context: context,
                  content: const Text(longContent),
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();

      final containerFinder = find
          .descendant(
            of: find.byType(TPopoverWidget),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is Container && widget.decoration is BoxDecoration,
            ),
          )
          .first;
      final container = tester.widget<Container>(containerFinder);
      final text = tester.widget<Text>(find.text(longContent));
      expect(container.constraints?.maxWidth, lessThanOrEqualTo(300));
      expect(tester.getSize(containerFinder).width, lessThanOrEqualTo(300));
      expect(text.maxLines, isNull);
      expect(text.overflow, isNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets('自定义 Widget 内容渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              return Center(
                child: TPopoverWidget(
                  context: context,
                  content: const Text('自定义Widget'),
                  width: 100,
                  height: 50,
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();

      expect(find.text('自定义Widget'), findsOneWidget);
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(TPopoverWidget),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is Container && widget.decoration is BoxDecoration,
              ),
            )
            .first,
      );
      expect(container.constraints?.maxWidth, 100);
      expect(container.constraints?.maxHeight, 50);
    });

    testWidgets('Widget 内容未指定 width/height 时按实际尺寸布局', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: Builder(
            builder: (context) {
              return TPopoverWidget(
                context: context,
                content: const Text('无尺寸'),
              );
            },
          ),
        ),
      );

      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.text('无尺寸'), findsOneWidget);
    });

    testWidgets('Widget 内容更新后无需固定尺寸', (tester) async {
      Widget build({required bool withSize}) => MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: Builder(
          builder: (context) {
            return TPopoverWidget(
              context: context,
              content: const Text('动态内容'),
              width: withSize ? 100 : null,
              height: withSize ? 50 : null,
            );
          },
        ),
      );

      await tester.pumpWidget(build(withSize: true));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(build(withSize: false));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  // ============================================================
  // colorScheme 颜色方案
  // ============================================================
  group('TPopoverWidget colorScheme', () {
    for (final scheme in TPopoverColorScheme.values) {
      testWidgets('colorScheme: $scheme 渲染正常', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Builder(
              builder: (context) {
                return Center(
                  child: TPopoverWidget(
                    context: context,
                    content: Text('${scheme.name}气泡'),
                    colorScheme: scheme,
                  ),
                );
              },
            ),
          ),
        );
        await tester.pump();

        expect(find.text('${scheme.name}气泡'), findsOneWidget);
      });
    }
  });

  // ============================================================
  // placement 定位方向
  // ============================================================
  group('TPopoverWidget placement', () {
    for (final placement in TPopoverPlacement.values) {
      testWidgets('placement: $placement 渲染正常', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Builder(
              builder: (context) {
                return Center(
                  child: TPopoverWidget(
                    context: context,
                    content: Text('${placement.name}定位'),
                    placement: placement,
                  ),
                );
              },
            ),
          ),
        );
        await tester.pump();

        expect(find.text('${placement.name}定位'), findsOneWidget);
      });
    }
  });

  // ============================================================
  // showArrow 箭头
  // ============================================================
  group('TPopoverWidget 箭头', () {
    testWidgets('showArrow: true 渲染箭头', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              return Center(
                child: TPopoverWidget(
                  context: context,
                  content: const Text('有箭头'),
                  placement: TPopoverPlacement.bottom,
                  showArrow: true,
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();

      // 箭头使用 Container + BoxDecoration(border:)
      expect(find.text('有箭头'), findsOneWidget);
    });

    testWidgets('showArrow: false 不渲染箭头', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              return Center(
                child: TPopoverWidget(
                  context: context,
                  content: const Text('无箭头'),
                  showArrow: false,
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();

      expect(find.text('无箭头'), findsOneWidget);
    });

    testWidgets('自定义 arrowSize', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              return Center(
                child: TPopoverWidget(
                  context: context,
                  content: const Text('大箭头'),
                  arrowSize: 16,
                  placement: TPopoverPlacement.top,
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();
      expect(find.text('大箭头'), findsOneWidget);
    });
  });

  // ============================================================
  // padding / width / height / radius
  // ============================================================
  group('TPopoverWidget 尺寸', () {
    testWidgets('自定义 padding 渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              return Center(
                child: TPopoverWidget(
                  context: context,
                  content: const Text('内边距'),
                  padding: const EdgeInsets.all(20),
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();
      expect(find.text('内边距'), findsOneWidget);
    });

    testWidgets('自定义 width 和 height', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              return Center(
                child: TPopoverWidget(
                  context: context,
                  content: const Text('固定尺寸'),
                  width: 200,
                  height: 80,
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();
      expect(find.text('固定尺寸'), findsOneWidget);
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(TPopoverWidget),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is Container && widget.decoration is BoxDecoration,
              ),
            )
            .first,
      );
      expect(tester.getSize(find.byWidget(container)), const Size(200, 80));
    });

    testWidgets('theme maxWidth 约束文本外框宽度', (tester) async {
      const longContent = '一段足够长的气泡文本，用来验证组件主题能够控制文本气泡最大宽度';
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              return Center(
                child: TPopoverWidget(
                  context: context,
                  content: const Text(longContent),
                ),
              );
            },
          ),
          popoverTheme: const TPopoverThemeData(maxWidth: 180),
        ),
      );
      await tester.pump();

      final containerFinder = find
          .descendant(
            of: find.byType(TPopoverWidget),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is Container && widget.decoration is BoxDecoration,
            ),
          )
          .first;
      expect(tester.getSize(containerFinder).width, lessThanOrEqualTo(180));
    });

    testWidgets('theme maxHeight 是文本气泡的最大高度而非固定高度', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              return Center(
                child: TPopoverWidget(
                  context: context,
                  content: const Text('短文本'),
                ),
              );
            },
          ),
          popoverTheme: const TPopoverThemeData(maxHeight: 200),
        ),
      );
      await tester.pump();

      final containerFinder = find
          .descendant(
            of: find.byType(TPopoverWidget),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is Container && widget.decoration is BoxDecoration,
            ),
          )
          .first;
      expect(tester.getSize(containerFinder).height, lessThan(200));
    });

    testWidgets('自定义 radius 圆角', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              return Center(
                child: TPopoverWidget(
                  context: context,
                  content: const Text('圆角'),
                  radius: BorderRadius.circular(20),
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();
      expect(find.text('圆角'), findsOneWidget);
    });

    testWidgets('theme applies padding, radius and arrow size', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              return Center(
                child: TPopoverWidget(
                  context: context,
                  content: const Text('主题气泡'),
                ),
              );
            },
          ),
          popoverTheme: const TPopoverThemeData(
            padding: EdgeInsets.all(10),
            borderRadius: 20,
            arrowSize: 16,
          ),
        ),
      );
      await tester.pump();

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(TPopoverWidget),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is Container && widget.decoration is BoxDecoration,
              ),
            )
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      final arrow = tester.widget<Container>(arrowContainerFinder());

      expect(decoration.borderRadius, BorderRadius.circular(20));
      expect(container.padding, const EdgeInsets.all(10));
      final arrowBorder =
          (arrow.decoration! as BoxDecoration).border! as Border;
      expect(
        [
          arrowBorder.top.width,
          arrowBorder.right.width,
          arrowBorder.bottom.width,
          arrowBorder.left.width,
        ].reduce(math.max),
        16,
      );
    });
  });

  testWidgets('showPopover uses theme barrierColor without a modal barrier', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TThemeBuilder.light(
          TThemeData.defaultData(),
        ).mergeExtension(const TPopoverThemeData(barrierColor: Colors.black54)),
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () {
                    TPopover.showPopover(
                      context: context,
                      content: const Text('气泡'),
                      placement: TPopoverPlacement.bottom,
                    );
                  },
                  child: const Text('open'),
                ),
              ),
            );
          },
        ),
      ),
    );

    final initialModalBarrierCount = find
        .byType(ModalBarrier)
        .evaluate()
        .length;
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final overlayColor = tester.widget<ColoredBox>(
      find.byKey(const Key('t-popover-overlay-color')),
    );
    expect(overlayColor.color, Colors.black54);
    expect(
      find.byType(ModalBarrier).evaluate().length,
      initialModalBarrierCount,
    );
  });

  // ============================================================
  // Anchor 受控模式
  // ============================================================
  group('TPopoverAnchor 和 TPopoverController', () {
    testWidgets('controller 展开前必须绑定 Anchor，Anchor 展开时必须存在 Overlay', (
      tester,
    ) async {
      final unboundController = TPopoverController();
      expect(unboundController.close, returnsNormally);
      expect(unboundController.open, throwsAssertionError);

      final boundController = TPopoverController();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: TPopoverAnchor(
            controller: boundController,
            content: const Text('无 Overlay'),
            builder: (context, controller, child) {
              expect(TPopoverController.maybeOf(context), same(controller));
              return const SizedBox(width: 40, height: 40);
            },
          ),
        ),
      );

      expect(boundController.open, throwsFlutterError);
      expect(boundController.isOpen, isFalse);
    });

    testWidgets('controller 展开、关闭和 isOpen 由 Anchor 生命周期统一管理', (tester) async {
      final controller = TPopoverController();
      var openCount = 0;
      var closeCount = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          Center(
            child: TPopoverAnchor(
              controller: controller,
              content: const Text('受控气泡'),
              onOpen: () => openCount++,
              onClose: () => closeCount++,
              builder: (context, controller, child) {
                return TextButton(
                  key: const Key('controlled-anchor'),
                  onPressed: controller.open,
                  child: Text(controller.isOpen ? '已展开' : '展开'),
                );
              },
            ),
          ),
        ),
      );

      expect(controller.isOpen, isFalse);
      await tester.tap(find.byKey(const Key('controlled-anchor')));
      await tester.pump();

      expect(controller.isOpen, isTrue);
      expect(find.text('已展开'), findsOneWidget);
      expect(find.text('受控气泡'), findsOneWidget);
      expect(openCount, 1);

      controller.open();
      await tester.pump();
      expect(find.text('受控气泡'), findsOneWidget);
      expect(openCount, 1);

      controller.close();
      controller.close();
      await tester.pump();

      expect(controller.isOpen, isFalse);
      expect(find.text('展开'), findsOneWidget);
      expect(find.text('受控气泡'), findsNothing);
      expect(closeCount, 1);
    });

    testWidgets('系统返回键关闭 Anchor 并仅通知一次', (tester) async {
      final controller = TPopoverController();
      var closeCount = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          Center(
            child: TPopoverAnchor(
              controller: controller,
              content: const Text('返回键关闭'),
              onClose: () => closeCount++,
              builder: (context, controller, child) => TextButton(
                onPressed: controller.open,
                child: const Text('打开返回键气泡'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('打开返回键气泡'));
      await tester.pump();
      expect(controller.isOpen, isTrue);
      expect(find.text('返回键关闭'), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pump();

      expect(controller.isOpen, isFalse);
      expect(find.text('返回键关闭'), findsNothing);
      expect(closeCount, 1);

      controller.close();
      await tester.pump();
      expect(closeCount, 1);
    });

    testWidgets('未传入 controller 时 builder 仍可展开并在自然关闭后更新状态', (tester) async {
      late TPopoverController localController;
      var contentCloseCount = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          Center(
            child: TPopoverAnchor(
              content: Builder(
                builder: (context) => TextButton(
                  key: const Key('close-from-content'),
                  onPressed: () {
                    contentCloseCount++;
                    TPopoverController.maybeOf(context)!.close();
                  },
                  child: const Text('内部控制器'),
                ),
              ),
              builder: (context, controller, child) {
                localController = controller;
                return TextButton(
                  onPressed: controller.open,
                  child: const Text('打开内部控制器'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('打开内部控制器'));
      await tester.pumpAndSettle();
      expect(localController.isOpen, isTrue);
      expect(find.text('内部控制器'), findsOneWidget);

      await tester.tap(find.byKey(const Key('close-from-content')));
      await tester.pump();
      expect(contentCloseCount, 1);
      expect(localController.isOpen, isFalse);
      expect(find.text('内部控制器'), findsNothing);

      await tester.tap(find.text('打开内部控制器'));
      await tester.pump();
      expect(localController.isOpen, isTrue);

      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
      expect(localController.isOpen, isFalse);
      expect(find.text('内部控制器'), findsNothing);
    });

    testWidgets('替换 controller 保留当前展开状态并把控制权交给新 controller', (tester) async {
      final firstController = TPopoverController();
      final secondController = TPopoverController();
      TPopoverController? observedController;

      Widget buildAnchor(TPopoverController controller) {
        return wrapWithTheme(
          Center(
            child: TPopoverAnchor(
              controller: controller,
              content: Builder(
                builder: (context) => TextButton(
                  key: const Key('observe-switched-controller'),
                  onPressed: () {
                    observedController = TPopoverController.maybeOf(context);
                  },
                  child: const Text('切换控制器'),
                ),
              ),
              builder: (context, controller, child) => TextButton(
                onPressed: controller.open,
                child: const Text('打开切换气泡'),
              ),
            ),
          ),
        );
      }

      await tester.pumpWidget(buildAnchor(firstController));
      await tester.tap(find.text('打开切换气泡'));
      await tester.pump();
      expect(firstController.isOpen, isTrue);

      await tester.pumpWidget(buildAnchor(secondController));
      await tester.pump();
      await tester.pump();
      expect(firstController.isOpen, isFalse);
      expect(secondController.isOpen, isTrue);
      expect(find.text('切换控制器'), findsOneWidget);
      await tester.tap(find.byKey(const Key('observe-switched-controller')));
      expect(observedController, same(secondController));

      secondController.close();
      await tester.pump();
      expect(secondController.isOpen, isFalse);
      expect(find.text('切换控制器'), findsNothing);
    });

    testWidgets('Anchor 移除时关闭气泡并解除 controller 绑定', (tester) async {
      final controller = TPopoverController();
      var closeCount = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          TPopoverAnchor(
            controller: controller,
            content: const Text('销毁关闭'),
            onClose: () => closeCount++,
            builder: (context, controller, child) => TextButton(
              onPressed: controller.open,
              child: const Text('打开后销毁'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('打开后销毁'));
      await tester.pump();
      expect(controller.isOpen, isTrue);

      await tester.pumpWidget(
        wrapWithTheme(const SizedBox(key: Key('replacement'))),
      );
      await tester.pump();
      expect(controller.isOpen, isFalse);
      expect(find.text('销毁关闭'), findsNothing);
      expect(closeCount, 1);
    });
  });

  group('TPopover.showPopover', () {
    testWidgets('省略 placement 时默认显示在锚点上方', (tester) async {
      late BuildContext anchorContext;
      await tester.pumpWidget(
        wrapWithTheme(
          Center(
            child: Builder(
              builder: (context) {
                anchorContext = context;
                return const SizedBox(
                  key: Key('default-placement-anchor'),
                  width: 40,
                  height: 40,
                );
              },
            ),
          ),
        ),
      );

      final anchorRect = tester.getRect(
        find.byKey(const Key('default-placement-anchor')),
      );
      unawaited(
        TPopover.showPopover(
          context: anchorContext,
          content: const Text('默认顶部'),
        ),
      );
      await tester.pumpAndSettle();

      final contentRect = tester.getRect(
        find.byKey(const Key('t-popover-content')),
      );
      expect(contentRect.bottom, lessThan(anchorRect.top));
    });

    testWidgets('showPopover 弹出气泡', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      unawaited(
        TPopover.showPopover(
          context: ctx,
          content: const Text('弹出气泡'),
          placement: TPopoverPlacement.bottom,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('弹出气泡'), findsOneWidget);
    });

    testWidgets('showPopover 带 colorScheme', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      unawaited(
        TPopover.showPopover(
          context: ctx,
          content: const Text('成功气泡'),
          colorScheme: TPopoverColorScheme.success,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('成功气泡'), findsOneWidget);
    });

    testWidgets('closeOnClickOutside: true 点击外部关闭', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      unawaited(
        TPopover.showPopover(
          context: ctx,
          content: const Text('可关闭'),
          closeOnClickOutside: true,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('可关闭'), findsOneWidget);
      // 点击外部关闭
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text('可关闭'), findsNothing);
    });

    testWidgets('展示后页面仍可滚动且滚动时关闭气泡', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        wrapWithTheme(
          ListView.builder(
            controller: controller,
            itemExtent: 80,
            itemCount: 20,
            itemBuilder: (context, index) {
              if (index == 2) {
                return Builder(
                  builder: (anchorContext) => Center(
                    child: TextButton(
                      onPressed: () {
                        unawaited(
                          TPopover.showPopover(
                            context: anchorContext,
                            content: const Text('滚动气泡'),
                            placement: TPopoverPlacement.bottom,
                          ),
                        );
                      },
                      child: const Text('滚动触发项'),
                    ),
                  ),
                );
              }
              return Text('列表项 $index');
            },
          ),
        ),
      );

      await tester.tap(find.text('滚动触发项'));
      await tester.pumpAndSettle();
      expect(find.text('滚动气泡'), findsOneWidget);

      await tester.dragFrom(const Offset(350, 500), const Offset(0, -120));
      await tester.pumpAndSettle();

      expect(controller.offset, greaterThan(0));
      expect(find.text('滚动气泡'), findsNothing);
    });

    testWidgets('closeOnScroll: false 滚动时保持气泡展示', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        wrapWithTheme(
          ListView(
            controller: controller,
            children: [
              const SizedBox(height: 160),
              Builder(
                builder: (anchorContext) => TextButton(
                  onPressed: () {
                    unawaited(
                      TPopover.showPopover(
                        context: anchorContext,
                        content: const Text('保持展示'),
                        closeOnScroll: false,
                      ),
                    );
                  },
                  child: const Text('保持触发项'),
                ),
              ),
              const SizedBox(height: 1000),
            ],
          ),
        ),
      );

      await tester.tap(find.text('保持触发项'));
      await tester.pump();
      await tester.dragFrom(const Offset(350, 500), const Offset(0, -120));
      await tester.pumpAndSettle();

      expect(controller.offset, greaterThan(0));
      expect(find.text('保持展示'), findsOneWidget);
    });

    testWidgets('外部关闭完成 showPopover Future', (tester) async {
      late BuildContext ctx;
      var completed = false;
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      unawaited(
        TPopover.showPopover(
          context: ctx,
          content: const Text('等待关闭'),
        ).then((_) => completed = true),
      );
      await tester.pump();
      expect(completed, isFalse);

      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
      expect(completed, isTrue);
    });

    testWidgets('系统返回键关闭并完成 showPopover Future', (tester) async {
      late BuildContext ctx;
      var completed = false;
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      unawaited(
        TPopover.showPopover(
          context: ctx,
          content: const Text('返回键完成 Future'),
        ).then((_) => completed = true),
      );
      await tester.pump();
      expect(completed, isFalse);

      await tester.binding.handlePopRoute();
      await tester.pump();

      expect(find.text('返回键完成 Future'), findsNothing);
      expect(completed, isTrue);
    });

    testWidgets('Popover 点击和长按回调各触发一次', (tester) async {
      late BuildContext ctx;
      var tapCount = 0;
      var longPressCount = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
        ),
      );

      unawaited(
        TPopover.showPopover(
          context: ctx,
          content: const Text('回调内容'),
          placement: TPopoverPlacement.bottom,
          onTap: () => tapCount += 1,
          onLongTap: () => longPressCount += 1,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('回调内容'));
      expect(tapCount, 1);
      await tester.longPress(find.text('回调内容'));
      expect(longPressCount, 1);
    });

    testWidgets('右下角锚点的 Popover 保持在安全区内', (tester) async {
      late BuildContext anchorContext;
      await tester.pumpWidget(
        wrapWithTheme(
          Align(
            alignment: Alignment.bottomRight,
            child: Builder(
              builder: (context) {
                anchorContext = context;
                return const SizedBox(width: 40, height: 40);
              },
            ),
          ),
        ),
      );

      unawaited(
        TPopover.showPopover(
          context: anchorContext,
          content: const Text('右下角的较长气泡内容'),
          placement: TPopoverPlacement.bottomRight,
        ),
      );
      await tester.pumpAndSettle();

      final textRect = tester.getRect(find.text('右下角的较长气泡内容'));
      final viewSize = tester.view.physicalSize / tester.view.devicePixelRatio;
      expect(textRect.left, greaterThanOrEqualTo(0));
      expect(textRect.top, greaterThanOrEqualTo(0));
      expect(textRect.right, lessThanOrEqualTo(viewSize.width));
      expect(textRect.bottom, lessThanOrEqualTo(viewSize.height));
    });

    testWidgets('top 上方空间不足时翻转到 bottom', (tester) async {
      late BuildContext anchorContext;
      const anchorKey = Key('top-flip-anchor');
      await tester.pumpWidget(
        wrapWithTheme(
          Align(
            alignment: Alignment.topCenter,
            child: Builder(
              builder: (context) {
                anchorContext = context;
                return const SizedBox(key: anchorKey, width: 40, height: 40);
              },
            ),
          ),
        ),
      );

      unawaited(
        TPopover.showPopover(
          context: anchorContext,
          content: const Text('自动翻转到底部'),
          placement: TPopoverPlacement.top,
        ),
      );
      await tester.pumpAndSettle();

      final anchorRect = tester.getRect(find.byKey(anchorKey));
      final popoverRect = tester.getRect(find.text('自动翻转到底部'));
      expect(popoverRect.top, greaterThanOrEqualTo(anchorRect.bottom));
      final border =
          tester.widget<Container>(arrowContainerFinder()).decoration
              as BoxDecoration;
      expect((border.border! as Border).top.color, isNot(Colors.transparent));
    });

    testWidgets('left 左侧空间不足时翻转到 right', (tester) async {
      late BuildContext anchorContext;
      const anchorKey = Key('left-flip-anchor');
      await tester.pumpWidget(
        wrapWithTheme(
          Align(
            alignment: Alignment.centerLeft,
            child: Builder(
              builder: (context) {
                anchorContext = context;
                return const SizedBox(key: anchorKey, width: 40, height: 40);
              },
            ),
          ),
        ),
      );

      unawaited(
        TPopover.showPopover(
          context: anchorContext,
          content: const Text('自动翻转到右侧'),
          placement: TPopoverPlacement.left,
        ),
      );
      await tester.pumpAndSettle();

      final anchorRect = tester.getRect(find.byKey(anchorKey));
      final popoverRect = tester.getRect(find.text('自动翻转到右侧'));
      expect(popoverRect.left, greaterThanOrEqualTo(anchorRect.right));
      final border =
          tester.widget<Container>(arrowContainerFinder()).decoration
              as BoxDecoration;
      expect((border.border! as Border).left.color, isNot(Colors.transparent));
    });

    testWidgets('两侧空间都不足时 clamp 并补偿箭头位置', (tester) async {
      tester.view.physicalSize = const Size(240, 180);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      late BuildContext anchorContext;
      await tester.pumpWidget(
        wrapWithTheme(
          Align(
            alignment: Alignment.centerRight,
            child: Builder(
              builder: (context) {
                anchorContext = context;
                return const SizedBox(width: 40, height: 40);
              },
            ),
          ),
        ),
      );

      unawaited(
        TPopover.showPopover(
          context: anchorContext,
          content: const ColoredBox(
            key: Key('clamped-popover-content'),
            color: Colors.red,
          ),
          width: 180,
          height: 150,
          placement: TPopoverPlacement.top,
          radius: BorderRadius.circular(20),
        ),
      );
      await tester.pumpAndSettle();

      final contentRect = tester.getRect(
        find.byKey(const Key('clamped-popover-content')),
      );
      expect(contentRect.left, greaterThanOrEqualTo(0));
      expect(contentRect.top, greaterThanOrEqualTo(0));
      expect(contentRect.right, lessThanOrEqualTo(240));
      expect(contentRect.bottom, lessThanOrEqualTo(180));
      final arrowTransform = tester.widget<Transform>(
        find
            .ancestor(
              of: arrowContainerFinder(),
              matching: find.byType(Transform),
            )
            .first,
      );
      final arrowTranslation = arrowTransform.transform.getTranslation().x;
      final resolvedArrowCenter = 90 + arrowTranslation;
      expect(arrowTranslation, greaterThan(0));
      expect(resolvedArrowCenter, greaterThanOrEqualTo(28));
      expect(resolvedArrowCenter, lessThanOrEqualTo(152));
    });

    testWidgets('锚点销毁后清理 Overlay 并完成 showPopover Future', (tester) async {
      late BuildContext anchorContext;
      late StateSetter setHostState;
      var showAnchor = true;
      var completed = false;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              setHostState = setState;
              return Stack(
                children: [
                  if (showAnchor)
                    Align(
                      alignment: Alignment.center,
                      child: Builder(
                        builder: (context) {
                          anchorContext = context;
                          return const SizedBox(width: 40, height: 40);
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      );

      unawaited(
        TPopover.showPopover(
          context: anchorContext,
          content: const Text('随锚点关闭'),
          placement: TPopoverPlacement.bottom,
        ).then((_) => completed = true),
      );
      await tester.pump();
      expect(find.text('随锚点关闭'), findsOneWidget);
      expect(completed, isFalse);

      setHostState(() => showAnchor = false);
      await tester.pump();
      await tester.pump();

      expect(find.text('随锚点关闭'), findsNothing);
      expect(find.byKey(const Key('t-popover-outside-dismiss')), findsNothing);
      expect(completed, isTrue);
    });
  });

  // ============================================================
  // 主题覆盖
  // ============================================================
  group('TPopover 主题覆盖', () {
    testWidgets('TPopoverThemeData 注入后正常渲染', (tester) async {
      late BuildContext ctx;
      await tester.pumpWidget(
        wrapWithTheme(
          Builder(
            builder: (context) {
              ctx = context;
              return const SizedBox();
            },
          ),
          popoverTheme: const TPopoverThemeData(
            backgroundColor: Colors.black,
            borderRadius: 8,
            arrowSize: 10,
            minWidth: 50,
            maxHeight: 200,
            boxShadow: [BoxShadow(color: Colors.purple, blurRadius: 4)],
          ),
        ),
      );

      unawaited(
        TPopover.showPopover(
          context: ctx,
          content: const Text('主题气泡'),
          colorScheme: TPopoverColorScheme.defaultTheme,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('主题气泡'), findsOneWidget);
      final themedContainer = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere((container) {
            final decoration = container.decoration;
            return decoration is BoxDecoration &&
                decoration.boxShadow?.first.color == Colors.purple;
          });
      expect(
        (themedContainer.decoration! as BoxDecoration).boxShadow?.first.color,
        Colors.purple,
      );
    });

    test('TPopoverThemeData merge 合并', () {
      const base = TPopoverThemeData(
        backgroundColor: Colors.white,
        borderRadius: 4,
        boxShadow: [BoxShadow(color: Colors.black)],
      );
      const override = TPopoverThemeData(borderRadius: 8);
      final merged = base.merge(override);
      expect(merged.backgroundColor, Colors.white);
      expect(merged.borderRadius, 8);
      expect(merged.boxShadow, base.boxShadow);
    });

    test('TPopoverThemeData copyWith', () {
      const original = TPopoverThemeData(backgroundColor: Colors.white);
      final copied = original.copyWith(
        backgroundColor: Colors.grey,
        boxShadow: const [BoxShadow(color: Colors.red)],
      );
      expect(copied.backgroundColor, Colors.grey);
      expect(copied.boxShadow?.first.color, Colors.red);
      expect(
        original
            .lerp(
              const TPopoverThemeData(
                boxShadow: [BoxShadow(color: Colors.blue)],
              ),
              0.75,
            )
            .boxShadow
            ?.first
            .color,
        Colors.blue,
      );
    });

    test('TPopoverThemeData lerp 保留 nullable fallback 语义', () {
      const fallback = TPopoverThemeData();
      const explicit = TPopoverThemeData(
        backgroundColor: Colors.black,
        padding: EdgeInsets.all(20),
        minWidth: 80,
        maxWidth: 240,
        maxHeight: 160,
        borderRadius: 12,
        barrierColor: Colors.black54,
        arrowSize: 10,
        showArrow: false,
        offset: 6,
        boxShadow: [BoxShadow(color: Colors.black)],
      );

      final beforeMidpoint = fallback.lerp(explicit, 0.25);
      expect(beforeMidpoint.backgroundColor, isNull);
      expect(beforeMidpoint.padding, isNull);
      expect(beforeMidpoint.minWidth, isNull);
      expect(beforeMidpoint.maxWidth, isNull);
      expect(beforeMidpoint.maxHeight, isNull);
      expect(beforeMidpoint.borderRadius, isNull);
      expect(beforeMidpoint.barrierColor, isNull);
      expect(beforeMidpoint.arrowSize, isNull);
      expect(beforeMidpoint.showArrow, isNull);
      expect(beforeMidpoint.offset, isNull);
      expect(beforeMidpoint.boxShadow, isNull);

      final afterMidpoint = fallback.lerp(explicit, 0.75);
      expect(afterMidpoint.backgroundColor, Colors.black);
      expect(afterMidpoint.padding, const EdgeInsets.all(20));
      expect(afterMidpoint.minWidth, 80);
      expect(afterMidpoint.maxWidth, 240);
      expect(afterMidpoint.maxHeight, 160);
      expect(afterMidpoint.borderRadius, 12);
      expect(afterMidpoint.barrierColor, Colors.black54);
      expect(afterMidpoint.arrowSize, 10);
      expect(afterMidpoint.showArrow, isFalse);
      expect(afterMidpoint.offset, 6);
      expect(afterMidpoint.boxShadow, explicit.boxShadow);

      final reverse = explicit.lerp(fallback, 0.75);
      expect(reverse.backgroundColor, isNull);
      expect(reverse.padding, isNull);
      expect(reverse.maxWidth, isNull);
      expect(reverse.arrowSize, isNull);
    });

    test('TPopoverThemeData lerp 连续插值两侧显式值', () {
      const start = TPopoverThemeData(
        backgroundColor: Colors.black,
        padding: EdgeInsets.all(8),
        maxWidth: 100,
        arrowSize: 4,
      );
      const end = TPopoverThemeData(
        backgroundColor: Colors.white,
        padding: EdgeInsets.all(16),
        maxWidth: 200,
        arrowSize: 12,
      );

      final midpoint = start.lerp(end, 0.5);
      expect(
        midpoint.backgroundColor,
        Color.lerp(Colors.black, Colors.white, 0.5),
      );
      expect(midpoint.padding, const EdgeInsets.all(12));
      expect(midpoint.maxWidth, 150);
      expect(midpoint.arrowSize, 8);
    });
  });
}
