import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TNavBar Widget 测试
///
/// 覆盖：默认渲染、title/centerTitle、leading/actions、useDefaultBack/onBack、
/// ThemeData 注入、禁用 callback、TNavBarItem、TNavBarBorder。
void main() {
  Widget wrapWithTheme(Widget child, {TNavBarThemeData? navBarTheme}) {
    var theme = TThemeBuilder.light(TThemeData.defaultData());
    if (navBarTheme != null) {
      theme = theme.mergeExtension(navBarTheme);
    }
    return MaterialApp(
      theme: theme,
      home: Scaffold(body: child),
    );
  }

  group('TNavBar 基础渲染', () {
    testWidgets('默认渲染（标题居中、默认返回）', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '页面标题'),
      ));
      expect(find.byType(TNavBar), findsOneWidget);
      expect(find.text('页面标题'), findsOneWidget);
    });

    testWidgets('标题居中', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '居中标题', centerTitle: true),
      ));
      expect(find.text('居中标题'), findsOneWidget);
    });

    testWidgets('标题左对齐', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '左对齐', centerTitle: false),
      ));
      expect(find.text('左对齐'), findsOneWidget);
    });

    testWidgets('titleWidget 替代 title', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '忽略', titleWidget: Text('自定义')),
      ));
      expect(find.text('自定义'), findsOneWidget);
      expect(find.text('忽略'), findsNothing);
    });
  });

  group('TNavBar leading / actions', () {
    testWidgets('leading 操作项渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(TNavBar(
        title: '标题',
        useDefaultBack: false,
        leading: [TNavBarItem(icon: TIcons.close, iconSize: 24)],
      )));
      expect(find.byType(TNavBar), findsOneWidget);
      expect(find.byIcon(TIcons.close), findsOneWidget);
    });

    testWidgets('actions 操作项渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(TNavBar(
        title: '标题',
        useDefaultBack: false,
        actions: [
          TNavBarItem(icon: TIcons.home, iconSize: 24),
          TNavBarItem(icon: TIcons.ellipsis, iconSize: 24),
        ],
      )));
      expect(find.byIcon(TIcons.home), findsOneWidget);
      expect(find.byIcon(TIcons.ellipsis), findsOneWidget);
    });

    testWidgets('useDefaultBack 为 true 时显示返回图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '标题', useDefaultBack: true),
      ));
      expect(find.byIcon(TIcons.chevron_left), findsOneWidget);
    });

    testWidgets('默认返回图标在完整主题下保持主文本色且不呈禁用态', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '标题', useDefaultBack: true),
      ));

      final backIcon = tester.widget<Icon>(find.byIcon(TIcons.chevron_left));
      expect(backIcon.size, 28.0);
      expect(backIcon.color, token.textColorPrimary);
      expect(backIcon.color, isNot(token.textDisabledColor));
    });

    testWidgets('useDefaultBack 为 false 时不显示返回图标', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '标题', useDefaultBack: false),
      ));
      expect(find.byIcon(TIcons.chevron_left), findsNothing);
    });
  });

  group('TNavBar onBack', () {
    testWidgets('onBack 回调被触发', (tester) async {
      var called = false;
      await tester.pumpWidget(wrapWithTheme(
        TNavBar(
          title: '标题',
          useDefaultBack: true,
          onBack: () => called = true,
        ),
      ));
      // 点击返回按钮
      final backFinder = find.byIcon(TIcons.chevron_left);
      await tester.tap(backFinder);
      expect(called, true);
    });

    testWidgets('onBack: null 时默认返回上一级', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        routes: {
          '/': (_) => Builder(
                builder: (context) => TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/detail'),
                  child: const Text('open'),
                ),
              ),
          '/detail': (_) => const Scaffold(
                appBar: TNavBar(
                  title: '标题',
                  useDefaultBack: true,
                  useSafeArea: true,
                  onBack: null,
                ),
              ),
        },
      ));

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('标题'), findsOneWidget);

      final backFinder = find.byIcon(TIcons.chevron_left);
      await tester.tap(backFinder);
      await tester.pumpAndSettle();

      expect(find.text('open'), findsOneWidget);
      expect(find.byType(TNavBar), findsNothing);
    });
  });

  group('TNavBar L4 样式', () {
    testWidgets('自定义 height', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '标题', height: 56),
      ));
      expect(find.byType(TNavBar), findsOneWidget);
    });

    testWidgets('自定义 backgroundColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '标题', backgroundColor: Colors.blue),
      ));
      expect(find.byType(TNavBar), findsOneWidget);
    });

    testWidgets('自定义 titleColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '彩色标题', titleColor: Colors.red),
      ));
      expect(find.text('彩色标题'), findsOneWidget);
    });

    testWidgets('构造器 backIconColor 覆盖默认返回图标颜色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(
          title: '标题',
          backIconColor: Colors.red,
        ),
      ));

      final backIcon = tester.widget<Icon>(find.byIcon(TIcons.chevron_left));
      expect(backIcon.color, Colors.red);
    });

    testWidgets('Theme backIconColor 覆盖默认返回图标颜色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '标题'),
        navBarTheme: const TNavBarThemeData(backIconColor: Colors.green),
      ));

      final backIcon = tester.widget<Icon>(find.byIcon(TIcons.chevron_left));
      expect(backIcon.color, Colors.green);
    });

    testWidgets('border 边框模式', (tester) async {
      await tester.pumpWidget(wrapWithTheme(TNavBar(
        title: '边框',
        useDefaultBack: false,
        useBorderStyle: true,
        leading: [TNavBarItem(icon: TIcons.close, iconSize: 24)],
        actions: [
          TNavBarItem(icon: TIcons.home, iconSize: 24),
          TNavBarItem(icon: TIcons.ellipsis, iconSize: 24),
        ],
      )));
      expect(find.byType(TNavBar), findsOneWidget);
    });
  });

  group('TNavBarThemeData', () {
    test('默认构造全 null', () {
      const theme = TNavBarThemeData();
      expect(theme.titleColor, null);
      expect(theme.backgroundColor, null);
      expect(theme.opacity, null);
    });

    test('copyWith 部分覆盖', () {
      const theme = TNavBarThemeData(opacity: 1.0);
      final copied = theme.copyWith(opacity: 0.5);
      expect(copied.opacity, 0.5);
    });

    test('lerp', () {
      const a = TNavBarThemeData(opacity: 1.0);
      const b = TNavBarThemeData(opacity: 0.5);
      final result = a.lerp(b, 0.5);
      expect(result.opacity, 0.75);
    });

    test('lerp 非同类返回自身', () {
      const a = TNavBarThemeData(opacity: 1.0);
      final result = a.lerp(null, 0.5);
      expect(result.opacity, 1.0);
    });

    testWidgets('Theme 不承载 height，构造器 height 同步 preferredSize 与实际高度',
        (tester) async {
      const navBar = TNavBar(title: '标题', height: 64);
      await tester.pumpWidget(wrapWithTheme(navBar));
      expect(navBar.preferredSize.height, 64);
      expect(tester.getSize(find.byType(TNavBar)).height, 64);
    });
  });

  group('TNavBar 安全区', () {
    Widget safeAreaHost({
      required Widget child,
      EdgeInsets padding = const EdgeInsets.only(top: 24),
    }) {
      return MediaQuery(
        data: MediaQueryData(
          size: const Size(375, 812),
          padding: padding,
        ),
        child: MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: Scaffold(body: child),
        ),
      );
    }

    testWidgets('standalone 默认不加入顶部安全区', (tester) async {
      const navBar = TNavBar(title: '安全区');
      await tester.pumpWidget(safeAreaHost(child: navBar));

      expect(navBar.preferredSize.height, 48);
      expect(tester.getSize(find.byType(TNavBar)).height, 48);
      expect(tester.getTopLeft(find.text('安全区')).dy, lessThan(24));
    });

    testWidgets('useSafeArea=true 将顶部安全区加入实际高度', (tester) async {
      const navBar = TNavBar(title: '开启安全区', useSafeArea: true);
      await tester.pumpWidget(safeAreaHost(child: navBar));

      expect(navBar.preferredSize.height, 48);
      expect(tester.getSize(find.byType(TNavBar)).height, 72);
      expect(tester.getTopLeft(find.text('开启安全区')).dy, greaterThan(24));
    });

    testWidgets('自定义 height 不包含顶部安全区', (tester) async {
      const navBar = TNavBar(title: '自定义高度', height: 64, useSafeArea: true);
      await tester.pumpWidget(safeAreaHost(child: navBar));

      expect(navBar.preferredSize.height, 64);
      expect(tester.getSize(find.byType(TNavBar)).height, 88);
    });

    testWidgets('Scaffold.appBar 只计算一次顶部安全区', (tester) async {
      const navBar = TNavBar(title: 'AppBar 安全区', useSafeArea: true);
      final bodyKey = GlobalKey();
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(375, 812),
            padding: EdgeInsets.only(top: 24),
          ),
          child: MaterialApp(
            theme: TThemeBuilder.light(TThemeData.defaultData()),
            home: Scaffold(
              appBar: navBar,
              body: SizedBox(key: bodyKey),
            ),
          ),
        ),
      );

      expect(navBar.preferredSize.height, 48);
      expect(tester.getSize(find.byType(TNavBar)).height, 72);
      expect(tester.getTopLeft(find.byKey(bodyKey)).dy, 72);
    });
  });

  group('TNavBarItem', () {
    test('默认 iconSize 为 24', () {
      final item = TNavBarItem(icon: TIcons.home);
      expect(item.iconSize, 24.0);
      expect(item.icon, TIcons.home);
    });

    test('onTap: null 禁用', () {
      final item = TNavBarItem(icon: TIcons.home, onTap: null);
      expect(item.onTap, null);
    });

    testWidgets('item 点击触发 onTap', (tester) async {
      var called = false;
      await tester.pumpWidget(wrapWithTheme(TNavBar(
        title: '标题',
        useDefaultBack: false,
        actions: [
          TNavBarItem(
              icon: TIcons.home, iconSize: 24, onTap: () => called = true),
        ],
      )));
      await tester.tap(find.byIcon(TIcons.home));
      expect(called, true);
    });

    testWidgets('onTap: null 的操作项在完整主题下使用禁用色', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(wrapWithTheme(TNavBar(
        title: '标题',
        useDefaultBack: false,
        actions: [
          TNavBarItem(icon: TIcons.home, iconSize: 24),
        ],
      )));

      final icon = tester.widget<Icon>(find.byIcon(TIcons.home));
      expect(icon.size, 24.0);
      expect(icon.color, token.textDisabledColor);
    });
  });

  group('TNavBarBorder', () {
    test('默认值', () {
      const border = TNavBarBorder();
      expect(border.width, 1.0);
      expect(border.radius, 22.0);
      expect(border.color, null);
      expect(border.padding, null);
    });

    test('自定义值', () {
      const border = TNavBarBorder(
        width: 2.0,
        radius: 16.0,
        color: Colors.red,
      );
      expect(border.width, 2.0);
      expect(border.radius, 16.0);
      expect(border.color, Colors.red);
    });
  });

  // ============================================================
  // 覆盖率补充
  // ============================================================
  group('TNavBar 覆盖率补充', () {
    test('preferredSize 自定义 height', () {
      // 覆盖 111-112（preferredSize getter）
      const navBar = TNavBar(title: 'test', height: 60);
      expect(navBar.preferredSize.height, 60);
    });

    testWidgets('belowTitleWidget 渲染', (tester) async {
      // 覆盖 284-286（belowTitleWidget 非空 → Column 渲染）
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(
          title: 'below',
          belowTitleWidget: Text('下方内容'),
        ),
      ));
      expect(find.text('下方内容'), findsOneWidget);
    });

    testWidgets('flexibleSpace 渲染', (tester) async {
      // 覆盖 312-315（flexibleSpace 非空 → Stack 渲染）
      await tester.pumpWidget(wrapWithTheme(
        TNavBar(
          title: 'flex',
          flexibleSpace: Container(color: Colors.blue),
        ),
      ));
      expect(find.byType(TNavBar), findsOneWidget);
    });
  });
}
