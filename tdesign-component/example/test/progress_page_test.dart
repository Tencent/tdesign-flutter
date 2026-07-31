import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/page/t_progress_page.dart';
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

  tearDown(TToast.dismissAll);

  Widget buildPage() {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: TThemeBuilder.light(TThemeData.defaultData()),
        home: const TProgressPage(),
      ),
    );
  }

  void configurePhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<Finder> showButtonProgress(WidgetTester tester) async {
    await tester.pumpWidget(buildPage());
    await tester.pump();
    final progress = find.byKey(const Key('progress-button'));
    await Scrollable.ensureVisible(
      tester.element(progress),
      alignment: 0.5,
    );
    await tester.pumpAndSettle();
    return progress;
  }

  testWidgets('按钮进度条长按只提示 onLongPress，不触发 onTap', (tester) async {
    configurePhone(tester);
    final progress = await showButtonProgress(tester);

    await tester.longPress(progress);
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('onLongPress 已触发，onTap 未触发'), findsOneWidget);
    expect(find.text('onTap 已触发'), findsNothing);
    expect(find.text('开始'), findsOneWidget);
    expect(tester.takeException(), isNull);
    TToast.dismissAll();
    await tester.pump();
  });

  testWidgets('按钮进度条点击只提示 onTap', (tester) async {
    configurePhone(tester);
    final progress = await showButtonProgress(tester);

    await tester.tap(progress);
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('onTap 已触发'), findsOneWidget);
    expect(find.text('onLongPress 已触发，onTap 未触发'), findsNothing);
    expect(tester.takeException(), isNull);
    TToast.dismissAll();
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('按钮进度条长按提示视觉快照', (tester) async {
    configurePhone(tester);
    final progress = await showButtonProgress(tester);

    await tester.longPress(progress);
    await tester.pump(const Duration(milliseconds: 250));

    await expectLater(
      find.byType(Overlay),
      matchesGoldenFile('goldens/progress_button_long_press_toast.png'),
    );
    TToast.dismissAll();
    await tester.pump();
  });
}
