import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/drawer/t_drawer_theme_data.dart';
import 'package:tdesign_flutter/src/components/tabbar/t_tab_bar_theme_data.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../fixtures/theme_implements/legacy_component_themes.dart';

void expectDrawer(TDrawerThemeData theme, double value) {
  expect(
    theme.resolveTitlePadding(const EdgeInsets.all(30)),
    EdgeInsets.all(value),
  );
  expect(
    theme.resolveItemPadding(const EdgeInsets.all(30)),
    EdgeInsets.all(value),
  );
  expect(theme.resolveItemIconSize(30), value);
  expect(theme.resolveItemIconGap(30), value);
}

void main() {
  const drawer = TDrawerThemeData(
    titlePadding: EdgeInsets.all(10),
    itemPadding: EdgeInsets.all(10),
    itemIconSize: 10,
    itemIconGap: 10,
  );
  for (final externalStart in [false, true]) {
    for (final externalEnd in [false, true]) {
      final absent = externalStart
          ? const LegacyDrawerTheme()
          : const TDrawerThemeData();
      final configured = externalEnd
          ? const LegacyDrawerTheme(delegate: drawer)
          : drawer;
      test(
        'Drawer legacy endpoints $externalStart/$externalEnd preserve copyWith and both directions',
        () {
          expectDrawer(absent.lerp(absent, .5), 30);
          for (final t in [0.0, .25, .5, 1.0]) {
            expectDrawer(absent.lerp(configured, t), 30 - 20 * t);
            expectDrawer(configured.lerp(absent, t), 10 + 20 * t);
          }
          final midway = absent.lerp(configured, .5);
          expectDrawer(midway.copyWith(), 20);
          expectDrawer(configured.copyWith(), 10);
          expect(
            midway.resolveTitlePadding(const EdgeInsets.all(50)),
            const EdgeInsets.all(30),
          );
          expect(
            midway.resolveItemPadding(const EdgeInsets.all(50)),
            const EdgeInsets.all(30),
          );
          expect(midway.resolveItemIconGap(50), 30);
          expect(midway.resolveItemIconSize(50), 30);
          expectDrawer(midway.copyWith(backgroundColor: Colors.red), 20);
          expectDrawer(midway.copyWith().lerp(absent, .5), 25);
          expectDrawer(configured.lerp(absent, .5).lerp(configured, .5), 15);
          final override = midway.copyWith(
            titlePadding: EdgeInsets.zero,
            itemPadding: EdgeInsets.zero,
            itemIconSize: 0,
            itemIconGap: 0,
          );
          expectDrawer(override, 0);
          // Updating one field must retain the deferred token state of its siblings.
          final one = midway.copyWith(itemIconGap: 0);
          expect(one.resolveItemIconGap(30), 0);
          expect(one.resolveItemIconSize(30), 20);
          expect(
            one.resolveTitlePadding(const EdgeInsets.all(30)),
            const EdgeInsets.all(20),
          );
          expectDrawer(absent.lerp(null, .5), 30);
        },
      );
      final tabAbsent = externalStart
          ? const LegacyTabBarTheme()
          : const TTabBarThemeData();
      final tabConfigured = externalEnd
          ? const LegacyTabBarTheme(delegate: TTabBarThemeData(barHeight: 40))
          : const TTabBarThemeData(barHeight: 40);
      test(
        'TabBar legacy endpoints $externalStart/$externalEnd preserve copyWith and interrupted transitions',
        () {
          expect(tabAbsent.lerp(tabAbsent, .5).resolveBarHeight(80), 80);
          for (final t in [0.0, .25, .5, 1.0]) {
            expect(
              tabAbsent.lerp(tabConfigured, t).resolveBarHeight(80),
              80 - 40 * t,
            );
            expect(
              tabConfigured.lerp(tabAbsent, t).resolveBarHeight(80),
              40 + 40 * t,
            );
          }
          final midway = tabAbsent.lerp(tabConfigured, .5);
          expect(midway.copyWith().resolveBarHeight(80), 60);
          expect(tabConfigured.copyWith().resolveBarHeight(80), 40);
          expect(midway.resolveBarHeight(100), 70);
          expect(
            midway.copyWith(backgroundColor: Colors.red).resolveBarHeight(80),
            60,
          );
          expect(midway.copyWith(barHeight: 0).resolveBarHeight(80), 0);
          expect(
            midway.copyWith().lerp(tabAbsent, .5).resolveBarHeight(80),
            70,
          );
          expect(
            tabConfigured
                .lerp(tabAbsent, .5)
                .lerp(tabConfigured, .5)
                .resolveBarHeight(80),
            50,
          );
          expect(tabAbsent.lerp(null, .5).resolveBarHeight(80), 80);
        },
      );
    }
  }

  test('Drawer directional paddings resolve in LTR and RTL', () {
    const a = LegacyDrawerTheme();
    const b = LegacyDrawerTheme(
      delegate: TDrawerThemeData(
        titlePadding: EdgeInsetsDirectional.fromSTEB(2, 4, 6, 8),
        itemPadding: EdgeInsetsDirectional.fromSTEB(2, 4, 6, 8),
      ),
    );
    const fallback = EdgeInsetsDirectional.fromSTEB(10, 12, 14, 16);
    final theme = a.lerp(b, .5).copyWith();
    for (final direction in TextDirection.values) {
      final expected = const EdgeInsetsDirectional.fromSTEB(
        6,
        8,
        10,
        12,
      ).resolve(direction);
      expect(theme.resolveTitlePadding(fallback).resolve(direction), expected);
      expect(theme.resolveItemPadding(fallback).resolve(direction), expected);
    }
  });

  final token = TThemeData.defaultData().copyWith(
    sizeMap: {'size4': 20, 'size6': 30, 'size8': 40, 'size14': 100},
  );
  Widget app(
    ThemeExtension<dynamic> theme, {
    required Widget child,
    bool animate = false,
    TThemeData? tokens,
  }) => MaterialApp(
    themeAnimationDuration: animate
        ? const Duration(milliseconds: 200)
        : Duration.zero,
    themeAnimationCurve: Curves.linear,
    theme: TThemeBuilder.light(
      tokens ?? token,
    ).copyWith(extensions: [tokens ?? token, theme]),
    home: Scaffold(body: Center(child: child)),
  );
  const drawerWidget = SizedBox(
    width: 280,
    height: 400,
    child: TDrawer(
      title: Text('title'),
      items: [TDrawerItem(title: 'item', icon: Icon(Icons.home))],
    ),
  );
  final tabWidget = TTabBar(
    type: TTabBarType.text,
    value: 0,
    navigationTabs: const [TTabBarItemConfig(tabText: 'tab')],
    onChanged: (_) {},
  );
  EdgeInsetsGeometry titlePadding(WidgetTester tester) => tester
      .widget<Padding>(
        find
            .ancestor(of: find.text('title'), matching: find.byType(Padding))
            .first,
      )
      .padding;

  testWidgets(
    'legacy Drawer follows token changes without replacing the component',
    (tester) async {
      await tester.pumpWidget(
        app(const LegacyDrawerTheme(), child: drawerWidget),
      );
      final element = tester.element(find.byType(TDrawer));
      final changed = token.copyWith(
        sizeMap: {'size4': 24, 'size6': 36, 'size8': 48},
      );
      await tester.pumpWidget(
        app(const LegacyDrawerTheme(), child: drawerWidget, tokens: changed),
      );
      expect(titlePadding(tester), const EdgeInsets.fromLTRB(36, 48, 36, 24));
      expect(tester.element(find.byType(TDrawer)), same(element));
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'legacy TabBar follows token changes without replacing the component',
    (tester) async {
      await tester.pumpWidget(app(const LegacyTabBarTheme(), child: tabWidget));
      final element = tester.element(find.byType(TTabBar));
      await tester.pumpWidget(
        app(
          const LegacyTabBarTheme(),
          child: tabWidget,
          tokens: token.copyWith(sizeMap: {'size14': 120}),
        ),
      );
      expect(tester.getSize(find.byType(TTabBar)).height, 120);
      expect(tester.element(find.byType(TTabBar)), same(element));
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'legacy Drawer is rendered with token defaults and explicit overrides',
    (tester) async {
      await tester.pumpWidget(
        app(const LegacyDrawerTheme(), child: drawerWidget),
      );
      expect(titlePadding(tester), const EdgeInsets.fromLTRB(30, 40, 30, 20));
      await tester.pumpWidget(
        app(const LegacyDrawerTheme(delegate: drawer), child: drawerWidget),
      );
      expect(titlePadding(tester), const EdgeInsets.all(10));
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'legacy TabBar is rendered with token defaults and explicit overrides',
    (tester) async {
      await tester.pumpWidget(app(const LegacyTabBarTheme(), child: tabWidget));
      expect(tester.getSize(find.byType(TTabBar)).height, 100);
      await tester.pumpWidget(
        app(
          const LegacyTabBarTheme(delegate: TTabBarThemeData(barHeight: 60)),
          child: tabWidget,
        ),
      );
      expect(tester.getSize(find.byType(TTabBar)).height, 60);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'Drawer AnimatedTheme interruption retains deferred token state with legacy target',
    (tester) async {
      await tester.pumpWidget(
        app(const TDrawerThemeData(), child: drawerWidget, animate: true),
      );
      await tester.pumpWidget(
        app(
          const LegacyDrawerTheme(delegate: drawer),
          child: drawerWidget,
          animate: true,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(titlePadding(tester), const EdgeInsets.fromLTRB(20, 25, 20, 15));
      await tester.pumpWidget(
        app(const LegacyDrawerTheme(), child: drawerWidget, animate: true),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        titlePadding(tester),
        const EdgeInsets.fromLTRB(25, 32.5, 25, 17.5),
      );
      await tester.pumpAndSettle();
      expect(titlePadding(tester), const EdgeInsets.fromLTRB(30, 40, 30, 20));
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'TabBar AnimatedTheme interruption retains deferred token state with legacy target',
    (tester) async {
      await tester.pumpWidget(
        app(const TTabBarThemeData(), child: tabWidget, animate: true),
      );
      await tester.pumpWidget(
        app(
          const LegacyTabBarTheme(delegate: TTabBarThemeData(barHeight: 60)),
          child: tabWidget,
          animate: true,
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.getSize(find.byType(TTabBar)).height, 80);
      await tester.pumpWidget(
        app(const LegacyTabBarTheme(), child: tabWidget, animate: true),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.getSize(find.byType(TTabBar)).height, 90);
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(TTabBar)).height, 100);
      expect(tester.takeException(), isNull);
    },
  );
}
