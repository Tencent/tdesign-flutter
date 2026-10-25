// These consumers deliberately implement only the v1.0.0 public interface.
import 'package:tdesign_flutter/tdesign_flutter.dart';

class LegacyDrawerTheme implements TDrawerThemeData {
  const LegacyDrawerTheme({this.delegate = const TDrawerThemeData()});
  final TDrawerThemeData delegate;
  @override
  Type get type => TDrawerThemeData;
  @override
  double? get width => delegate.width;
  @override
  Color? get backgroundColor => delegate.backgroundColor;
  @override
  TextStyle? get titleStyle => delegate.titleStyle;
  @override
  EdgeInsetsGeometry? get titlePadding => delegate.titlePadding;
  @override
  TextStyle? get itemTextStyle => delegate.itemTextStyle;
  @override
  Color? get itemBackgroundColor => delegate.itemBackgroundColor;
  @override
  Color? get itemPressedColor => delegate.itemPressedColor;
  @override
  EdgeInsetsGeometry? get itemPadding => delegate.itemPadding;
  @override
  Color? get itemIconColor => delegate.itemIconColor;
  @override
  double? get itemIconSize => delegate.itemIconSize;
  @override
  double? get itemIconGap => delegate.itemIconGap;
  @override
  Color? get dividerColor => delegate.dividerColor;
  @override
  double? get dividerIndent => delegate.dividerIndent;
  @override
  double? get dividerThickness => delegate.dividerThickness;
  @override
  EdgeInsetsGeometry? get footerPadding => delegate.footerPadding;
  @override
  TDrawerThemeData copyWith({
    double? width,
    Color? backgroundColor,
    TextStyle? titleStyle,
    EdgeInsetsGeometry? titlePadding,
    TextStyle? itemTextStyle,
    Color? itemBackgroundColor,
    Color? itemPressedColor,
    EdgeInsetsGeometry? itemPadding,
    Color? itemIconColor,
    double? itemIconSize,
    double? itemIconGap,
    Color? dividerColor,
    double? dividerIndent,
    double? dividerThickness,
    EdgeInsetsGeometry? footerPadding,
  }) => delegate.copyWith(
    width: width,
    backgroundColor: backgroundColor,
    titleStyle: titleStyle,
    titlePadding: titlePadding,
    itemTextStyle: itemTextStyle,
    itemBackgroundColor: itemBackgroundColor,
    itemPressedColor: itemPressedColor,
    itemPadding: itemPadding,
    itemIconColor: itemIconColor,
    itemIconSize: itemIconSize,
    itemIconGap: itemIconGap,
    dividerColor: dividerColor,
    dividerIndent: dividerIndent,
    dividerThickness: dividerThickness,
    footerPadding: footerPadding,
  );
  @override
  TDrawerThemeData lerp(ThemeExtension<TDrawerThemeData>? other, double t) =>
      delegate.lerp(other, t);
}

class LegacyTabBarTheme implements TTabBarThemeData {
  const LegacyTabBarTheme({this.delegate = const TTabBarThemeData()});
  final TTabBarThemeData delegate;
  @override
  Type get type => TTabBarThemeData;
  @override
  double? get barHeight => delegate.barHeight;
  @override
  Color? get selectedBgColor => delegate.selectedBgColor;
  @override
  Color? get unselectedBgColor => delegate.unselectedBgColor;
  @override
  Color? get backgroundColor => delegate.backgroundColor;
  @override
  double? get dividerHeight => delegate.dividerHeight;
  @override
  double? get dividerThickness => delegate.dividerThickness;
  @override
  Color? get dividerColor => delegate.dividerColor;
  @override
  TTabBarThemeData copyWith({
    double? barHeight,
    Color? selectedBgColor,
    Color? unselectedBgColor,
    Color? backgroundColor,
    double? dividerHeight,
    double? dividerThickness,
    Color? dividerColor,
  }) => delegate.copyWith(
    barHeight: barHeight,
    selectedBgColor: selectedBgColor,
    unselectedBgColor: unselectedBgColor,
    backgroundColor: backgroundColor,
    dividerHeight: dividerHeight,
    dividerThickness: dividerThickness,
    dividerColor: dividerColor,
  );
  @override
  TTabBarThemeData lerp(ThemeExtension<TTabBarThemeData>? other, double t) =>
      delegate.lerp(other, t);
}
