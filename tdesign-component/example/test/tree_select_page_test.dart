import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_tree_select_page.dart';
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
        home: const TTreeSelectPage(),
      ),
    );
  }

  void configurePhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<Finder> openPopupAndSelectCity(WidgetTester tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();
    await tester.tap(find.widgetWithText(TCell, '选择分类'));
    await tester.pumpAndSettle();

    final popup = find.byKey(const Key('tree-select-popup'));
    expect(popup, findsOneWidget);
    expect(tester.getSize(popup).height, greaterThanOrEqualTo(336));

    for (final label in const ['城市', '广东', '深圳']) {
      await tester.tap(
        find.descendant(of: popup, matching: find.text(label)),
      );
      await tester.pump();
    }
    return popup;
  }

  testWidgets('弹窗跨分支选择后停留在当前页面并在确认后提交', (tester) async {
    configurePhone(tester);

    final popup = await openPopupAndSelectCity(tester);

    expect(
      find.descendant(of: popup, matching: find.text('深圳')),
      findsOneWidget,
    );
    expect(find.text('已选择 1 项'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();

    expect(find.text('已选择 2 项'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('弹窗展示丰富数据且具体禁用项不可选择', (tester) async {
    configurePhone(tester);

    await tester.pumpWidget(buildPage());
    await tester.pump();
    await tester.tap(find.widgetWithText(TCell, '选择分类'));
    await tester.pumpAndSettle();

    final popup = find.byKey(const Key('tree-select-popup'));
    await tester.tap(find.descendant(of: popup, matching: find.text('城市')));
    await tester.pump();
    await tester.tap(find.descendant(of: popup, matching: find.text('广东')));
    await tester.pump();

    final disabledLabel = find.descendant(
      of: popup,
      matching: find.text('珠海（暂不可选）'),
    );
    expect(disabledLabel, findsOneWidget);
    expect(
      find.descendant(of: popup, matching: find.text('东莞')),
      findsOneWidget,
    );
    final disabledTile = find.ancestor(
      of: disabledLabel,
      matching: find.byType(Opacity),
    );
    expect(tester.widget<Opacity>(disabledTile.first).opacity, 0.4);

    await tester.tap(disabledLabel, warnIfMissed: false);
    await tester.pump();

    expect(
      find.descendant(
        of: find.ancestor(
          of: disabledLabel,
          matching: find.byKey(const ValueKey((2, 'zhuhai'))),
        ),
        matching: find.byIcon(TIcons.check),
      ),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('弹窗跨分支选中视觉快照', (tester) async {
    configurePhone(tester);

    await openPopupAndSelectCity(tester);

    await expectLater(
      find.byType(Overlay),
      matchesGoldenFile('goldens/tree_select_popup_selected.png'),
    );
  });
}
