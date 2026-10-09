import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

Widget host(
  Widget child, {
  List<ThemeExtension<dynamic>> extensions = const [],
}) {
  final theme = ThemeData(
    extensions: [TThemeData.defaultData(), ...extensions],
  );
  return MaterialApp(
    theme: theme,
    home: Scaffold(body: child),
  );
}

TThemeData copyTheme(TThemeData theme) =>
    theme.copyWith(spacerMap: {'spacer': 10});

TThemeData transitionTheme(TThemeData theme, TThemeData other) =>
    theme.lerp(other, 0.5);

void main() {
  test('TThemeData operations return the public concrete type', () {
    final token = TThemeData.defaultData().copyWith(name: 'consumer');
    final copied = copyTheme(token).copyWith(radiusMap: {'radiusDefault': 20});
    expect(copied.name, 'consumer');
    expect(copied.spacerMap['spacer'], 10);
    expect(copied.radiusMap['radiusDefault'], 20);
    expect(transitionTheme(token, copied).name, 'consumer');
  });

  test('moved specification and interaction choices compile on instances', () {
    final widgets = <Widget>[
      const TSearchBar(variant: TSearchBarVariant.round),
      const TCollapse<int>(
        value: [],
        children: [],
        variant: TCollapseVariant.card,
        animationDuration: Duration(milliseconds: 120),
      ),
      TTable<Map<String, Object>>(
        columns: [
          TTableColumn(
            id: 'name',
            header: const Text('Name'),
            cellBuilder: (_, row, index) => Text(row['name']! as String),
          ),
        ],
        data: const [],
        bordered: true,
        stripe: true,
      ),
      const TLink(size: TLinkSize.large, underline: true),
      const TCell(align: TCellAlign.top),
      const TCellGroup(cells: [], variant: TCellGroupVariant.card),
      const TInput(
        clearButtonMode: TInputClearButtonMode.always,
        cursorColor: Colors.green,
        style: TextStyle(fontSize: 18),
      ),
      const TTextarea(minLines: 3),
      const TSwitch(
        value: false,
        size: TSwitchSize.small,
        variant: TSwitchVariant.text,
      ),
      const TTimeCounter(
        time: 1000,
        autoStart: false,
        size: TTimeCounterSize.small,
        variant: TTimeCounterVariant.square,
      ),
      const TStepper(
        value: 1,
        size: TStepperSize.small,
        variant: TStepperVariant.outline,
      ),
      const TButton(
        size: TButtonSize.small,
        variant: TButtonVariant.outline,
        shape: TButtonShape.square,
      ),
      const TAvatar(
        size: TAvatarSize.small,
        shape: TAvatarShape.square,
        child: Text('A', style: TextStyle(fontSize: 16)),
      ),
      const TTag('Tag', shape: TTagShape.square),
      const TSelectTag('Tag', value: true, shape: TTagShape.square),
      const TFormItem(
        child: Text('Field'),
        verticalAlignment: TFormItemVerticalAlignment.center,
        contentAlignment: TFormItemContentAlignment.end,
      ),
      const TDrawer(child: Text('Drawer')),
      const TNavBar(title: Text('Navigation')),
      const TDropdownMenu(
        items: [],
        animationDuration: Duration(milliseconds: 120),
      ),
      const TTabsBar(tabs: [TTab(text: 'Tab')]),
      const TSwiper(children: [Text('Slide')]),
      TIndexes(
        indexList: const ['A'],
        builderContent: (_, index) => Text(index),
      ),
      const TIcon(Icons.home, size: 20, color: Colors.green),
    ];
    expect(widgets, hasLength(23));
  });

  test(
    'all moved visual defaults are accessible through public Theme types',
    () {
      final theme = ThemeData(
        extensions: [
          const TCollapseThemeData(elevation: 2),
          const TAvatarThemeData(
            dimension: 40,
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          const TDrawerThemeData(width: 280, backgroundColor: Colors.white),
          const TNavBarThemeData(
            titleColor: Colors.blue,
            backIconColor: Colors.green,
            backgroundColor: Colors.white,
            padding: EdgeInsets.all(4),
            titleMargin: 8,
            opacity: 0.9,
            border: TNavBarBorder(),
            boxShadow: [],
          ),
          const TTabBarThemeData(
            barHeight: 64,
            dividerHeight: 20,
            dividerThickness: 1,
            dividerColor: Colors.red,
            selectedBgColor: Colors.green,
            unselectedBgColor: Colors.white,
            backgroundColor: Colors.white,
          ),
          const TDialogThemeData(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(),
            elevation: 2,
            width: 300,
            maxHeight: 400,
            contentPadding: EdgeInsets.all(8),
          ),
          const TFormThemeData(labelWidth: 80, labelAlign: TextAlign.end),
          const TPopoverThemeData(
            offset: 8,
            arrowSize: 6,
            padding: EdgeInsets.all(8),
            barrierColor: Color(0x33000000),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8)),
          ),
          const TSideBarThemeData(
            textStyle: TextStyle(color: Colors.black),
            selectedTextStyle: TextStyle(color: Colors.blue),
            contentPadding: EdgeInsets.all(8),
            selectedBgColor: Colors.white,
            unSelectedBgColor: Colors.grey,
          ),
          const TTabsBarThemeData(
            indicator: BoxDecoration(color: Colors.blue),
            backgroundColor: Colors.white,
            dividerColor: Colors.grey,
            dividerHeight: 1,
          ),
          const TIndexesThemeData(indexListMaxHeight: 0.8),
          const TSwiperThemeData(paginationAlignment: Alignment.bottomLeft),
          TTagThemeData(
            font: Font(size: 12, lineHeight: 20, fontWeight: FontWeight.w600),
            squareBorderRadius: 3,
          ),
          const TProgressThemeData(circleSize: 100),
          const TButtonThemeData(iconTextSpacing: 8),
          const TInputThemeData(hintStyle: TextStyle(color: Colors.grey)),
          const TBadgeThemeData(backgroundColor: Colors.red),
          const TSliderThemeData(inactiveTrackColor: Colors.grey),
          const TPopupThemeData(barrierColor: Color(0x66000000)),
          const TSwipeCellThemeData(actionPadding: EdgeInsets.all(16)),
          const TTextThemeData(textStyle: TextStyle(fontSize: 16, height: 1.5)),
        ],
      );
      expect(theme.extension<TAvatarThemeData>()!.dimension, 40);
      expect(theme.extension<TProgressThemeData>()!.circleSize, 100);
      expect(
        theme.extension<TSideBarThemeData>()!.selectedTextStyle!.color,
        Colors.blue,
      );
    },
  );

  test('renamed color presets and per-action styles compile together', () {
    const buttonStyle = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.green),
    );
    const widgets = <Widget>[
      TButton(colorPreset: TButtonColorPreset.primary, style: buttonStyle),
      TTag('Danger', colorPreset: TTagColorPreset.danger),
      TSelectTag('Success', value: true, colorPreset: TTagColorPreset.success),
      TLink(colorPreset: TLinkColorPreset.primary),
      TBackTop(colorPreset: TBackTopColorPreset.dark),
      TDialog(
        actions: [
          TDialogAction(
            child: Text('OK'),
            colorPreset: TButtonColorPreset.primary,
            style: buttonStyle,
          ),
        ],
      ),
      TConfirmDialog(buttonStyle: buttonStyle),
    ];
    expect(widgets, hasLength(7));
  });

  testWidgets(
    'migrated Text styles preserve subtree defaults and instance overrides',
    (tester) async {
      await tester.pumpWidget(
        host(
          const Column(
            children: [
              TText('Inherited'),
              TText(
                'Explicit',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'custom',
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.green,
                ),
              ),
              TText.rich(
                TTextSpan(
                  text: 'Rich',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
          extensions: [
            const TTextThemeData(
              textStyle: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      );
      expect(
        tester.widget<Text>(find.text('Inherited')).style!.color,
        Colors.blue,
      );
      final style = tester.widget<Text>(find.text('Explicit')).style!;
      expect(style.fontSize, 16);
      expect(style.color, Colors.red);
      expect(style.fontWeight, FontWeight.w600);
      expect(style.decoration, TextDecoration.lineThrough);
      expect(style.decorationColor, Colors.green);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'local Avatar Theme replaces removed instance colors and dimension',
    (tester) async {
      await tester.pumpWidget(
        host(
          const TAvatarGroup(
            children: [
              TAvatar(shape: TAvatarShape.square, child: Text('A')),
              TAvatar(child: Text('B')),
            ],
          ),
          extensions: [
            const TAvatarThemeData(
              dimension: 40,
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ],
        ),
      );
      expect(tester.getSize(find.byType(TAvatar).first), const Size(40, 40));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Tag-specific overrides remain independently configurable', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        const Row(
          children: [
            TTag(
              'Danger',
              colorPreset: TTagColorPreset.danger,
              variant: TTagVariant.light,
            ),
            TTag(
              'Success',
              colorPreset: TTagColorPreset.success,
              variant: TTagVariant.light,
            ),
          ],
        ),
        extensions: [
          const TTagThemeData(
            dangerColor: Colors.purple,
            successColor: Colors.green,
            successLightColor: Colors.lime,
            squareBorderRadius: 3,
          ),
        ],
      ),
    );
    expect(
      tester.widget<Text>(find.text('Danger')).style!.color,
      Colors.purple,
    );
    expect(
      tester.widget<Text>(find.text('Success')).style!.color,
      Colors.green,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'TabBar Theme height and inline items work through the public API',
    (tester) async {
      var tapped = -1;
      await tester.pumpWidget(
        host(
          TTabBar(
            type: TTabBarType.iconText,
            value: 0,
            onChanged: (index) => tapped = index,
            useSafeArea: false,
            iconTextLayout: TTabBarIconTextLayout.inline,
            navigationTabs: [
              TTabBarItemConfig(
                tabText: 'One',
                selectedIcon: const Icon(Icons.home),
                unselectedIcon: const Icon(Icons.home),
                onTap: () => tapped = 0,
              ),
              TTabBarItemConfig(
                tabText: 'Two',
                selectedIcon: const Icon(Icons.star),
                unselectedIcon: const Icon(Icons.star),
                onTap: () => tapped = 1,
              ),
            ],
          ),
          extensions: [const TTabBarThemeData(barHeight: 64)],
        ),
      );
      expect(tester.getSize(find.byType(TTabBar)).height, 64);
      await tester.tap(find.text('Two'));
      expect(tapped, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Popover commands consume the migrated local Theme and colorPreset',
    (tester) async {
      final controller = TPopoverController();
      await tester.pumpWidget(
        host(
          Center(
            child: TPopoverAnchor(
              controller: controller,
              content: const Text('Popover body'),
              colorPreset: TPopoverColorPreset.primary,
              showArrow: false,
              builder: (context, controller, child) => TextButton(
                onPressed: controller.open,
                child: const Text('Open'),
              ),
            ),
          ),
          extensions: [
            const TPopoverThemeData(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              barrierColor: Color(0x33000000),
              padding: EdgeInsets.all(8),
            ),
          ],
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Popover body'), findsOneWidget);
      controller.close();
      await tester.pumpAndSettle();
      expect(find.text('Popover body'), findsNothing);
      final closed = TPopover.showPopover(
        context: tester.element(find.text('Open')),
        content: const Text('One-shot'),
        colorPreset: TPopoverColorPreset.primary,
        showArrow: false,
      );
      await tester.pumpAndSettle();
      expect(find.text('One-shot'), findsOneWidget);
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      await closed;
      expect(find.text('One-shot'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Popup migrated overlay and options open and close externally', (
    tester,
  ) async {
    await tester.pumpWidget(host(const Center(child: Text('Anchor'))));
    final handle = TPopup.show(
      tester.element(find.text('Anchor')),
      options: TPopupOptions.bottom(
        child: const SizedBox(height: 80, child: Text('Panel')),
        animationDuration: const Duration(milliseconds: 120),
        overlay: const TPopupOverlayConfig(color: Color(0x33000000)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Panel'), findsOneWidget);
    handle.close();
    await tester.pumpAndSettle();
    expect(find.text('Panel'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  test(
    'Popup alpha and duration and SwipeCell per-item visuals have public replacements',
    () {
      final popup = TPopupOptions.bottom(
        child: const Text('Panel'),
        animationDuration: const Duration(milliseconds: 120),
        overlay: const TPopupOverlayConfig(color: Color(0x33000000)),
      );
      expect(popup.animationDuration, const Duration(milliseconds: 120));
      expect(popup.overlay!.color, const Color(0x33000000));
      const action = TSwipeCellAction(
        label: 'Delete',
        backgroundColor: Colors.red,
        icon: Icons.delete,
        iconColor: Colors.white,
        iconSize: 20,
        iconLabelSpacing: 4,
        labelStyle: TextStyle(color: Colors.white),
      );
      expect(action.iconLabelSpacing, 4);
      expect(
        () => TSwipeCellAction(
          label: 'Conflict',
          builder: (_) => const Text('Custom'),
        ),
        throwsAssertionError,
      );
    },
  );
}
