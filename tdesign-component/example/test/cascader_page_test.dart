import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_cascader_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  setUpAll(() async {
    final iconFont = FontLoader('packages/tdesign_icons/TIcons')
      ..addFont(rootBundle.load('packages/tdesign_icons/fonts/t.ttf'));
    final flutterBin =
        File(Platform.resolvedExecutable).parent.parent.parent.parent.parent;
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    final robotoFont = FontLoader('Roboto')
      ..addFont(robotoFile.readAsBytes().then(ByteData.sublistView));
    await Future.wait([iconFont.load(), robotoFont.load()]);
  });

  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TCascaderPage(),
      ),
    );
  }

  testWidgets('底部弹层可以完整展示并完成受控选择', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildPage());
    await tester.pump();

    await tester.tap(find.widgetWithText(TCell, '选择地区'));
    await tester.pumpAndSettle();

    final popup = find.byKey(const Key('cascader-popup'));
    expect(popup, findsOneWidget);
    expect(tester.getSize(popup).height, greaterThan(360));
    expect(tester.takeException(), isNull);

    expect(find.text('广东省 / 深圳市 / 南山区'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: popup,
        matching: find.byKey(const ValueKey('cascader-ft')),
      ),
    );
    await tester.pump();
    expect(find.text('广东省 / 深圳市 / 南山区'), findsOneWidget);

    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(find.text('广东省 / 深圳市 / 福田区'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Demo 覆盖基础、预选、占位和禁用状态', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildPage());
    await tester.pump();

    final scrollable = find.descendant(
      of: find.byType(CustomScrollView),
      matching: find.byType(Scrollable),
    ).first;
    for (final description in const [
      '标签导航',
      '步骤导航',
      '默认选中路径',
      '自定义占位文案',
      '禁用部分选项',
      '整体禁用',
    ]) {
      await tester.scrollUntilVisible(
        find.text(description),
        320,
        scrollable: scrollable,
      );
      expect(find.text(description), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('底部弹层视觉快照', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildPage());
    await tester.pump();
    await tester.tap(find.widgetWithText(TCell, '选择地区'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Overlay),
      matchesGoldenFile('goldens/cascader_popup.png'),
    );
  });
}
