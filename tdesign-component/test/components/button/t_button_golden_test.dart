import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TButton P0 Golden 测试
///
/// 覆盖 primary 默认态、danger、disabled、纯 icon + circle 等关键态。
/// 首次运行用 `flutter test --update-goldens` 生成基线。
void main() {
  setUpAll(() async {
    final flutterBin =
        File(Platform.resolvedExecutable).parent.parent.parent.parent.parent;
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    await (FontLoader('Roboto')
          ..addFont(robotoFile.readAsBytes().then(ByteData.sublistView)))
        .load();
  });

  Widget wrapWithTheme(Widget child, {TButtonThemeData? buttonTheme}) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
          labelLarge: TextStyle(fontFamily: 'Roboto'),
        ),
        extensions: [
          TThemeData.defaultData(),
          if (buttonTheme != null) buttonTheme,
        ],
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: child),
      ),
    );
  }

  group('TButton Golden', () {
    testWidgets('primary 默认态', (tester) async {
      tester.view.physicalSize = const Size(400, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('Button'),
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
          onPressed: _noop,
        ),
      ));
      await expectLater(
        find.byType(TButton),
        matchesGoldenFile('goldens/t_button_primary_default.png'),
      );
    });

    testWidgets('danger 态', (tester) async {
      tester.view.physicalSize = const Size(400, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('Danger'),
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.danger,
          onPressed: _noop,
        ),
      ));
      await expectLater(
        find.byType(TButton),
        matchesGoldenFile('goldens/t_button_danger.png'),
      );
    });

    testWidgets('disabled 禁用态', (tester) async {
      tester.view.physicalSize = const Size(400, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('Disabled'),
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
          onPressed: null,
        ),
      ));
      await expectLater(
        find.byType(TButton),
        matchesGoldenFile('goldens/t_button_disabled.png'),
      );
    });

    testWidgets('纯 icon + circle', (tester) async {
      tester.view.physicalSize = const Size(400, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          icon: Icon(Icons.add),
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
          onPressed: _noop,
        ),
        buttonTheme: const TButtonThemeData(shape: TButtonShape.circle),
      ));
      await expectLater(
        find.byType(TButton),
        matchesGoldenFile('goldens/t_button_icon_circle.png'),
      );
    });

    testWidgets('outline 变体', (tester) async {
      tester.view.physicalSize = const Size(400, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('Outline'),
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
          onPressed: _noop,
        ),
      ));
      await expectLater(
        find.byType(TButton),
        matchesGoldenFile('goldens/t_button_outline.png'),
      );
    });

    testWidgets('text 变体', (tester) async {
      tester.view.physicalSize = const Size(400, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('Text'),
          variant: TButtonVariant.text,
          colorScheme: TButtonColorScheme.primary,
          onPressed: _noop,
        ),
      ));
      await expectLater(
        find.byType(TButton),
        matchesGoldenFile('goldens/t_button_text.png'),
      );
    });
  });
}

void _noop() {}
