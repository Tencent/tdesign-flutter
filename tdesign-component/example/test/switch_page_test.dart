import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_base.dart';
import 'package:tdesign_flutter_example/page/t_switch_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

import 'golden_test_utils.dart';

const _pageWidth = 375.0;
const _pageHeight = 1320.0;
const _goldenCjkFontFamily = 'TDesign Golden CJK';
const _nonLinuxPreviewDiffRate = 0.05;

void main() {
  late GoldenFileComparator originalGoldenComparator;

  setUpAll(() async {
    originalGoldenComparator = Platform.isLinux
        ? goldenFileComparator
        : useGoldenDiffTolerance(maxDiffRate: _nonLinuxPreviewDiffRate);
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
    final cjkFont = FontLoader(_goldenCjkFontFamily)
      ..addFont(
        File(
          'test/fonts/TDesignGoldenCJK-Regular.otf',
        ).readAsBytes().then(ByteData.sublistView),
      );
    await Future.wait([iconFont.load(), robotoFont.load(), cjkFont.load()]);
  });
  tearDownAll(() {
    goldenFileComparator = originalGoldenComparator;
  });

  Widget buildPage([ThemeMode mode = ThemeMode.light]) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModeProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _withGoldenFontFallback(
          TThemeBuilder.light(TThemeData.defaultData()),
        ),
        darkTheme: _withGoldenFontFallback(
          TThemeBuilder.dark(TThemeData.defaultData()),
        ),
        themeMode: mode,
        home: RepaintBoundary(
          key: const Key('switch-page-golden'),
          child: ExamplePageInheritedTheme(
            model: ExamplePageModel(
              text: 'Switch 开关',
              name: 'switch',
              pageBuilder: (_, __) => const TSwitchPage(),
            ),
            child: const TSwitchPage(),
          ),
        ),
      ),
    );
  }

  void configurePage(WidgetTester tester) {
    tester.view.physicalSize = const Size(_pageWidth, _pageHeight);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> pumpPage(
    WidgetTester tester, [
    ThemeMode mode = ThemeMode.light,
  ]) async {
    configurePage(tester);
    await tester.pumpWidget(buildPage(mode));
    await tester.pump();
  }

  testWidgets('Switch 示例按小程序分组展示类型、状态和尺寸', (tester) async {
    await pumpPage(tester);

    expect(find.text('01 组件类型'), findsOneWidget);
    expect(find.text('02 组件状态'), findsOneWidget);
    expect(find.text('03 组件样式'), findsOneWidget);
    expect(find.text('04 单元测试'), findsNothing);
    expect(find.text('基础开关'), findsNWidgets(2));
    expect(find.text('带描述开关'), findsOneWidget);
    expect(find.text('自定义颜色开关'), findsNWidgets(2));
    expect(find.text('开关尺寸'), findsOneWidget);
    expect(find.text('大尺寸 32'), findsOneWidget);
    expect(find.text('中尺寸 28'), findsOneWidget);
    expect(find.text('小尺寸 24'), findsOneWidget);
    for (final key in const [
      'switch-demo-basic',
      'switch-demo-label',
      'switch-demo-color',
      'switch-demo-status',
      'switch-demo-sizes',
    ]) {
      expect(find.byKey(Key(key)), findsOneWidget);
    }
    expect(find.byType(TCellGroup), findsNWidgets(4));
    expect(find.byType(TSwitch), findsNWidgets(11));

    final scrollable = tester.state<ScrollableState>(
      find.descendant(
        of: find.byType(CustomScrollView),
        matching: find.byType(Scrollable),
      ),
    );
    expect(scrollable.position.maxScrollExtent, 0);
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
      TThemeData.defaultData().bgColorPage,
    );
  });

  testWidgets('Switch 示例包含文字、图标、加载和禁用状态', (tester) async {
    await pumpPage(tester);

    final switches = tester.widgetList<TSwitch>(find.byType(TSwitch)).toList();
    final variants = switches.map((widget) => widget.variant).toSet();
    final loadingValues = switches
        .where((widget) => widget.variant == TSwitchVariant.loading)
        .map((widget) => widget.value)
        .toSet();
    final disabledValues = switches
        .where((widget) => widget.variant == null && widget.onChanged == null)
        .map((widget) => widget.value)
        .toSet();

    expect(variants, contains(TSwitchVariant.text));
    expect(variants, contains(TSwitchVariant.icon));
    expect(loadingValues, containsAll(const [false, true]));
    expect(disabledValues, containsAll(const [false, true]));

    final basic = find.descendant(
      of: find.byKey(const Key('switch-demo-basic')),
      matching: find.byType(TSwitch),
    );
    expect(tester.widget<TSwitch>(basic).value, isTrue);
    await tester.tap(basic);
    await tester.pump();
    expect(tester.widget<TSwitch>(basic).value, isFalse);

    final sizes = tester
        .widgetList<TSwitch>(
          find.descendant(
            of: find.byKey(const Key('switch-demo-sizes')),
            matching: find.byType(TSwitch),
          ),
        )
        .toList();
    expect(sizes.map((widget) => widget.size), [
      TSwitchSize.large,
      null,
      TSwitchSize.small,
    ]);
  });

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('完整 Switch ${mode.name} Demo 快照', (tester) async {
      await pumpPage(tester, mode);

      final page = find.byKey(const Key('switch-page-golden'));
      expect(page, findsOneWidget);
      final boundary = tester.renderObject<RenderRepaintBoundary>(page);
      final image = await boundary.toImage();
      addTearDown(image.dispose);

      await expectLater(
        image,
        matchesGoldenFile('goldens/switch_page_${mode.name}.png'),
      );
    });
  }
}

ThemeData _withGoldenFontFallback(ThemeData theme) {
  const fallback = [_goldenCjkFontFamily];
  return theme.copyWith(
    textTheme: theme.textTheme.apply(fontFamilyFallback: fallback),
    primaryTextTheme: theme.primaryTextTheme.apply(
      fontFamilyFallback: fallback,
    ),
  );
}
