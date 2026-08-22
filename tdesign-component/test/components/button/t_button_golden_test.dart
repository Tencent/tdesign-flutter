import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TButton P0 Golden 测试
///
/// 覆盖 primary 默认态、danger、disabled、纯 icon + circle/square 等关键态。
/// 首次运行用 `flutter test --update-goldens` 生成基线。
void main() {
  setUpAll(() async {
    final flutterBin =
        File(Platform.resolvedExecutable).parent.parent.parent.parent.parent;
    final robotoFile = File(
      '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
    );
    final robotoFont = FontLoader('Roboto')
      ..addFont(robotoFile.readAsBytes().then(ByteData.sublistView));
    final iconFont = FontLoader('packages/tdesign_flutter_icons/TIcons')
      ..addFont(
        rootBundle.load('packages/tdesign_flutter_icons/fonts/t.ttf'),
      );
    await Future.wait([robotoFont.load(), iconFont.load()]);
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
          icon: Icon(TIcons.app),
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

    testWidgets('纯 icon + square 保留默认圆角', (tester) async {
      tester.view.physicalSize = const Size(400, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          icon: Icon(TIcons.app),
          size: TButtonSize.large,
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
          onPressed: _noop,
        ),
        buttonTheme: const TButtonThemeData(shape: TButtonShape.square),
      ));
      await expectLater(
        find.byType(TButton),
        matchesGoldenFile('goldens/t_button_icon_square.png'),
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

    testWidgets('四档尺寸矩阵', (tester) async {
      tester.view.physicalSize = const Size(520, 160);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      const matrixKey = Key('button-size-matrix');
      await tester.pumpWidget(wrapWithTheme(
        const RepaintBoundary(
          key: matrixKey,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TButton(
                size: TButtonSize.large,
                colorScheme: TButtonColorScheme.primary,
                onPressed: _noop,
                child: Text('L 48'),
              ),
              SizedBox(width: 12),
              TButton(
                size: TButtonSize.medium,
                colorScheme: TButtonColorScheme.primary,
                onPressed: _noop,
                child: Text('M 40'),
              ),
              SizedBox(width: 12),
              TButton(
                size: TButtonSize.small,
                colorScheme: TButtonColorScheme.primary,
                onPressed: _noop,
                child: Text('S 32'),
              ),
              SizedBox(width: 12),
              TButton(
                size: TButtonSize.extraSmall,
                colorScheme: TButtonColorScheme.primary,
                onPressed: _noop,
                child: Text('XS 28'),
              ),
            ],
          ),
        ),
      ));

      await expectLater(
        find.byKey(matrixKey),
        matchesGoldenFile('goldens/t_button_size_matrix.png'),
      );
    });
  });
}

void _noop() {}
