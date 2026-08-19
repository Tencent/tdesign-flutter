import 'package:flutter/material.dart';

import 't_field_scope.dart';

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
  final Map<String, bool Function()> _validateCallbacks = {};
  final Map<String, VoidCallback> _clearValidateCallbacks = {};
  final Map<String, String> _externalErrors = {};
  bool _hasSubmitted = false;
  int _validationVersion = 0;

  /// 当前字段值的只读快照。
  Map<String, Object?> get values => Map.unmodifiable(_values);

  /// 运行表单字段校验。
  ///
  /// [fields] 为空时校验所有已注册字段；传入字段名后只校验指定字段。
  bool validate({Iterable<String>? fields}) {
    final valid = fields == null
        ? _formKey.currentState?.validate() ?? false
        : _validateFields(fields);
    if (!_hasSubmitted) {
      setState(() => _hasSubmitted = true);
    }
    return valid;
  }

  bool _validateFields(Iterable<String> fields) {
    var valid = true;
    for (final name in fields) {
      if (!(_validateCallbacks[name]?.call() ?? true)) {
        valid = false;
      }
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

  /// 重置 Flutter 字段的交互和校验状态，并清除外部错误。
  ///
  /// 字段值由业务受控状态所有；调用方应自行恢复 [TFormField.value]。
  void reset() {
    for (final clearValidate in _clearValidateCallbacks.values) {
      clearValidate();
    }
    _externalErrors.clear();
    _validationVersion++;
    if (_hasSubmitted) {
      setState(() => _hasSubmitted = false);
    } else {
      setState(() {});
    }
  }

  /// 清除全部或指定字段的校验状态。
  ///
  /// 同时清除通过 [setValidateMessage] 注入的外部错误。
  void clearValidate({Iterable<String>? fields}) {
    final names = fields?.toSet();
    final callbacks = names == null
        ? _clearValidateCallbacks.entries
        : _clearValidateCallbacks.entries.where(
            (entry) => names.contains(entry.key),
          );
    for (final entry in callbacks) {
      entry.value();
    }
    if (names == null) {
      _externalErrors.clear();
    } else {
      for (final name in names) {
        _externalErrors.remove(name);
      }
    }
    _validationVersion++;
    setState(() {});
  }

  /// 设置字段的外部校验错误。
  ///
  /// 常用于服务端校验。传入 `null` 的字段会清除对应外部错误；外部错误
  /// 会覆盖字段本地校验错误，直到调用 [clearValidate] 或再次设置。
  void setValidateMessage(Map<String, String?> messages) {
    for (final entry in messages.entries) {
      final message = entry.value;
      if (message == null || message.isEmpty) {
        _externalErrors.remove(entry.key);
      } else {
        _externalErrors[entry.key] = message;
      }
    }
    _validationVersion++;
    setState(() {});
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

  void _registerFieldActions(
    String name,
    Object owner, {
    required bool Function() validate,
    required VoidCallback clearValidate,
  }) {
    if (identical(_fieldOwners[name], owner)) {
      _validateCallbacks[name] = validate;
      _clearValidateCallbacks[name] = clearValidate;
    }
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
      _validateCallbacks.remove(name);
      _clearValidateCallbacks.remove(name);
    }
  }

  String? _externalError(String name) => _externalErrors[name];

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
      validationVersion: _validationVersion,
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

  /// 运行表单字段校验。
  bool validate({Iterable<String>? fields}) =>
      _state?.validate(fields: fields) ?? false;

  /// 校验并提交表单。
  bool submit() => _state?.submit() ?? false;

  /// 重置表单。
  void reset() => _state?.reset();

  /// 清除全部或指定字段的校验状态。
  void clearValidate({Iterable<String>? fields}) =>
      _state?.clearValidate(fields: fields);

  /// 设置字段的外部校验错误。
  void setValidateMessage(Map<String, String?> messages) =>
      _state?.setValidateMessage(messages);

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
    required this.validationVersion,
    required super.child,
  });

  final TFormState state;
  final bool showErrorMessage;
  final AutovalidateMode autovalidateMode;
  final int validationVersion;

  static _TFormScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_TFormScope>();
  }

  @override
  bool updateShouldNotify(_TFormScope oldWidget) {
    return showErrorMessage != oldWidget.showErrorMessage ||
        autovalidateMode != oldWidget.autovalidateMode ||
        validationVersion != oldWidget.validationVersion;
  }
}

/// 字段级校验规则。
///
/// 返回 null 表示校验通过；返回错误文案时停止后续校验。
typedef TFormRule<T> = FormFieldValidator<T>;

/// TDesign 字段 builder。
typedef TFormFieldBuilder<T> =
    Widget Function(
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
    final externalError = _scope?.state._externalError(widget.name);
    if (externalError != null) {
      return externalError;
    }
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
        final errorText = _scope?.showErrorMessage ?? true
            ? _scope?.state._externalError(widget.name) ?? field.errorText
            : null;
        _scope?.state._registerFieldActions(
          widget.name,
          this,
          validate: () => field.validate(),
          clearValidate: field.reset,
        );
        return TFieldScope(
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
