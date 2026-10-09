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

/// 多行文本框内部标题与编辑区的排列方式。
enum TTextareaLayout {
  /// 标题与编辑区横向排列。
  horizontal,

  /// 标题与编辑区竖向排列。
  vertical,
}

class TTextarea extends StatefulWidget {
  const TTextarea({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.enabled = true,
    this.readOnly = false,
    this.hintText,
    this.label,
    this.layout = TTextareaLayout.horizontal,
    this.prefix,
    this.suffix,
    this.clearButtonMode,
    this.status = TInputStatus.normal,
    this.bordered = false,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.maxCharacter,
    this.indicator = false,
    this.autofocus = false,
    this.focusNode,
    this.inputType = TextInputType.multiline,
    this.inputAction,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
  }) : assert(controller == null || initialValue == null),
       assert(maxLength == null || maxCharacter == null),
       assert(maxLength == null || maxLength >= 0),
       assert(maxCharacter == null || maxCharacter >= 0);

  /// 文本控制器；与 initialValue 互斥。外部控制器由调用方释放，
  /// 未提供时由组件创建并释放内部控制器。
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

  /// 输入框内部标题。
  ///
  /// 表单中的字段标签请使用 `TFormItem.label`，避免与表单必填、校验语义重复。
  final String? label;

  /// 内部标题与编辑区的排列方式。
  final TTextareaLayout layout;

  /// 前缀组件。
  final Widget? prefix;

  /// 后缀组件。
  final Widget? suffix;

  /// 清除按钮显示模式；未传时不显示清除按钮。
  final TInputClearButtonMode? clearButtonMode;

  /// 输入框语义状态。
  final TInputStatus status;

  /// 是否显示外边框。
  final bool bordered;

  /// 最大行数；null 表示不限制。
  final int? maxLines;

  /// 最小行数；未传时使用 4 行，并限制到非空 maxLines。
  final int? minLines;

  /// 最大字符数；非空时必须大于或等于 0，与 maxCharacter 互斥。
  final int? maxLength;

  /// 最大字符权重，按 Unicode code point 计算：ASCII code point 计 1，
  /// 非 ASCII code point 计 2；非空时必须大于或等于 0，与 maxLength 互斥。
  final int? maxCharacter;

  /// 是否显示当前字符计数。
  final bool indicator;

  /// 是否自动聚焦。
  final bool autofocus;

  /// 焦点节点；外部节点由调用方释放，未提供时由组件管理内部节点。
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
        ? theme?.borderColor ?? token.componentStroke
        : theme?.borderColor ??
              switch (effectiveStatus) {
                TInputStatus.normal =>
                  _focusNode.hasFocus
                      ? token.brandColor
                      : token.componentBorder,
                TInputStatus.success => token.successColor,
                TInputStatus.warning => token.warningColor,
                TInputStatus.error => token.errorColor,
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
        ).copyWith(
          color: widget.enabled
              ? token.textColorPrimary
              : token.textColorDisabled,
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: inFormItem
            ? Colors.transparent
            : theme?.backgroundColor ?? token.bgColorContainer,
        border: widget.bordered
            ? Border.all(color: borderColor, width: theme?.borderWidth ?? 1)
            : null,
        borderRadius: BorderRadius.circular(
          theme?.borderRadius ?? (widget.bordered ? token.radiusDefault : 0),
        ),
      ),
      child: Padding(
        padding: contentPadding,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final constrainedEditor = constraints.hasTightHeight
                ? SizedBox(height: constraints.maxHeight, child: editor)
                : editor;
            return switch ((widget.label, widget.layout)) {
              (null, _) => constrainedEditor,
              (final label?, TTextareaLayout.horizontal) => Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(label, style: labelStyle),
                  SizedBox(width: token.spacer2),
                  Expanded(child: constrainedEditor),
                ],
              ),
              (final label?, TTextareaLayout.vertical) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(label, style: labelStyle),
                  SizedBox(height: token.spacer),
                  if (constraints.hasTightHeight)
                    Expanded(child: editor)
                  else
                    editor,
                ],
              ),
            };
          },
        ),
      ),
    );
  }
}
