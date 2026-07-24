import 'package:flutter/material.dart';

/// TDesign 表单容器。
///
/// 校验和字段生命周期委托给 Flutter [Form] 与 [FormState]。
class TForm extends StatefulWidget {
  const TForm({
    super.key,

    /// 表单内容。
    required this.child,

    /// 表单控制器。
    this.controller,

    /// 自动校验时机。
    this.autovalidateMode = AutovalidateMode.disabled,

    /// 任意字段变化时触发。
    this.onChanged,

    /// 校验通过后触发，参数为各 [TFormField] 注册的字段值。
    this.onSubmit,

    /// 是否向字段 builder 暴露错误文案。
    this.showErrorMessage = true,
  });

  /// 表单内容。
  final Widget child;

  /// 表单控制器。
  final TFormController? controller;

  /// 自动校验时机。
  final AutovalidateMode autovalidateMode;

  /// 任意字段变化时触发。
  final VoidCallback? onChanged;

  /// 校验通过后触发。
  final ValueChanged<Map<String, Object?>>? onSubmit;

  /// 是否向字段 builder 暴露错误文案。
  final bool showErrorMessage;

  @override
  TFormState createState() => TFormState();
}

/// [TForm] 的公开状态。
class TFormState extends State<TForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, Object?> _values = {};

  /// 当前字段值的只读快照。
  Map<String, Object?> get values => Map.unmodifiable(_values);

  /// 运行所有字段校验。
  bool validate() => _formKey.currentState?.validate() ?? false;

  /// 校验并在成功时触发 [TForm.onSubmit]。
  bool submit() {
    final valid = validate();
    if (valid) {
      _formKey.currentState?.save();
      widget.onSubmit?.call(values);
    }
    return valid;
  }

  /// 重置字段的 Material 校验状态。
  void reset() {
    _formKey.currentState?.reset();
    widget.onChanged?.call();
  }

  void _setValue(String name, Object? value) {
    _values[name] = value;
  }

  void _removeValue(String name) {
    _values.remove(name);
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
  }

  @override
  void didUpdateWidget(covariant TForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      widget.controller?._attach(this);
    }
  }

  @override
  void dispose() {
    widget.controller?._detach(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _TFormScope(
      state: this,
      showErrorMessage: widget.showErrorMessage,
      child: Form(
        key: _formKey,
        autovalidateMode: widget.autovalidateMode,
        onChanged: widget.onChanged,
        child: widget.child,
      ),
    );
  }
}

/// 命令式触发表单提交、校验和重置。
class TFormController {
  TFormState? _state;

  /// 当前字段值的只读快照。
  Map<String, Object?> get values => _state?.values ?? const {};

  /// 运行所有字段校验。
  bool validate() => _state?.validate() ?? false;

  /// 校验并提交表单。
  bool submit() => _state?.submit() ?? false;

  /// 重置表单。
  void reset() => _state?.reset();

  void _attach(TFormState state) => _state = state;

  void _detach(TFormState state) {
    if (identical(_state, state)) {
      _state = null;
    }
  }
}

class _TFormScope extends InheritedWidget {
  const _TFormScope({
    required this.state,
    required this.showErrorMessage,
    required super.child,
  });

  final TFormState state;
  final bool showErrorMessage;

  static _TFormScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_TFormScope>();
  }

  @override
  bool updateShouldNotify(_TFormScope oldWidget) {
    return showErrorMessage != oldWidget.showErrorMessage;
  }
}

/// TDesign 字段 builder。
typedef TFormFieldBuilder<T> = Widget Function(
  BuildContext context,
  T value,
  ValueChanged<T>? onChanged,
  String? errorText,
);

/// 将严格受控组件接入 Flutter [FormField] 的字段桥接组件。
class TFormField<T> extends StatefulWidget {
  const TFormField({
    super.key,

    /// 字段名，在表单提交数据中作为 key。
    required this.name,

    /// 受控字段值。
    required this.value,

    /// 字段内容 builder。
    required this.builder,

    /// 字段值变化回调；为 null 时禁用字段。
    this.onChanged,

    /// 字段校验器。
    this.validator,

    /// 保存字段时触发。
    this.onSaved,

    /// 自动校验时机；为空时继承 [TForm]。
    this.autovalidateMode,
  });

  /// 字段名。
  final String name;

  /// 受控字段值。
  final T value;

  /// 字段值变化回调；为 null 时禁用字段。
  final ValueChanged<T>? onChanged;

  /// 字段内容 builder。
  final TFormFieldBuilder<T> builder;

  /// 字段校验器。
  final FormFieldValidator<T>? validator;

  /// 保存字段时触发。
  final FormFieldSetter<T>? onSaved;

  /// 自动校验时机。
  final AutovalidateMode? autovalidateMode;

  @override
  State<TFormField<T>> createState() => _TFormFieldState<T>();
}

class _TFormFieldState<T> extends State<TFormField<T>> {
  _TFormScope? _scope;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bindScope(_TFormScope.maybeOf(context));
  }

  @override
  void didUpdateWidget(covariant TFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.name != widget.name) {
      _scope?.state._removeValue(oldWidget.name);
    }
    _scope?.state._setValue(widget.name, widget.value);
  }

  @override
  void dispose() {
    _scope?.state._removeValue(widget.name);
    super.dispose();
  }

  void _bindScope(_TFormScope? next) {
    if (!identical(_scope, next)) {
      _scope?.state._removeValue(widget.name);
      _scope = next;
    }
    _scope?.state._setValue(widget.name, widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      key: ValueKey<Object?>(widget.value),
      initialValue: widget.value,
      enabled: widget.onChanged != null,
      validator: widget.validator,
      onSaved: widget.onSaved,
      autovalidateMode: widget.autovalidateMode,
      builder: (field) {
        return widget.builder(
          context,
          widget.value,
          widget.onChanged == null
              ? null
              : (next) {
                  field.didChange(next);
                  _scope?.state._setValue(widget.name, next);
                  widget.onChanged?.call(next);
                },
          _scope?.showErrorMessage ?? true ? field.errorText : null,
        );
      },
    );
  }
}
