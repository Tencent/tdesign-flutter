import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrapWithTheme(Widget child, {TTabBarThemeData? tabBarTheme}) {
    return MaterialApp(
      theme: ThemeData(
        extensions: [
          TThemeData.defaultData(),
          if (tabBarTheme != null) tabBarTheme,
        ],
      ),
      home: Scaffold(body: child),
    );
  }

  List<TTabBarItemConfig> textTabs({List<VoidCallback?>? taps, int count = 3}) {
    return List.generate(count, (index) {
      return TTabBarItemConfig(tabText: '标签${index + 1}', onTap: taps?[index]);
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
    test('copyWith and lerp preserve visual fields', () {
      const data = TTabBarThemeData(barHeight: 56);
      final copied = data.copyWith(
        barHeight: 64,
        selectedBgColor: Colors.red,
        dividerColor: Colors.green,
        topBorder: const BorderSide(color: Colors.black),
      );
      expect(copied.barHeight, 64);
      expect(copied.selectedBgColor, Colors.red);
      expect(copied.dividerColor, Colors.green);
      expect(copied.topBorder?.color, Colors.black);

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
        dividerHeight: 32,
      );
      final copied = data.copyWith();

      expect(copied.barHeight, 56);
      expect(copied.selectedBgColor, Colors.red);
      expect(copied.centerDistance, 4);
      expect(copied.dividerHeight, 32);
    });

    test('lerp keeps runtime defaults and does not synthesize overrides', () {
      const defaults = TTabBarThemeData();
      const custom = TTabBarThemeData(
        barHeight: 64,
        selectedBgColor: Colors.red,
        centerDistance: 8,
        dividerHeight: 40,
        dividerThickness: 1.5,
        topBorder: BorderSide(color: Colors.blue, width: 2),
      );

      final early = defaults.lerp(custom, 0.25);
      expect(early.barHeight, 58);
      expect(early.centerDistance, 2);
      expect(early.dividerHeight, 34);
      expect(early.dividerThickness, 0.75);
      expect(early.selectedBgColor, isNull);
      expect(early.topBorder, isNull);

      final late = defaults.lerp(custom, 0.75);
      expect(late.barHeight, 62);
      expect(late.selectedBgColor, Colors.red);
      expect(late.topBorder, const BorderSide(color: Colors.blue, width: 2));

      final empty = defaults.lerp(const TTabBarThemeData(), 0.5);
      expect(empty.barHeight, isNull);
      expect(empty.centerDistance, isNull);
      expect(empty.dividerHeight, isNull);
      expect(empty.dividerThickness, isNull);
      expect(empty.selectedBgColor, isNull);
      expect(empty.topBorder, isNull);
    });
  });

  group('TTabBar config classes', () {
    test('content type, item style and bar style are independent', () {
      expect(TTabBarType.values, hasLength(4));
      expect(TTabBarItemStyle.values, hasLength(2));
      expect(TTabBarStyle.values, hasLength(2));
      expect(
        TTabBarIndicatorAnimation.values,
        contains(TTabBarIndicatorAnimation.elastic),
      );
    });

    test('item badge and popup config keep constructor data', () {
      const tabBadge = TBadge(variant: TBadgeVariant.dot);
      const tabItem = TTabBarItemConfig(tabText: '消息', badge: tabBadge);
      expect(tabItem.badge, same(tabBadge));

      const item = TTabBarMenuItem(value: '更多');
      final popup = TTabBarPopUpBtnConfig(
        items: [item],
        onChanged: (_) {},
        popUpDialogConfig: TTabBarPopUpShapeConfig(popUpWidth: 120),
      );
      expect(popup.items.single.value, '更多');
      expect(popup.popUpDialogConfig?.popUpWidth, 120);
    });

    testWidgets(
      'popup menu item uses typography without covering panel color',
      (tester) async {
        final token = TThemeData.defaultData();
        await tester.pumpWidget(
          wrapWithTheme(const TTabBarMenuItem(value: '更多')),
        );

        final text = tester.widget<Text>(find.text('更多'));
        expect(text.style?.fontSize, token.fontBodyLarge?.size);

        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration! as BoxDecoration;
        expect(decoration.color, isNull);
      },
    );
  });

  group('TTabBar widget', () {
    testWidgets('文字主题按字段覆盖默认值，单项样式优先', (tester) async {
      final token = TThemeData.defaultData();
      for (final materialTheme in [false, true]) {
        final base = TThemeBuilder.light(token);
        await tester.pumpWidget(
          MaterialApp(
            theme: materialTheme
                ? base.copyWith(
                    textTheme: const TextTheme(
                      bodyLarge: TextStyle(fontSize: 21),
                    ),
                  )
                : base.mergeExtension(
                    const TTextThemeData(textStyle: TextStyle(fontSize: 21)),
                  ),
            home: Scaffold(
              body: TTabBar(
                type: TTabBarType.text,
                value: 0,
                useSafeArea: false,
                onChanged: (_) {},
                navigationTabs: const [
                  TTabBarItemConfig(tabText: '默认选中'),
                  TTabBarItemConfig(tabText: '默认未选'),
                  TTabBarItemConfig(
                    tabText: '局部覆盖',
                    unselectTabTextStyle: TextStyle(
                      fontSize: 24,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        final selected = tester.widget<Text>(find.text('默认选中')).style!;
        final unselected = tester.widget<Text>(find.text('默认未选')).style!;
        final custom = tester.widget<Text>(find.text('局部覆盖')).style!;
        expect(selected.fontSize, 21);
        expect(selected.color, token.brandNormalColor);
        expect(unselected.fontSize, 21);
        expect(unselected.color, token.textColorPrimary);
        expect(custom.fontSize, 24);
        expect(custom.color, Colors.orange);
      }
    });

    testWidgets('二级菜单继承局部主题且背景配置不被菜单行覆盖', (tester) async {
      final localToken = TThemeData.defaultData().copyWithTThemeData(
        'popup-local',
        colorMap: {'bgColorContainer': Colors.purple},
      );
      await tester.pumpWidget(
        MaterialApp(
          theme: TThemeBuilder.light(TThemeData.defaultData()),
          home: Scaffold(
            body: Theme(
              data: TThemeBuilder.light(localToken).mergeExtension(
                const TTextThemeData(textStyle: TextStyle(fontSize: 21)),
              ),
              child: TTabBar(
                type: TTabBarType.doubleLayer,
                value: 0,
                useSafeArea: false,
                onChanged: (_) {},
                navigationTabs: [
                  TTabBarItemConfig(
                    tabText: '菜单入口',
                    popUpButtonConfig: TTabBarPopUpBtnConfig(
                      items: const [TTabBarMenuItem(value: '菜单项')],
                      onChanged: (_) {},
                      popUpDialogConfig: TTabBarPopUpShapeConfig(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('菜单入口'));
      await tester.pumpAndSettle();
      final menu = find.byType(TTabBarMenuItem);
      expect(tester.element(menu).tTheme.bgColorContainer, Colors.purple);
      expect(tester.widget<Text>(find.text('菜单项')).style?.fontSize, 21);
      final row = tester.widget<Container>(
        find.descendant(of: menu, matching: find.byType(Container)).first,
      );
      expect((row.decoration! as BoxDecoration).color, isNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets('动画配置切换保持指示器与受控值同步', (tester) async {
      var value = 0;
      var animation = TTabBarIndicatorAnimation.none;
      late StateSetter update;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return TTabBar(
                type: TTabBarType.text,
                value: value,
                useSafeArea: false,
                indicatorAnimation: animation,
                onChanged: (next) => setState(() => value = next),
                navigationTabs: textTabs(),
              );
            },
          ),
        ),
      );
      Finder indicator() => find
          .descendant(
            of: find.byType(TTabBar),
            matching: find.byWidgetPredicate(
              (widget) => widget is Positioned && widget.left != null,
            ),
          )
          .first;
      await tester.tap(find.text('标签3'));
      await tester.pumpAndSettle();
      for (final mode in [
        TTabBarIndicatorAnimation.linear,
        TTabBarIndicatorAnimation.elastic,
      ]) {
        update(() => animation = mode);
        await tester.pumpAndSettle();
        expect(
          tester.getCenter(indicator()).dx,
          closeTo(tester.getCenter(find.text('标签3')).dx, 2),
        );
      }
      update(() => animation = TTabBarIndicatorAnimation.none);
      await tester.pumpAndSettle();
      await tester.tap(find.text('标签2'));
      await tester.pumpAndSettle();
      update(() => animation = TTabBarIndicatorAnimation.linear);
      await tester.pumpAndSettle();
      expect(
        tester.getCenter(indicator()).dx,
        closeTo(tester.getCenter(find.text('标签2')).dx, 2),
      );

      update(() => value = 2);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final before = tester.getTopLeft(indicator()).dx;
      update(() => value = 0);
      await tester.pump();
      expect(tester.getTopLeft(indicator()).dx, closeTo(before, 0.01));
      await tester.pumpAndSettle();
      expect(
        tester.getCenter(indicator()).dx,
        closeTo(tester.getCenter(find.text('标签1')).dx, 2),
      );
    });

    testWidgets('renders text variant and emits onChanged', (tester) async {
      var changed = -1;
      var tapped = false;
      await tester.pumpWidget(
        wrapWithTheme(
          TTabBar(
            type: TTabBarType.text,
            value: 0,
            navigationTabs: textTabs(taps: [null, () => tapped = true, null]),
            onChanged: (value) => changed = value,
          ),
        ),
      );

      await tester.tap(find.text('标签2'));
      await tester.pumpAndSettle();

      expect(changed, 1);
      expect(tapped, isTrue);
    });

    testWidgets('disabled when onChanged is null', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrapWithTheme(
          TTabBar(
            type: TTabBarType.text,
            value: 0,
            navigationTabs: textTabs(taps: [() => tapped = true, null, null]),
          ),
        ),
      );

      await tester.tap(find.text('标签1'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
    });

    testWidgets('renders every content type, item style and bar style', (
      tester,
    ) async {
      for (final type in TTabBarType.values) {
        for (final itemStyle in TTabBarItemStyle.values) {
          for (final style in TTabBarStyle.values) {
            final tabs = switch (type) {
              TTabBarType.icon => iconTabs(),
              TTabBarType.iconText => iconTextTabs(),
              TTabBarType.text || TTabBarType.doubleLayer => textTabs(),
            };
            await tester.pumpWidget(
              wrapWithTheme(
                TTabBar(
                  type: type,
                  itemStyle: itemStyle,
                  style: style,
                  value: 0,
                  navigationTabs: tabs,
                  onChanged: (_) {},
                ),
              ),
            );
            expect(find.byType(TTabBar), findsOneWidget);
          }
        }
      }
    });

    testWidgets('iconText keeps the bottom-bar icon above its text', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TTabBar(
            type: TTabBarType.iconText,
            centerDistance: 4,
            value: 0,
            navigationTabs: iconTextTabs(),
            onChanged: (_) {},
          ),
        ),
      );

      final firstIcon = tester.getCenter(find.byIcon(Icons.home));
      final firstText = tester.getCenter(find.text('标签1'));
      expect(firstIcon.dy, lessThan(firstText.dy));
    });

    testWidgets('updates value with none, linear and elastic animations', (
      tester,
    ) async {
      for (final animation in TTabBarIndicatorAnimation.values) {
        var value = 0;
        late StateSetter setState;
        await tester.pumpWidget(
          wrapWithTheme(
            StatefulBuilder(
              builder: (context, setter) {
                setState = setter;
                return TTabBar(
                  type: TTabBarType.text,
                  value: value,
                  navigationTabs: textTabs(),
                  indicatorAnimation: animation,
                  animationDuration: const Duration(milliseconds: 20),
                  onChanged: (next) => setState(() => value = next),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('标签3'));
        await tester.pump(const Duration(milliseconds: 10));
        await tester.pumpAndSettle();
        expect(value, 2);
      }
    });

    testWidgets(
      'repeated tap, long press, safe area and no placeholder paths',
      (tester) async {
        var tapCount = 0;
        var longPressed = false;
        await tester.pumpWidget(
          wrapWithTheme(
            TTabBar(
              type: TTabBarType.text,
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
          ),
        );

        await tester.tap(find.text('标签1'));
        await tester.longPress(find.text('标签1'));
        await tester.pumpAndSettle();

        expect(tapCount, 1);
        expect(longPressed, isTrue);
      },
    );

    testWidgets('expansion panel popup opens and reports selected value', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        wrapWithTheme(
          TTabBar(
            type: TTabBarType.doubleLayer,
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
        ),
      );

      await tester.tap(find.text('更多'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('选项B'));
      await tester.pumpAndSettle();

      expect(selected, '选项B');
    });

    testWidgets('ink well routes double-layer popup through one tap chain', (
      tester,
    ) async {
      var itemTapCount = 0;
      var changedCount = 0;
      String? selected;
      await tester.pumpWidget(
        wrapWithTheme(
          TTabBar(
            type: TTabBarType.doubleLayer,
            value: 0,
            needInkWell: true,
            navigationTabs: [
              const TTabBarItemConfig(tabText: '普通'),
              TTabBarItemConfig(
                tabText: '更多',
                onTap: () => itemTapCount++,
                popUpButtonConfig: TTabBarPopUpBtnConfig(
                  items: const [TTabBarMenuItem(value: '选项A')],
                  onChanged: (value) => selected = value,
                ),
              ),
            ],
            onChanged: (_) => changedCount++,
          ),
        ),
      );

      await tester.tap(find.text('更多'));
      await tester.pumpAndSettle();

      expect(itemTapCount, 1);
      expect(changedCount, 1);
      expect(find.text('选项A'), findsOneWidget);

      await tester.tap(find.text('选项A'));
      await tester.pumpAndSettle();
      expect(selected, '选项A');
    });

    testWidgets('badge uses its own offset and anchors to iconText content', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TTabBar(
            type: TTabBarType.iconText,
            value: 0,
            needInkWell: true,
            centerDistance: 6,
            navigationTabs: [
              TTabBarItemConfig(
                tabText: '消息',
                selectedIcon: const Icon(Icons.mail),
                unselectedIcon: const Icon(Icons.mail_outline),
                badge: const TBadge(label: '9', offset: Offset(2, 1)),
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
        ),
      );

      expect(find.byType(TBadge), findsOneWidget);
      final badge = tester.widget<TBadge>(find.byType(TBadge));
      expect(badge.offset, const Offset(2, 1));
      expect(badge.child, isNotNull);
      final badgeCenter = tester.getCenter(find.text('9'));
      final iconCenter = tester.getCenter(find.byIcon(Icons.mail));
      expect(badgeCenter.dx, greaterThan(iconCenter.dx));
      expect(badgeCenter.dy, lessThan(iconCenter.dy));
    });

    testWidgets('badge inherits theme offset without blocking item taps', (
      tester,
    ) async {
      var badgeTaps = 0;
      var changedValue = -1;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            badgeTheme: const BadgeThemeData(offset: Offset(7, 9)),
            extensions: [TThemeData.defaultData()],
          ),
          home: Scaffold(
            body: TTabBar(
              type: TTabBarType.text,
              value: 0,
              navigationTabs: [
                const TTabBarItemConfig(tabText: '首页'),
                TTabBarItemConfig(
                  tabText: '消息',
                  badge: TBadge(label: '1', onTap: () => badgeTaps++),
                ),
              ],
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      final materialBadge = tester.widget<Badge>(find.byType(Badge));
      expect(materialBadge.offset, const Offset(7, 9));

      await tester.tap(find.text('消息'));
      await tester.pump();
      expect(badgeTaps, 1);
      expect(changedValue, 1);
    });

    testWidgets('badge onTap follows allowMultipleTaps with InkWell', (
      tester,
    ) async {
      var badgeTaps = 0;
      var changedCount = 0;
      var selectedIndex = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) => TTabBar(
              type: TTabBarType.text,
              value: selectedIndex,
              needInkWell: true,
              navigationTabs: [
                TTabBarItemConfig(
                  tabText: '首页',
                  badge: TBadge(label: '1', onTap: () => badgeTaps++),
                ),
                TTabBarItemConfig(
                  tabText: '消息',
                  allowMultipleTaps: true,
                  badge: TBadge(label: '2', onTap: () => badgeTaps++),
                ),
              ],
              onChanged: (index) {
                changedCount++;
                setState(() => selectedIndex = index);
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('首页'));
      await tester.pump();
      expect(badgeTaps, 0);
      expect(changedCount, 0);

      await tester.tap(find.text('消息'));
      await tester.pump();
      expect(badgeTaps, 1);
      expect(changedCount, 1);

      await tester.tap(find.text('消息'));
      await tester.pump();
      expect(badgeTaps, 2);
      expect(changedCount, 1);
    });

    testWidgets('ink well routes one tap through one selection callback', (
      tester,
    ) async {
      var itemTapCount = 0;
      var changedCount = 0;
      await tester.pumpWidget(
        wrapWithTheme(
          TTabBar(
            type: TTabBarType.text,
            value: 0,
            needInkWell: true,
            navigationTabs: [
              const TTabBarItemConfig(tabText: '标签1'),
              TTabBarItemConfig(tabText: '标签2', onTap: () => itemTapCount++),
            ],
            onChanged: (_) => changedCount++,
          ),
        ),
      );

      await tester.tap(find.text('标签2'));
      await tester.pump();

      expect(itemTapCount, 1);
      expect(changedCount, 1);
    });

    test('asserts invalid current API inputs', () {
      expect(
        () => TTabBar(
          type: TTabBarType.text,
          value: 0,
          navigationTabs: const [],
          onChanged: (_) {},
        ),
        throwsFlutterError,
      );
      expect(
        () => TTabBar(
          type: TTabBarType.text,
          value: 0,
          navigationTabs: [TTabBarItemConfig(onTap: () {})],
          onChanged: (_) {},
        ),
        throwsFlutterError,
      );
      expect(
        () => TTabBar(
          type: TTabBarType.icon,
          value: 0,
          navigationTabs: [TTabBarItemConfig(onTap: () {})],
          onChanged: (_) {},
        ),
        throwsFlutterError,
      );
      expect(
        () => TTabBar(
          type: TTabBarType.iconText,
          value: 0,
          navigationTabs: [TTabBarItemConfig(tabText: 'x', onTap: () {})],
          onChanged: (_) {},
        ),
        throwsFlutterError,
      );
      expect(
        () => TTabBar(
          type: TTabBarType.text,
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
      await tester.pumpWidget(
        wrapWithTheme(
          TTabBar(
            type: TTabBarType.text,
            value: 1,
            navigationTabs: textTabs(),
            indicatorAnimation: TTabBarIndicatorAnimation.linear,
            onChanged: (_) {},
          ),
          tabBarTheme: const TTabBarThemeData(
            barHeight: 60,
            selectedBgColor: Colors.blue,
            dividerColor: Colors.green,
          ),
        ),
      );

      expect(find.byType(TTabBar), findsOneWidget);
      expect(tester.getSize(find.byType(TTabBar)).height, 60);
    });

    testWidgets('behavior parameters belong to the widget instance', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrapWithTheme(
          TTabBar(
            type: TTabBarType.text,
            value: 0,
            navigationTabs: textTabs(),
            needInkWell: false,
            animationDuration: const Duration(milliseconds: 20),
            animationCurve: Curves.linear,
            onChanged: (_) {},
          ),
          tabBarTheme: const TTabBarThemeData(barHeight: 56),
        ),
      );
      expect(find.byType(InkWell), findsNothing);
    });
  });
}
