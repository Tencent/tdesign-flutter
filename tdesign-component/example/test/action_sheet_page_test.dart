import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/src/components/action_sheet/t_action_sheet_grid.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_action_sheet_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

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

  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TActionSheetPage(),
      ),
    );
  }

  void configurePhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> openBasicGrid(WidgetTester tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();
    final trigger = find.widgetWithText(TButton, '常规宫格型');
    await tester.scrollUntilVisible(
      trigger,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(trigger);
    await tester.pumpAndSettle();
  }

  testWidgets('官方 Demo 矩阵公开展示全部场景', (tester) async {
    configurePhone(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();

    const labels = [
      '常规列表型',
      '带描述列表型',
      '带图标列表型',
      '常规宫格型',
      '带描述宫格型',
      '带翻页宫格型',
      '列表型选项状态',
      '居中列表型',
      '左对齐列表型',
    ];
    for (final label in labels) {
      final trigger = find.widgetWithText(TButton, label);
      await tester.scrollUntilVisible(
        trigger,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(trigger, findsOneWidget);
    }
  });

  testWidgets('常规宫格型在手机视口完整展示且不溢出', (tester) async {
    configurePhone(tester);

    await openBasicGrid(tester);

    expect(find.byType(TActionSheetGrid), findsOneWidget);
    expect(find.text('微信'), findsOneWidget);
    expect(find.text('复制'), findsOneWidget);
    expect(find.text('取消'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('常规宫格型弹窗视觉快照', (tester) async {
    configurePhone(tester);

    await openBasicGrid(tester);

    await expectLater(
      find.byType(Overlay),
      matchesGoldenFile('goldens/action_sheet_share_grid.png'),
    );
  });
}
