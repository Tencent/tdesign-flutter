import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TNavBar Widget 测试
///
/// 覆盖：默认渲染、title/centerTitle、leading/actions、useDefaultBack/onBack、
/// ThemeData 注入、禁用 callback、TNavBarItem、TNavBarBorder。
void main() {
  TextStyle effectiveTextStyle(WidgetTester tester, String text) {
    final finder = find.text(text);
    final textWidget = tester.widget<Text>(finder);
    return DefaultTextStyle.of(
      tester.element(finder),
    ).style.merge(textWidget.style);
  }

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
    testWidgets('默认渲染（标题居中、默认无返回）', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TNavBar(title: Text('页面标题'))),
      );
      expect(find.byType(TNavBar), findsOneWidget);
      expect(find.text('页面标题'), findsOneWidget);
      expect(find.byIcon(TIcons.chevron_left), findsNothing);
    });

    testWidgets('标题居中', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TNavBar(title: Text('居中标题'), centerTitle: true)),
      );
      expect(find.text('居中标题'), findsOneWidget);
    });

    testWidgets('标题左对齐', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TNavBar(title: Text('左对齐'), centerTitle: false)),
      );
      expect(find.text('左对齐'), findsOneWidget);
    });

    testWidgets('title 支持自定义 Widget', (tester) async {
      await tester.pumpWidget(wrapWithTheme(const TNavBar(title: Text('自定义'))));
      expect(find.text('自定义'), findsOneWidget);
      expect(find.text('忽略'), findsNothing);
    });
  });

  group('TNavBar leading / actions', () {
    testWidgets('leading 操作项渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TNavBar(
            title: Text('标题'),
            useDefaultBack: false,
            leading: [TNavBarItem(icon: TIcons.close, iconSize: 24)],
          ),
        ),
      );
      expect(find.byType(TNavBar), findsOneWidget);
      expect(find.byIcon(TIcons.close), findsOneWidget);
    });

    testWidgets('actions 操作项渲染', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TNavBar(
            title: Text('标题'),
            useDefaultBack: false,
            actions: [
              TNavBarItem(icon: TIcons.home, iconSize: 24),
              TNavBarItem(icon: TIcons.ellipsis, iconSize: 24),
            ],
          ),
        ),
      );
      expect(find.byIcon(TIcons.home), findsOneWidget);
      expect(find.byIcon(TIcons.ellipsis), findsOneWidget);
    });

    testWidgets('useDefaultBack 为 true 时显示返回图标', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TNavBar(title: Text('标题'), useDefaultBack: true)),
      );
      expect(find.byIcon(TIcons.chevron_left), findsOneWidget);
    });

    testWidgets('默认返回图标在完整主题下保持主文本色且不呈禁用态', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrapWithTheme(const TNavBar(title: Text('标题'), useDefaultBack: true)),
      );

      final backIcon = tester.widget<Icon>(find.byIcon(TIcons.chevron_left));
      expect(backIcon.size, 24.0);
      expect(backIcon.color, token.textColorPrimary);
      expect(backIcon.color, isNot(token.textDisabledColor));
    });

    testWidgets('useDefaultBack 为 false 时不显示返回图标', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(const TNavBar(title: Text('标题'), useDefaultBack: false)),
      );
      expect(find.byIcon(TIcons.chevron_left), findsNothing);
    });
  });

  group('TNavBar onBack', () {
    testWidgets('onBack 回调被触发', (tester) async {
      var called = false;
      await tester.pumpWidget(
        wrapWithTheme(
          TNavBar(
            title: const Text('标题'),
            useDefaultBack: true,
            onBack: () => called = true,
          ),
        ),
      );
      // 点击返回按钮
      final backFinder = find.byIcon(TIcons.chevron_left);
      await tester.tap(backFinder);
      expect(called, true);
    });

    testWidgets('提供 onBack 时拦截默认 maybePop', (tester) async {
      var called = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          routes: {
            '/': (_) => Builder(
              builder: (context) => TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/detail'),
                child: const Text('open'),
              ),
            ),
            '/detail': (_) => Scaffold(
              appBar: TNavBar(
                title: const Text('标题'),
                useDefaultBack: true,
                onBack: () => called = true,
              ),
            ),
          },
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(TIcons.chevron_left));
      await tester.pumpAndSettle();

      expect(called, true);
      expect(find.text('标题'), findsOneWidget);
      expect(find.text('open'), findsNothing);
    });

    testWidgets('onBack: null 时默认返回上一级', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
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
                title: Text('标题'),
                useDefaultBack: true,
                useSafeArea: true,
                onBack: null,
              ),
            ),
          },
        ),
      );

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
      await tester.pumpWidget(
        wrapWithTheme(const TNavBar(title: Text('标题'), height: 56)),
      );
      expect(find.byType(TNavBar), findsOneWidget);
    });

    testWidgets('自定义 backgroundColor', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TNavBar(title: Text('标题'), backgroundColor: Colors.blue),
        ),
      );
      expect(find.byType(TNavBar), findsOneWidget);
    });

    testWidgets('自定义 titleColor', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TNavBar(title: Text('彩色标题'), titleColor: Colors.red),
        ),
      );
      expect(find.text('彩色标题'), findsOneWidget);
    });

    testWidgets('构造器 backIconColor 覆盖默认返回图标颜色', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TNavBar(
            title: Text('标题'),
            backIconColor: Colors.red,
            useDefaultBack: true,
          ),
        ),
      );

      final backIcon = tester.widget<Icon>(find.byIcon(TIcons.chevron_left));
      expect(backIcon.color, Colors.red);
    });

    testWidgets('Theme backIconColor 覆盖默认返回图标颜色', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TNavBar(title: Text('标题'), useDefaultBack: true),
          navBarTheme: const TNavBarThemeData(backIconColor: Colors.green),
        ),
      );

      final backIcon = tester.widget<Icon>(find.byIcon(TIcons.chevron_left));
      expect(backIcon.color, Colors.green);
    });

    testWidgets('border 边框模式', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TNavBar(
            title: Text('边框'),
            useDefaultBack: false,
            useBorderStyle: true,
            leading: [TNavBarItem(icon: TIcons.close, iconSize: 24)],
            actions: [
              TNavBarItem(icon: TIcons.home, iconSize: 24),
              TNavBarItem(icon: TIcons.ellipsis, iconSize: 24),
            ],
          ),
        ),
      );
      expect(find.byType(TNavBar), findsOneWidget);
    });

    testWidgets('默认标题使用 Title Large 语义 Token', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrapWithTheme(const TNavBar(title: Text('Title Large'))),
      );

      final style = effectiveTextStyle(tester, 'Title Large');
      expect(style.fontSize, token.fontTitleLarge?.size);
      expect(style.height, token.fontTitleLarge?.height);
      expect(style.fontWeight, token.fontTitleLarge?.fontWeight);
    });

    testWidgets('标题 Widget 自身样式覆盖默认标题样式', (tester) async {
      final token = TThemeData.defaultData();
      Widget wrapWithMaterial(Widget child) {
        final base = TThemeBuilder.light(token);
        return MaterialApp(
          theme: base.copyWith(
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                fontSize: 40,
                height: 1.2,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          home: Scaffold(body: child),
        );
      }

      await tester.pumpWidget(
        wrapWithMaterial(
          const TNavBar(
            title: Text(
              'Explicit wins',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );

      final style = effectiveTextStyle(tester, 'Explicit wins');
      expect(style.fontSize, 16);
      expect(style.height, 1.5);
      expect(style.fontWeight, FontWeight.w400);
    });

    testWidgets('Material AppBarTheme fontSize 优先于默认 Token', (
      tester,
    ) async {
      final token = TThemeData.defaultData();
      Widget wrapWithMaterial(Widget child) {
        final base = TThemeBuilder.light(token);
        return MaterialApp(
          theme: base.copyWith(
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(fontSize: 40),
            ),
          ),
          home: Scaffold(body: child),
        );
      }

      await tester.pumpWidget(
        wrapWithMaterial(const TNavBar(title: Text('Material wins'))),
      );

      final style = effectiveTextStyle(tester, 'Material wins');
      // 默认回退 Title Large Token，但 Material fontSize 应插在 Token 之前。
      expect(style.fontSize, 40);
    });

    testWidgets('Material AppBarTheme fontFamily 在未显式配置时生效', (tester) async {
      final token = TThemeData.defaultData();
      final base = TThemeBuilder.light(token);
      await tester.pumpWidget(
        MaterialApp(
          theme: base.copyWith(
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                fontFamily: 'MaterialFamily',
                package: 'material_fonts',
              ),
            ),
          ),
          home: const Scaffold(body: TNavBar(title: Text('Material family'))),
        ),
      );

      final style = effectiveTextStyle(tester, 'Material family');
      expect(style.fontFamily, 'packages/material_fonts/MaterialFamily');
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

    test('copyWith 可显式清除 nullable 字段', () {
      const theme = TNavBarThemeData(
        titleColor: Colors.red,
        opacity: 1.0,
        border: TNavBarBorder(color: Colors.blue),
        boxShadow: [BoxShadow(color: Colors.black)],
      );

      final copied = theme.copyWith(
        titleColor: null,
        opacity: null,
        border: null,
        boxShadow: null,
      );

      expect(copied.titleColor, isNull);
      expect(copied.opacity, isNull);
      expect(copied.border, isNull);
      expect(copied.boxShadow, isNull);
    });

    test('lerp', () {
      const a = TNavBarThemeData(titleColor: Colors.black, opacity: 1.0);
      const b = TNavBarThemeData(titleColor: Colors.white, opacity: 0.5);
      final result = a.lerp(b, 0.5);
      expect(result.opacity, 0.75);
      expect(result.titleColor, Color.lerp(Colors.black, Colors.white, 0.5));
    });

    test('lerp 保留 nullable 字段的默认回退语义', () {
      const defaults = TNavBarThemeData();
      const explicit = TNavBarThemeData(
        titleColor: Colors.red,
        backgroundColor: Colors.blue,
        titleMargin: 24,
        opacity: 0.5,
      );

      final beforeMidpoint = defaults.lerp(explicit, 0.25);
      expect(beforeMidpoint.titleColor, isNull);
      expect(beforeMidpoint.backgroundColor, isNull);
      expect(beforeMidpoint.titleMargin, isNull);
      expect(beforeMidpoint.opacity, isNull);

      final afterMidpoint = defaults.lerp(explicit, 0.75);
      expect(afterMidpoint.titleColor, Colors.red);
      expect(afterMidpoint.backgroundColor, Colors.blue);
      expect(afterMidpoint.titleMargin, 24);
      expect(afterMidpoint.opacity, 0.5);

      final reverseBeforeMidpoint = explicit.lerp(defaults, 0.25);
      expect(reverseBeforeMidpoint.titleColor, Colors.red);
      expect(reverseBeforeMidpoint.titleMargin, 24);
      final reverseAfterMidpoint = explicit.lerp(defaults, 0.75);
      expect(reverseAfterMidpoint.titleColor, isNull);
      expect(reverseAfterMidpoint.titleMargin, isNull);

      final bothDefault = defaults.lerp(const TNavBarThemeData(), 0.5);
      expect(bothDefault.titleColor, isNull);
      expect(bothDefault.backgroundColor, isNull);
      expect(bothDefault.titleMargin, isNull);
      expect(bothDefault.opacity, isNull);
    });

    testWidgets('AnimatedTheme 切换不会把 null 回退插值成透明色', (tester) async {
      final token = TThemeData.defaultData();
      final baseTheme = TThemeBuilder.light(token);
      var useExplicitTheme = false;
      late StateSetter updateTheme;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              updateTheme = setState;
              final navBarTheme = useExplicitTheme
                  ? const TNavBarThemeData(titleColor: Colors.red)
                  : const TNavBarThemeData();
              return AnimatedTheme(
                data: baseTheme.mergeExtension(navBarTheme),
                duration: const Duration(seconds: 1),
                child: const Scaffold(
                  body: TNavBar(title: Text('Animated title')),
                ),
              );
            },
          ),
        ),
      );

      updateTheme(() => useExplicitTheme = true);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      var style = effectiveTextStyle(tester, 'Animated title');
      expect(style.color, token.textColorPrimary);

      await tester.pump(const Duration(milliseconds: 500));
      style = effectiveTextStyle(tester, 'Animated title');
      expect(style.color, Colors.red);
    });

    test('lerp 非同类返回自身', () {
      const a = TNavBarThemeData(opacity: 1.0);
      final result = a.lerp(null, 0.5);
      expect(result.opacity, 1.0);
    });

    testWidgets('Theme 不承载 height，构造器 height 同步 preferredSize 与实际高度', (
      tester,
    ) async {
      const navBar = TNavBar(title: Text('标题'), height: 64);
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
        data: MediaQueryData(size: const Size(375, 812), padding: padding),
        child: MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: Scaffold(body: child),
        ),
      );
    }

    testWidgets('standalone 默认不加入顶部安全区', (tester) async {
      const navBar = TNavBar(title: Text('安全区'));
      await tester.pumpWidget(safeAreaHost(child: navBar));

      expect(navBar.preferredSize.height, 48);
      expect(tester.getSize(find.byType(TNavBar)).height, 48);
      expect(tester.getTopLeft(find.text('安全区')).dy, lessThan(24));
    });

    testWidgets('useSafeArea=true 将顶部安全区加入实际高度', (tester) async {
      const navBar = TNavBar(title: Text('开启安全区'), useSafeArea: true);
      await tester.pumpWidget(safeAreaHost(child: navBar));

      expect(navBar.preferredSize.height, 48);
      expect(tester.getSize(find.byType(TNavBar)).height, 72);
      expect(tester.getTopLeft(find.text('开启安全区')).dy, greaterThan(24));
    });

    testWidgets('自定义 height 不包含顶部安全区', (tester) async {
      const navBar = TNavBar(
        title: Text('自定义高度'),
        height: 64,
        useSafeArea: true,
      );
      await tester.pumpWidget(safeAreaHost(child: navBar));

      expect(navBar.preferredSize.height, 64);
      expect(tester.getSize(find.byType(TNavBar)).height, 88);
    });

    testWidgets('Scaffold.appBar 只计算一次顶部安全区', (tester) async {
      const navBar = TNavBar(title: Text('AppBar 安全区'), useSafeArea: true);
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
      const item = TNavBarItem(icon: TIcons.home);
      expect(item.iconSize, 24.0);
      expect(item.icon, TIcons.home);
    });

    test('onTap: null 禁用', () {
      const item = TNavBarItem(icon: TIcons.home, onTap: null);
      expect(item.onTap, null);
    });

    testWidgets('item 点击触发 onTap', (tester) async {
      var called = false;
      await tester.pumpWidget(
        wrapWithTheme(
          TNavBar(
            title: const Text('标题'),
            useDefaultBack: false,
            actions: [
              TNavBarItem(
                icon: TIcons.home,
                iconSize: 24,
                onTap: () => called = true,
              ),
            ],
          ),
        ),
      );
      await tester.tap(find.byIcon(TIcons.home));
      expect(called, true);
    });

    testWidgets('onTap: null 的操作项在完整主题下使用禁用色', (tester) async {
      final token = TThemeData.defaultData();
      await tester.pumpWidget(
        wrapWithTheme(
          const TNavBar(
            title: Text('标题'),
            useDefaultBack: false,
            actions: [TNavBarItem(icon: TIcons.home, iconSize: 24)],
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(TIcons.home));
      expect(icon.size, 24.0);
      expect(icon.color, token.textDisabledColor);
    });

    testWidgets('onTap: null 的自定义操作项使用禁用透明度', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          const TNavBar(
            title: Text('标题'),
            actions: [TNavBarItem(customWidget: Text('禁用操作'))],
          ),
        ),
      );

      final opacity = tester.widget<Opacity>(
        find.ancestor(of: find.text('禁用操作'), matching: find.byType(Opacity)),
      );
      expect(opacity.opacity, 0.4);
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
      const border = TNavBarBorder(width: 2.0, radius: 16.0, color: Colors.red);
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
      const navBar = TNavBar(title: Text('test'), height: 60);
      expect(navBar.preferredSize.height, 60);
    });

    testWidgets('belowTitleWidget 渲染', (tester) async {
      // 覆盖 284-286（belowTitleWidget 非空 → Column 渲染）
      await tester.pumpWidget(
        wrapWithTheme(
          const TNavBar(title: Text('below'), belowTitleWidget: Text('下方内容')),
        ),
      );
      expect(find.text('下方内容'), findsOneWidget);
    });

    testWidgets('flexibleSpace 渲染', (tester) async {
      // 覆盖 312-315（flexibleSpace 非空 → Stack 渲染）
      await tester.pumpWidget(
        wrapWithTheme(
          TNavBar(
            title: const Text('flex'),
            flexibleSpace: Container(color: Colors.blue),
          ),
        ),
      );
      expect(find.byType(TNavBar), findsOneWidget);
    });
  });
}
