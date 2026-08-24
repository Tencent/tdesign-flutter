import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_base.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/page/t_checkbox_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

import 'golden_test_utils.dart';

void main() {
  final originalGoldenComparator = useGoldenDiffTolerance();
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
  tearDownAll(() {
    goldenFileComparator = originalGoldenComparator;
  });

  Widget buildPage(ThemeMode mode) {
    return RepaintBoundary(
      key: const Key('checkbox-page-golden'),
      child: ChangeNotifierProvider(
        create: (_) => ThemeModeProvider(),
        child: MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          darkTheme: TThemeBuilder.dark(TThemeData.defaultData()),
          themeMode: mode,
          home: ExamplePageInheritedTheme(
            model: ExamplePageModel(
              text: 'Checkbox 多选框',
              name: 'checkbox',
              pageBuilder: (_, __) => const TCheckboxPage(),
            ),
            child: const TCheckboxPage(),
          ),
        ),
      ),
    );
  }

  testWidgets('Checkbox Demo follows the official groups', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeModeProvider(),
        child: MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: ExamplePageInheritedTheme(
            model: ExamplePageModel(
              text: 'Checkbox 多选框',
              name: 'checkbox',
              pageBuilder: (_, __) => const TCheckboxPage(),
            ),
            child: const TCheckboxPage(),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('01 组件类型'), findsOneWidget);
    expect(find.text('纵向多选框'), findsOneWidget);

    final scrollState = tester.state<ScrollableState>(
      find.byType(Scrollable).first,
    );
    var foundStatus = false;
    var foundStyle = false;
    var foundSpec = false;
    var foundAll = false;
    for (
      var offset = 0.0;
      offset <= scrollState.position.maxScrollExtent;
      offset += 300
    ) {
      scrollState.position.jumpTo(offset);
      await tester.pump();
      foundStatus |= find.text('02 组件状态').evaluate().isNotEmpty;
      foundStyle |= find.text('03 组件样式').evaluate().isNotEmpty;
      foundSpec |= find.text('04 组件规格').evaluate().isNotEmpty;
      foundAll |= find.text('带全选多选框').evaluate().isNotEmpty;
    }
    expect(foundStatus, isTrue);
    expect(foundStyle, isTrue);
    expect(foundSpec, isTrue);
    expect(foundAll, isTrue);
  });

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('Checkbox Demo ${mode.name} 手机视口视觉快照', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildPage(mode));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byKey(const Key('checkbox-page-golden')),
        matchesGoldenFile('goldens/checkbox_page_${mode.name}.png'),
      );
    });
  }
}
