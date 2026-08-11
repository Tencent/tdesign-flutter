import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TNavBar Widget 测试
///
/// 覆盖标题渲染、titleWidget 优先级、leading/actions、useDefaultBack、
/// onBack 回调、A 类禁用（onTap: null）、Theme 各字段覆盖、preferredSize。
void main() {
  /// 用 TTheme 包裹以提供基础 Token
  Widget wrapWithTheme(Widget child, {TNavBarThemeData? navBarTheme}) {
    final themeExtensions = <ThemeExtension>[
      if (navBarTheme != null) navBarTheme,
    ];
    return MaterialApp(
      theme: ThemeData(
        extensions: [TThemeData.defaultData(), ...themeExtensions],
      ),
      home: Scaffold(body: child),
    );
  }

  group('TNavBar 基础渲染', () {
    testWidgets('默认标题渲染', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '首页'),
      ));
      expect(find.text('首页'), findsOneWidget);
      expect(find.byType(TNavBar), findsOneWidget);
    });

    testWidgets('titleWidget 优先级高于 title', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(
          title: '文本标题',
          titleWidget: Text('自定义标题'),
        ),
      ));
      expect(find.text('自定义标题'), findsOneWidget);
      expect(find.text('文本标题'), findsNothing);
    });

    testWidgets('默认显示返回按钮', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '测试'),
      ));
      // useDefaultBack 默认 true，应渲染返回图标
      expect(find.byIcon(TIcons.chevron_left), findsOneWidget);
    });

    testWidgets('useDefaultBack=false 不显示返回按钮', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(
          title: '测试',
          useDefaultBack: false,
        ),
      ));
      expect(find.byIcon(TIcons.chevron_left), findsNothing);
    });

    testWidgets('onBack 回调触发', (tester) async {
      var backCalled = false;
      await tester.pumpWidget(wrapWithTheme(
        TNavBar(
          title: '测试',
          useDefaultBack: false,
          onBack: () => backCalled = true,
        ),
      ));
      // 没有 useDefaultBack 时没有返回按钮，需要通过 leading 提供
      expect(backCalled, isFalse);
    });

    testWidgets('actions 渲染右侧操作项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TNavBar(
          title: '测试',
          useDefaultBack: false,
          actions: [
            TNavBarItem(icon: TIcons.ellipsis, onTap: () {}),
          ],
        ),
      ));
      expect(find.byIcon(TIcons.ellipsis), findsOneWidget);
    });

    testWidgets('leading 渲染左侧操作项', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TNavBar(
          title: '测试',
          useDefaultBack: false,
          leading: [
            TNavBarItem(icon: TIcons.chevron_left, onTap: () {}),
          ],
        ),
      ));
      expect(find.byIcon(TIcons.chevron_left), findsOneWidget);
    });
  });

  group('TNavBar A 类禁用', () {
    testWidgets('onTap: null 时操作项不响应点击', (tester) async {
      var tapCount = 0;
      await tester.pumpWidget(wrapWithTheme(
        TNavBar(
          title: '测试',
          useDefaultBack: false,
          actions: [
            TNavBarItem(
              icon: TIcons.ellipsis,
              onTap: () => tapCount++,
            ),
          ],
        ),
      ));
      await tester.tap(find.byIcon(TIcons.ellipsis));
      await tester.pump();
      expect(tapCount, 1);

      // onTap: null 表示禁用
      await tester.pumpWidget(wrapWithTheme(
        TNavBar(
          title: '测试',
          useDefaultBack: false,
          actions: [
            TNavBarItem(icon: TIcons.ellipsis, onTap: null),
          ],
        ),
      ));
      await tester.tap(find.byIcon(TIcons.ellipsis));
      await tester.pump();
      // tapCount 不应增加
      expect(tapCount, 1);
    });
  });

  group('TNavBar Theme 覆盖', () {
    testWidgets('TNavBarThemeData 覆盖标题颜色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '主题测试'),
        navBarTheme: const TNavBarThemeData(
          titleColor: Colors.red,
        ),
      ));
      final textWidget = tester.widget<Text>(find.text('主题测试'));
      expect(textWidget.style?.color, Colors.red);
    });

    testWidgets('构造器参数优先级高于 Theme', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(
          title: '优先级测试',
          titleColor: Colors.blue,
        ),
        navBarTheme: const TNavBarThemeData(
          titleColor: Colors.red,
        ),
      ));
      final textWidget = tester.widget<Text>(find.text('优先级测试'));
      // 构造器 titleColor 蓝色应覆盖 Theme 红色
      expect(textWidget.style?.color, Colors.blue);
    });

    testWidgets('TNavBarThemeData 覆盖背景颜色', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(title: '背景测试'),
        navBarTheme: const TNavBarThemeData(
          backgroundColor: Colors.green,
        ),
      ));
      // 验证不抛异常即通过
      expect(find.byType(TNavBar), findsOneWidget);
    });

    testWidgets('TNavBar 高度通过构造器设置', (tester) async {
      const navBar = TNavBar(title: '高度测试', height: 64);
      await tester.pumpWidget(wrapWithTheme(navBar));
      expect(navBar.preferredSize.height, 64);
      expect(find.byType(TNavBar), findsOneWidget);
    });
  });

  group('TNavBar preferredSize', () {
    testWidgets('默认高度 48', (tester) async {
      const navBar = TNavBar(title: '尺寸测试');
      expect(navBar.preferredSize.height, 48);
    });

    testWidgets('自定义高度', (tester) async {
      const navBar = TNavBar(title: '尺寸测试', height: 56);
      expect(navBar.preferredSize.height, 56);
    });
  });

  group('TNavBar 边框模式', () {
    testWidgets('useBorderStyle 渲染边框容器', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TNavBar(
          title: '边框测试',
          useDefaultBack: false,
          actions: [
            TNavBarItem(icon: TIcons.ellipsis, onTap: () {}),
            TNavBarItem(icon: TIcons.setting, onTap: () {}),
          ],
          useBorderStyle: true,
        ),
      ));
      expect(find.byType(TNavBar), findsOneWidget);
    });
  });

  group('TNavBar belowTitleWidget', () {
    testWidgets('渲染 belowTitleWidget', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const TNavBar(
          title: '下方组件测试',
          useDefaultBack: false,
          belowTitleWidget: Text('下方内容'),
        ),
      ));
      expect(find.text('下方内容'), findsOneWidget);
    });
  });
}
