import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../form/t_field_scope.dart';
import '../form/t_form_item_scope.dart';
import '../input/t_input.dart';
import '../input/t_input_theme_data.dart';
import '../input/t_input_types.dart';

/// TDesign 多行文本输入框。
///
/// 编辑能力复用 [TInput]；容器、内部标题、提示词和计数器遵循
/// Textarea 的视觉契约。表单字段标签仍应由 `TFormItem` 提供，[label] 仅用于
/// 独立 Textarea 自身的内部标题。
class TTextarea extends StatefulWidget {
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

    /// 输入框内部标题。
    ///
    /// 表单中的字段标签请使用 `TFormItem.label`，避免与表单必填、校验语义重复。
    this.label,

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

    /// 最大字符权重，按 Unicode code point 计算：ASCII code point 计 1，
    /// 非 ASCII code point 计 2。
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

  /// 输入框内部标题；表单字段标签应由 `TFormItem` 提供。
  final String? label;

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

  /// 最大字符权重，按 Unicode code point 计算：ASCII code point 计 1，
  /// 非 ASCII code point 计 2。
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

  @override
  State<TTextarea> createState() => _TTextareaState();
}

class _TTextareaState extends State<TTextarea> {
  late final FocusNode _internalFocusNode;

  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = FocusNode();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant TTextarea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode).removeListener(
        _handleFocusChanged,
      );
      _focusNode.addListener(_handleFocusChanged);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _internalFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = context.tTheme;
    final material = Theme.of(context);
    final theme = material.extension<TInputThemeData>();
    final fieldScope = TFieldScope.maybeOf(context);
    final effectiveStatus =
        fieldScope?.errorText != null && fieldScope?.showErrorInInput != false
        ? TInputStatus.error
        : widget.status;
    final inFormItem = TFormItemScope.maybeOf(context);
    final contentPadding =
        theme?.contentPadding ??
        (inFormItem ? EdgeInsets.zero : const EdgeInsets.all(16));
    final borderColor = !widget.enabled
        ? theme?.borderColor ?? token.componentStrokeColor
        : theme?.borderColor ??
              switch (effectiveStatus) {
                TInputStatus.normal =>
                  _focusNode.hasFocus
                      ? token.brandNormalColor
                      : token.componentBorderColor,
                TInputStatus.success => token.successNormalColor,
                TInputStatus.warning => token.warningNormalColor,
                TInputStatus.error => token.errorNormalColor,
              };
    final inputTheme = (theme ?? const TInputThemeData()).copyWith(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
    );
    final labelFont = token.fontBodyMedium;
    final labelStyle =
        TextStyle(
              fontSize: labelFont?.size,
              height: labelFont?.height,
              fontWeight: labelFont?.fontWeight,
            )
            .merge(material.tExplicitTextTheme?.bodyMedium)
            .copyWith(
              color: widget.enabled
                  ? material.tExplicitTextTheme?.bodyMedium?.color ??
                        material.tExplicitColorScheme?.onSurface ??
                        token.textColorPrimary
                  : token.textDisabledColor,
            );
    final editor = Theme(
      data: Theme.of(context).mergeExtension(inputTheme),
      child: TInput(
        controller: widget.controller,
        initialValue: widget.initialValue,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        onEditingComplete: widget.onEditingComplete,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        hintText: widget.hintText,
        prefix: widget.prefix,
        suffix: widget.suffix,
        clearButtonMode: widget.clearButtonMode,
        status: widget.status,
        borderless: true,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        maxCharacter: widget.maxCharacter,
        indicator: widget.indicator,
        autofocus: widget.autofocus,
        focusNode: _focusNode,
        inputType: widget.inputType,
        inputAction: widget.inputAction,
        textAlign: widget.textAlign,
        inputFormatters: widget.inputFormatters,
      ),
    );
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: labelStyle),
          SizedBox(height: token.spacer8),
        ],
        editor,
      ],
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: inFormItem
            ? Colors.transparent
            : theme?.backgroundColor ?? token.bgColorContainer,
        border: widget.bordered
            ? Border.all(color: borderColor, width: theme?.borderWidth ?? 1)
            : null,
        borderRadius: BorderRadius.circular(
          theme?.borderRadius ?? token.radiusDefault,
        ),
      ),
      child: Padding(padding: contentPadding, child: content),
    );
  }
}
