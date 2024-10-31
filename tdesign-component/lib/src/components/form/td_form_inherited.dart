import 'package:flutter/cupertino.dart';

import '../../../tdesign_flutter.dart';

class TDFormInherited extends InheritedWidget {
  final bool disabled;
  final double? labelWidth;
  final bool isHorizontal;
  final bool isValidate;
  final List<TDFormValidation> rules;
  final bool? formShowErrorMessage;
  final TextAlign formContentAlign;

  const TDFormInherited({
    super.key,
    required Widget child,
    required this.disabled,
    required this.isHorizontal,
    required this.isValidate,
    required this.rules,
    required this.formContentAlign,
    this.labelWidth,
    this.formShowErrorMessage,
  }) : super(child: child);

  static TDFormInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TDFormInherited>();
  }

  @override
  bool updateShouldNotify(TDFormInherited oldWidget) {
    return disabled != oldWidget.disabled ||
        labelWidth != oldWidget.labelWidth ||
        isHorizontal != oldWidget.isHorizontal ||
        isValidate != oldWidget.isValidate ||
        rules != oldWidget.rules ||
        formShowErrorMessage != oldWidget.formShowErrorMessage ||
        formContentAlign != oldWidget.formContentAlign;
  }
}
