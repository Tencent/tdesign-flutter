import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_base.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

const _pageWidth = 375.0;
const _initialPageHeight = 812.0;
const _maxPageHeight = 12000.0;
const _goldenCjkFontFamily = 'TDesign Golden CJK';
const _feedbackGoldenCjkFontFamily = 'TDesign Feedback Golden CJK';
const _alignmentCjkFontFamily = 'TDesign Alignment CJK';

class DemoPageTestSpec {
  const DemoPageTestSpec({
    required this.name,
    required this.title,
    required this.page,
    required this.expectedTexts,
    this.componentType,
    this.expectedComponentCount,
    this.useFeedbackGoldenFont = false,
    this.useAlignmentCjkFont = false,
  });

  final String name;
  final String title;
  final Widget page;
  final List<String> expectedTexts;
  final Type? componentType;
  final int? expectedComponentCount;
  final bool useFeedbackGoldenFont;
  final bool useAlignmentCjkFont;
}

void registerDemoPageTests(DemoPageTestSpec spec) {
  registerDemoStructureTests(spec);
  registerDemoGoldenTests(spec);
}

void registerDemoStructureTests(DemoPageTestSpec spec) {
  setUpAll(() => _loadGoldenFonts(spec));

  testWidgets('${spec.name} Demo structure', (tester) async {
    await pumpFullDemoPage(tester, spec, ThemeMode.light);

    for (final text in spec.expectedTexts) {
      expect(
        find.text(text),
        findsAtLeastNWidgets(1),
        reason: '${spec.name}: $text',
      );
    }
    if (spec.componentType case final componentType?) {
      final count = spec.expectedComponentCount;
      expect(
        find.byType(componentType),
        count == null ? findsAtLeastNWidgets(1) : findsNWidgets(count),
      );
    }
    expect(tester.takeException(), isNull);
    await disposeDemoPage(tester);
  }, tags: 'demo');
}

void registerDemoGoldenTests(DemoPageTestSpec spec) {
  setUpAll(() => _loadGoldenFonts(spec));

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('${spec.name} ${mode.name} Demo golden', (tester) async {
      await pumpFullDemoPage(tester, spec, mode);

      await expectLater(
        find.byKey(ValueKey('${spec.name}-demo-page')),
        matchesGoldenFile('goldens/${spec.name}_page_${mode.name}.png'),
      );
      await disposeDemoPage(tester);
    }, tags: 'golden');
  }
}

Future<void> disposeDemoPage(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 1));
}

Future<void> _loadGoldenFonts(DemoPageTestSpec spec) async {
  final iconFont = FontLoader('packages/tdesign_flutter_icons/TIcons')
    ..addFont(rootBundle.load('packages/tdesign_flutter_icons/fonts/t.ttf'));
  final cupertinoIconFont =
      FontLoader('packages/cupertino_icons/CupertinoIcons')..addFont(
        rootBundle.load('packages/cupertino_icons/assets/CupertinoIcons.ttf'),
      );
  final flutterBin = File(
    Platform.resolvedExecutable,
  ).parent.parent.parent.parent.parent;
  final robotoFont = FontLoader('Roboto')
    ..addFont(
      File(
        '${flutterBin.path}/cache/artifacts/material_fonts/Roboto-Regular.ttf',
      ).readAsBytes().then(ByteData.sublistView),
    );
  final cjkFont = FontLoader(_goldenCjkFontFamily)
    ..addFont(
      File(
        'test/fonts/TDesignGoldenCJK-Regular.otf',
      ).readAsBytes().then(ByteData.sublistView),
    );
  final loaders = <Future<void>>[
    iconFont.load(),
    cupertinoIconFont.load(),
    robotoFont.load(),
    cjkFont.load(),
  ];
  if (spec.useFeedbackGoldenFont) {
    final materialIconsFont = FontLoader('MaterialIcons')
      ..addFont(
        File(
          '${flutterBin.path}/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
        ).readAsBytes().then(ByteData.sublistView),
      );
    final feedbackCjkFont = FontLoader(_feedbackGoldenCjkFontFamily)
      ..addFont(
        File(
          'test/fonts/TDesignFeedbackGoldenCJK-Regular.otf',
        ).readAsBytes().then(ByteData.sublistView),
      );
    loaders.addAll([materialIconsFont.load(), feedbackCjkFont.load()]);
  }
  if (spec.useAlignmentCjkFont) {
    final alignmentCjkFont = FontLoader(_alignmentCjkFontFamily)
      ..addFont(
        File(
          'test/fonts/TDesignAlignmentCJK-Regular.otf',
        ).readAsBytes().then(ByteData.sublistView),
      );
    loaders.add(alignmentCjkFont.load());
  }
  await Future.wait(loaders);
}

Future<void> pumpFullDemoPage(
  WidgetTester tester,
  DemoPageTestSpec spec,
  ThemeMode mode,
) async {
  var height = _initialPageHeight;
  for (var attempt = 0; attempt < 4; attempt++) {
    tester.view.physicalSize = Size(_pageWidth, height);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(_buildPage(spec, mode));
    await tester.pump();

    final scrollables = find.byType(CustomScrollView);
    if (scrollables.evaluate().isEmpty) {
      break;
    }
    final scrollable = find.descendant(
      of: scrollables.first,
      matching: find.byType(Scrollable),
    );
    final extent = tester
        .state<ScrollableState>(scrollable.first)
        .position
        .maxScrollExtent;
    if (extent <= 0.01) {
      break;
    }
    height = (height + extent).clamp(_initialPageHeight, _maxPageHeight);
  }
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> pumpDemoPageAtPhoneViewport(
  WidgetTester tester,
  DemoPageTestSpec spec,
  ThemeMode mode,
) async {
  tester.view.physicalSize = const Size(_pageWidth, _initialPageHeight);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(_buildPage(spec, mode));
  await tester.pump();
}

Widget _buildPage(DemoPageTestSpec spec, ThemeMode mode) {
  final model = ExamplePageModel(
    text: spec.title,
    name: spec.name,
    pageBuilder: (_, __) => spec.page,
  );
  return ChangeNotifierProvider(
    create: (_) => ThemeModeProvider(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _withGoldenFonts(
        TThemeBuilder.light(TThemeData.defaultData()),
        spec,
      ),
      darkTheme: _withGoldenFonts(
        TThemeBuilder.dark(TThemeData.defaultData()),
        spec,
      ),
      themeMode: mode,
      home: RepaintBoundary(
        key: ValueKey('${spec.name}-demo-page'),
        child: ExamplePageInheritedTheme(model: model, child: spec.page),
      ),
    ),
  );
}

ThemeData _withGoldenFonts(ThemeData theme, DemoPageTestSpec spec) {
  final fallback = [
    if (spec.useFeedbackGoldenFont) _feedbackGoldenCjkFontFamily,
    _goldenCjkFontFamily,
    if (spec.useAlignmentCjkFont) _alignmentCjkFontFamily,
  ];
  return theme.copyWith(
    textTheme: theme.textTheme.apply(fontFamilyFallback: fallback),
    primaryTextTheme: theme.primaryTextTheme.apply(
      fontFamilyFallback: fallback,
    ),
  );
}
