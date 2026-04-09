import 'package:flutter/cupertino.dart';

import 'td_dropdown_item.dart';
import 'td_dropdown_menu.dart';
import 'td_dropdown_popup.dart';

class TDropdownInherited extends InheritedWidget {
  const TDropdownInherited({required Widget child, required this.popupState, required this.directionListenable, Key? key})
      : super(child: child, key: key);

  final TDropdownPopup popupState;
  final ValueNotifier<TDropdownMenuDirection> directionListenable;

  @override
  bool updateShouldNotify(covariant TDropdownInherited oldWidget) {
    return true;
  }

  static TDropdownInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TDropdownInherited>();
  }
}
