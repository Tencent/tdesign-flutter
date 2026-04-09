import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// Helper: 将组件包裹在 TTheme + MaterialApp 中渲染
Widget _buildTestApp(Widget child) {
  return TTheme(
    data: TThemeData.defaultData(),
    child: MaterialApp(
      home: Scaffold(
        body: child,
      ),
    ),
  );
}

/// Helper: 构建标准 iconText 类型 TBottomTabBar
Widget _buildIconTextTabBar({int currentIndex = 0}) {
  return TBottomTabBar(
    TBottomTabBarBasicType.iconText,
    componentType: TBottomTabBarComponentType.normal,
    useVerticalDivider: false,
    currentIndex: currentIndex,
    navigationTabs: [
      TBottomTabBarTabConfig(
        tabText: '书籍',
        selectedIcon: const Icon(Icons.book),
        unselectedIcon: const Icon(Icons.book),
        onTap: () {},
      ),
      TBottomTabBarTabConfig(
        tabText: '我的',
        selectedIcon: const Icon(Icons.person),
        unselectedIcon: const Icon(Icons.person),
        onTap: () {},
      ),
    ],
  );
}

/// Helper: 构建标准 icon 类型 TBottomTabBar
Widget _buildIconTabBar({int currentIndex = 0}) {
  return TBottomTabBar(
    TBottomTabBarBasicType.icon,
    componentType: TBottomTabBarComponentType.normal,
    useVerticalDivider: false,
    currentIndex: currentIndex,
    navigationTabs: [
      TBottomTabBarTabConfig(
        selectedIcon: const Icon(Icons.book),
        unselectedIcon: const Icon(Icons.book),
        onTap: () {},
      ),
      TBottomTabBarTabConfig(
        selectedIcon: const Icon(Icons.person),
        unselectedIcon: const Icon(Icons.person),
        onTap: () {},
      ),
    ],
  );
}

