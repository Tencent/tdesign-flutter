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
    final progress = find.byKey(const Key('progress-button-value'));
    await Scrollable.ensureVisible(tester.element(progress), alignment: 0.5);
    await tester.pumpAndSettle();
    return progress;
  }

  testWidgets('按钮进度条展示百分比与自定义文案并可真实推进', (tester) async {
    configurePhone(tester);
    final progress = await showButtonProgress(tester);
    final continueProgress = find.byKey(const Key('progress-button-continue'));

    expect(
      find.descendant(of: progress, matching: find.text('80%')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: continueProgress, matching: find.text('Continue')),
      findsOneWidget,
    );
    await tester.tap(progress);
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: progress, matching: find.text('90%')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: continueProgress, matching: find.text('Continue')),
      findsOneWidget,
    );
  });

  testWidgets('微型按钮点击切换播放状态与进度', (tester) async {
    configurePhone(tester);
    await tester.pumpWidget(buildPage());
    await tester.pump();
    final progress = find.byKey(const Key('progress-micro-button'));
    await tester.scrollUntilVisible(
      progress,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(TIcons.play), findsOneWidget);
    await tester.tap(progress);
    await tester.pump();
    expect(find.byIcon(TIcons.pause), findsOneWidget);
  });
}
