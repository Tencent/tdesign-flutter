import 'package:flutter/cupertino.dart';

import 'td_dropdown_item.dart';
import 'td_dropdown_menu.dart';
import 'td_dropdown_popup.dart';

class TDDropdownInherited extends InheritedWidget {
  const TDDropdownInherited({required Widget child, required this.popupState, required this.directionListenable, Key? key})
      : super(child: child, key: key);

  final TDDropdownPopup popupState;
  final ValueNotifier<TDDropdownMenuDirection> directionListenable;

  @override
  bool updateShouldNotify(covariant TDDropdownInherited oldWidget) {
    return true;
  }

  static TDDropdownInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TDDropdownInherited>();
  }
}
