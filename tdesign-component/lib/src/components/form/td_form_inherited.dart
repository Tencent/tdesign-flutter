import 'package:flutter/cupertino.dart';

import '../../../tdesign_flutter.dart';

class TDFormInherited extends InheritedWidget {
  final bool disabled;
  final double? labelWidth;
  final bool isHorizontal;
  final bool isValidate;
  final List<TDFormValidation> rules;

  const TDFormInherited(
      {super.key,
      required Widget child,
      required this.disabled,
      required this.isHorizontal,
      required this.isValidate,
      this.labelWidth,
      required this.rules})
      : super(child: child);

  static TDFormInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TDFormInherited>();
  }

  @override
  bool updateShouldNotify(TDFormInherited oldWidget) {
    return disabled != oldWidget.disabled ||
        labelWidth != oldWidget.labelWidth ||
        isHorizontal != oldWidget.isHorizontal ||
        isValidate != oldWidget.isValidate ||
        rules != oldWidget.rules;
  }
}
