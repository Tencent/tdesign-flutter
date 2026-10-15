import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/documentation_examples.dart';
import 'package:tdesign_flutter_example/page/theme/theme_function_color_example.dart';
import 'package:tdesign_flutter_example/page/theme/theme_other_color_example.dart';
import 'package:tdesign_flutter_example/page/theme/theme_page.dart';
import 'package:tdesign_flutter_example/page/theme/theme_text_color_example.dart';

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
}
