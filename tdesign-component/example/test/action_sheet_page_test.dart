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

  Future<void> openShareGrid(WidgetTester tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();
    await tester.tap(find.widgetWithText(TButton, '分享照片'));
    await tester.pumpAndSettle();
  }

  testWidgets('分享方式宫格在手机视口完整展示且不溢出', (tester) async {
    configurePhone(tester);

    await openShareGrid(tester);

    expect(find.byType(TActionSheetGrid), findsOneWidget);
    expect(find.text('消息'), findsOneWidget);
    expect(find.text('更多'), findsOneWidget);
    expect(find.text('取消'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('分享方式宫格弹窗视觉快照', (tester) async {
    configurePhone(tester);

    await openShareGrid(tester);

    await expectLater(
      find.byType(Overlay),
      matchesGoldenFile('goldens/action_sheet_share_grid.png'),
    );
  });
}
