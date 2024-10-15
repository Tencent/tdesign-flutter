import 'package:flutter/cupertino.dart';

class TDFormInherited extends InheritedWidget {
  final bool disabled;
  final double? labelWidth;
  final bool isHorizontal;

  const TDFormInherited({
    required Widget child,
    required this.disabled,
    required this.isHorizontal,
    this.labelWidth,
  }) : super(child: child);

  static TDFormInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TDFormInherited>();
  }

  @override
  bool updateShouldNotify(TDFormInherited oldWidget) {
    return disabled != oldWidget.disabled ||
        labelWidth != oldWidget.labelWidth ||
        isHorizontal != oldWidget.isHorizontal;
  }
}
