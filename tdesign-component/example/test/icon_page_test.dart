import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart' hide TIcons;
import 'package:tdesign_flutter_example/page/t_icon_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';
import 'package:url_launcher/link.dart';

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

  Widget buildGrid(List<MapEntry<String, IconData>> icons) {
    return MaterialApp(
      theme: TThemeBuilder.light(TThemeData.defaultData()),
      home: Scaffold(body: IconCatalogGrid(icons: icons)),
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

  testWidgets('图标目录使用接近小程序的四列密度和响应式列宽', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final icons = TIcons.allIconsMap.entries.take(20).toList();
    await tester.pumpWidget(buildGrid(icons));

    final grid = tester.widget<GridView>(
      find.byKey(const Key('icon-catalog-grid')),
    );
    expect(grid.padding, const EdgeInsets.fromLTRB(16, 8, 16, 24));

    final firstItem = find.byKey(
      ValueKey('icon-catalog-item-${icons.first.key}'),
    );
    expect(tester.getTopLeft(firstItem).dx, greaterThanOrEqualTo(16));
    final item = tester.widget<Container>(firstItem);
    expect(item.decoration, isNull);
    final firstIcon = tester.widget<TIcon>(
      find.descendant(of: firstItem, matching: find.byType(TIcon)),
    );
    expect(firstIcon.size, 24);
    final firstLabel = tester.widget<TText>(
      find.descendant(of: firstItem, matching: find.byType(TText)),
    );
    expect(firstLabel.font?.size, 12);
    expect(firstLabel.font?.height, 20 / 12);
    expect(firstLabel.textColor, TThemeData.defaultData().textColorPlaceholder);

    final fourthItem = find.byKey(
      ValueKey('icon-catalog-item-${icons[3].key}'),
    );
    final fifthItem = find.byKey(ValueKey('icon-catalog-item-${icons[4].key}'));
    expect(tester.getTopLeft(fourthItem).dy, tester.getTopLeft(firstItem).dy);
    expect(
      tester.getTopLeft(fifthItem).dy,
      greaterThan(tester.getTopLeft(firstItem).dy),
    );

    final delegate =
        grid.gridDelegate as SliverGridDelegateWithMaxCrossAxisExtent;
    expect(delegate.maxCrossAxisExtent, 96);
    expect(delegate.mainAxisExtent, 64);
    expect(delegate.mainAxisSpacing, 15);
  });

  testWidgets('点击图标复制可直接使用的 TIcon 代码', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    String? copiedText;
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'Clipboard.setData') {
        copiedText =
            (call.arguments as Map<Object?, Object?>)['text'] as String?;
      }
      return null;
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );

    final first = TIcons.allIconsMap.entries.first;
    await tester.pumpWidget(buildGrid([first]));

    final item = find.byKey(ValueKey('icon-catalog-item-${first.key}'));
    await tester.tap(find.ancestor(of: item, matching: find.byType(InkWell)));
    await tester.pump();

    expect(copiedText, 'TIcon(TIcons.${first.key})');
    expect(find.text('已复制 TIcon(TIcons.${first.key})'), findsOneWidget);
  });

  testWidgets('图标官网使用真实 Link 跳转且不再显示边框开关', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildPage());
    await tester.pump();

    final officialLink = find.byKey(const Key('icon-official-link'));
    final scrollable = tester.state<ScrollableState>(
      find.byType(Scrollable).first,
    );
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
    expect(find.text('筛选 Icon 请前往 TDesign 官网：'), findsNothing);
    expect(find.text('显示边框'), findsNothing);
    expect(find.byType(TSwitch), findsNothing);

    await Scrollable.ensureVisible(
      tester.element(officialLink),
      alignment: 0.5,
    );
    await tester.pumpAndSettle();
  });
}
