import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_base.dart';
import 'package:tdesign_flutter_example/page/fab/fab_page.dart';
import 'package:tdesign_flutter_example/provider/theme_mode_provider.dart';

import 'demo_page_test_utils.dart';
import 'support/review_golden.dart';

const _spec = DemoPageTestSpec(
  name: 'code-viewer',
  title: 'Fab 悬浮按钮',
  page: TFabPage(),
  expectedTexts: [],
);

void main() {
  setUpAll(() => loadDemoGoldenFonts(_spec));
  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final stage in ['picker', 'panel']) {
      testWidgets('code $stage ${mode.name} golden', (tester) async {
        tester.view.physicalSize = const Size(375, 812);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final model = ExamplePageModel(
          text: _spec.title,
          name: 'fab',
          showAction: true,
          pageBuilder: (_, __) => const TFabPage(),
        );
        await tester.pumpWidget(
          RepaintBoundary(
            key: const ValueKey('code-viewer-app'),
            child: ChangeNotifierProvider(
              create: (_) => ThemeModeProvider(),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: withDemoGoldenFonts(
                  TThemeBuilder.light(TThemeData.defaultData()),
                  _spec,
                ),
                darkTheme: withDemoGoldenFonts(
                  TThemeBuilder.dark(TThemeData.defaultData()),
                  _spec,
                ),
                themeMode: mode,
                home: ExamplePageInheritedTheme(
                  model: model,
                  child: const TFabPage(),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(TIcons.code));
        await tester.runAsync(() async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
        });
        await tester.pumpAndSettle();
        expect(find.text('选择示例代码'), findsOneWidget);
        if (stage == 'picker') {
          final goldenPath = 'goldens/code_picker_${mode.name}.png';
          await captureGoldenEvidence(
            tester,
            find.byKey(const ValueKey('code-viewer-app')),
            goldenPath,
          );
          await expectLater(
            find.byKey(const ValueKey('code-viewer-app')),
            matchesGoldenFile(goldenPath),
          );
          await disposeDemoPage(tester);
          return;
        }
        await tester.tap(
          find
              .descendant(
                of: find.byType(BottomSheet),
                matching: find.byType(TCell),
              )
              .first,
        );
        await tester.runAsync(() async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
        });
        await tester.pumpAndSettle();
        expect(find.byType(Markdown), findsOneWidget);
        final goldenPath = 'goldens/code_panel_${mode.name}.png';
        await captureGoldenEvidence(
          tester,
          find.byKey(const ValueKey('code-viewer-app')),
          goldenPath,
        );
        await expectLater(
          find.byKey(const ValueKey('code-viewer-app')),
          matchesGoldenFile(goldenPath),
        );
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}
