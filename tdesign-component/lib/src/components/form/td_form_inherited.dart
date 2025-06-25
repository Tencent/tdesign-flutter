import 'package:flutter/cupertino.dart';

import '../../../tdesign_flutter.dart';

class TDFormInherited extends InheritedWidget {
  final Map<String, dynamic>  formData;
  final double? labelWidth;
  final bool isHorizontal;
  final bool isValidate;
  final Map<String,TDFormValidation> rules;
  final bool? formShowErrorMessage;
  final bool? requiredMark;
  final TextAlign formContentAlign;
  final Function  onFormDataChange;
  final Function onSubmit;
  const TDFormInherited({
    super.key,
    required this.formData,
    required Widget child,
    required this.isHorizontal,
    required this.isValidate,
    required this.rules,
    required this.formContentAlign,
    required this.onFormDataChange,
    required this.onSubmit,
    required this.requiredMark,
    this.labelWidth,
    this.formShowErrorMessage,
  }) : super(child: child);

  static TDFormInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TDFormInherited>();
  }

  @override
  bool updateShouldNotify(TDFormInherited oldWidget) {
    return
        labelWidth != oldWidget.labelWidth ||
        isHorizontal != oldWidget.isHorizontal ||
        isValidate != oldWidget.isValidate ||
        rules != oldWidget.rules ||
        formShowErrorMessage != oldWidget.formShowErrorMessage ||
        formContentAlign != oldWidget.formContentAlign;
  }
}
