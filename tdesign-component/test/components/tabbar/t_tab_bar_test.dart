import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrapWithTheme(Widget child, {TTabBarThemeData? tabBarTheme}) {
    return MaterialApp(
      theme: ThemeData(extensions: [
        TThemeData.defaultData(),
        if (tabBarTheme != null) tabBarTheme,
      ]),
      home: Scaffold(body: child),
    );
  }

  List<TTabBarItemConfig> textTabs({List<VoidCallback?>? taps, int count = 3}) {
    return List.generate(count, (index) {
      return TTabBarItemConfig(
        tabText: '标签${index + 1}',
        onTap: taps?[index],
      );
    });
  }

  List<TTabBarItemConfig> iconTextTabs() {
    return List.generate(3, (index) {
      return TTabBarItemConfig(
        tabText: '标签${index + 1}',
        selectedIcon: const Icon(Icons.home),
        unselectedIcon: const Icon(Icons.home_outlined),
        onTap: () {},
      );
    });
  }

  List<TTabBarItemConfig> iconTabs() {
    return List.generate(2, (index) {
      return TTabBarItemConfig(
        selectedIcon: const Icon(Icons.star),
        unselectedIcon: const Icon(Icons.star_border),
        onTap: () {},
      );
    });
  }

  group('TTabBarThemeData', () {
    test('copyWith and lerp use current v1 fields', () {
      const data = TTabBarThemeData(barHeight: 56);
      final copied = data.copyWith(
        barHeight: 64,
        selectedBgColor: Colors.red,
        useVerticalDivider: true,
        showTopBorder: true,
        needInkWell: true,
      );
      expect(copied.barHeight, 64);
      expect(copied.selectedBgColor, Colors.red);
      expect(copied.useVerticalDivider, isTrue);
      expect(copied.showTopBorder, isTrue);
      expect(copied.needInkWell, isTrue);

      const start = TTabBarThemeData(barHeight: 56);
      const end = TTabBarThemeData(barHeight: 64);
      expect(start.lerp(end, 0.5).barHeight, 60);
      expect(start.lerp(null, 0.5), same(start));
    });

    test('copyWith preserves existing values when omitted', () {
      const data = TTabBarThemeData(
        barHeight: 56,
        selectedBgColor: Colors.red,
        centerDistance: 4,
        showTopBorder: true,
        needInkWell: true,
      );
      final copied = data.copyWith();

      expect(copied.barHeight, 56);
      expect(copied.selectedBgColor, Colors.red);
      expect(copied.centerDistance, 4);
      expect(copied.showTopBorder, isTrue);
      expect(copied.needInkWell, isTrue);
    });
  });

  group('TTabBar config classes', () {
    test('variant and indicator enums expose v1 values', () {
      expect(TTabBarVariant.values, contains(TTabBarVariant.text));
      expect(TTabBarVariant.values, contains(TTabBarVariant.iconText));
      expect(TTabBarVariant.values, contains(TTabBarVariant.icon));
      expect(TTabBarVariant.values, contains(TTabBarVariant.expansionPanel));
      expect(TTabBarVariant.values, contains(TTabBarVariant.weakText));
      expect(TTabBarVariant.values, contains(TTabBarVariant.capsule));
      expect(
        TTabBarIndicatorAnimation.values,
        contains(TTabBarIndicatorAnimation.elastic),
      );
    });

    test('badge and popup configs keep constructor data', () {
      final badge = TTabBarBadgeConfig(showBadge: true);
      expect(badge.showBadge, isTrue);
      expect(badge.tBadge, isA<TBadge>());

      const item = TTabBarMenuItem(value: '更多');
      final popup = TTabBarPopUpBtnConfig(
        items: [item],
        onChanged: (_) {},
        popUpDialogConfig: TTabBarPopUpShapeConfig(popUpWidth: 120),
      );
      expect(popup.items.single.value, '更多');
      expect(popup.popUpDialogConfig?.popUpWidth, 120);
    });

    testWidgets('popup menu item uses global typography and surface tokens',
        (tester) async {
      final token = TThemeData.defaultData();
      await tester
          .pumpWidget(wrapWithTheme(const TTabBarMenuItem(value: '更多')));

      final text = tester.widget<Text>(find.text('更多'));
      expect(text.style?.fontSize, token.fontBodyLarge?.size);

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, token.bgColorContainer);
    });
  });

  group('TTabBar widget', () {
    testWidgets('renders text variant and emits onChanged', (tester) async {
      var changed = -1;
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          variant: TTabBarVariant.text,
          value: 0,
          navigationTabs: textTabs(taps: [null, () => tapped = true, null]),
          onChanged: (value) => changed = value,
        ),
      ));

      await tester.tap(find.text('标签2'));
      await tester.pumpAndSettle();

      expect(changed, 1);
      expect(tapped, isTrue);
    });

    testWidgets('disabled when onChanged is null', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          variant: TTabBarVariant.text,
          value: 0,
          navigationTabs: textTabs(taps: [() => tapped = true, null, null]),
        ),
      ));

      await tester.tap(find.text('标签1'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
    });

    testWidgets('renders icon, iconText, weak and capsule variants',
        (tester) async {
      for (final variant in [
        TTabBarVariant.icon,
        TTabBarVariant.iconText,
        TTabBarVariant.weakText,
        TTabBarVariant.weakIcon,
        TTabBarVariant.weakIconText,
        TTabBarVariant.capsule,
      ]) {
        final tabs = switch (variant) {
          TTabBarVariant.icon || TTabBarVariant.weakIcon => iconTabs(),
          TTabBarVariant.iconText ||
          TTabBarVariant.weakIconText ||
          TTabBarVariant.capsule =>
            iconTextTabs(),
          _ => textTabs(),
        };
        await tester.pumpWidget(wrapWithTheme(
          TTabBar(
            variant: variant,
            value: 0,
            navigationTabs: tabs,
            onChanged: (_) {},
          ),
        ));
        expect(find.byType(TTabBar), findsOneWidget);
      }
    });

    testWidgets('updates value with none, linear and elastic animations',
        (tester) async {
      for (final animation in TTabBarIndicatorAnimation.values) {
        var value = 0;
        late StateSetter setState;
        await tester.pumpWidget(wrapWithTheme(
          StatefulBuilder(
            builder: (context, setter) {
              setState = setter;
              return TTabBar(
                variant: TTabBarVariant.text,
                value: value,
                navigationTabs: textTabs(),
                indicatorAnimation: animation,
                animationDuration: const Duration(milliseconds: 20),
                onChanged: (next) => setState(() => value = next),
              );
            },
          ),
        ));

        await tester.tap(find.text('标签3'));
        await tester.pump(const Duration(milliseconds: 10));
        await tester.pumpAndSettle();
        expect(value, 2);
      }
    });

    testWidgets('repeated tap, long press, safe area and no placeholder paths',
        (tester) async {
      var tapCount = 0;
      var longPressed = false;
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          variant: TTabBarVariant.text,
          value: 0,
          placeholder: false,
          navigationTabs: [
            TTabBarItemConfig(
              tabText: '标签1',
              allowMultipleTaps: true,
              onTap: () => tapCount++,
              onLongPress: () => longPressed = true,
            ),
            TTabBarItemConfig(tabText: '标签2', onTap: () {}),
          ],
          onChanged: (_) {},
        ),
      ));

      await tester.tap(find.text('标签1'));
      await tester.longPress(find.text('标签1'));
      await tester.pumpAndSettle();

      expect(tapCount, 1);
      expect(longPressed, isTrue);
    });

    testWidgets('expansion panel popup opens and reports selected value',
        (tester) async {
      String? selected;
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          variant: TTabBarVariant.expansionPanel,
          value: 0,
          navigationTabs: [
            TTabBarItemConfig(
              tabText: '更多',
              onTap: () {},
              popUpButtonConfig: TTabBarPopUpBtnConfig(
                items: const [
                  TTabBarMenuItem(value: '选项A'),
                  TTabBarMenuItem(value: '选项B'),
                ],
                onChanged: (value) => selected = value,
                popUpDialogConfig: TTabBarPopUpShapeConfig(
                  popUpWidth: 120,
                  radius: 4,
                  arrowWidth: 10,
                  arrowHeight: 6,
                ),
              ),
            ),
            TTabBarItemConfig(tabText: '普通', onTap: () {}),
          ],
          onChanged: (_) {},
        ),
      ));

      await tester.tap(find.text('更多'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('选项B'));
      await tester.pumpAndSettle();

      expect(selected, '选项B');
    });

    testWidgets('badge offsets and ink well render on iconText items',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          variant: TTabBarVariant.iconText,
          value: 0,
          needInkWell: true,
          centerDistance: 6,
          navigationTabs: [
            TTabBarItemConfig(
              tabText: '消息',
              selectedIcon: const Icon(Icons.mail),
              unselectedIcon: const Icon(Icons.mail_outline),
              badgeConfig: TTabBarBadgeConfig(
                showBadge: true,
                tBadge: const TBadge(count: 9),
                badgeTopOffset: 1,
                badgeRightOffset: 2,
              ),
              onTap: () {},
            ),
            TTabBarItemConfig(
              tabText: '首页',
              selectedIcon: const Icon(Icons.home),
              unselectedIcon: const Icon(Icons.home_outlined),
              onTap: () {},
            ),
          ],
          onChanged: (_) {},
        ),
      ));

      expect(find.byType(TBadge), findsOneWidget);
    });

    test('asserts invalid current API inputs', () {
      expect(
        () => TTabBar(
          variant: TTabBarVariant.text,
          value: 0,
          navigationTabs: const [],
          onChanged: (_) {},
        ),
        throwsFlutterError,
      );
      expect(
        () => TTabBar(
          variant: TTabBarVariant.text,
          value: 0,
          navigationTabs: [TTabBarItemConfig(onTap: () {})],
          onChanged: (_) {},
        ),
        throwsFlutterError,
      );
      expect(
        () => TTabBar(
          variant: TTabBarVariant.icon,
          value: 0,
          navigationTabs: [TTabBarItemConfig(onTap: () {})],
          onChanged: (_) {},
        ),
        throwsFlutterError,
      );
      expect(
        () => TTabBar(
          variant: TTabBarVariant.iconText,
          value: 0,
          navigationTabs: [TTabBarItemConfig(tabText: 'x', onTap: () {})],
          onChanged: (_) {},
        ),
        throwsFlutterError,
      );
      expect(
        () => TTabBar(
          variant: TTabBarVariant.text,
          value: 2,
          navigationTabs: textTabs(count: 1),
          onChanged: (_) {},
        ),
        throwsFlutterError,
      );
      expect(
        () => TTabBarPopUpBtnConfig(
          items: const [TTabBarMenuItem(value: 'x')],
          onChanged: (_) {},
          popUpDialogConfig: TTabBarPopUpShapeConfig(arrowHeight: 0),
        ),
        throwsFlutterError,
      );
    });

    testWidgets('theme values and animated indicators render', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          variant: TTabBarVariant.text,
          value: 1,
          navigationTabs: textTabs(),
          indicatorAnimation: TTabBarIndicatorAnimation.linear,
          onChanged: (_) {},
        ),
        tabBarTheme: const TTabBarThemeData(
          barHeight: 60,
          selectedBgColor: Colors.blue,
          useVerticalDivider: true,
          needInkWell: true,
        ),
      ));

      expect(find.byType(TTabBar), findsOneWidget);
      expect(find.byType(InkWell), findsNWidgets(3));
      expect(tester.getSize(find.byType(TTabBar)).height, 60);
    });

    testWidgets('构造器参数覆盖 ThemeData 动画和水波纹', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        TTabBar(
          variant: TTabBarVariant.text,
          value: 0,
          navigationTabs: textTabs(),
          needInkWell: false,
          animationDuration: const Duration(milliseconds: 20),
          animationCurve: Curves.linear,
          onChanged: (_) {},
        ),
        tabBarTheme: const TTabBarThemeData(
          needInkWell: true,
          animationDuration: Duration(seconds: 1),
          animationCurve: Curves.bounceIn,
        ),
      ));
      expect(find.byType(InkWell), findsNothing);
    });
  });
}
