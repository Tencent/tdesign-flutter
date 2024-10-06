import 'package:flutter/cupertino.dart';

class TDFormInherited extends InheritedWidget {
  const TDFormInherited(
      {required Widget child, required this.disabled, Key? key})
      : super(child: child, key: key);

  final bool disabled;

  @override
  bool updateShouldNotify(covariant TDFormInherited oldWidget) {
    return true;
  }

  static TDFormInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TDFormInherited>();
  }
}
