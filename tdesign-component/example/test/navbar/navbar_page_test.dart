import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/navbar/navbar_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

import '../demo_page_test_utils.dart';
import 'navbar_demo_test_spec.dart';

void main() {
  Widget buildPage({ThemeData? theme}) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: theme ?? TThemeBuilder.light(TThemeData.defaultData()),
        home: const MediaQuery(
          data: MediaQueryData(
            size: Size(375, 812),
            padding: EdgeInsets.only(top: 24),
          ),
          child: TNavBarPage(),
        ),
      ),
    );
  }

  testWidgets('Navbar 公开场景与覆盖契约双向一致', (tester) async {
    await pumpFullDemoPage(tester, navbarDemoPageTestSpec, ThemeMode.light);

    final renderedEntries = <(String, double)>[];
    for (final scene in navBarDemoScenes) {
      final boundary = find.byKey(scene.key);
      expect(boundary, findsOneWidget, reason: scene.id);
      expect(
        find.descendant(of: boundary, matching: find.byType(TNavBar)),
        findsOneWidget,
        reason: scene.id,
      );
      renderedEntries.add((scene.id, tester.getTopLeft(boundary).dy));
    }
    expect(find.byType(TNavBar), findsNWidgets(navBarDemoScenes.length + 1));
    renderedEntries.sort((left, right) => left.$2.compareTo(right.$2));
    expect(
      renderedEntries.map((entry) => entry.$1),
      navBarDemoScenes.map((scene) => scene.id),
    );
  });

  testWidgets('Navbar 所有 Demo 自定义操作都通过真实点击触发', (tester) async {
    const actions = [
      ('left_multi', 'close', TIcons.close, '关闭'),
      ('left_multi', 'more', TIcons.ellipsis, '更多'),
      ('right_multi', 'home', TIcons.home, '首页'),
      ('right_multi', 'more', TIcons.ellipsis, '更多'),
      ('search', 'home', TIcons.home, '首页'),
      ('search', 'more', TIcons.ellipsis, '更多'),
      ('image', 'home', TIcons.home, '首页'),
      ('image', 'more', TIcons.ellipsis, '更多'),
      ('title_center', 'home', TIcons.home, '首页'),
      ('title_center', 'more', TIcons.ellipsis, '更多'),
      ('title_left', 'home', TIcons.home, '首页'),
      ('title_left', 'more', TIcons.ellipsis, '更多'),
      ('title_normal', 'home', TIcons.home, '首页'),
      ('title_normal', 'more', TIcons.ellipsis, '更多'),
      ('title_below', 'back', TIcons.chevron_left, '返回'),
      ('title_below', 'home', TIcons.home, '首页'),
      ('title_below', 'more', TIcons.ellipsis, '更多'),
      ('custom_color', 'back', TIcons.chevron_left, '返回'),
      ('custom_color', 'home', TIcons.home, '首页'),
      ('custom_color', 'more', TIcons.ellipsis, '更多'),
    ];
    expect(
      actions.map((action) => '${action.$1}:${action.$2}').toSet(),
      expectedNavBarFunctionalActions,
    );

    await pumpFullDemoPage(tester, navbarDemoPageTestSpec, ThemeMode.light);
    for (final action in actions) {
      final scene = navBarDemoScenes.singleWhere(
        (scene) => scene.id == action.$1,
      );
      final target = find.descendant(
        of: find.byKey(scene.key),
        matching: find.byIcon(action.$3),
      );
      expect(target, findsOneWidget, reason: '${action.$1}:${action.$2}');
      await tester.tap(target);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('点击了${action.$4}'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    }
  });

  testWidgets('Navbar Demo 内嵌示例不重复占用顶部安全区', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildPage());
    await tester.pump();

    final demoShell = tester.widget<TNavBar>(find.byType(TNavBar).first);
    expect(demoShell.useDefaultBack, isFalse);
    expect(demoShell.leading?.first.icon, TIcons.chevron_left);
    expect(demoShell.leading?.first.iconSize, 28);
    final demoShellTitle = demoShell.title! as Text;
    expect(demoShellTitle.style?.fontSize, 16);
    expect(demoShellTitle.style?.height, closeTo(22 / 14, 0.001));
    expect(demoShellTitle.style?.fontWeight, FontWeight.w500);

    expect(
      tester.getSize(find.byKey(const Key('navbar-demo-base'))).height,
      48,
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('navbar-demo-custom-height')),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      tester.getSize(find.byKey(const Key('navbar-demo-custom-height'))).height,
      80,
    );
    final customHeight = tester.widget<TNavBar>(
      find.byKey(const Key('navbar-demo-custom-height')),
    );
    expect(customHeight.title, isA<TText>());
    final renderedBackTitle = tester.widget<Text>(
      find.descendant(
        of: find.byKey(const Key('navbar-demo-custom-height')),
        matching: find.text('返回'),
      ),
    );
    expect(renderedBackTitle.style?.fontSize, 16);
    expect(renderedBackTitle.style?.height, 1.5);
    expect(renderedBackTitle.style?.fontWeight, FontWeight.w400);
  });

  testWidgets('公共 Demo 壳层标题行高不受 Material bodyMedium 污染', (tester) async {
    final theme = TThemeBuilder.light(TThemeData.defaultData());
    await tester.pumpWidget(
      buildPage(
        theme: theme.copyWith(
          textTheme: theme.textTheme.copyWith(
            bodyMedium: const TextStyle(height: 3),
          ),
        ),
      ),
    );
    await tester.pump();

    final demoShell = tester.widget<TNavBar>(find.byType(TNavBar).first);
    final demoShellTitle = demoShell.title! as Text;
    expect(demoShellTitle.style?.fontSize, 16);
    expect(demoShellTitle.style?.height, closeTo(22 / 14, 0.001));
    expect(demoShellTitle.style?.fontWeight, FontWeight.w500);
  });

  testWidgets('Navbar Demo 对齐 Figma H5 组合、图片尺寸与搜索交互', (tester) async {
    tester.view.physicalSize = const Size(375, 1318);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildPage());
    await tester.pump();

    final base = tester.widget<TNavBar>(
      find.byKey(const Key('navbar-demo-base')),
    );
    final leftMulti = tester.widget<TNavBar>(
      find.byKey(const Key('navbar-demo-left-multi-action')),
    );
    final rightMulti = tester.widget<TNavBar>(
      find.byKey(const Key('navbar-demo-right-multi-action')),
    );
    expect(base.useDefaultBack, isTrue);
    expect(leftMulti.leading, hasLength(1));
    expect(leftMulti.actions, hasLength(1));
    expect(rightMulti.actions, hasLength(2));

    final search = tester.widget<TNavBar>(
      find.byKey(const Key('navbar-demo-search')),
    );
    final image = tester.widget<TNavBar>(
      find.byKey(const Key('navbar-demo-image')),
    );
    expect(search.actions, hasLength(2));
    expect(image.actions, hasLength(2));
    final searchIcon = find.descendant(
      of: find.byKey(const Key('navbar-demo-search')),
      matching: find.byIcon(TIcons.search),
    );
    expect(searchIcon, findsOneWidget);
    expect(tester.widget<Icon>(searchIcon).size, 20);
    expect(tester.getSize(searchIcon), const Size.square(20));
    expect(image.title, isA<TImage>());
    final logo = image.title! as TImage;
    expect(logo.width, 87);
    expect(logo.height, 24);

    final searchField = find.descendant(
      of: find.byKey(const Key('navbar-demo-search')),
      matching: find.byType(EditableText),
    );
    await tester.enterText(searchField, 'Navbar');
    await tester.pump();
    expect(find.text('Navbar'), findsOneWidget);

    final moreAction = find.descendant(
      of: find.byKey(const Key('navbar-demo-left-multi-action')),
      matching: find.byIcon(TIcons.ellipsis),
    );
    await tester.tap(moreAction);
    await tester.pump();
    expect(find.text('点击了更多'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });
}
