import 'package:flutter/cupertino.dart';

import 'td_dropdown_item.dart';
import 'td_dropdown_popup.dart';

class TDDropdownInherited extends InheritedWidget {
  const TDDropdownInherited({required Widget child, required this.state, Key? key})
      : super(child: child, key: key);

  final TDDropdownPopup state;

  @override
  bool updateShouldNotify(covariant TDDropdownInherited oldWidget) {
    return true;
  }

  static TDDropdownInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TDDropdownInherited>();
  }
}
