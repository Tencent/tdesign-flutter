import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  approvedFixedTokenTests();
  final base = TThemeData.defaultData();
  final unrelated = base.copyWith(
    sizeMap: {'size4': 36, 'size7': 80, 'size8': 96},
    radiusMap: {'radiusSmall': 18, 'radiusLarge': 27},
    shadowMap: {
      'shadow1': [const BoxShadow(blurRadius: 60)],
    },
  );

  Future<void> pump(
    WidgetTester tester,
    Widget child,
    TThemeData token, {
    ThemeExtension<dynamic>? component,
    bool dark = false,
  }) => tester.pumpWidget(
    MaterialApp(
      themeAnimationDuration: Duration.zero,
      theme: (dark ? TThemeBuilder.dark(token) : TThemeBuilder.light(token))
          .copyWith(extensions: [token, if (component != null) component]),
      home: Scaffold(body: Center(child: child)),
    ),
  );

  List<BoxDecoration> decorations(WidgetTester tester) => [
    ...tester
        .widgetList<Container>(find.byType(Container))
        .map((w) => w.decoration)
        .whereType<BoxDecoration>(),
    ...tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((w) => w.decoration)
        .whereType<BoxDecoration>(),
  ];

  testWidgets('Badge 气泡圆角和 padding 不受无关全局刻度控制', (tester) async {
    const child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [TBadge(variant: TBadgeVariant.bubble, label: '9')],
    );
    await pump(tester, child, base);
    final before = decorations(tester);
    final size = tester.getSize(find.byType(Row).first);
    await pump(tester, child, unrelated);
    await tester.pumpAndSettle();
    expect(decorations(tester), before);
    expect(tester.getSize(find.byType(Row).first), size);
  });

  testWidgets('Checkbox 的 1.5px 方角不绑定到另一档全局圆角', (tester) async {
    const child = TCheckbox(value: true, title: '方形指示器');
    const component = TCheckboxThemeData(variant: TCheckboxVariant.square);
    await pump(tester, child, unrelated, component: component);
    final indicator = tester.widget<Container>(
      find.byKey(const ValueKey('checkbox-square-indicator')),
    );
    final box = indicator.decoration! as BoxDecoration;
    expect(box.borderRadius, BorderRadius.circular(1.5));
  });

  for (final dark in [false, true]) {
    final initial = dark ? base.dark! : base;
    testWidgets('Cell 卡片圆角只响应 radiusLarge，显式配置优先 dark=$dark', (tester) async {
      const child = TCellGroup(
        key: ValueKey('token-cell'),
        variant: TCellGroupVariant.card,
        cells: [TCell(title: Text('单元格'))],
      );
      BorderRadiusGeometry? radius() => tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(TCellGroup),
              matching: find.byType(Container),
            ),
          )
          .map((w) => w.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((d) => d.borderRadius != null)
          .borderRadius;
      await pump(tester, child, initial, dark: dark);
      final element = tester.element(find.byKey(const ValueKey('token-cell')));
      expect(radius(), BorderRadius.circular(9));
      final other = initial.copyWith(
        radiusMap: {'radiusSmall': 21, 'radiusDefault': 25},
      );
      await pump(tester, child, other, dark: dark);
      expect(radius(), BorderRadius.circular(9));
      final related = other.copyWith(
        radiusMap: {...other.radiusMap, 'radiusLarge': 15},
      );
      await pump(tester, child, related, dark: dark);
      expect(radius(), BorderRadius.circular(15));
      expect(
        tester.element(find.byKey(const ValueKey('token-cell'))),
        same(element),
      );
      await pump(
        tester,
        child,
        related,
        dark: dark,
        component: const TCellThemeData(
          cardBorderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      );
      expect(radius(), BorderRadius.circular(20));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Table 表头与数据水平 padding 响应 spacer1，显式配置优先 dark=$dark', (
      tester,
    ) async {
      final child = TTable<String>(
        key: const ValueKey('token-table'),
        columns: [
          TTableColumn<String>(
            id: 'value',
            header: const Text('表头'),
            cellBuilder: (_, value, __) => Text(value),
          ),
        ],
        data: const ['单元格'],
      );
      EdgeInsetsGeometry padding(String text) => tester
          .widget<Padding>(
            find
                .ancestor(of: find.text(text), matching: find.byType(Padding))
                .first,
          )
          .padding;
      void check(EdgeInsetsGeometry expected) {
        expect(padding('表头'), expected);
        expect(padding('单元格'), expected);
      }

      await pump(tester, child, initial, dark: dark);
      final element = tester.element(find.byKey(const ValueKey('token-table')));
      check(const EdgeInsets.symmetric(horizontal: 12));
      final other = initial.copyWith(spacerMap: {'spacer': 19, 'spacer2': 23});
      await pump(tester, child, other, dark: dark);
      check(const EdgeInsets.symmetric(horizontal: 12));
      final related = other.copyWith(
        spacerMap: {...other.spacerMap, 'spacer1': 17},
      );
      await pump(tester, child, related, dark: dark);
      check(const EdgeInsets.symmetric(horizontal: 17));
      expect(
        tester.element(find.byKey(const ValueKey('token-table'))),
        same(element),
      );
      await pump(
        tester,
        child,
        related,
        dark: dark,
        component: const TTableThemeData(
          cellPadding: EdgeInsets.fromLTRB(3, 2, 5, 4),
        ),
      );
      check(const EdgeInsets.fromLTRB(3, 2, 5, 4));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Tabs tag 内框只响应 spacer2，保留外层显式 padding dark=$dark', (
      tester,
    ) async {
      const child = DefaultTabController(
        length: 2,
        child: TTabsBar(
          key: ValueKey('token-tabs'),
          variant: TTabsBarVariant.tag,
          tabs: [
            TTab(text: '标签一'),
            TTab(text: '标签二'),
          ],
        ),
      );
      Iterable<Container> boxes() => tester
          .widgetList<Container>(find.byType(Container))
          .where(
            (w) =>
                w.decoration is ShapeDecoration &&
                (w.decoration! as ShapeDecoration).shape is StadiumBorder,
          );
      void check(double horizontal) {
        expect(boxes(), hasLength(2));
        for (final box in boxes()) {
          expect(box.padding, EdgeInsets.symmetric(horizontal: horizontal));
          expect(box.constraints?.minHeight, 32);
          final outer = tester.widget<Padding>(
            find
                .ancestor(
                  of: find.byWidget(box),
                  matching: find.byType(Padding),
                )
                .first,
          );
          expect(outer.padding, const EdgeInsets.all(7));
        }
      }

      await pump(
        tester,
        child,
        initial,
        dark: dark,
        component: const TTabsBarThemeData(labelPadding: EdgeInsets.all(7)),
      );
      final element = tester.element(find.byKey(const ValueKey('token-tabs')));
      check(16);
      final other = initial.copyWith(spacerMap: {'spacer': 19, 'spacer1': 23});
      await pump(
        tester,
        child,
        other,
        dark: dark,
        component: const TTabsBarThemeData(labelPadding: EdgeInsets.all(7)),
      );
      check(16);
      await pump(
        tester,
        child,
        other.copyWith(spacerMap: {...other.spacerMap, 'spacer2': 20}),
        dark: dark,
        component: const TTabsBarThemeData(labelPadding: EdgeInsets.all(7)),
      );
      check(20);
      expect(
        tester.element(find.byKey(const ValueKey('token-tabs'))),
        same(element),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Button 小档与 Avatar 小档图标保持原规格', (tester) async {
    const child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TButton(
          size: TButtonSize.small,
          icon: Icon(TIcons.add),
          child: Text('按钮'),
        ),
        TAvatar(size: TAvatarSize.small),
      ],
    );
    await pump(tester, child, base);
    final icons = find.byType(Icon);
    final before = [
      for (final e in icons.evaluate()) tester.getSize(find.byWidget(e.widget)),
    ];
    await pump(tester, child, unrelated);
    await tester.pumpAndSettle();
    final after = [
      for (final e in icons.evaluate()) tester.getSize(find.byWidget(e.widget)),
    ];
    expect(after, before);
  });

  testWidgets('全局基础投影不能接管头像组专有阴影', (tester) async {
    const child = TAvatarGroup(children: [TAvatar(), TAvatar()]);
    await pump(tester, child, base);
    final before = decorations(
      tester,
    ).where((d) => d.boxShadow != null).toList();
    expect(before, isNotEmpty);
    await pump(tester, child, unrelated);
    await tester.pumpAndSettle();
    expect(
      decorations(tester).where((d) => d.boxShadow != null).toList(),
      before,
    );
    const shadow = BoxShadow(blurRadius: 7, color: Colors.red);
    await pump(
      tester,
      child,
      unrelated,
      component: const TAvatarThemeData(groupShadow: shadow),
    );
    await tester.pumpAndSettle();
    expect(
      decorations(tester).any((d) => d.boxShadow?.contains(shadow) ?? false),
      isTrue,
    );
  });
}

