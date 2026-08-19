import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../input/t_input.dart';
import '../input/t_input_types.dart';

/// [TInput.multiline] 的语义别名。
class TTextarea extends StatelessWidget {
  const TTextarea({
    super.key,

    /// 文本控制器。
    this.controller,

    /// 内部控制器的初始文本，仅初始化一次。
    this.initialValue,

    /// 文本变化通知。
    this.onChanged,

    /// 提交回调。
    this.onSubmitted,

    /// 编辑完成回调。
    this.onEditingComplete,

    /// 是否可交互。
    this.enabled = true,

    /// 是否只读。
    this.readOnly = false,

    /// 占位提示文案。
    this.hintText,

    /// 前缀组件。
    this.prefix,

    /// 后缀组件。
    this.suffix,

    /// 清除按钮显示模式；未传时读取 `TInputThemeData.clearButtonMode`。
    this.clearButtonMode,

    /// 输入框语义状态。
    this.status = TInputStatus.normal,

    /// 是否显示外边框。
    this.bordered = false,

    /// 最大行数；null 表示不限制。
    this.maxLines,

    /// 最小行数；未传时读取 Theme 默认值。
    this.minLines,

    /// 最大字符数。
    this.maxLength,

    /// 最大字符数，按 ASCII 字符 1、非 ASCII 字符 2 计数。
    this.maxCharacter,

    /// 是否显示当前字符计数。
    this.indicator = false,

    /// 是否自动聚焦。
    this.autofocus = false,

    /// 焦点节点。
    this.focusNode,

    /// 键盘类型。
    this.inputType = TextInputType.multiline,

    /// 键盘动作。
    this.inputAction,

    /// 文本对齐方式。
    this.textAlign = TextAlign.start,

    /// 输入格式化器。
    this.inputFormatters,

    /// Material 输入装饰逃逸口。
    this.decoration,
  }) : assert(controller == null || initialValue == null),
       assert(maxLength == null || maxCharacter == null),
       assert(maxLength == null || maxLength >= 0),
       assert(maxCharacter == null || maxCharacter >= 0);

  /// 文本控制器。
  final TextEditingController? controller;

  /// 内部控制器的初始文本，仅初始化一次。
  final String? initialValue;

  /// 文本变化通知。
  final ValueChanged<String>? onChanged;

  /// 提交回调。
  final ValueChanged<String>? onSubmitted;

  /// 编辑完成回调。
  final VoidCallback? onEditingComplete;

  /// 是否可交互。
  final bool enabled;

  /// 是否只读。
  final bool readOnly;

  /// 占位提示文案。
  final String? hintText;

  /// 前缀组件。
  final Widget? prefix;

  /// 后缀组件。
  final Widget? suffix;

  /// 清除按钮显示模式。
  final TInputClearButtonMode? clearButtonMode;

  /// 输入框语义状态。
  final TInputStatus status;

  /// 是否显示外边框。
  final bool bordered;

  /// 最大行数；null 表示不限制。
  final int? maxLines;

  /// 最小行数；未传时读取 Theme 默认值。
  final int? minLines;

  /// 最大字符数。
  final int? maxLength;

  /// 最大字符数，按 ASCII 字符 1、非 ASCII 字符 2 计数。
  final int? maxCharacter;

  /// 是否显示当前字符计数。
  final bool indicator;

  /// 是否自动聚焦。
  final bool autofocus;

  /// 焦点节点。
  final FocusNode? focusNode;

  /// 键盘类型。
  final TextInputType inputType;

  /// 键盘动作。
  final TextInputAction? inputAction;

  /// 文本对齐方式。
  final TextAlign textAlign;

  /// 输入格式化器。
  final List<TextInputFormatter>? inputFormatters;

  /// Material 输入装饰逃逸口。
  final InputDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return TInput.multiline(
      controller: controller,
      initialValue: initialValue,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onEditingComplete: onEditingComplete,
      enabled: enabled,
      readOnly: readOnly,
      hintText: hintText,
      prefix: prefix,
      suffix: suffix,
      clearButtonMode: clearButtonMode,
      status: status,
      borderless: !bordered,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      maxCharacter: maxCharacter,
      indicator: indicator,
      autofocus: autofocus,
      focusNode: focusNode,
      inputType: inputType,
      inputAction: inputAction,
      textAlign: textAlign,
      inputFormatters: inputFormatters,
      decoration: decoration,
    );
  }
}
