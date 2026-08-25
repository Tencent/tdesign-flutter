import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_base.dart';
import 'package:tdesign_flutter_example/page/t_form_page.dart';
import 'package:tdesign_flutter_example/page/t_input_page.dart';
import 'package:tdesign_flutter_example/page/t_textarea_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

void main() {
  setUpAll(() async {
    final iconFont = FontLoader('packages/tdesign_flutter_icons/TIcons')
      ..addFont(rootBundle.load('packages/tdesign_flutter_icons/fonts/t.ttf'));
    final flutterBin = File(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;
    final robotoFont = FontLoader('Roboto')
      ..addFont(
        File(
          '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
        ).readAsBytes().then(ByteData.sublistView),
      );
    await Future.wait([iconFont.load(), robotoFont.load()]);
  });

  const pages = <_DemoPage>[
    _DemoPage(
      name: 'input',
      title: 'Input 输入框',
      height: 2994,
      child: TInputViewPage(),
    ),
    _DemoPage(
      name: 'textarea',
      title: 'Textarea 多行文本框',
      height: 1966,
      child: TTextareaPage(),
    ),
    _DemoPage(name: 'form', title: 'Form 表单', height: 1135, child: TFormPage()),
  ];

  for (final page in pages) {
    for (final themeMode in [ThemeMode.light, ThemeMode.dark]) {
      final brightness = themeMode == ThemeMode.light ? 'light' : 'dark';
      testWidgets('完整 ${page.name} $brightness Demo 快照', (tester) async {
        tester.view.physicalSize = Size(375, page.height);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(_buildPage(page, themeMode));
        await tester.pump();

        expect(
          tester
              .state<ScrollableState>(find.byType(Scrollable).first)
              .position
              .maxScrollExtent,
          0,
        );
        await expectLater(
          find.byWidget(page.child),
          matchesGoldenFile('goldens/${page.name}_demo_$brightness.png'),
        );
      });
    }
  }
}

Widget _buildPage(_DemoPage page, ThemeMode themeMode) {
  final model = ExamplePageModel(
    text: page.title,
    name: page.name,
    pageBuilder: (_, __) => page.child,
  );
  return ChangeNotifierProvider(
    create: (_) => ThemeModeProvider(),
    child: MaterialApp(
      theme: TThemeBuilder.light(TThemeData.defaultData()),
      darkTheme: TThemeBuilder.dark(TThemeData.defaultData()),
      themeMode: themeMode,
      home: ExamplePageInheritedTheme(model: model, child: page.child),
    ),
  );
}

class _DemoPage {
  const _DemoPage({
    required this.name,
    required this.title,
    required this.height,
    required this.child,
  });

  final String name;
  final String title;
  final double height;
  final Widget child;
}
