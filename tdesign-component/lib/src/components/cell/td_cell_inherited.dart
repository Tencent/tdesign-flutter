import 'package:flutter/cupertino.dart';

import 'td_cell_style.dart';

class TCellInherited extends InheritedWidget {
  const TCellInherited({required Widget child, required this.style, Key? key})
      : super(child: child, key: key);

  final TCellStyle style;

  @override
  bool updateShouldNotify(covariant TCellInherited oldWidget) {
    return true;
  }

  static TCellInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TCellInherited>();
  }
}
