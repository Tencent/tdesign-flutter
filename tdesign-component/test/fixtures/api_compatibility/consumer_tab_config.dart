// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package

import 'package:tdesign_flutter/tdesign_flutter.dart';

class ConsumerTabConfig implements TTabBarItemConfig {
  const ConsumerTabConfig({this.delegate = const TTabBarItemConfig()});
  final TTabBarItemConfig delegate;

  @override
  Widget? get selectedIcon => delegate.selectedIcon;

  @override
  Widget? get unselectedIcon => delegate.unselectedIcon;

  @override
  String? get tabText => delegate.tabText;

  @override
  TextStyle? get selectTabTextStyle => delegate.selectTabTextStyle;

  @override
  TextStyle? get unselectTabTextStyle => delegate.unselectTabTextStyle;

  @override
  GestureTapCallback? get onTap => delegate.onTap;

  @override
  TBadgeConfig? get badge => delegate.badge;

  @override
  TTabBarPopUpBtnConfig? get popUpButtonConfig => delegate.popUpButtonConfig;

  @override
  GestureLongPressCallback? get onLongPress => delegate.onLongPress;

  @override
  bool get allowMultipleTaps => delegate.allowMultipleTaps;

  @override
  bool get notifyOnReselect => allowMultipleTaps;
}
