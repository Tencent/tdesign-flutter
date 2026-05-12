import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TTabBarView 自适应高度相关 Widget 测试
///
/// 覆盖 [issue #519](https://github.com/Tencent/tdesign-flutter/issues/519)
/// 的修复点：
/// 1. 默认 `autoHeight = false` 时，行为保持与原生 TabBarView 一致，
///    仍需外部给高度约束（向后兼容）；
/// 2. `autoHeight = true` 时，外部无需包 SizedBox 即可根据子内容高度
///    自动撑开；
/// 3. 切换 tab 后外层高度会过渡到目标子 widget 的高度；
/// 4. 子 widget 列表数量变更后高度缓存正确重建。
void main() {
  /// 构建一个带 TabController 的测试宿主
  ///
  /// [tabLabels] 必须与 children 的数量相等。用不同的 tabLabel 和子内容
  /// text，避免 finder 命中冲突。
  Widget buildHost({
    required TabController controller,
    required Widget tabBarView,
    required List<String> tabLabels,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            // 用原生 TabBar 驱动 controller，不依赖 TTabBar 的样式实现，
            // 让测试只聚焦在 TTabBarView 自身的行为上。
            TabBar(
              controller: controller,
              tabs: [
                for (final label in tabLabels) Tab(text: label),
              ],
            ),
            tabBarView,
          ],
        ),
      ),
    );
  }

  group('TTabBarView default mode (issue #519 backward compatibility)', () {
    testWidgets('autoHeight 默认为 false，行为等价于原生 TabBarView',
        (WidgetTester tester) async {
      final controller =
          TabController(length: 3, vsync: const TestVSync());
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildHost(
          controller: controller,
          tabLabels: const ['Tab1', 'Tab2', 'Tab3'],
          tabBarView: SizedBox(
            height: 120,
            child: TTabBarView(
              controller: controller,
              children: const [
                SizedBox(height: 100, child: Text('Content-Alpha')),
                SizedBox(height: 100, child: Text('Content-Beta')),
                SizedBox(height: 100, child: Text('Content-Gamma')),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 外部包了 SizedBox(height: 120)，内容应正常显示
      expect(find.text('Content-Alpha'), findsOneWidget);
    });
  });

  group('TTabBarView autoHeight mode (issue #519)', () {
    testWidgets('autoHeight: true 时不包外层 SizedBox 仍能正常渲染子内容',
        (WidgetTester tester) async {
      final controller =
          TabController(length: 3, vsync: const TestVSync());
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildHost(
          controller: controller,
          tabLabels: const ['Tab1', 'Tab2', 'Tab3'],
          // 关键：不再包 SizedBox / 不指定 height
          tabBarView: TTabBarView(
            autoHeight: true,
            controller: controller,
            animationDuration: const Duration(milliseconds: 50),
            children: const [
              SizedBox(height: 100, child: Text('Content-Alpha')),
              SizedBox(height: 200, child: Text('Content-Beta')),
              SizedBox(height: 150, child: Text('Content-Gamma')),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 当前激活 tab 的子内容可见
      expect(find.text('Content-Alpha'), findsOneWidget);
    });

    testWidgets('autoHeight: true 时外层容器的高度会跟随子内容',
        (WidgetTester tester) async {
      final controller =
          TabController(length: 3, vsync: const TestVSync());
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        buildHost(
          controller: controller,
          tabLabels: const ['Tab1', 'Tab2', 'Tab3'],
          tabBarView: TTabBarView(
            autoHeight: true,
            controller: controller,
            animationDuration: const Duration(milliseconds: 50),
            children: const [
              SizedBox(height: 100, child: Text('Content-Alpha')),
              SizedBox(height: 200, child: Text('Content-Beta')),
              SizedBox(height: 150, child: Text('Content-Gamma')),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 初始激活第 0 页（高度 100）
      final tabBarViewFinder = find.byType(TTabBarView);
      expect(tabBarViewFinder, findsOneWidget);

      final initialHeight = tester.getSize(tabBarViewFinder).height;
      expect(initialHeight, greaterThan(0),
          reason: 'autoHeight 模式下 TTabBarView 的实际高度必须 > 0');
      // 允许一定误差（浮点抖动），但应与 100 接近
      expect(initialHeight, closeTo(100, 4),
          reason: '首次渲染时外层高度应与第 0 个子 widget 高度一致');

      // 切到第 1 页（高度 200）
      controller.animateTo(1);
      await tester.pumpAndSettle();

      final secondHeight = tester.getSize(tabBarViewFinder).height;
      expect(secondHeight, closeTo(200, 4),
          reason: '切换到第 1 页后外层高度应过渡到子 widget 高度 200');
    });

    testWidgets('autoHeight: true 时 children 数量变更后可正常重建',
        (WidgetTester tester) async {
      final controller1 =
          TabController(length: 3, vsync: const TestVSync());
      addTearDown(controller1.dispose);

      await tester.pumpWidget(
        buildHost(
          controller: controller1,
          tabLabels: const ['Tab1', 'Tab2', 'Tab3'],
          tabBarView: TTabBarView(
            autoHeight: true,
            controller: controller1,
            animationDuration: const Duration(milliseconds: 50),
            children: const [
              SizedBox(height: 100, child: Text('Content-Alpha')),
              SizedBox(height: 200, child: Text('Content-Beta')),
              SizedBox(height: 150, child: Text('Content-Gamma')),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 换到新的 controller + 新的 2 个子
      final controller2 =
          TabController(length: 2, vsync: const TestVSync());
      addTearDown(controller2.dispose);

      await tester.pumpWidget(
        buildHost(
          controller: controller2,
          tabLabels: const ['TabX', 'TabY'],
          tabBarView: TTabBarView(
            autoHeight: true,
            controller: controller2,
            animationDuration: const Duration(milliseconds: 50),
            children: const [
              SizedBox(height: 80, child: Text('Content-X')),
              SizedBox(height: 160, child: Text('Content-Y')),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 新的第 0 页可见
      expect(find.text('Content-X'), findsOneWidget);
      // 外层高度跟随新子内容
      final height = tester.getSize(find.byType(TTabBarView)).height;
      expect(height, closeTo(80, 4),
          reason: 'children 数量变更并重建后外层高度应按新子 widget 计算');
    });
  });
}
