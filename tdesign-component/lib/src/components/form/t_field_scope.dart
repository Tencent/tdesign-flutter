import 'package:flutter/widgets.dart';

/// 表单字段向视觉组件传递的中立状态。
///
/// 该 scope 不暴露表单生命周期，也不要求子组件了解 `TForm` 或
/// `TFormField`。它只描述当前字段的展示状态，供表单项和输入组件消费。
class TFieldScope extends InheritedWidget {
  const TFieldScope({
    super.key,
    required this.required,
    required this.errorText,
    this.showErrorInInput = true,
    required super.child,
  });

  /// 当前字段是否为必填。
  final bool required;

  /// 当前字段的错误文案。
  final String? errorText;

  /// 是否由输入组件消费错误状态；TFormItem 展示错误时会关闭它。
  final bool showErrorInInput;

  /// 读取最近的字段展示状态。
  static TFieldScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TFieldScope>();
  }

  @override
  bool updateShouldNotify(TFieldScope oldWidget) {
    return required != oldWidget.required ||
        errorText != oldWidget.errorText ||
        showErrorInInput != oldWidget.showErrorInInput;
  }
}
