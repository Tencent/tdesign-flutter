import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';
import 't_field_scope.dart';
import 't_form_theme_data.dart';

/// TDesign 表单容器。
///
/// 校验和字段生命周期委托给 Flutter [Form] 与 [FormState]。
///
/// ### 主题配置
///
/// 组件主题通过 [TFormThemeData] 配置，放入 Flutter [ThemeData.extensions]
/// 后作用于对应子树。字段含义、未配置时的回退及复制/过渡行为见本页的
/// `TFormThemeData` 说明。
class TForm extends StatefulWidget {
  const TForm({
    super.key,
    required this.child,
    this.controller,
    this.autovalidateMode,
    this.onChanged,
    this.onSubmit,
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

  /// 用户通过 [TFormField] 提交字段值变化时触发。
  ///
  /// 回调执行时 [TFormController.values] 已包含本次变化。仅同步外部受控值、
  /// 清除校验状态或外部错误时不会触发。
  final VoidCallback? onChanged;

  /// 校验通过后触发，参数为各 [TFormField] 注册的字段值。
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
  bool _submitFailed = false;
  bool _suppressOnChanged = false;
  int _validationVersion = 0;

  /// 当前字段值的只读快照。
  Map<String, Object?> get values => Map.unmodifiable(_values);

  /// 运行表单字段校验。
  ///
  /// [fields] 为空时校验所有已注册字段；传入字段名后只校验指定字段。
  /// 未注册或尚未构建完成的字段视为校验失败。
  ///
  /// ## 返回值
  /// 所有参与校验的字段均通过时为 true；未注册或尚未构建完成的指定字段视为失败。
  bool validate({Iterable<String>? fields}) {
    return fields == null
        ? _formKey.currentState?.validate() ?? false
        : _validateFields(fields);
  }

  bool _validateFields(Iterable<String> fields) {
    var valid = true;
    for (final name in fields) {
      if (!(_validateCallbacks[name]?.call() ?? false)) {
        valid = false;
      }
    }
    return valid;
  }

  /// 校验表单；校验成功后保存字段，并在配置 [TForm.onSubmit] 时触发提交回调。
  ///
  /// ## 返回值
  /// 表单校验结果；true 仅表示校验通过并已保存字段，不表示业务请求成功。
  /// 若未配置 [TForm.onSubmit]，不会触发业务提交回调。
  bool submit() {
    final valid = validate();
    if (valid) {
      _formKey.currentState?.save();
      widget.onSubmit?.call(values);
    } else if (widget.autovalidateMode == null && !_submitFailed) {
      setState(() => _submitFailed = true);
    }
    return valid;
  }

  /// 重置 Flutter 字段的交互和校验状态，并清除外部错误。
  ///
  /// 字段值由业务受控状态所有；调用方应自行恢复 [TFormField.value]。
  void reset() {
    _withoutChangeNotification(() {
      _formKey.currentState?.reset();
      for (final clearValidate in _clearValidateCallbacks.values) {
        clearValidate();
      }
    });
    _externalErrors.clear();
    _validationVersion++;
    if (_submitFailed) {
      setState(() => _submitFailed = false);
    } else {
      setState(() {});
    }
  }

  /// 清除全部或指定字段的校验状态。
  ///
  /// 同时清除通过 [setValidateMessage] 注入的外部错误。
  void clearValidate({
    /// 本次操作的字段名；为空时操作全部已注册字段。
    Iterable<String>? fields,
  }) {
    final names = fields?.toSet();
    final callbacks = names == null
        ? _clearValidateCallbacks.entries
        : _clearValidateCallbacks.entries.where(
            (entry) => names.contains(entry.key),
          );
    _withoutChangeNotification(() {
      for (final entry in callbacks) {
        entry.value();
      }
    });
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
  void setValidateMessage(
    /// 字段名与外部校验消息的映射；消息为 null 或空字符串时清除对应错误。
    Map<String, String?> messages,
  ) {
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
        (_submitFailed
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

  void _withoutChangeNotification(VoidCallback callback) {
    final wasSuppressed = _suppressOnChanged;
    _suppressOnChanged = true;
    try {
      callback();
    } finally {
      _suppressOnChanged = wasSuppressed;
    }
  }

  void _handleChanged() {
    if (!_suppressOnChanged) {
      widget.onChanged?.call();
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
    final theme = Theme.of(context).extension<TFormThemeData>();
    return _TFormScope(
      state: this,
      showErrorMessage: widget.showErrorMessage,
      autovalidateMode: _effectiveAutovalidateMode,
      validationVersion: _validationVersion,
      child: ColoredBox(
        color: theme?.backgroundColor ?? context.tTheme.bgColorContainer,
        child: Form(
          key: _formKey,
          autovalidateMode: _effectiveAutovalidateMode,
          onChanged: _handleChanged,
          child: widget.child,
        ),
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
  ///
  /// ## 返回值
  /// 绑定表单的校验结果；未绑定表单时为 false。
  bool validate({
    /// 本次操作的字段名；为空时操作全部已注册字段。
    Iterable<String>? fields,
  }) => _state?.validate(fields: fields) ?? false;

  /// 校验并提交表单。
  ///
  /// ## 返回值
  /// 绑定表单的校验与提交结果；未绑定表单或校验失败时为 false。
  bool submit() => _state?.submit() ?? false;

  /// 重置表单。
  void reset() => _state?.reset();

  /// 清除全部或指定字段的校验状态。
  void clearValidate({
    /// 本次操作的字段名；为空时操作全部已注册字段。
    Iterable<String>? fields,
  }) => _state?.clearValidate(fields: fields);

  /// 设置字段的外部校验错误。
  void setValidateMessage(
    /// 字段名与外部校验消息的映射；消息为 null 或空字符串时清除对应错误。
    Map<String, String?> messages,
  ) => _state?.setValidateMessage(messages);

  void _attach(TFormState state) {
    assert(
      _state == null || identical(_state, state),
      'A TFormController cannot be attached to more than one TForm at the '
      'same time.',
    );
    _state = state;
  }

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

/// TDesign 字段 builder。
/// [context] 表单字段的构建上下文。
/// [value] 当前字段值。
/// [onChanged] 更新字段值的回调；为 null 时字段不可编辑。
/// [errorText] 当前字段校验错误；为 null 时无错误文案。
///
/// ## 返回值
/// 表单字段的输入与展示内容。
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
    required this.name,
    required this.value,
    required this.builder,
    this.onChanged,
    this.required = false,
    this.requiredMessage = '此项不能为空',
    this.validator,
    this.onSaved,
    this.autovalidateMode,
  });

  /// 字段名，在表单提交数据中作为 key。
  final String name;

  /// 受控字段值。
  final T value;

  /// 字段值变化回调；为 null 时禁用字段。
  final ValueChanged<T>? onChanged;

  /// 是否执行内置必填校验，并让表单项默认显示必填标记。
  ///
  /// 内置规则仅将 null、空白字符串、空 [Iterable] 和空 [Map] 视为未填写；
  /// false 与 0 均是有效值。对象内部的未选择状态应通过 [validator] 描述。
  final bool required;

  /// 内置必填校验失败时的错误文案。
  final String requiredMessage;

  /// 字段内容 builder。
  final TFormFieldBuilder<T> builder;

  /// 字段校验器。
  final FormFieldValidator<T>? validator;

  /// 保存字段时触发。
  final FormFieldSetter<T>? onSaved;

  /// 自动校验时机；为空时继承 [TForm]。
  final AutovalidateMode? autovalidateMode;

  @override
  State<TFormField<T>> createState() => _TFormFieldState<T>();
}

class _TFormFieldState<T> extends State<TFormField<T>> {
  _TFormScope? _scope;
  final GlobalKey<_TControlledFormFieldState<T>> _fieldKey =
      GlobalKey<_TControlledFormFieldState<T>>();
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
        field.syncControlledValue(widget.value);
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
    return widget.validator?.call(value);
  }

  void _clearValidate() {
    _fieldKey.currentState?.clearValidation();
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
    return _TControlledFormField<T>(
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
          clearValidate: _clearValidate,
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
                    _scope?.state._setValue(widget.name, this, next);
                    field.didChange(next);
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

/// [FormField] bridge that synchronizes a controlled value without treating
/// the update as user interaction or emitting [Form.onChanged].
class _TControlledFormField<T> extends FormField<T> {
  const _TControlledFormField({
    required super.builder,
    super.key,
    super.initialValue,
    super.enabled,
    super.validator,
    super.onSaved,
    super.autovalidateMode,
  });

  @override
  FormFieldState<T> createState() => _TControlledFormFieldState<T>();
}

class _TControlledFormFieldState<T> extends FormFieldState<T> {
  void syncControlledValue(T value) {
    setState(() => setValue(value));
  }

  void clearValidation() => reset();
}
