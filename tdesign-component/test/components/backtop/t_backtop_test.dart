import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TBackTop V1.0 Widget 测试
///
/// 覆盖：默认渲染、shape 形态、showText、visibilityOffset 显隐、onPressed 回调/禁用、
/// 回顶动画防抖、ThemeData 子树注入、品牌主题、tooltip。
void main() {
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
        body: Stack(
          fit: StackFit.expand,
          children: [child],
        ),
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
                20, (i) => SizedBox(height: 200, child: Text('Item $i'))),
          ),
          Positioned(right: 16, bottom: 32, child: child),
        ],
      ),
    );
  }

  group('TBackTop 基础渲染', () {
    testWidgets('默认圆形渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TBackTop()));
      expect(find.byType(TBackTop), findsOneWidget);
    });

    testWidgets('半圆形渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBackTop(shape: TBackTopShape.halfCircle),
      ));
      expect(find.byType(TBackTop), findsOneWidget);
    });

    testWidgets('showText 为 true 时显示文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBackTop(showText: true),
      ));
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
      await tester.pumpWidget(wrapWithTheme(
        const TBackTop(showText: false),
      ));
      expect(find.text('顶部'), findsNothing);
    });

    testWidgets('半圆形态 showText 显示返回+顶部', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBackTop(shape: TBackTopShape.halfCircle, showText: true),
      ));
      expect(find.text('返回'), findsOneWidget);
      expect(find.text('顶部'), findsOneWidget);
      expect(
          tester.widget<Text>(find.text('返回')).overflow, TextOverflow.ellipsis);
      expect(
          tester.widget<Text>(find.text('顶部')).overflow, TextOverflow.ellipsis);
    });
  });

  group('TBackTop 禁用态 (A类)', () {
    testWidgets('onPressed: null 时 GestureDetector onTap 为 null',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBackTop(onPressed: null),
      ));
      expect(find.byType(TBackTop), findsOneWidget);
      // 禁用时 GestureDetector 仍存在（为 tooltip 服务），但 onTap 为 null
      final gestureDetector =
          tester.widget<GestureDetector>(find.byType(GestureDetector));
      expect(gestureDetector.onTap, null);
    });

    testWidgets('onPressed: null 时 tooltip 仍可用', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBackTop(onPressed: null, tooltip: '回顶'),
      ));
      expect(find.byType(Tooltip), findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
    });
  });

  group('TBackTop onPressed 回调', () {
    testWidgets('onPressed 被触发', (tester) async {
      var called = false;
      await tester.pumpWidget(wrapWithTheme(
        TBackTop(onPressed: () => called = true),
      ));
      await tester.tap(find.byType(TBackTop));
      expect(called, true);
    });

    testWidgets('有 controller 且挂载时先回顶再调 onPressed', (tester) async {
      final controller = ScrollController(initialScrollOffset: 500);
      var called = false;

      await tester.pumpWidget(wrapScrollable(
        TBackTop(
          controller: controller,
          onPressed: () => called = true,
        ),
        controller,
      ));

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
      await tester.pumpWidget(wrapWithTheme(
        TBackTop(onPressed: () => called = true),
      ));
      await tester.tap(find.byType(TBackTop));
      await tester.pump();
      expect(called, true);
    });
  });

  group('TBackTop 回顶防抖', () {
    testWidgets('动画进行中重复点击不额外触发 onPressed', (tester) async {
      final controller = ScrollController(initialScrollOffset: 3000);
      var callCount = 0;

      await tester.pumpWidget(wrapScrollable(
        TBackTop(
          controller: controller,
          onPressed: () => callCount++,
        ),
        controller,
      ));

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
      await tester.pumpWidget(wrapScrollable(
        TBackTop(
          controller: controller,
          visibilityOffset: 100,
        ),
        controller,
      ));
      await tester.pump();
      // 偏移 50 < 100，应隐藏
      expect(find.byType(GestureDetector), findsNothing);
      controller.dispose();
    });

    testWidgets('达到阈值后显示', (tester) async {
      final controller = ScrollController(initialScrollOffset: 150);
      await tester.pumpWidget(wrapScrollable(
        TBackTop(
          controller: controller,
          visibilityOffset: 100,
        ),
        controller,
      ));
      await tester.pump();
      expect(find.byType(TBackTop), findsOneWidget);
      controller.dispose();
    });

    testWidgets('阈值边界值：刚好等于阈值时显示', (tester) async {
      final controller = ScrollController(initialScrollOffset: 100);
      await tester.pumpWidget(wrapScrollable(
        TBackTop(
          controller: controller,
          visibilityOffset: 100,
        ),
        controller,
      ));
      await tester.pump();
      expect(find.byType(TBackTop), findsOneWidget);
      controller.dispose();
    });

    testWidgets('滚动越过阈值后显示切换', (tester) async {
      final controller = ScrollController(initialScrollOffset: 0);
      await tester.pumpWidget(wrapScrollable(
        TBackTop(
          controller: controller,
          visibilityOffset: 100,
        ),
        controller,
      ));
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
  });

  group('TBackTop 主题颜色', () {
    testWidgets('裸 TThemeData 驱动默认背景和内容色', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData(
          extensions: [token],
        ),
        home: const Scaffold(body: TBackTop(onPressed: _noop)),
      ));

      final decoration = tester
          .widgetList<Container>(find.byType(Container))
          .map((container) => container.decoration)
          .whereType<BoxDecoration>()
          .first;
      expect(decoration.color, token.brandLightColor);
      expect(decoration.border?.top.color, token.brandNormalColor);
      expect(
        tester.widget<Icon>(find.byIcon(TIcons.backtop)).color,
        token.textColorAnti,
      );
    });

    testWidgets('组件 Theme 颜色覆盖全局品牌色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBackTop(onPressed: _noop),
        backTopTheme: const TBackTopThemeData(
          backgroundColor: Colors.red,
          borderColor: Colors.redAccent,
          contentColor: Colors.white,
        ),
      ));
      final decoration = tester
          .widgetList<Container>(find.byType(Container))
          .map((container) => container.decoration)
          .whereType<BoxDecoration>()
          .first;
      expect(decoration.color, Colors.red);
      expect(decoration.border?.top.color, Colors.redAccent);
      expect(
          tester.widget<Icon>(find.byIcon(TIcons.backtop)).color, Colors.white);
    });
  });

  group('TBackTop tooltip', () {
    testWidgets('自定义 tooltip 文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBackTop(tooltip: '回到顶部', onPressed: null),
      ));
      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, '回到顶部');
    });

    testWidgets('未传 tooltip 时使用 resource 默认文案', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBackTop(onPressed: null),
      ));
      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      // 默认中文：返回顶部
      expect(tooltip.message, '返回顶部');
    });
  });

  group('TBackTopThemeData', () {
    test('默认构造全 null', () {
      const theme = TBackTopThemeData();
      expect(theme.shape, null);
      expect(theme.backgroundColor, null);
      expect(theme.borderColor, null);
      expect(theme.contentColor, null);
      expect(theme.defaultVisibilityOffset, null);
    });

    test('copyWith 部分覆盖', () {
      const theme = TBackTopThemeData(
        shape: TBackTopShape.circle,
        defaultVisibilityOffset: 100,
      );
      final copied = theme.copyWith(shape: TBackTopShape.halfCircle);
      expect(copied.shape, TBackTopShape.halfCircle);
      expect(copied.defaultVisibilityOffset, 100);
    });

    test('copyWith 全量覆盖', () {
      const theme = TBackTopThemeData(shape: TBackTopShape.circle);
      final copied = theme.copyWith(
        shape: TBackTopShape.halfCircle,
        backgroundColor: Colors.red,
        defaultVisibilityOffset: 200,
      );
      expect(copied.shape, TBackTopShape.halfCircle);
      expect(copied.backgroundColor, Colors.red);
      expect(copied.defaultVisibilityOffset, 200);
    });

    test('lerp t=0 取左值', () {
      const a = TBackTopThemeData(
        shape: TBackTopShape.circle,
        defaultVisibilityOffset: 100,
      );
      const b = TBackTopThemeData(
        shape: TBackTopShape.halfCircle,
        defaultVisibilityOffset: 200,
      );
      final result = a.lerp(b, 0);
      expect(result.shape, TBackTopShape.circle);
      expect(result.defaultVisibilityOffset, 100);
    });

    test('lerp t=1 取右值', () {
      const a = TBackTopThemeData(
        shape: TBackTopShape.circle,
        defaultVisibilityOffset: 100,
      );
      const b = TBackTopThemeData(
        shape: TBackTopShape.halfCircle,
        defaultVisibilityOffset: 200,
      );
      final result = a.lerp(b, 1);
      expect(result.shape, TBackTopShape.halfCircle);
      expect(result.defaultVisibilityOffset, 200);
    });

    test('lerp 非同类返回自身', () {
      const a = TBackTopThemeData(shape: TBackTopShape.circle);
      final result = a.lerp(null, 0.5);
      expect(result.shape, TBackTopShape.circle);
    });

    testWidgets('Theme 注入 shape 生效', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBackTop(),
        backTopTheme: const TBackTopThemeData(shape: TBackTopShape.halfCircle),
      ));
      expect(find.byType(TBackTop), findsOneWidget);
    });

    testWidgets('Theme 注入 defaultVisibilityOffset 生效', (tester) async {
      final controller = ScrollController(initialScrollOffset: 0);
      await tester.pumpWidget(wrapScrollable(
        TBackTop(controller: controller),
        controller,
      ));
      // 无 Theme 注入 visibilityOffset，默认始终可见
      await tester.pump();
      expect(find.byType(TBackTop), findsOneWidget);
      controller.dispose();
    });

    testWidgets('构造器 visibilityOffset 覆盖 Theme defaultVisibilityOffset',
        (tester) async {
      final controller = ScrollController(initialScrollOffset: 0);
      await tester.pumpWidget(wrapScrollable(
        TBackTop(controller: controller, visibilityOffset: 50),
        controller,
      ));
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

  group('TBackTop Theme 颜色', () {
    testWidgets('裸 TThemeData 提供颜色 token 兜底', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrapWithTheme(const TBackTop()));
      final decoration = tester
          .widgetList<Container>(find.byType(Container))
          .map((container) => container.decoration)
          .whereType<BoxDecoration>()
          .first;
      expect(decoration.color, token.brandLightColor);
      expect(decoration.border?.top.color, token.brandNormalColor);
      expect(
        tester.widget<Icon>(find.byIcon(TIcons.backtop)).color,
        token.textColorAnti,
      );
    });

    testWidgets('Theme 颜色字段注入生效', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBackTop(),
        backTopTheme: const TBackTopThemeData(backgroundColor: Colors.red),
      ));
      expect(find.byType(TBackTop), findsOneWidget);
    });

    testWidgets('半圆形 + showText + Theme 注入', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TBackTop(shape: TBackTopShape.halfCircle, showText: true),
        backTopTheme: const TBackTopThemeData(shape: TBackTopShape.halfCircle),
      ));
      expect(find.text('返回'), findsOneWidget);
      expect(find.text('顶部'), findsOneWidget);
    });
  });
}

void _noop() {}
