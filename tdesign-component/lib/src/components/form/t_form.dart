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
    this.autovalidateMode,

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
  ///
  /// 未传时，首次 [TFormController.submit] 校验失败后会切换为
  /// [AutovalidateMode.onUserInteraction]；显式传入时完全遵循 Flutter
  /// [Form] 的校验语义。
  final AutovalidateMode? autovalidateMode;

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
  final Map<String, Object> _fieldOwners = {};
  bool _hasSubmitted = false;

  /// 当前字段值的只读快照。
  Map<String, Object?> get values => Map.unmodifiable(_values);

  /// 运行所有字段校验。
  bool validate() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!_hasSubmitted) {
      setState(() => _hasSubmitted = true);
    }
    return valid;
  }

  /// 校验并在成功时触发 [TForm.onSubmit]。
  bool submit() {
    final valid = validate();
    if (valid) {
      _formKey.currentState?.save();
      widget.onSubmit?.call(values);
    }
    return valid;
  }

  /// 重置 Flutter 字段的交互和校验状态。
  ///
  /// 字段值由业务受控状态所有；调用方应自行恢复 [TFormField.value]。
  void reset() {
    _formKey.currentState?.reset();
    if (_hasSubmitted) {
      setState(() => _hasSubmitted = false);
    }
  }

  AutovalidateMode get _effectiveAutovalidateMode {
    return widget.autovalidateMode ??
        (_hasSubmitted
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled);
  }

  void _registerField(String name, Object owner, Object? value) {
    final previousOwner = _fieldOwners[name];
    assert(
      previousOwner == null || identical(previousOwner, owner),
      'Duplicate TFormField name: $name. Each mounted field in a TForm must '
      'have a unique name.',
    );
    if (previousOwner != null && !identical(previousOwner, owner)) {
      return;
    }
    _fieldOwners[name] = owner;
    _values[name] = value;
  }

  void _setValue(String name, Object owner, Object? value) {
    if (identical(_fieldOwners[name], owner)) {
      _values[name] = value;
    }
  }

  void _removeField(String name, Object owner) {
    if (identical(_fieldOwners[name], owner)) {
      _fieldOwners.remove(name);
      _values.remove(name);
    }
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
      autovalidateMode: _effectiveAutovalidateMode,
      child: Form(
        key: _formKey,
        autovalidateMode: _effectiveAutovalidateMode,
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
    required this.autovalidateMode,
    required super.child,
  });

  final TFormState state;
  final bool showErrorMessage;
  final AutovalidateMode autovalidateMode;

  static _TFormScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_TFormScope>();
  }

  @override
  bool updateShouldNotify(_TFormScope oldWidget) {
    return showErrorMessage != oldWidget.showErrorMessage ||
        autovalidateMode != oldWidget.autovalidateMode;
  }
}

/// 字段 builder 子树中的当前表单状态。
///
/// 这是 Form 与基础输入组件之间的内部桥接；应用代码通常只需使用
/// [TFormField] builder 的 `errorText` 参数，或让表单项自动展示错误。
class TFormFieldScope extends InheritedWidget {
  const TFormFieldScope({
    super.key,
    required this.required,
    required this.errorText,
    required super.child,
  });

  /// 当前字段是否为必填。
  final bool required;

  /// 当前字段的校验错误；全局关闭错误展示时为 null。
  final String? errorText;

  /// 读取最近的字段状态。
  static TFormFieldScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TFormFieldScope>();
  }

  @override
  bool updateShouldNotify(TFormFieldScope oldWidget) {
    return required != oldWidget.required || errorText != oldWidget.errorText;
  }
}

/// 字段级校验规则。
///
/// 返回 null 表示校验通过；返回错误文案时停止后续校验。
typedef TFormRule<T> = FormFieldValidator<T>;

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

    /// 是否执行内置必填校验，并让表单项默认显示必填标记。
    this.required = false,

    /// 内置必填校验失败时的错误文案。
    this.requiredMessage = '此项不能为空',

    /// 按顺序执行的字段校验规则。
    this.rules = const [],

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

  /// 是否执行内置必填校验。
  ///
  /// 内置规则仅将 null、空白字符串、空 [Iterable] 和空 [Map] 视为未填写；
  /// false 与 0 均是有效值。对象内部的未选择状态应通过 [rules] 描述。
  final bool required;

  /// 内置必填校验失败时的错误文案。
  final String requiredMessage;

  /// 按顺序执行的字段校验规则。
  ///
  /// 在内置 [required] 校验通过后执行；返回第一条错误后停止。新代码优先
  /// 使用 [rules] 表达多个约束，单个 [validator] 用于最后的自定义校验。
  final List<TFormRule<T>> rules;

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
  final _fieldKey = GlobalKey<FormFieldState<T>>();
  bool _syncScheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bindScope(_TFormScope.maybeOf(context));
  }

  @override
  void didUpdateWidget(covariant TFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.name != widget.name) {
      _scope?.state._removeField(oldWidget.name, this);
    }
    _scope?.state._registerField(widget.name, this, widget.value);
    if (oldWidget.value != widget.value || oldWidget.name != widget.name) {
      _scheduleValueSync();
    }
  }

  @override
  void dispose() {
    _scope?.state._removeField(widget.name, this);
    super.dispose();
  }

  void _bindScope(_TFormScope? next) {
    if (!identical(_scope, next)) {
      _scope?.state._removeField(widget.name, this);
      _scope = next;
    }
    _scope?.state._registerField(widget.name, this, widget.value);
  }

  void _scheduleValueSync() {
    if (_syncScheduled) {
      return;
    }
    _syncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncScheduled = false;
      if (!mounted) {
        return;
      }
      final field = _fieldKey.currentState;
      if (field != null && field.value != widget.value) {
        field.didChange(widget.value);
        _scope?.state._setValue(widget.name, this, widget.value);
      }
    });
  }

  String? _validate(T? value) {
    if (widget.required && _isRequiredEmpty(value)) {
      return widget.requiredMessage;
    }
    for (final rule in widget.rules) {
      final errorText = rule(value);
      if (errorText != null) {
        return errorText;
      }
    }
    return widget.validator?.call(value);
  }

  bool _isRequiredEmpty(Object? value) {
    if (value == null) {
      return true;
    }
    if (value is String) {
      return value.trim().isEmpty;
    }
    if (value is Iterable<Object?>) {
      return value.isEmpty;
    }
    if (value is Map<Object?, Object?>) {
      return value.isEmpty;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      key: _fieldKey,
      initialValue: widget.value,
      enabled: widget.onChanged != null,
      validator: _validate,
      onSaved: widget.onSaved,
      autovalidateMode: widget.autovalidateMode ?? _scope?.autovalidateMode,
      builder: (field) {
        final errorText =
            _scope?.showErrorMessage ?? true ? field.errorText : null;
        return TFormFieldScope(
          required: widget.required,
          errorText: errorText,
          child: widget.builder(
            context,
            widget.value,
            widget.onChanged == null
                ? null
                : (next) {
                    field.didChange(next);
                    _scope?.state._setValue(widget.name, this, next);
                    widget.onChanged?.call(next);
                    _scheduleValueSync();
                  },
            errorText,
          ),
        );
      },
    );
  }
}
