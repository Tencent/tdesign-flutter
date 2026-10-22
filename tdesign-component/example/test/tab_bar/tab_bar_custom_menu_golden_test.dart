import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../demo_page_test_utils.dart';
import 'tab_bar_demo_test_spec.dart';

// These focused scenes exercise the custom-menu layout, which the public
// Demo's built-in menu does not enter. Existing Demo images remain unchanged.
void main() {
  setUpAll(() => loadDemoGoldenFonts(tabBarDemoPageTestSpec));

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    for (final scene in ['multiline', 'mixed', 'scroll']) {
      testWidgets('TabBar custom menu $scene ${mode.name} golden', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(375, 812);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final base = mode == ThemeMode.light
            ? TThemeBuilder.light(TThemeData.defaultData())
            : TThemeBuilder.dark(TThemeData.defaultData());
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: withDemoGoldenFonts(base, tabBarDemoPageTestSpec),
            home: MediaQuery(
              data: const MediaQueryData(
                size: Size(375, 812),
                textScaler: TextScaler.noScaling,
              ),
              child: Scaffold(
                appBar: AppBar(title: const Text('TabBar custom menu')),
                body: Column(
                  children: [
                    Expanded(
                      child: Center(child: TText('Custom menu: $scene')),
                    ),
                    TTabBar(
                      type: TTabBarType.doubleLayer,
                      value: 0,
                      useSafeArea: false,
                      onChanged: (_) {},
                      navigationTabs: [
                        TTabBarItemConfig(
                          tabText: 'Menu',
                          onTap: () {},
                          popUpButtonConfig: TTabBarPopUpBtnConfig(
                            onChanged: (_) {},
                            popUpDialogConfig: TTabBarPopUpShapeConfig(
                              popUpWidth: 210,
                            ),
                            items: _menuItems(scene),
                          ),
                        ),
                        TTabBarItemConfig(tabText: 'Other', onTap: () {}),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Menu'));
        await tester.pumpAndSettle();
        expect(find.byType(TTabBarMenuItem), findsWidgets);
        expect(tester.takeException(), isNull);

        await expectLater(
          find.byType(Overlay),
          matchesGoldenFile('goldens/tab_bar_custom_${scene}_${mode.name}.png'),
        );
        if (scene == 'scroll') {
          await tester.drag(
            find.byType(SingleChildScrollView),
            const Offset(0, -2400),
          );
          await tester.pumpAndSettle();
          expect(find.text('Last option').hitTestable(), findsOneWidget);
          await expectLater(
            find.byType(Overlay),
            matchesGoldenFile(
              'goldens/tab_bar_custom_scroll_bottom_${mode.name}.png',
            ),
          );
        }
        await disposeDemoPage(tester);
      }, tags: 'golden');
    }
  }
}

List<TTabBarMenuItem> _menuItems(String scene) => switch (scene) {
  'multiline' => const [
    TTabBarMenuItem(
      value: 'long',
      itemWidget: Padding(
        padding: EdgeInsets.all(12),
        child: TText('A longer custom option wraps naturally across lines.'),
      ),
    ),
    TTabBarMenuItem(value: 'Plain option'),
  ],
  'mixed' => [
    const TTabBarMenuItem(value: 'Plain option'),
    const TTabBarMenuItem(
      value: 'row',
      itemWidget: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text('Native'), SizedBox(width: 8), TText('TText')],
        ),
      ),
    ),
    TTabBarMenuItem(
      value: 'builder',
      itemWidget: Builder(
        builder: (_) => const Padding(
          padding: EdgeInsets.all(8),
          child: TText('Two lines\nCustom option'),
        ),
      ),
    ),
  ],
  _ => [
    const TTabBarMenuItem(
      value: 'tall',
      itemWidget: SizedBox(
        height: 220,
        child: Center(child: TText('Tall custom row')),
      ),
    ),
    for (var index = 2; index < 8; index++)
      TTabBarMenuItem(value: 'Option $index'),
    const TTabBarMenuItem(value: 'Last option'),
  ],
};
