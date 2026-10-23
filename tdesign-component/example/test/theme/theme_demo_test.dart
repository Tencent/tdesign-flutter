import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_route.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/documentation_examples.dart';
import 'package:tdesign_flutter_example/documentation_quick_start.dart';
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
    final flutterBin = File(
      Platform.resolvedExecutable,
    ).parent.parent.parent.parent.parent;
    await (FontLoader('monospace')..addFont(
          File(
            '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
          ).readAsBytes().then(ByteData.sublistView),
        ))
        .load();
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
    page: ThemeGuidePage(themeAdapter: _guideGoldenTheme),
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
  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('custom theme guide default ${mode.name} switch golden', (
      tester,
    ) async {
      await pumpFullDemoPage(tester, guideSpec, mode);
      await tester.tap(find.text('默认主题'));
      await tester.pumpAndSettle();
      await _expectGuideGolden(tester, 'custom_theme_default_${mode.name}.png');
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final clicked in [false, true]) {
      testWidgets(
        'quick start preview ${mode.name} ${clicked ? 'clicked' : 'initial'} golden',
        (tester) async {
          tester.view.physicalSize = const Size(375, 600);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          await tester.runAsync(() => loadDemoGoldenFonts(guideSpec));
          final tokens = TThemeData.defaultData();
          await tester.pumpWidget(
            RepaintBoundary(
              key: const ValueKey('quick-start-preview'),
              child: MaterialApp(
                theme: _guideGoldenTheme(
                  mode == ThemeMode.dark
                      ? TThemeBuilder.dark(tokens)
                      : TThemeBuilder.light(tokens),
                ),
                home: const CounterPage(),
              ),
            ),
          );
          await tester.pumpAndSettle();
          if (clicked) {
            await tester.tap(find.text('点击次数：0'));
            await tester.pumpAndSettle();
          }
          await _expectGuideGolden(
            tester,
            'quick_start_${mode.name}_${clicked ? 'clicked' : 'initial'}.png',
            boundaryKey: 'quick-start-preview',
          );
        },
        tags: 'golden',
      );
    }
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
            find.text('brandColor：#${isDark ? '56C08D' : '16875D'}'),
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
    'functional palettes allow unequal groups and refresh with theme',
    (tester) async {
      Widget host(TThemeData tokens) => MaterialApp(
        theme: ThemeData(extensions: [tokens]),
        home: const Scaffold(
          body: SingleChildScrollView(child: ThemeFunctionColorExample()),
        ),
      );
      for (final dark in [false, true]) {
        final defaults = TThemeData.defaultData();
        final tokens = (dark ? defaults.dark! : defaults).copyWith(
          name: 'unequal-palette',
          colorMap: {
            'brandBusiness': dark ? Colors.greenAccent : Colors.green,
            'brandAdditional': Colors.purple,
          },
        );
        await tester.pumpWidget(host(tokens));
        await tester.pumpAndSettle();
        for (final prefix in ['brand', 'error', 'warning', 'success']) {
          for (var index = 1; index <= 10; index++) {
            expect(find.text('${prefix}Color$index'), findsOneWidget);
          }
        }
        for (final key in ['brandBusiness', 'brandAdditional', 'errorColor']) {
          final label = find.text(key);
          expect(label, findsOneWidget);
          final row = tester.widget<Container>(
            find.ancestor(of: label, matching: find.byType(Container)).first,
          );
          expect(row.color, tokens.colorMap[key]);
        }
        expect(find.text('功能色数量不一样'), findsNothing);
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets(
    'sparse functional palettes render actual keys and resolve aliases',
    (tester) async {
      final tokens = TThemeData.defaultData().copyWith(name: 'sparse-palette');
      tokens.refMap = TMap<String, String>()..['brandAlias'] = 'brandColor12';
      tokens.colorMap = TMap<String, Color>(refs: tokens.refMap)
        ..addAll({
          'brandColor2': Colors.red,
          'brandColor12': Colors.purple,
          'successBusiness': Colors.green,
        });
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [tokens]),
          home: const Scaffold(
            body: SingleChildScrollView(child: ThemeFunctionColorExample()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.widgetList<TText>(find.byType(TText)).map((text) => text.data),
        ['brandColor2', 'brandColor12', 'brandAlias', 'successBusiness'],
      );
      final alias = tester.widget<Container>(
        find
            .ancestor(
              of: find.text('brandAlias'),
              matching: find.byType(Container),
            )
            .first,
      );
      expect(alias.color, Colors.purple);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('empty functional palettes do not invent numbered colors', (
    tester,
  ) async {
    final tokens = TThemeData.defaultData().copyWith(name: 'empty-palette');
    tokens.refMap = TMap<String, String>();
    tokens.colorMap = TMap<String, Color>();
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [tokens]),
        home: const Scaffold(
          body: SingleChildScrollView(child: ThemeFunctionColorExample()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(TText), findsNothing);
    expect(tester.takeException(), isNull);
  });

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
      await tester.pumpWidget(buildThemeApp(ThemeMode.light, home));
      await tester.pumpAndSettle();
      expect(find.text('ff16875d'), findsOneWidget);
      await tester.pumpWidget(buildThemeApp(ThemeMode.dark, home));
      await tester.pumpAndSettle();
      expect(find.text('ff56c08d'), findsOneWidget);
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
            return wrapLocalTheme(
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
      configureResources();
      addTearDown(
        () => setTResourceBuilder((context) => null, needAlwaysBuild: true),
      );
      Widget home() => Scaffold(
        body: Builder(
          builder: (context) =>
              Text(TResourceManager.instance.delegate(context).confirm),
        ),
      );
      await tester.pumpWidget(buildLocalizedApp(const Locale('zh'), home()));
      await tester.pumpAndSettle();
      expect(find.text('确认'), findsOneWidget);
      await tester.pumpWidget(buildLocalizedApp(const Locale('en'), home()));
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
    for (final scene in ThemeScene.values) {
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
      expect(find.byType(ThemeDemo), findsOneWidget);
      if (scene == ThemeScene.local) {
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
        expect(find.text('brandColor：#16875D'), findsOneWidget);
        expect(find.text('品牌色按钮'), findsOneWidget);
        expect(find.text('品牌色标签'), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets(
    'business and default themes update every scene and preserve input',
    (tester) async {
      await pumpFullDemoPage(tester, guideSpec, ThemeMode.light);
      MaterialApp previewApp() => tester.widget<MaterialApp>(
        find.descendant(
          of: find.byType(ThemeGuidePage),
          matching: find.byType(MaterialApp),
        ),
      );
      final businessTokens = previewApp().theme!.extension<TThemeData>();
      final businessDarkTokens = previewApp().darkTheme!
          .extension<TThemeData>();
      final input = find.byType(TInput).first;
      await tester.enterText(
        find.descendant(of: input, matching: find.byType(EditableText)),
        '海边步道',
      );
      await tester.tap(find.text('品牌色按钮').first);
      await tester.pumpAndSettle();
      expect(find.text('已保存'), findsOneWidget);
      for (final business in [false, true]) {
        await tester.tap(find.text(business ? '业务主题' : '默认主题'));
        await tester.pumpAndSettle();
        for (final dark in [false, true]) {
          await tester.tap(find.text(dark ? '深色' : '浅色'));
          await tester.pumpAndSettle();
          if (business) {
            expect(
              previewApp().theme!.extension<TThemeData>(),
              same(businessTokens),
            );
            expect(
              previewApp().darkTheme!.extension<TThemeData>(),
              same(businessDarkTokens),
            );
          }
          final selected = business ? createTheme() : TThemeData.defaultData();
          final tokens = dark ? selected.dark! : selected;
          for (final type in [TButton, TTag, TInput]) {
            for (final context in tester.elementList(find.byType(type))) {
              expect(context.tTheme.brandColor, tokens.brandColor);
              expect(context.tTheme.textColorPrimary, tokens.textColorPrimary);
            }
          }
          for (final card in tester.widgetList<Container>(
            find.byKey(const ValueKey('business-theme-card')),
          )) {
            final decoration = card.decoration! as BoxDecoration;
            expect(decoration.color, tokens.bgColorPage);
            expect(
              (decoration.border! as Border).top.color,
              tokens.componentBorder,
            );
          }
          expect(find.text('海边步道'), findsOneWidget);
          expect(find.text('已保存'), findsOneWidget);
          expect(tester.takeException(), isNull);
        }
      }
      await disposeDemoPage(tester);
    },
  );

  testWidgets('custom theme guide switches light dark and system modes', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await tester.pumpWidget(const ThemeDemo(scene: ThemeScene.mode));
    await tester.pumpAndSettle();
    final initialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    final businessTokens = initialApp.theme!.extension<TThemeData>();
    final businessDarkTokens = initialApp.darkTheme!.extension<TThemeData>();
    expect(find.text('brandColor：#16875D'), findsOneWidget);
    await tester.tap(find.text('深色'));
    await tester.pumpAndSettle();
    expect(find.text('brandColor：#56C08D'), findsOneWidget);
    expect(find.text('当前外观：深色'), findsOneWidget);
    await tester.tap(find.text('跟随系统'));
    await tester.pumpAndSettle();
    expect(find.text('当前外观：浅色'), findsOneWidget);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(find.text('当前外观：深色'), findsOneWidget);
    await tester.tap(find.text('浅色'));
    await tester.pumpAndSettle();
    expect(find.text('brandColor：#16875D'), findsOneWidget);
    final rebuiltApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(rebuiltApp.theme!.extension<TThemeData>(), same(businessTokens));
    expect(
      rebuiltApp.darkTheme!.extension<TThemeData>(),
      same(businessDarkTokens),
    );
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
    expect(find.byType(ThemeContent), findsNWidgets(3));
    expect(find.text('brandColor：#16875D'), findsNWidgets(2));
    await tester.tap(find.text('深色'));
    await tester.pumpAndSettle();
    expect(find.text('brandColor：#56C08D'), findsNWidgets(2));
    expect(find.text('brandColor：#16875D'), findsNothing);
    expect(find.text('当前模式：深色'), findsOneWidget);
    final defaults = createTheme().dark!;
    final pageScaffold = tester.widget<Scaffold>(
      find
          .descendant(
            of: find.byType(ExamplePage),
            matching: find.byType(Scaffold),
          )
          .first,
    );
    expect(pageScaffold.backgroundColor, defaults.bgColorPage);
    for (final scene in ThemeScene.values) {
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
    expect(find.text('brandColor：#16875D'), findsNWidgets(2));
    expect(find.text('brandColor：#56C08D'), findsNothing);
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
        home: const ThemeDemo(scene: ThemeScene.mode),
      );
      for (final dark in [true, false, true]) {
        await tester.pumpWidget(host(dark));
        await tester.pumpAndSettle();
        final defaults = dark ? createTheme().dark! : createTheme();
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
          find.text('主题配置：${dark ? 'greenDark' : 'green'}'),
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
            home: const ThemeDemo(scene: ThemeScene.json),
          ),
        );
        await tester.pumpAndSettle();
        final comparison = find.byKey(const ValueKey('theme-token-comparison'));
        expect(comparison, findsOneWidget);
        for (final value in [
          '#16875D',
          '#56C08D',
          '#EFF7F2',
          '#101F18',
          '#FFFFFF',
          '#192E23',
          '#183C2C',
          '#E2F3E9',
        ]) {
          expect(
            find.descendant(of: comparison, matching: find.text(value)),
            findsOneWidget,
          );
        }
        expect(find.text('brandColor\n主题配置'), findsOneWidget);
        expect(find.textContaining('主题配置'), findsNWidgets(5));
        expect(
          find.text(dark ? '深色（当前）\ngreenDark' : '浅色（当前）\ngreen'),
          findsOneWidget,
        );
        final scene = find.byKey(const ValueKey('theme-scene-json'));
        final activeTokens = tester.element(scene).tTheme;
        final activeBg = dark ? '#101F18' : '#EFF7F2';
        final activeText = dark ? '#E2F3E9' : '#183C2C';
        expect(
          activeTokens.bgColorPage.toARGB32(),
          int.parse('FF${activeBg.substring(1)}', radix: 16),
        );
        expect(
          activeTokens.textColorPrimary.toARGB32(),
          int.parse('FF${activeText.substring(1)}', radix: 16),
        );
        expect(tester.getSize(comparison).width, lessThanOrEqualTo(320));
        expect(tester.takeException(), isNull);
      }
    },
  );

  testWidgets(
    'guide golden fonts preserve token pairs and reach native table text',
    (tester) async {
      await pumpFullDemoPage(tester, guideSpec, ThemeMode.light);
      for (final value in ['#16875D', '#56C08D', '配置项 / 来源']) {
        final paragraph = tester.renderObject<RenderParagraph>(
          find.text(value),
        );
        expect(
          paragraph.text.style?.fontFamilyFallback,
          containsAll(['Roboto', 'TDesign Golden CJK']),
        );
      }
      expect(find.text('浅色（当前）\ngreen'), findsOneWidget);
      expect(find.text('深色\ngreenDark'), findsOneWidget);
      await disposeDemoPage(tester);
    },
  );
}

Future<void> _expectGuideGolden(
  WidgetTester tester,
  String name, {
  String boundaryKey = 'custom-theme-demo-page',
}) async {
  final target = find.byKey(ValueKey(boundaryKey));
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

ThemeData _guideGoldenTheme(ThemeData theme) {
  const fallback = ['Roboto', 'TDesign Golden CJK'];
  return theme.copyWith(
    textTheme: theme.textTheme.apply(
      fontFamily: 'Roboto',
      fontFamilyFallback: fallback,
    ),
    primaryTextTheme: theme.primaryTextTheme.apply(
      fontFamily: 'Roboto',
      fontFamilyFallback: fallback,
    ),
  );
}
