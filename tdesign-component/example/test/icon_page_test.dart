import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_icon_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';
import 'package:url_launcher/link.dart';

void main() {
  setUpAll(() async {
    final iconFont = FontLoader('packages/tdesign_flutter_icons/TIcons')
      ..addFont(rootBundle.load('packages/tdesign_flutter_icons/fonts/t.ttf'));
    final flutterBin =
        File(Platform.resolvedExecutable).parent.parent.parent.parent.parent;
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    final robotoFont = FontLoader('Roboto')
      ..addFont(robotoFile.readAsBytes().then(ByteData.sublistView));
    await Future.wait([iconFont.load(), robotoFont.load()]);
  });

  Widget buildGrid(List<MapEntry<String, IconData>> icons) {
    return MaterialApp(
      theme: TThemeBuilder.light(TThemeData.defaultData()),
      home: Scaffold(
        body: IconCatalogGrid(
          icons: icons,
        ),
      ),
    );
  }

  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TIconPage(),
      ),
    );
  }

  testWidgets('图标目录只构建视口附近的网格项', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final icons = TIcons.allIconsMap.entries.toList();
    await tester.pumpWidget(buildGrid(icons));

    final renderedIcons = find.byType(TIcon).evaluate().length;
    expect(renderedIcons, greaterThan(0));
    expect(renderedIcons, lessThan(icons.length));
  });

  testWidgets('图标目录保留页面边距并使用响应式列宽', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final icons = TIcons.allIconsMap.entries.take(20).toList();
    await tester.pumpWidget(buildGrid(icons));

    final grid = tester.widget<GridView>(
      find.byKey(const Key('icon-catalog-grid')),
    );
    expect(grid.padding, const EdgeInsets.fromLTRB(16, 12, 16, 24));

    final firstItem = find.byKey(
      ValueKey('icon-catalog-item-${icons.first.key}'),
    );
    expect(tester.getTopLeft(firstItem).dx, greaterThanOrEqualTo(16));
    final item = tester.widget<Container>(firstItem);
    final decoration = item.decoration! as BoxDecoration;
    expect(decoration.border, isNotNull);

    final delegate =
        grid.gridDelegate as SliverGridDelegateWithMaxCrossAxisExtent;
    expect(delegate.maxCrossAxisExtent, 176);
  });

  testWidgets('图标目录网格视觉快照', (tester) async {
    tester.view.physicalSize = const Size(360, 420);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final icons = TIcons.allIconsMap.entries.take(12).toList();
    await tester.pumpWidget(buildGrid(icons));

    await expectLater(
      find.byKey(const Key('icon-catalog-grid')),
      matchesGoldenFile('goldens/icon_catalog_grid.png'),
    );
  });

  testWidgets('图标官网使用真实 Link 跳转且不再显示边框开关', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildPage());
    await tester.pump();

    final officialLink = find.byKey(const Key('icon-official-link'));
    final scrollable =
        tester.state<ScrollableState>(find.byType(Scrollable).first);
    for (var index = 0; index < 8 && officialLink.evaluate().isEmpty; index++) {
      scrollable.position.jumpTo(scrollable.position.maxScrollExtent);
      await tester.pumpAndSettle();
    }

    expect(officialLink, findsOneWidget);
    final link = tester.widget<Link>(officialLink);
    expect(link.uri, Uri.parse('https://tdesign.tencent.com/icons'));
    expect(link.target, LinkTarget.blank);
    final tLink = tester.widget<TLink>(
      find.descendant(of: officialLink, matching: find.byType(TLink)),
    );
    expect(tLink.onPressed, isNotNull);
    expect(find.text('显示边框'), findsNothing);
    expect(find.byType(TSwitch), findsNothing);

    await Scrollable.ensureVisible(
      tester.element(officialLink),
      alignment: 0.5,
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const Key('icon-official-link-section')),
      matchesGoldenFile('goldens/icon_official_link.png'),
    );
  });
}
