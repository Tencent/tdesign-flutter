import 'package:flutter/widgets.dart';

/// 表单项内部视觉作用域。
///
/// 输入组件使用该作用域识别自己处于表单项内容区，从而避免把字段行的
/// `TFormItem` 内边距和输入组件自身的默认内边距叠加。
class TFormItemScope extends InheritedWidget {
  const TFormItemScope({super.key, required super.child});

  static bool maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TFormItemScope>() != null;
  }

  @override
  bool updateShouldNotify(TFormItemScope oldWidget) => false;
}
