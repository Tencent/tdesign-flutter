import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_base.dart';
import 'package:tdesign_flutter_example/page/t_search_bar_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  setUpAll(() async {
    final iconFont = FontLoader('packages/tdesign_flutter_icons/TIcons')
      ..addFont(rootBundle.load('packages/tdesign_flutter_icons/fonts/t.ttf'));
    final flutterBin = File(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    final robotoFont = FontLoader('Roboto')
      ..addFont(robotoFile.readAsBytes().then(ByteData.sublistView));
    await Future.wait([iconFont.load(), robotoFont.load()]);
  });

  Widget buildPage({ThemeMode themeMode = ThemeMode.light}) {
    final model = ExamplePageModel(
      text: 'Search 搜索框',
      name: 'search',
      pageBuilder: (_, __) => const TSearchBarPage(),
    );
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        darkTheme: TThemeBuilder.dark(TThemeData.defaultData()),
        themeMode: themeMode,
        home: ExamplePageInheritedTheme(
          model: model,
          child: const TSearchBarPage(),
        ),
      ),
    );
  }

  testWidgets('Search 页面覆盖小程序 Demo 场景和 40dp 组件本体', (tester) async {
    tester.view.physicalSize = const Size(375, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildPage());
    await tester.pump();

    expect(find.text('基础搜索框'), findsOneWidget);
    expect(find.text('字数限制'), findsOneWidget);
    expect(find.text('获取焦点后显示取消按钮'), findsOneWidget);
    expect(find.text('搜索框形状'), findsOneWidget);
    expect(find.text('默认状态其他对齐方式'), findsOneWidget);
    expect(find.byType(TSearchBar), findsNWidgets(8));

    for (final element in find.byType(TSearchBar).evaluate()) {
      expect(tester.getSize(find.byWidget(element.widget)).height, 40);
    }
  });

  testWidgets('搜索结果由 Demo 组合而非 TSearchBar 公共 API', (tester) async {
    tester.view.physicalSize = const Size(375, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildPage());
    await tester.pump();

    final resultField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.hintText == '输入tdesign，有预览结果',
    );
    await tester.tap(resultField);
    await tester.pump();

    for (final result in [
      'tdesign-vue',
      'tdesign-react',
      'tdesign-miniprogram',
      'tdesign-angular',
      'tdesign-mobile-vue',
      'tdesign-mobile-react',
    ]) {
      expect(find.text(result), findsOneWidget);
    }

    await tester.enterText(resultField, 'mobile');
    await tester.pump();

    expect(find.text('tdesign-mobile-vue'), findsOneWidget);
    expect(find.text('tdesign-mobile-react'), findsOneWidget);
    expect(find.text('tdesign-vue'), findsNothing);
    final highlighted = tester
        .widgetList<Text>(find.byType(Text))
        .where((text) => text.textSpan?.toPlainText() == 'tdesign-mobile-vue')
        .single;
    final spans = (highlighted.textSpan! as TextSpan).children!;
    expect((spans[1] as TextSpan).text, 'mobile');
    expect(
      (spans[1] as TextSpan).style?.color,
      TThemeData.defaultData().brandNormalColor,
    );

    await tester.tap(find.text('tdesign-mobile-vue'));
    await tester.pump();
    expect(fieldText(resultField, tester), 'tdesign-mobile-vue');
    expect(find.text('tdesign-mobile-react'), findsNothing);
  });

  testWidgets('手机尺寸浅色 Search Demo 快照', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildPage());
    await tester.pump();

    await expectLater(
      find.byType(TSearchBarPage),
      matchesGoldenFile('goldens/search_demo_light.png'),
    );
  });

  testWidgets('手机尺寸深色 Search Demo 快照', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildPage(themeMode: ThemeMode.dark));
    await tester.pump();

    await expectLater(
      find.byType(TSearchBarPage),
      matchesGoldenFile('goldens/search_demo_dark.png'),
    );
  });
}

String fieldText(Finder finder, WidgetTester tester) =>
    tester.widget<TextField>(finder).controller!.text;
