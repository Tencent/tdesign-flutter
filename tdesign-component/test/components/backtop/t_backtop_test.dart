import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TBackTop Widget 测试
///
/// 覆盖：默认渲染、shape 形态、showText、visibilityOffset 显隐、onPressed 回调/禁用、
/// 回顶动画防抖、ThemeData 子树注入、品牌主题、tooltip。
void main() {
  for (final replace in [false, true]) {
    testWidgets(
      'legacy callback changes binding after success: replace=$replace',
      (tester) async {
        final controller = ScrollController(initialScrollOffset: 500);
        addTearDown(controller.dispose);
        ScrollPosition? original;
        ScrollPositionWithSingleContext? replacement;
        final events = <String>[];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  ListView(
                    controller: controller,
                    children: const [SizedBox(height: 4000)],
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: TBackTop(
                      controller: controller,
                      visibilityOffset: 0,
                      onPressed: () {
                        events.add('pressed');
                        original = controller.position;
                        expect(original!.pixels, original!.minScrollExtent);
                        controller.detach(original!);
                        if (replace) {
                          replacement = ScrollPositionWithSingleContext(
                            physics: const ClampingScrollPhysics(),
                            context: original!.context,
                            initialPixels: 0,
                          );
                          replacement!.applyViewportDimension(
                            original!.viewportDimension,
                          );
                          replacement!.applyContentDimensions(
                            original!.minScrollExtent,
                            original!.maxScrollExtent,
                          );
                          controller.attach(replacement!);
                        }
                      },
                      onCompleted: () => events.add('completed'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        try {
          await tester.pump();
          await tester.tap(find.byType(TBackTop));
          expect(events, isEmpty);
          await tester.pumpAndSettle();
          if (replace) {
            expect(controller.offset, 0);
            expect(controller.position, same(replacement));
          } else {
            expect(controller.hasClients, isFalse);
          }
          expect(events, ['pressed']);
          expect(tester.takeException(), isNull);
        } finally {
          if (replacement != null) {
            controller.detach(replacement!);
            replacement!.dispose();
          }
          if (original != null) {
            controller.attach(original!);
          }
          await tester.pumpWidget(const SizedBox());
        }
      },
    );
  }

  testWidgets('默认图标22，独立于无匹配全局size，组件覆盖优先', (tester) async {
    Future<void> pump(TThemeData token, [TBackTopThemeData? component]) =>
        tester.pumpWidget(
          MaterialApp(
            themeAnimationDuration: Duration.zero,
            theme: TThemeBuilder.light(
              token,
            ).copyWith(extensions: [token, if (component != null) component]),
            home: const Scaffold(body: TBackTop()),
          ),
        );
    final token = TThemeData.defaultData();
    await pump(token);
    expect(tester.widget<Icon>(find.byIcon(TIcons.backtop)).size, 22);
    final other = token.copyWith(
      sizeMap: {...token.sizeMap, 'size7': 25, 'size8': 30},
    );
    await pump(other);
    expect(tester.widget<Icon>(find.byIcon(TIcons.backtop)).size, 22);
    await pump(other, const TBackTopThemeData(iconSize: 17));
    expect(tester.widget<Icon>(find.byIcon(TIcons.backtop)).size, 17);
    expect(
      const TBackTopThemeData()
          .lerp(const TBackTopThemeData(iconSize: 30), .5)
          .iconSize,
      26,
    );
  });

  RoundedRectangleBorder circleBorder(
    TThemeData token, {
    BorderSide side = BorderSide.none,
  }) => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(token.radiusCircle),
    side: side,
  );

  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TBackTopThemeData? backTopTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (backTopTheme != null) backTopTheme,
    ];
    return MaterialApp(
      theme: ThemeData(
        extensions: [TThemeData.defaultData(), ...themeExtensions],
      ),
      home: Scaffold(
        body: Stack(fit: StackFit.expand, children: [child]),
      ),
    );
  }

  /// 创建带 ListView 的测试环境，使 ScrollController 可正常挂载
  Widget wrapScrollable(Widget child, ScrollController controller) {
    return wrapWithTheme(
      Stack(
        fit: StackFit.expand,
        children: [
          ListView(
            controller: controller,
            children: List.generate(
              20,
              (i) => SizedBox(height: 200, child: Text('Item $i')),
            ),
          ),
          Positioned(right: 16, bottom: 32, child: child),
        ],
      ),
    );
  }

  group('1.0.1 completion compatibility', () {
    testWidgets('legacy callback without controller stays immediate', (
      tester,
    ) async {
      final events = <String>[];
      await tester.pumpWidget(
        wrapWithTheme(
          TBackTop(
            onPressed: () => events.add('pressed'),
            onCompleted: () => events.add('completed'),
          ),
        ),
      );
      await tester.tap(find.byType(TBackTop));
      expect(events, ['pressed']);
    });

    testWidgets('completion alone does not enable the button', (tester) async {
      var completed = 0;
      await tester.pumpWidget(
        wrapWithTheme(TBackTop(onCompleted: () => completed++)),
      );
      expect(
        tester
            .widget<GestureDetector>(
              find.descendant(
                of: find.byType(TBackTop),
                matching: find.byType(GestureDetector),
              ),
            )
            .onTap,
        isNull,
      );
      await tester.tap(find.byType(TBackTop));
      expect(completed, 0);
    });

    for (final scenario in [
      'success',
      'interrupted',
      'replaced',
      'detached',
      'disposed',
      'already top',
    ]) {
      testWidgets('completion guards: $scenario', (tester) async {
        final controller = ScrollController(initialScrollOffset: 500);
        final other = ScrollController();
        addTearDown(controller.dispose);
        addTearDown(other.dispose);
        final events = <String>[];
        var current = controller;
        var showBackTop = true;
        var showList = true;
        late StateSetter rebuild;
        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                rebuild = setState;
                return Scaffold(
                  body: Stack(
                    children: [
                      if (showList)
                        ListView(
                          controller: current,
                          children: const [SizedBox(height: 4000)],
                        ),
                      if (showBackTop)
                        Positioned(
                          right: 16,
                          bottom: 32,
                          child: TBackTop(
                            controller: current,
                            visibilityOffset: 0,
                            onPressed: () {
                              events.add('pressed');
                            },
                            onCompleted: () => events.add('completed'),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
        await tester.pump();
        if (scenario == 'already top') {
          controller.jumpTo(0);
          await tester.pump();
        }
        await tester.tap(find.byType(TBackTop));
        expect(
          events,
          scenario == 'already top' ? ['pressed', 'completed'] : isEmpty,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        // Repeated activation is ignored while the operation is in progress.
        if (scenario != 'already top') {
          await tester.tap(find.byType(TBackTop));
        }
        if (scenario == 'interrupted') {
          controller.jumpTo(300);
        } else if (scenario == 'replaced') {
          rebuild(() => current = other);
          await tester.pump();
        } else if (scenario == 'detached') {
          rebuild(() => showList = false);
          await tester.pump();
        } else if (scenario == 'disposed') {
          rebuild(() => showBackTop = false);
          await tester.pump();
        }
        await tester.pumpAndSettle();
        expect(
          events,
          scenario == 'disposed'
              ? isEmpty
              : scenario == 'success' || scenario == 'already top'
              ? ['pressed', 'completed']
              : ['pressed'],
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      });
    }
  });

  for (final interrupted in [false, true]) {
    testWidgets(
      'success is determined before legacy callback effects: interrupted=$interrupted',
      (tester) async {
        final controller = ScrollController(initialScrollOffset: 500);
        addTearDown(controller.dispose);
        var pressed = 0;
        var completed = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  ListView(
                    controller: controller,
                    children: const [SizedBox(height: 4000)],
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: TBackTop(
                      controller: controller,
                      visibilityOffset: 0,
                      onPressed: () {
                        pressed++;
                        controller.jumpTo(interrupted ? 0 : 200);
                      },
                      onCompleted: () => completed++,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.tap(find.byType(TBackTop));
        expect(pressed, 0);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        if (interrupted) {
          controller.jumpTo(300);
        }
        await tester.pumpAndSettle();
        expect(pressed, 1);
        expect(completed, interrupted ? 0 : 1);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }

  testWidgets(
    'cross-frame restore of the original position permits completion',
    (tester) async {
      final first = ScrollController(initialScrollOffset: 500);
      final second = ScrollController();
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      var listController = first;
      var completed = 0;
      late StateSetter update;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return Scaffold(
                body: Stack(
                  children: [
                    ListView(
                      controller: listController,
                      children: const [SizedBox(height: 4000)],
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: TBackTop(
                        controller: first,
                        visibilityOffset: 0,
                        onCompleted: () => completed++,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();
      final originalPosition = first.position;
      await tester.tap(find.byType(TBackTop));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      update(() => listController = second);
      await tester.pump();
      expect(first.hasClients, isFalse);
      expect(second.position, same(originalPosition));
      await tester.pump(const Duration(milliseconds: 100));
      update(() => listController = first);
      await tester.pump();
      expect(first.position, same(originalPosition));
      await tester.pumpAndSettle();
      expect(first.offset, 0);
      expect(completed, 1);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('same-frame detach and reattach permits one ordered completion', (
    tester,
  ) async {
    final controller = ScrollController(initialScrollOffset: 500);
    addTearDown(controller.dispose);
    final events = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              ListView(
                controller: controller,
                children: const [SizedBox(height: 4000)],
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: TBackTop(
                  controller: controller,
                  visibilityOffset: 0,
                  onPressed: () => events.add('pressed'),
                  onCompleted: () => events.add('completed'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byType(TBackTop));
    expect(events, isEmpty);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final position = controller.position;
    controller.detach(position);
    expect(controller.hasClients, isFalse);
    controller.attach(position);
    expect(controller.position, same(position));
    expect(events, isEmpty);
    await tester.pumpAndSettle();
    expect(controller.offset, 0);
    expect(events, ['pressed', 'completed']);
    await tester.pumpWidget(const SizedBox());
  });

  for (final scenario in [
    'BackTop controller restored',
    'unbound at completion',
    'position replaced',
  ]) {
    testWidgets('completion-time identity: $scenario', (tester) async {
      final first = ScrollController();
      final second = ScrollController();
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      var listController = first;
      var backtopController = first;
      var listVersion = 0;
      final events = <String>[];
      late StateSetter update;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return Scaffold(
                body: Stack(
                  children: [
                    ListView(
                      key: ValueKey(listVersion),
                      controller: listController,
                      children: const [SizedBox(height: 4000)],
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: TBackTop(
                        controller: backtopController,
                        visibilityOffset: 0,
                        onPressed: () => events.add('pressed'),
                        onCompleted: () => events.add('completed'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
      await tester.pump();
      first.jumpTo(500);
      await tester.pump();
      final original = first.position;
      await tester.tap(find.byType(TBackTop));
      expect(events, isEmpty);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      if (scenario == 'BackTop controller restored') {
        update(() => backtopController = second);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        update(() => backtopController = first);
        await tester.pump();
        expect(first.position, same(original));
        expect(events, isEmpty);
      } else if (scenario == 'unbound at completion') {
        update(() => listController = second);
        await tester.pump();
        expect(first.hasClients, isFalse);
        expect(second.position, same(original));
        expect(events, isEmpty);
      } else {
        update(() => listVersion++);
        await tester.pump();
        expect(first.position, isNot(same(original)));
        expect(first.positions.contains(original), isFalse);
        expect(first.offset, 0);
      }
      await tester.pumpAndSettle();
      expect(
        events,
        scenario == 'BackTop controller restored'
            ? ['pressed', 'completed']
            : ['pressed'],
      );
      if (scenario == 'unbound at completion') {
        expect(second.offset, 0);
        expect(first.hasClients, isFalse);
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  group('TBackTop 基础渲染', () {
    testWidgets('默认圆形渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TBackTop()));
      expect(find.byType(TBackTop), findsOneWidget);
    });

    testWidgets('半圆形渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TBackTop(shape: TBackTopShape.halfCircle)),
      );
      expect(find.byType(TBackTop), findsOneWidget);
      final decoration = tester
          .widgetList<Container>(find.byType(Container))
          .map((container) => container.decoration)
          .whereType<ShapeDecoration>()
          .first;
      final token = TThemeData.defaultData();
      expect(
        decoration.shape,
        RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(token.radiusRound),
            bottomLeft: Radius.circular(token.radiusRound),
          ),
          side: BorderSide(color: token.componentBorder, width: 0.5),
        ),
      );
    });

    testWidgets('半圆形跟随 radiusRound，不受 radiusCircle 覆盖影响', (tester) async {
      final token = TThemeData.defaultData().copyWith(
        radiusMap: {'radiusRound': 12, 'radiusCircle': 8},
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [token]),
          home: const Scaffold(
            body: Row(
              children: [
                TBackTop(),
                TBackTop(shape: TBackTopShape.halfCircle),
              ],
            ),
          ),
        ),
      );
      final decorations = tester
          .widgetList<Container>(find.byType(Container))
          .map((container) => container.decoration)
          .whereType<ShapeDecoration>()
          .toList();
      final side = BorderSide(color: token.componentBorder, width: 0.5);
      expect(decorations[0].shape, circleBorder(token, side: side));
      expect(
        decorations[1].shape,
        RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
          side: side,
        ),
      );
    });

    testWidgets('showText 为 true 时显示文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TBackTop(showText: true)));
      // 默认中文环境下，应显示 "顶部"
      expect(find.text('顶部'), findsOneWidget);
      final text = tester.widget<Text>(find.text('顶部'));
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);
      expect(
        text.style?.fontSize,
        TThemeData.defaultData().fontMarkExtraSmall?.size,
      );
    });

    testWidgets('showText 为 false 时不显示文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TBackTop(showText: false)));
      expect(find.text('顶部'), findsNothing);
    });

    testWidgets('半圆形态 showText 显示返回+顶部', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const Align(
            child: TBackTop(shape: TBackTopShape.halfCircle, showText: true),
          ),
        ),
      );
      expect(find.text('返回\n顶部'), findsOneWidget);
      expect(
        tester.widget<Text>(find.text('返回\n顶部')).overflow,
        TextOverflow.ellipsis,
      );
    });
  });

  group('TBackTop 动作来源', () {
    testWidgets('无 controller 和回调时不响应点击', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TBackTop(onPressed: null)));
      expect(find.byType(TBackTop), findsOneWidget);
      final gestureDetector = tester.widget<GestureDetector>(
        find.byType(GestureDetector),
      );
      expect(gestureDetector.onTap, null);
    });

    testWidgets('仅传 controller 时仍可点击回顶', (tester) async {
      final controller = ScrollController(initialScrollOffset: 500);
      await tester.pumpWidget(
        wrapScrollable(TBackTop(controller: controller), controller),
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<GestureDetector>(find.byType(GestureDetector)).onTap,
        isNotNull,
      );
      await tester.tap(find.byType(TBackTop));
      await tester.pumpAndSettle();
      expect(controller.offset, lessThan(1));
      controller.dispose();
    });
  });

  group('TBackTop onPressed 回调', () {
    testWidgets('onPressed 被触发', (tester) async {
      var called = false;
      await tester.pumpWidget(
        wrapWithTheme(TBackTop(onPressed: () => called = true)),
      );
      await tester.tap(find.byType(TBackTop));
      expect(called, true);
    });

    testWidgets('有 controller 且挂载时先回顶再调 onPressed', (tester) async {
      final controller = ScrollController(initialScrollOffset: 500);
      var called = false;

      await tester.pumpWidget(
        wrapScrollable(
          TBackTop(controller: controller, onPressed: () => called = true),
          controller,
        ),
      );

      // 滚动到底部以验证回顶
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TBackTop));
      // 等待动画完成
      await tester.pumpAndSettle();

      // controller 应已滚动到顶部
      expect(controller.offset, lessThan(1));
      // onPressed 应被调用
      expect(called, true);
      controller.dispose();
    });

    testWidgets('无 controller 时仅调 onPressed', (tester) async {
      var called = false;
      await tester.pumpWidget(
        wrapWithTheme(TBackTop(onPressed: () => called = true)),
      );
      await tester.tap(find.byType(TBackTop));
      await tester.pump();
      expect(called, true);
    });
  });

  group('TBackTop 回顶防抖', () {
    testWidgets('动画进行中重复点击不额外触发 onPressed', (tester) async {
      final controller = ScrollController(initialScrollOffset: 3000);
      var callCount = 0;

      await tester.pumpWidget(
        wrapScrollable(
          TBackTop(controller: controller, onPressed: () => callCount++),
          controller,
        ),
      );

      await tester.pumpAndSettle();

      // 快速连续点击 3 次
      await tester.tap(find.byType(TBackTop));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.byType(TBackTop));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.byType(TBackTop));

      await tester.pumpAndSettle();

      // 防抖应保证 onPressed 只执行一次
      expect(callCount, 1);
      controller.dispose();
    });
  });

  group('TBackTop visibilityOffset 显隐控制', () {
    testWidgets('未设置 visibilityOffset 时始终可见', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TBackTop()));
      expect(find.byType(TBackTop), findsOneWidget);
    });

    testWidgets('设置 visibilityOffset 后未达到阈值时隐藏', (tester) async {
      final controller = ScrollController(initialScrollOffset: 50);
      await tester.pumpWidget(
        wrapScrollable(
          TBackTop(controller: controller, visibilityOffset: 100),
          controller,
        ),
      );
      await tester.pump();
      // 偏移 50 < 100，应隐藏
      expect(find.byType(GestureDetector), findsNothing);
      controller.dispose();
    });

    testWidgets('达到阈值后显示', (tester) async {
      final controller = ScrollController(initialScrollOffset: 150);
      await tester.pumpWidget(
        wrapScrollable(
          TBackTop(controller: controller, visibilityOffset: 100),
          controller,
        ),
      );
      await tester.pump();
      expect(find.byType(TBackTop), findsOneWidget);
      controller.dispose();
    });

    testWidgets('阈值边界值：刚好等于阈值时显示', (tester) async {
      final controller = ScrollController(initialScrollOffset: 100);
      await tester.pumpWidget(
        wrapScrollable(
          TBackTop(controller: controller, visibilityOffset: 100),
          controller,
        ),
      );
      await tester.pump();
      expect(find.byType(TBackTop), findsOneWidget);
      controller.dispose();
    });

    testWidgets('滚动越过阈值后显示切换', (tester) async {
      final controller = ScrollController(initialScrollOffset: 0);
      await tester.pumpWidget(
        wrapScrollable(
          TBackTop(controller: controller, visibilityOffset: 100),
          controller,
        ),
      );
      await tester.pump();
      // 偏移 0，应隐藏
      expect(find.byType(GestureDetector), findsNothing);

      // 模拟滚动越过阈值
      controller.jumpTo(200);
      await tester.pump();
      expect(find.byType(TBackTop), findsOneWidget);

      // 滚回顶部
      controller.jumpTo(0);
      await tester.pump();
      expect(find.byType(GestureDetector), findsNothing);

      controller.dispose();
    });

    testWidgets('运行时替换 controller 和阈值后重新同步显隐', (tester) async {
      final firstController = ScrollController(initialScrollOffset: 50);
      final secondController = ScrollController(initialScrollOffset: 150);

      await tester.pumpWidget(
        wrapScrollable(
          TBackTop(controller: firstController, visibilityOffset: 100),
          firstController,
        ),
      );
      await tester.pump();
      expect(find.byType(GestureDetector), findsNothing);

      await tester.pumpWidget(
        wrapScrollable(
          TBackTop(controller: secondController, visibilityOffset: 120),
          secondController,
        ),
      );
      await tester.pumpAndSettle();
      secondController.jumpTo(150);
      await tester.pump();
      expect(find.byType(GestureDetector), findsOneWidget);

      secondController.jumpTo(0);
      await tester.pump();
      expect(find.byType(GestureDetector), findsNothing);

      firstController.dispose();
      secondController.dispose();
    });
  });

  group('TBackTop 主题颜色', () {
    testWidgets('裸 TThemeData 驱动默认背景和内容色', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [token]),
          home: const Scaffold(body: TBackTop(onPressed: _noop)),
        ),
      );

      final decoration = tester
          .widgetList<Container>(find.byType(Container))
          .map((container) => container.decoration)
          .whereType<ShapeDecoration>()
          .first;
      expect(decoration.color, token.bgColorContainer);
      expect(
        decoration.shape,
        circleBorder(
          token,
          side: BorderSide(color: token.componentBorder, width: 0.5),
        ),
      );
      expect(
        tester.widget<Icon>(find.byIcon(TIcons.backtop)).color,
        token.textColorPrimary,
      );
    });

    testWidgets('组件 Theme 颜色覆盖全局品牌色', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TBackTop(onPressed: _noop),
          backTopTheme: const TBackTopThemeData(
            backgroundColor: Colors.red,
            borderColor: Colors.redAccent,
            contentColor: Colors.white,
          ),
        ),
      );
      final decoration = tester
          .widgetList<Container>(find.byType(Container))
          .map((container) => container.decoration)
          .whereType<ShapeDecoration>()
          .first;
      expect(decoration.color, Colors.red);
      expect(
        decoration.shape,
        circleBorder(
          TThemeData.defaultData(),
          side: const BorderSide(color: Colors.redAccent, width: 0.5),
        ),
      );
      expect(
        tester.widget<Icon>(find.byIcon(TIcons.backtop)).color,
        Colors.white,
      );
    });
  });

  group('TBackTop tooltip', () {
    testWidgets('自定义 tooltip 文案', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TBackTop(tooltip: '回到顶部', onPressed: null)),
      );
      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, '回到顶部');
    });

    testWidgets('未传 tooltip 时使用 resource 默认文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TBackTop(onPressed: null)));
      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      // 默认中文：返回顶部
      expect(tooltip.message, '返回顶部');
    });
  });

  group('TBackTopThemeData', () {
    test('默认构造全 null', () {
      const theme = TBackTopThemeData();
      expect(theme.backgroundColor, null);
      expect(theme.borderColor, null);
      expect(theme.contentColor, null);
      expect(theme.roundSize, null);
      expect(theme.halfCircleHeight, null);
      expect(theme.halfCircleMinWidth, null);
      expect(theme.iconSize, null);
      expect(theme.borderWidth, null);
      expect(theme.halfCircleHorizontalPadding, null);
      expect(theme.contentGap, null);
      expect(theme.textStyle, null);
    });

    test('copyWith 部分覆盖', () {
      const theme = TBackTopThemeData(roundSize: 48, iconSize: 20);
      final copied = theme.copyWith(roundSize: 56);
      expect(copied.roundSize, 56);
      expect(copied.iconSize, 20);
    });

    test('copyWith 全量覆盖', () {
      const theme = TBackTopThemeData();
      final copied = theme.copyWith(
        backgroundColor: Colors.red,
        halfCircleHeight: 44,
        contentGap: 4,
      );
      expect(copied.backgroundColor, Colors.red);
      expect(copied.halfCircleHeight, 44);
      expect(copied.contentGap, 4);
    });

    test('lerp 空值按内置尺寸插值且双空保持空', () {
      const a = TBackTopThemeData();
      const b = TBackTopThemeData(roundSize: 56, iconSize: 24);
      final result = a.lerp(b, 0.5);
      expect(result.roundSize, 52);
      expect(result.iconSize, 23);
      expect(result.contentGap, null);
    });

    test('lerp 非同类返回自身', () {
      const a = TBackTopThemeData(roundSize: 48);
      final result = a.lerp(null, 0.5);
      expect(result.roundSize, 48);
    });

    test('lerp 覆盖单边和双边颜色及文字样式', () {
      const a = TBackTopThemeData(
        backgroundColor: Colors.red,
        borderColor: Colors.black,
        textStyle: TextStyle(fontSize: 10),
      );
      const b = TBackTopThemeData(
        borderColor: Colors.white,
        contentColor: Colors.blue,
      );

      final beforeMidpoint = a.lerp(b, 0.25);
      expect(beforeMidpoint.backgroundColor, Colors.red);
      expect(beforeMidpoint.contentColor, isNull);
      expect(
        beforeMidpoint.borderColor,
        Color.lerp(Colors.black, Colors.white, 0.25),
      );
      expect(beforeMidpoint.textStyle?.fontSize, 10);

      final afterMidpoint = a.lerp(b, 0.75);
      expect(afterMidpoint.backgroundColor, isNull);
      expect(afterMidpoint.contentColor, Colors.blue);
      expect(afterMidpoint.textStyle, isNotNull);
    });

    testWidgets('默认显隐阈值为 200', (tester) async {
      final controller = ScrollController(initialScrollOffset: 199);
      await tester.pumpWidget(
        wrapScrollable(TBackTop(controller: controller), controller),
      );
      await tester.pump();
      expect(find.byType(GestureDetector), findsNothing);
      controller.jumpTo(200);
      await tester.pump();
      expect(find.byType(GestureDetector), findsOneWidget);
      controller.dispose();
    });

    testWidgets('构造器 visibilityOffset 使用实例唯一状态源', (tester) async {
      final controller = ScrollController(initialScrollOffset: 0);
      await tester.pumpWidget(
        wrapScrollable(
          TBackTop(controller: controller, visibilityOffset: 50),
          controller,
        ),
      );
      await tester.pump();
      // 偏移 0 < 50，应隐藏
      expect(find.byType(GestureDetector), findsNothing);

      // 滚到 60
      controller.jumpTo(60);
      await tester.pump();
      expect(find.byType(TBackTop), findsOneWidget);

      controller.dispose();
    });
  });

  group('TBackTopShape 枚举', () {
    test('枚举值', () {
      expect(TBackTopShape.circle.index, 0);
      expect(TBackTopShape.halfCircle.index, 1);
    });
  });

  group('TBackTopColorPreset 枚举', () {
    test('枚举值', () {
      expect(TBackTopColorPreset.values, [
        TBackTopColorPreset.light,
        TBackTopColorPreset.dark,
      ]);
    });
  });

  group('TBackTop Theme 颜色', () {
    testWidgets('裸 TThemeData 提供颜色 token 兜底', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrapWithTheme(const TBackTop()));
      final decoration = tester
          .widgetList<Container>(find.byType(Container))
          .map((container) => container.decoration)
          .whereType<ShapeDecoration>()
          .first;
      expect(decoration.color, token.bgColorContainer);
      expect(
        decoration.shape,
        circleBorder(
          token,
          side: BorderSide(color: token.componentBorder, width: 0.5),
        ),
      );
      expect(
        tester.widget<Icon>(find.byIcon(TIcons.backtop)).color,
        token.textColorPrimary,
      );
    });

    testWidgets('Theme 颜色字段注入生效', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TBackTop(),
          backTopTheme: const TBackTopThemeData(backgroundColor: Colors.red),
        ),
      );
      expect(find.byType(TBackTop), findsOneWidget);
    });

    testWidgets('dark 圆形和半圆形使用各自设计 Token', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrapWithTheme(
          const Row(
            children: [
              TBackTop(colorPreset: TBackTopColorPreset.dark),
              TBackTop(
                shape: TBackTopShape.halfCircle,
                colorPreset: TBackTopColorPreset.dark,
              ),
            ],
          ),
        ),
      );
      final decorations = tester
          .widgetList<Container>(find.byType(Container))
          .map((container) => container.decoration)
          .whereType<ShapeDecoration>()
          .toList();
      expect(decorations[0].color, token.grayColor13);
      expect(decorations[1].color, token.grayColor14);
      final side = BorderSide(color: token.grayColor9, width: 0.5);
      expect(decorations[0].shape, circleBorder(token, side: side));
      expect(
        decorations[1].shape,
        RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(token.radiusRound),
            bottomLeft: Radius.circular(token.radiusRound),
          ),
          side: side,
        ),
      );
      expect(
        tester
            .widgetList<Icon>(find.byIcon(TIcons.backtop))
            .every((icon) => icon.color == token.whiteColor1),
        isTrue,
      );
    });

    testWidgets('dark 预设在系统深色主题下仍使用白色内容', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.dark(token),
          home: const Scaffold(
            body: Row(
              children: [
                TBackTop(colorPreset: TBackTopColorPreset.dark),
                TBackTop(
                  shape: TBackTopShape.halfCircle,
                  colorPreset: TBackTopColorPreset.dark,
                  showText: true,
                ),
              ],
            ),
          ),
        ),
      );

      expect(
        tester
            .widgetList<Icon>(find.byIcon(TIcons.backtop))
            .every((icon) => icon.color == token.whiteColor1),
        isTrue,
      );
      expect(
        tester.widget<Text>(find.byType(Text).first).style?.color,
        token.whiteColor1,
      );
    });

    testWidgets('Theme 尺寸和文字样式字段生效', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const Align(
            child: TBackTop(shape: TBackTopShape.halfCircle, showText: true),
          ),
          backTopTheme: const TBackTopThemeData(
            halfCircleHeight: 44,
            halfCircleMinWidth: 50,
            iconSize: 24,
            borderWidth: 1,
            halfCircleHorizontalPadding: 10,
            contentGap: 4,
            textStyle: TextStyle(fontSize: 12),
          ),
        ),
      );
      final decoratedSizes = tester
          .widgetList<Container>(find.byType(Container))
          .where((container) => container.decoration is ShapeDecoration)
          .map((container) => tester.getSize(find.byWidget(container)));
      expect(decoratedSizes.any((size) => size.height == 44), isTrue);
      expect(tester.widget<Icon>(find.byIcon(TIcons.backtop)).size, 24);
      expect(tester.widget<Text>(find.text('返回\n顶部')).style?.fontSize, 12);
    });

    testWidgets('contentColor 唯一控制图标和文字颜色', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TBackTop(showText: true),
          backTopTheme: const TBackTopThemeData(
            contentColor: Colors.green,
            textStyle: TextStyle(color: Colors.red),
          ),
        ),
      );

      expect(
        tester.widget<Icon>(find.byIcon(TIcons.backtop)).color,
        Colors.green,
      );
      expect(tester.widget<Text>(find.text('顶部')).style?.color, Colors.green);
    });

    testWidgets('半圆形 + showText + Theme 注入', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TBackTop(shape: TBackTopShape.halfCircle, showText: true),
          backTopTheme: const TBackTopThemeData(contentGap: 4),
        ),
      );
      expect(find.text('返回\n顶部'), findsOneWidget);
    });
  });
}

void _noop() {}
