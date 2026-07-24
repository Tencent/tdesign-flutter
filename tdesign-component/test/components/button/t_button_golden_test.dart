import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// TButton P0 Golden 测试
///
/// 覆盖 primary 默认态、danger、disabled、纯 icon + circle 等关键态。
/// 首次运行用 `flutter test --update-goldens` 生成基线。
void main() {
  Widget wrapWithTheme(Widget child, {TButtonThemeData? buttonTheme}) {
    return MaterialApp(
      theme: ThemeData(extensions: [
        TThemeData.defaultData(),
        if (buttonTheme != null) buttonTheme,
      ]),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: child),
      ),
    );
  }

  // golden 基线在 Windows 上生成；Linux/WSL 字体渲染与 Windows 有像素级差异，
  // 跨平台比对会失败，故非 Windows 平台跳过整组（源码行已被非 golden 测试覆盖）。
  group('TButton Golden', () {
    testWidgets('primary 默认态', (tester) async {
      tester.view.physicalSize = const Size(400, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(wrapWithTheme(
        const TButton(
          child: Text('按钮'),
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.primary,
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
          child: Text('危险'),
          variant: TButtonVariant.fill,
          colorScheme: TButtonColorScheme.danger,
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
          child: Text('禁用'),
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
          child: Text('描边'),
          variant: TButtonVariant.outline,
          colorScheme: TButtonColorScheme.primary,
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
          child: Text('文字'),
          variant: TButtonVariant.text,
          colorScheme: TButtonColorScheme.primary,
        ),
      ));
      await expectLater(
        find.byType(TButton),
        matchesGoldenFile('goldens/t_button_text.png'),
      );
    });
  }, skip: !Platform.isWindows);
}
