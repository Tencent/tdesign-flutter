import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_base.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/l10n/app_localizations.dart';
import 'package:tdesign_flutter_example/page/t_radio_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

import '../demo_page_test_utils.dart';

const _radioDemoSpec = DemoPageTestSpec(
  name: 'radio',
  title: 'Radio 单选框',
  page: TRadioPage(),
  expectedTexts: [],
  supplementalCjkFontFamily: 'Radio Golden CJK',
  supplementalCjkFontPath: 'test/fonts/RadioGoldenCJK-Regular.otf',
);

void main() {
  setUpAll(() => loadDemoGoldenFonts(_radioDemoSpec));
  Widget buildPage(ThemeMode mode) {
    return RepaintBoundary(
      key: const Key('radio-page-golden'),
      child: ChangeNotifierProvider(
        create: (_) => ThemeModeProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: const Locale('zh', 'CN'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.noScaling),
            child: child!,
          ),
          theme: _withRadioGoldenFonts(
            TThemeBuilder.light(TThemeData.defaultData()),
          ),
          darkTheme: _withRadioGoldenFonts(
            TThemeBuilder.dark(TThemeData.defaultData()),
          ),
          themeMode: mode,
          home: ExamplePageInheritedTheme(
            model: ExamplePageModel(
              text: 'Radio 单选框',
              name: 'radio',
              pageBuilder: (_, __) => const TRadioPage(),
            ),
            child: const TRadioPage(),
          ),
        ),
      ),
    );
  }

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('Radio Demo ${mode.name} 整页视觉快照', (tester) async {
      tester.view.physicalSize = const Size(375, 2600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildPage(mode));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byKey(const Key('radio-page-golden')),
        matchesGoldenFile('goldens/radio_page_${mode.name}.png'),
      );
    });

    testWidgets('Radio Demo ${mode.name} selected golden', (tester) async {
      tester.view.physicalSize = const Size(375, 2600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildPage(mode));
      await tester.pump();
      final group = find.byType(TRadioGroup<int>).first;
      final radios = find.descendant(
        of: group,
        matching: find.byType(TRadio<int>),
      );
      await tester.tap(radios.last);
      await tester.pump();

      expect(tester.widget<TRadioGroup<int>>(group).value, 3);
      await expectLater(
        find.byKey(const Key('radio-page-golden')),
        matchesGoldenFile('goldens/radio_selected_${mode.name}.png'),
      );
    });
  }
}

ThemeData _withRadioGoldenFonts(ThemeData theme) {
  const fallback = ['Radio Golden CJK', 'TDesign Golden CJK'];
  return theme.copyWith(
    textTheme: theme.textTheme.apply(fontFamilyFallback: fallback),
    primaryTextTheme: theme.primaryTextTheme.apply(
      fontFamilyFallback: fallback,
    ),
  );
}