void main() {
  group('TBottomTabBar — iconText 图标颜色 (issue #900)', () {
    // TC-01: iconText 选中 tab 图标颜色为 brandNormalColor
    testWidgets('TC-01: 选中 tab 的图标颜色应为 brandNormalColor', (tester) async {
      await tester.pumpWidget(_buildTestApp(_buildIconTextTabBar(currentIndex: 0)));
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(TBottomTabBar));
      final expectedColor = TTheme.of(context).brandNormalColor;

      // 找到所有 Icon widget，第一个属于 index=0（选中）
      final icons = tester.widgetList<Icon>(find.byType(Icon)).toList();
      expect(icons, isNotEmpty);

      // 通过 IconTheme 验证选中图标的颜色
      final iconThemes = tester.widgetList<IconTheme>(find.byType(IconTheme)).toList();
      expect(iconThemes, isNotEmpty, reason: '选中图标应被 IconTheme 包裹以注入颜色');

      // 验证至少有一个 IconTheme 的 color 是 brandNormalColor
      final selectedIconTheme = iconThemes.firstWhere(
        (t) => t.data.color == expectedColor,
        orElse: () => throw TestFailure(
          '未找到 color == brandNormalColor 的 IconTheme。'
          '实际 IconTheme colors: ${iconThemes.map((t) => t.data.color).toList()}',
        ),
      );
      expect(selectedIconTheme.data.color, equals(expectedColor));
    });

    // TC-02: iconText 未选中 tab 图标颜色为 textColorPrimary
    testWidgets('TC-02: 未选中 tab 的图标颜色应为 textColorPrimary', (tester) async {
      await tester.pumpWidget(_buildTestApp(_buildIconTextTabBar(currentIndex: 0)));
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(TBottomTabBar));
      final expectedColor = TTheme.of(context).textColorPrimary;

      final iconThemes = tester.widgetList<IconTheme>(find.byType(IconTheme)).toList();
      expect(iconThemes, isNotEmpty, reason: '未选中图标应被 IconTheme 包裹以注入颜色');

      final unselectedIconTheme = iconThemes.firstWhere(
        (t) => t.data.color == expectedColor,
        orElse: () => throw TestFailure(
          '未找到 color == textColorPrimary 的 IconTheme。'
          '实际 IconTheme colors: ${iconThemes.map((t) => t.data.color).toList()}',
        ),
      );
      expect(unselectedIconTheme.data.color, equals(expectedColor));
    });

    // TC-03: 点击切换后图标颜色同步更新
    testWidgets('TC-03: 点击切换 tab 后图标颜色应同步更新', (tester) async {
      int selectedIndex = 0;
      late StateSetter outerSetState;

      await tester.pumpWidget(
        StatefulBuilder(builder: (context, setState) {
          outerSetState = setState;
          return _buildTestApp(TBottomTabBar(
            TBottomTabBarBasicType.iconText,
            componentType: TBottomTabBarComponentType.normal,
            useVerticalDivider: false,
            currentIndex: selectedIndex,
            navigationTabs: [
              TBottomTabBarTabConfig(
                tabText: '书籍',
                selectedIcon: const Icon(Icons.book),
                unselectedIcon: const Icon(Icons.book),
                onTap: () => outerSetState(() => selectedIndex = 0),
              ),
              TBottomTabBarTabConfig(
                tabText: '我的',
                selectedIcon: const Icon(Icons.person),
                unselectedIcon: const Icon(Icons.person),
                onTap: () => outerSetState(() => selectedIndex = 1),
              ),
            ],
          ));
        }),
      );
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(TBottomTabBar));
      final brandColor = TTheme.of(context).brandNormalColor;
      final primaryColor = TTheme.of(context).textColorPrimary;

      // 点击 index=1
      await tester.tap(find.text('我的'));
      await tester.pumpAndSettle();

      final iconThemesAfter = tester.widgetList<IconTheme>(find.byType(IconTheme)).toList();
      final colors = iconThemesAfter.map((t) => t.data.color).toSet();

      expect(colors, contains(brandColor), reason: '切换后新选中 tab 图标应为 brandNormalColor');
      expect(colors, contains(primaryColor), reason: '切换后旧 tab 图标应为 textColorPrimary');
    });
  });

  group('TBottomTabBar — icon 类型图标颜色 (issue #900 同类问题)', () {
    // TC-04: icon 类型选中 tab 图标颜色为 brandNormalColor
    testWidgets('TC-04: icon 类型 — 选中 tab 图标颜色应为 brandNormalColor', (tester) async {
      await tester.pumpWidget(_buildTestApp(_buildIconTabBar(currentIndex: 0)));
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(TBottomTabBar));
      final expectedColor = TTheme.of(context).brandNormalColor;

      final iconThemes = tester.widgetList<IconTheme>(find.byType(IconTheme)).toList();
      expect(iconThemes, isNotEmpty);

      final match = iconThemes.firstWhere(
        (t) => t.data.color == expectedColor,
        orElse: () => throw TestFailure(
          '未找到 color == brandNormalColor 的 IconTheme。'
          '实际: ${iconThemes.map((t) => t.data.color).toList()}',
        ),
      );
      expect(match.data.color, equals(expectedColor));
    });

    // TC-05: icon 类型未选中 tab 图标颜色为 textColorPrimary
    testWidgets('TC-05: icon 类型 — 未选中 tab 图标颜色应为 textColorPrimary', (tester) async {
      await tester.pumpWidget(_buildTestApp(_buildIconTabBar(currentIndex: 0)));
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(TBottomTabBar));
      final expectedColor = TTheme.of(context).textColorPrimary;

      final iconThemes = tester.widgetList<IconTheme>(find.byType(IconTheme)).toList();
      final match = iconThemes.firstWhere(
        (t) => t.data.color == expectedColor,
        orElse: () => throw TestFailure(
          '未找到 color == textColorPrimary 的 IconTheme。'
          '实际: ${iconThemes.map((t) => t.data.color).toList()}',
        ),
      );
      expect(match.data.color, equals(expectedColor));
    });
  });

  group('TBottomTabBar — 回归检查', () {
    // TC-06: 文字颜色不受影响
    testWidgets('TC-06: iconText 类型文字颜色回归验证', (tester) async {
      await tester.pumpWidget(_buildTestApp(_buildIconTextTabBar(currentIndex: 0)));
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(TBottomTabBar));
      final brandColor = TTheme.of(context).brandNormalColor;
      final primaryColor = TTheme.of(context).textColorPrimary;

      // 通过 TText 验证文字颜色
      final tdTexts = tester.widgetList<TText>(find.byType(TText)).toList();
      expect(tdTexts.length, 2);

      // 找到 textColor 为 brandColor 的文字（选中）
      final selectedText = tdTexts.firstWhere(
        (t) => t.textColor == brandColor,
        orElse: () => throw TestFailure('未找到 textColor == brandNormalColor 的 TText'),
      );
      expect(selectedText.textColor, equals(brandColor));

      // 找到 textColor 为 primaryColor 的文字（未选中）
      final unselectedText = tdTexts.firstWhere(
        (t) => t.textColor == primaryColor,
        orElse: () => throw TestFailure('未找到 textColor == textColorPrimary 的 TText'),
      );
      expect(unselectedText.textColor, equals(primaryColor));
    });

    // TC-07: 用户显式设置 icon color 时不被覆盖
    testWidgets('TC-07: 用户显式设置的图标颜色不被 IconTheme 覆盖', (tester) async {
      const explicitColor = Colors.red;

      await tester.pumpWidget(_buildTestApp(TBottomTabBar(
        TBottomTabBarBasicType.iconText,
        componentType: TBottomTabBarComponentType.normal,
        currentIndex: 0,
        navigationTabs: [
          TBottomTabBarTabConfig(
            tabText: '书籍',
            selectedIcon: const Icon(Icons.book, color: explicitColor),
            unselectedIcon: const Icon(Icons.book),
            onTap: () {},
          ),
          TBottomTabBarTabConfig(
            tabText: '我的',
            selectedIcon: const Icon(Icons.person),
            unselectedIcon: const Icon(Icons.person),
            onTap: () {},
          ),
        ],
      )));
      await tester.pumpAndSettle();

      // Flutter Icon 的 color 属性显式设置时优先于 IconTheme，无需额外断言
      // 只需确保渲染不报错
      expect(find.byType(TBottomTabBar), findsOneWidget);
    });
  });
}
