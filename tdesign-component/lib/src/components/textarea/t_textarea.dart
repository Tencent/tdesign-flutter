import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../input/t_input.dart';

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

    /// 标签文案。
    this.label,

    /// 占位提示文案。
    this.hintText,

    /// 前缀组件。
    this.prefix,

    /// 后缀组件。
    this.suffix,

    /// 最大行数；null 表示不限制。
    this.maxLines,

    /// 最小行数；未传时读取 Theme 默认值。
    this.minLines,

    /// 最大字符数。
    this.maxLength,

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
  }) : assert(controller == null || initialValue == null);

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

  /// 标签文案。
  final String? label;

  /// 占位提示文案。
  final String? hintText;

  /// 前缀组件。
  final Widget? prefix;

  /// 后缀组件。
  final Widget? suffix;

  /// 最大行数；null 表示不限制。
  final int? maxLines;

  /// 最小行数；未传时读取 Theme 默认值。
  final int? minLines;

  /// 最大字符数。
  final int? maxLength;

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
      label: label,
      hintText: hintText,
      prefix: prefix,
      suffix: suffix,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
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