void approvedFixedTokenTests() {
  ThemeExtension<dynamic> emptyTheme(ThemeExtension<dynamic> theme) =>
      switch (theme) {
        TAvatarThemeData() => const TAvatarThemeData(),
        TBadgeThemeData() => const TBadgeThemeData(),
        TDrawerThemeData() => const TDrawerThemeData(),
        TDropdownThemeData() => const TDropdownThemeData(),
        _ => throw StateError('Missing empty theme'),
      };

  test('Token默认插值保留实际刻度、copyWith及中断过渡', () {
    final dropdown = const TDropdownThemeData().lerp(
      const TDropdownThemeData(barHeight: 60),
      .25,
    );
    expect(dropdown.hasBarHeightOverride, isTrue);
    expect(dropdown.resolveBarHeight(52), 54);
    expect(dropdown.copyWith(iconColor: Colors.red).resolveBarHeight(52), 54);
    expect(
      dropdown
          .merge(const TDropdownThemeData(iconColor: Colors.blue))
          .resolveBarHeight(52),
      54,
    );
    expect(
      dropdown.lerp(const TDropdownThemeData(), .5).resolveBarHeight(52),
      53,
    );
    final search = const TSearchBarThemeData().lerp(
      const TSearchBarThemeData(height: 60),
      .25,
    );
    expect(search.hasHeightOverride, isTrue);
    expect(search.resolveHeight(44), 48);
    expect(
      search
          .copyWith(textStyle: const TextStyle(color: Colors.red))
          .resolveHeight(44),
      48,
    );
    final toast = const TToastThemeData().lerp(
      const TToastThemeData(iconSize: 40),
      .5,
    );
    expect(toast.resolveIconSize(28), 34);
    expect(toast.copyWith(iconColor: Colors.red).resolveIconSize(28), 34);
    expect(
      toast
          .merge(const TToastThemeData(iconColor: Colors.blue))
          .resolveIconSize(28),
      34,
    );
    expect(const TToastThemeData().lerp(toast, .5).resolveIconSize(28), 31);
    expect(const TToastThemeData().resolveIconSize(28), 28);
  });

  double icon(WidgetTester tester, IconData data) =>
      tester.widget<Icon>(find.byIcon(data).first).size ??
      IconTheme.of(tester.element(find.byIcon(data).first)).size!;
  double tagHeight(WidgetTester tester) => tester
      .widgetList<Container>(find.byType(Container))
      .firstWhere(
        (w) =>
            w.decoration is ShapeDecoration &&
            (w.decoration! as ShapeDecoration).shape is StadiumBorder,
      )
      .constraints!
      .minHeight;
  double block(WidgetTester tester) => tester
      .widgetList<Container>(find.byType(Container))
      .firstWhere(
        (w) =>
            w.constraints?.hasTightWidth == true &&
            w.decoration is BoxDecoration,
      )
      .constraints!
      .maxWidth;
  final cases =
      <
        (
          String,
          Widget,
          String,
          double,
          double Function(WidgetTester),
          ThemeExtension<dynamic>?,
        )
      >[
        (
          'Avatar large',
          const TAvatar(size: TAvatarSize.large),
          'size10',
          32,
          (t) => icon(t, TIcons.user),
          const TAvatarThemeData(iconSize: 13),
        ),
        (
          'Avatar medium',
          const TAvatar(),
          'size8',
          24,
          (t) => icon(t, TIcons.user),
          const TAvatarThemeData(iconSize: 13),
        ),
        (
          'Badge dot',
          const TBadge(variant: TBadgeVariant.dot),
          'size4',
          8,
          (t) => t.getSize(find.byType(TBadge)).width,
          const TBadgeThemeData(dotSize: 13),
        ),
        (
          'Button large',
          const TButton(
            size: TButtonSize.large,
            icon: Icon(TIcons.add),
            child: Text('按钮'),
          ),
          'size8',
          24,
          (t) => icon(t, TIcons.add),
          null,
        ),
        (
          'Button medium',
          const TButton(
            size: TButtonSize.medium,
            icon: Icon(TIcons.add),
            child: Text('按钮'),
          ),
          'size7',
          20,
          (t) => icon(t, TIcons.add),
          null,
        ),
        (
          'Drawer item',
          const SizedBox(
            height: 300,
            child: TDrawer(
              items: [TDrawerItem(title: '菜单', icon: Icon(TIcons.add))],
            ),
          ),
          'size8',
          24,
          (t) => icon(t, TIcons.add),
          const TDrawerThemeData(itemIconSize: 13),
        ),
        (
          'Search height',
          const TSearchBar(),
          'size12',
          40,
          (t) => t.getSize(find.byType(TSearchBar)).height,
          null,
        ),
        (
          'Search icon',
          const TSearchBar(initialValue: 'test'),
          'size8',
          24,
          (t) => icon(t, TIcons.close_circle_filled),
          null,
        ),
        (
          'Loading gap',
          Builder(
            builder: (context) => Theme(
              data: Theme.of(
                context,
              ).mergeExtension(const TLoadingThemeData(axis: Axis.vertical)),
              child: const TLoading(text: '加载中'),
            ),
          ),
          'size3',
          6,
          (t) =>
              (t.widget<Flex>(find.byType(Flex).first).children[1] as SizedBox)
                  .height!,
          null,
        ),
        (
          'Dropdown height',
          TDropdownMenu(
            items: [
              TDropdownMenuItem(
                label: '排序',
                panelBuilder: (_, __) => const Text('选项'),
              ),
            ],
          ),
          'size13',
          48,
          (t) => t.getSize(find.byType(TDropdownMenu)).height,
          null,
        ),
        (
          'Dropdown icon',
          TDropdownMenu(
            items: [
              TDropdownMenuItem(
                label: '排序',
                panelBuilder: (_, __) => const Text('选项'),
              ),
            ],
          ),
          'size7',
          20,
          (t) => t.widgetList<Icon>(find.byType(Icon)).single.size!,
          const TDropdownThemeData(iconSize: 13),
        ),
        (
          'Swiper fraction',
          const SizedBox(
            height: 180,
            child: TSwiper(
              pagination: TSwiperPaginationVariant.fraction,
              children: [Text('第一页'), Text('第二页')],
            ),
          ),
          'size8',
          24,
          (t) => t
              .widgetList<ConstrainedBox>(find.byType(ConstrainedBox))
              .firstWhere(
                (w) =>
                    w.constraints.minHeight > 0 &&
                    w.constraints.minHeight < 100 &&
                    w.constraints.maxHeight == double.infinity,
              )
              .constraints
              .minHeight,
          null,
        ),
        (
          'Tabs tag height',
          const DefaultTabController(
            length: 2,
            child: TTabsBar(
              variant: TTabsBarVariant.tag,
              tabs: [
                TTab(text: '一'),
                TTab(text: '二'),
              ],
            ),
          ),
          'size10',
          32,
          tagHeight,
          null,
        ),
        for (final entry in [
          (TTimeCounterSize.small, 'size7', 20.0),
          (TTimeCounterSize.medium, 'size8', 24.0),
          (TTimeCounterSize.large, 'size9', 28.0),
        ])
          (
            'CountDown ${entry.$1}',
            TTimeCounter(
              time: 5000,
              autoStart: false,
              size: entry.$1,
              variant: TTimeCounterVariant.square,
            ),
            entry.$2,
            entry.$3,
            block,
            null,
          ),
      ];
  for (final dark in [false, true]) {
    for (final entry in cases) {
      testWidgets('用户授权一致刻度 ${entry.$1} dark=$dark', (tester) async {
        final base = TThemeData.defaultData();
        final token = dark ? base.dark! : base;
        Future<void> pump(
          TThemeData data, [
          ThemeExtension<dynamic>? component,
        ]) async {
          await tester.pumpWidget(
            MaterialApp(
              themeAnimationDuration: Duration.zero,
              theme:
                  (dark ? TThemeBuilder.dark(data) : TThemeBuilder.light(data))
                      .copyWith(
                        extensions: [data, if (component != null) component],
                      ),
              home: Scaffold(body: Center(child: entry.$2)),
            ),
          );
          // Button icon themes animate on newer Flutter versions.
          await tester.pump(const Duration(milliseconds: 300));
          await tester.pump();
        }

        await pump(token);
        final element = tester.element(find.byWidget(entry.$2));
        expect(entry.$5(tester), entry.$4);
        final unrelated = token.copyWith(
          sizeMap: {...token.sizeMap, 'size16': 73},
        );
        await pump(unrelated);
        expect(entry.$5(tester), entry.$4);
        final changed = unrelated.copyWith(
          sizeMap: {...unrelated.sizeMap, entry.$3: entry.$4 + 2},
        );
        await pump(changed);
        expect(entry.$5(tester), entry.$4 + 2);
        expect(tester.element(find.byWidget(entry.$2)), same(element));
        if (entry.$6 != null) {
          await pump(changed, entry.$6);
          expect(entry.$5(tester), 13);
          final empty = emptyTheme(entry.$6!);
          await pump(changed, entry.$6!.lerp(empty, 0.5));
          expect(entry.$5(tester), (13 + entry.$4 + 2) / 2);
        }
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      });
    }
  }
}
