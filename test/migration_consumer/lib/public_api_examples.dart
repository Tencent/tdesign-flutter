import 'package:tdesign_flutter/tdesign_flutter.dart';

// Compile-only contracts for migrated public constructors and parameter types.
// These are checked by flutter analyze; behavior belongs to focused tests.

List<Widget> instanceMigrationExamples() {
  return <Widget>[
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
    TIndexes(indexList: const ['A'], builderContent: (_, index) => Text(index)),
    const TIcon(Icons.home, size: 20, color: Colors.green),
  ];
}

ThemeData themeMigrationExample() {
  return ThemeData(
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
}

List<Widget> colorPresetMigrationExamples() {
  const buttonStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.green),
  );
  return const <Widget>[
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
}

TPopupOptions popupMigrationExample() => TPopupOptions.bottom(
  child: const Text('Panel'),
  animationDuration: const Duration(milliseconds: 120),
  overlay: const TPopupOverlayConfig(color: Color(0x33000000)),
);

TSwipeCellAction swipeActionMigrationExample() => const TSwipeCellAction(
  label: 'Delete',
  backgroundColor: Colors.red,
  icon: Icons.delete,
  iconColor: Colors.white,
  iconSize: 20,
  iconLabelSpacing: 4,
  labelStyle: TextStyle(color: Colors.white),
);

Widget textStyleMigrationExample() => const Column(
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
);

Widget avatarGroupMigrationExample() => const TAvatarGroup(
  children: [
    TAvatar(shape: TAvatarShape.square, child: Text('A')),
    TAvatar(child: Text('B')),
  ],
);

TTagThemeData tagThemeMigrationExample() => const TTagThemeData(
  dangerColor: Colors.purple,
  successColor: Colors.green,
  successLightColor: Colors.lime,
  squareBorderRadius: 3,
);
