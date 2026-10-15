import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_route.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/documentation_examples.dart';
import 'package:tdesign_flutter_example/documentation_theme_demo.dart';
import 'package:tdesign_flutter_example/page/theme/theme_function_color_example.dart';
import 'package:tdesign_flutter_example/page/theme/theme_other_color_example.dart';
import 'package:tdesign_flutter_example/page/theme/theme_page.dart';
import 'package:tdesign_flutter_example/page/theme/theme_text_color_example.dart';
import 'package:tdesign_flutter_example/util/web_theme_message.dart';

import '../demo_page_test_utils.dart';

void main() {
  const spec = DemoPageTestSpec(
    name: 'theme',
    title: 'Theme 主题',
    page: TThemeColorsPage(),
    expectedTexts: ['01 颜色示例', '功能色', '文字&图标颜色', '中性色板'],
    componentType: TText,
  );
  registerDemoPageTests(spec);

  setUpAll(() async {
    // 指南内部 MaterialApp 使用默认字体栈；为其中文 fallback 加载测试字体。
    await (FontLoader('Microsoft YaHei')..addFont(
          File(
            'test/fonts/TDesignGoldenCJK-Regular.otf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load();
  });

  const guideSpec = DemoPageTestSpec(
    name: 'custom-theme',
    title: '自定义主题',
    page: DocumentationThemeGuidePage(),
    expectedTexts: ['JSON 配置', '组件局部样式', '明暗模式'],
    goldenDirectory: 'theme',
  );
  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('custom theme guide ${mode.name} whole page golden', (
      tester,
    ) async {
      await pumpFullDemoPage(tester, guideSpec, mode);
      await _expectGuideGolden(tester, 'custom_theme_initial_${mode.name}.png');
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
  for (final followSystem in [false, true]) {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      testWidgets(
        'custom theme guide ${followSystem ? 'system' : 'manual'} ${mode.name} switch golden',
        (tester) async {
          final isDark = mode == ThemeMode.dark;
          tester.platformDispatcher.platformBrightnessTestValue = isDark
              ? Brightness.dark
              : Brightness.light;
          addTearDown(
            tester.platformDispatcher.clearPlatformBrightnessTestValue,
          );
          await pumpFullDemoPage(
            tester,
            guideSpec,
            isDark ? ThemeMode.light : ThemeMode.dark,
          );
          await tester.tap(
            find.text(
              followSystem
                  ? '跟随系统'
                  : isDark
                  ? '深色'
                  : '浅色',
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text('当前外观：${isDark ? '深色' : '浅色'}'), findsNWidgets(2));
          expect(
            find.text('brandColor：#${isDark ? '699EF5' : '0052D9'}'),
            findsNWidgets(2),
          );
          expect(find.textContaining('单元测试'), findsNothing);
          await _expectGuideGolden(
            tester,
            'custom_theme_${followSystem ? 'system' : 'manual'}_${mode.name}.png',
          );
          await disposeDemoPage(tester);
        },
        tags: 'golden',
      );
    }
  }

  testWidgets('Theme Demo lists the current palette keys', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);

    for (final prefix in ['fontGray', 'fontWhite']) {
      for (var index = 1; index <= 4; index++) {
        expect(find.text('$prefix$index'), findsOneWidget);
      }
    }
    for (var index = 1; index <= 14; index++) {
      expect(find.text('grayColor$index'), findsOneWidget);
    }
    expect(find.text('bgColorContainer'), findsOneWidget);
    expect(find.text('whiteColor1'), findsNothing);
    expect(tester.takeException(), isNull);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets(
    'Theme public Demo has the same three source groups in light and dark',
    (tester) async {
      for (final mode in [ThemeMode.light, ThemeMode.dark]) {
        await pumpFullDemoPage(tester, spec, mode);
        expect(find.byType(ThemeFunctionColorExample), findsOneWidget);
        expect(find.byType(ThemeTextColorExample), findsOneWidget);
        expect(find.byType(ThemeOtherColorExample), findsOneWidget);
        expect(tester.takeException(), isNull);
        await disposeDemoPage(tester);
      }
    },
    tags: 'demo',
  );

  testWidgets(
    'theme guide JSON and runtime mode switch change the effective brand token',
    (tester) async {
      final home = Scaffold(
        body: Builder(
          builder: (context) =>
              Text(context.tTheme.brandColor.toARGB32().toRadixString(16)),
        ),
      );
      await tester.pumpWidget(documentationThemeApp(ThemeMode.light, home));
      await tester.pumpAndSettle();
      expect(find.text('ff0052d9'), findsOneWidget);
      await tester.pumpWidget(documentationThemeApp(ThemeMode.dark, home));
      await tester.pumpAndSettle();
      expect(find.text('ff699ef5'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('local theme guide preserves unrelated theme extensions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            final tokens = context.tTheme;
            return documentationLocalTheme(
              context,
              Builder(
                builder: (inner) {
                  expect(inner.tTheme, same(tokens));
                  expect(
                    Theme.of(
                      inner,
                    ).extension<TTagThemeData>()?.squareBorderRadius,
                    6,
                  );
                  return const SizedBox.shrink();
                },
              ),
            );
          },
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'internationalization guide uses current resource context after locale changes',
    (tester) async {
      configureDocumentationResources();
      addTearDown(
        () => setTResourceBuilder((context) => null, needAlwaysBuild: true),
      );
      Widget home() => Scaffold(
        body: Builder(
          builder: (context) =>
              Text(TResourceManager.instance.delegate(context).confirm),
        ),
      );
      await tester.pumpWidget(
        documentationLocalizedApp(const Locale('zh'), home()),
      );
      await tester.pumpAndSettle();
      expect(find.text('确认'), findsOneWidget);
      await tester.pumpWidget(
        documentationLocalizedApp(const Locale('en'), home()),
      );
      await tester.pumpAndSettle();
      expect(find.text('Confirm'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('visible neutral palette refreshes after a custom token change', (
    tester,
  ) async {
    Widget host(Color color) => MaterialApp(
      theme: TThemeBuilder.light(
        TThemeData.defaultData().copyWith(
          name: 'documentation-palette',
          colorMap: {'grayColor1': color},
        ),
      ),
      home: const Scaffold(
        body: SingleChildScrollView(child: ThemeOtherColorExample()),
      ),
    );
    for (final color in [Colors.red, Colors.blue]) {
      await tester.pumpWidget(host(color));
      await tester.pumpAndSettle();
      final swatch = find
          .ancestor(
            of: find.text('grayColor1'),
            matching: find.byType(Container),
          )
          .first;
      expect(tester.widget<Container>(swatch).color, color);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Web incremental themes retain all inherited neutral swatches', (
    tester,
  ) async {
    for (final color in [Colors.red, Colors.blue]) {
      final theme = parseWebThemeUpdateMessage({
        'type': 'flutter-theme-update',
        'theme': {
          'light': {
            'color': {
              'grayColor1': color == Colors.red ? '#f44336' : '#2196f3',
            },
          },
          'dark': {
            'color': {
              'grayColor1': color == Colors.red ? '#f44336' : '#2196f3',
            },
          },
        },
      });
      expect(theme, isNotNull);
      expect(
        theme!.colorMap.keys.where((key) => key.startsWith('grayColor')),
        hasLength(1),
      );
      for (final mode in [ThemeMode.light, ThemeMode.dark]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: TThemeBuilder.light(theme),
            darkTheme: TThemeBuilder.dark(theme),
            themeMode: mode,
            home: const Scaffold(
              body: SingleChildScrollView(child: ThemeOtherColorExample()),
            ),
          ),
        );
        await tester.pumpAndSettle();
        for (var index = 1; index <= 14; index++) {
          final label = find.text('grayColor$index');
          expect(label, findsOneWidget);
          final swatch = tester.widget<Container>(
            find.ancestor(of: label, matching: find.byType(Container)).first,
          );
          expect(
            swatch.color?.toARGB32(),
            (index == 1
                    ? color
                    : (mode == ThemeMode.dark ? theme.dark! : theme)
                          .colorMap['grayColor$index'])
                ?.toARGB32(),
          );
        }
        expect(find.text('bgColorContainer'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets('custom theme guide routes render the shared runnable examples', (
    tester,
  ) async {
    TExampleRoute.init();
    for (final scene in DocumentationThemeScene.values) {
      final name = 'custom-theme-${scene.name}';
      expect(TExampleRoute.pageModelList.containsKey(name), isTrue);
      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey(name),
          initialRoute: name,
          onGenerateRoute: TExampleRoute.onGenerateRoute,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(DocumentationThemeDemo), findsOneWidget);
      if (scene == DocumentationThemeScene.local) {
        final tags = tester.elementList(find.byType(TTag)).toList();
        expect(tags, hasLength(2));
        expect(
          Theme.of(tags[0]).extension<TTagThemeData>()?.squareBorderRadius,
          isNot(6),
        );
        expect(
          Theme.of(tags[1]).extension<TTagThemeData>()?.squareBorderRadius,
          6,
        );
      } else {
        expect(find.text('brandColor：#0052D9'), findsOneWidget);
        expect(find.text('品牌色按钮'), findsOneWidget);
        expect(find.text('品牌色标签'), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('custom theme guide switches light dark and system modes', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await tester.pumpWidget(
      const DocumentationThemeDemo(scene: DocumentationThemeScene.mode),
    );
    await tester.pumpAndSettle();
    expect(find.text('brandColor：#0052D9'), findsOneWidget);
    await tester.tap(find.text('深色'));
    await tester.pumpAndSettle();
    expect(find.text('brandColor：#699EF5'), findsOneWidget);
    expect(find.text('当前外观：深色'), findsOneWidget);
    await tester.tap(find.text('跟随系统'));
    await tester.pumpAndSettle();
    expect(find.text('当前外观：浅色'), findsOneWidget);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(find.text('当前外观：深色'), findsOneWidget);
    await tester.tap(find.text('浅色'));
    await tester.pumpAndSettle();
    expect(find.text('brandColor：#0052D9'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('custom theme guide shares the component ExamplePage structure', (
    tester,
  ) async {
    TExampleRoute.init();
    final model = TExampleRoute.pageModelList['custom-theme'];
    expect(model, isNotNull);
    final spec = DemoPageTestSpec(
      name: 'custom-theme',
      title: '自定义主题',
      page: Builder(builder: (context) => model!.pageBuilder(context, model)),
      expectedTexts: const ['JSON 配置', '组件局部样式', '明暗模式'],
    );
    await pumpFullDemoPage(tester, spec, ThemeMode.light);
    final page = tester.widget<ExamplePage>(find.byType(ExamplePage));
    expect(page.children.map((module) => module.title), [
      'JSON 配置',
      '组件局部样式',
      '明暗模式',
    ]);
    expect(find.byType(DocumentationThemeContent), findsNWidgets(3));
    expect(find.text('brandColor：#0052D9'), findsNWidgets(2));
    await tester.tap(find.text('深色'));
    await tester.pumpAndSettle();
    expect(find.text('brandColor：#699EF5'), findsNWidgets(2));
    expect(find.text('brandColor：#0052D9'), findsNothing);
    expect(find.text('当前模式：深色'), findsOneWidget);
    final defaults = TThemeData.defaultData().dark!;
    final pageScaffold = tester.widget<Scaffold>(
      find
          .descendant(
            of: find.byType(ExamplePage),
            matching: find.byType(Scaffold),
          )
          .first,
    );
    expect(pageScaffold.backgroundColor, defaults.bgColorPage);
    for (final scene in DocumentationThemeScene.values) {
      final finder = find.byKey(ValueKey('theme-scene-${scene.name}'));
      expect(
        tester.widget<ColoredBox>(finder).color,
        defaults.bgColorContainer,
      );
      final context = tester.element(finder);
      expect(Theme.of(context).brightness, Brightness.dark);
      expect(context.tTheme.textColorPrimary, defaults.textColorPrimary);
    }
    await tester.tap(find.text('浅色'));
    await tester.pumpAndSettle();
    expect(find.text('brandColor：#0052D9'), findsNWidgets(2));
    expect(find.text('brandColor：#699EF5'), findsNothing);
    expect(tester.takeException(), isNull);
    await disposeDemoPage(tester);
  });

  testWidgets(
    'custom theme guide initially follows and updates with the host appearance',
    (tester) async {
      Widget host(bool dark) => MaterialApp(
        theme: dark
            ? TThemeBuilder.dark(TThemeData.defaultData())
            : TThemeBuilder.light(TThemeData.defaultData()),
        home: const DocumentationThemeDemo(scene: DocumentationThemeScene.mode),
      );
      for (final dark in [true, false, true]) {
        await tester.pumpWidget(host(dark));
        await tester.pumpAndSettle();
        final defaults = dark
            ? TThemeData.defaultData().dark!
            : TThemeData.defaultData();
        final finder = find.byKey(const ValueKey('theme-scene-mode'));
        expect(
          tester.widget<ColoredBox>(finder).color,
          defaults.bgColorContainer,
        );
        expect(
          Theme.of(tester.element(finder)).brightness,
          dark ? Brightness.dark : Brightness.light,
        );
        expect(find.text('当前模式：${dark ? '深色' : '浅色'}'), findsOneWidget);
        expect(
          find.text('主题配置：${dark ? 'oceanDark' : 'ocean'}'),
          findsOneWidget,
        );
      }
    },
  );

  testWidgets(
    'guide compares actual light and dark token values at phone width',
    (tester) async {
      tester.view.physicalSize = const Size(320, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final dark in [false, true]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: dark
                ? TThemeBuilder.dark(TThemeData.defaultData())
                : TThemeBuilder.light(TThemeData.defaultData()),
            home: const DocumentationThemeDemo(
              scene: DocumentationThemeScene.json,
            ),
          ),
        );
        await tester.pumpAndSettle();
        final comparison = find.byKey(const ValueKey('theme-token-comparison'));
        expect(comparison, findsOneWidget);
        for (final value in [
          '#0052D9',
          '#699EF5',
          '#F3F3F3',
          '#181818',
          '#FFFFFF',
          '#242424',
          '#E5000000',
          '#E6FFFFFF',
        ]) {
          expect(
            find.descendant(of: comparison, matching: find.text(value)),
            findsOneWidget,
          );
        }
        expect(find.text('brandColor\nJSON 覆盖'), findsOneWidget);
        expect(find.textContaining('默认继承'), findsNWidgets(3));
        expect(
          find.text(dark ? '深色（当前）\noceanDark' : '浅色（当前）\nocean'),
          findsOneWidget,
        );
        final scene = find.byKey(const ValueKey('theme-scene-json'));
        final activeTokens = tester.element(scene).tTheme;
        final activeBg = dark ? '#181818' : '#F3F3F3';
        final activeText = dark ? '#E6FFFFFF' : '#E5000000';
        expect(
          activeTokens.bgColorPage.toARGB32(),
          int.parse('FF${activeBg.substring(1)}', radix: 16),
        );
        expect(
          activeTokens.textColorPrimary.toARGB32(),
          int.parse(activeText.substring(1), radix: 16),
        );
        expect(tester.getSize(comparison).width, lessThanOrEqualTo(320));
        expect(tester.takeException(), isNull);
      }
    },
  );
}

Future<void> _expectGuideGolden(WidgetTester tester, String name) async {
  final target = find.byKey(const ValueKey('custom-theme-demo-page'));
  final golden = File('test/theme/goldens/$name');
  if (!golden.existsSync()) {
    // 首次 Linux 验收保留实际图供核对，缺失基线仍然报错，不自动批准。
    await tester.runAsync(() async {
      final boundary = tester.renderObject<RenderRepaintBoundary>(target);
      final image = await boundary.toImage();
      try {
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        final actual = File(
          'test/theme/failures/${name.replaceAll('.png', '')}_actual.png',
        );
        await actual.parent.create(recursive: true);
        await actual.writeAsBytes(
          data!.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        );
      } finally {
        image.dispose();
      }
    });
  }
  await expectLater(target, matchesGoldenFile('goldens/$name'));
}
