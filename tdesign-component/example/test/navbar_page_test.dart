import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_navbar_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

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
