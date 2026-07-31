import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_icons/tdesign_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../form/t_form.dart';
import '../form/t_form_item.dart';
import 't_input_resolve.dart';
import 't_input_theme_data.dart';

/// 基于 Material [TextField] 的 v1 文本输入框。
///
/// [controller] 是主控制路径；未传时由组件创建内部 controller，并使用
/// [initialValue] 初始化一次。两者不能同时传入。
class TInput extends StatefulWidget {
  const TInput({
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

    /// 后缀组件；传入后不显示内置清除按钮。
    this.suffix,

    /// 最大行数。
    this.maxLines = 1,

    /// 最小行数。
    this.minLines,

    /// 最大字符数。
    this.maxLength,

    /// 是否自动聚焦。
    this.autofocus = false,

    /// 焦点节点。
    this.focusNode,

    /// 键盘类型。
    this.inputType = TextInputType.text,

    /// 键盘动作。
    this.inputAction,

    /// 文本对齐方式。
    this.textAlign = TextAlign.start,

    /// 是否隐藏输入文本。
    this.obscureText = false,

    /// 输入格式化器。
    this.inputFormatters,

    /// Material 输入装饰逃逸口。
    this.decoration,

    /// 输入文本样式。
    this.style,

    /// 光标颜色。
    this.cursorColor,
  }) : _multiline = false,
       assert(controller == null || initialValue == null),
       assert(!obscureText || maxLines == 1);

  /// 创建多行输入框。
  const TInput.multiline({
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

    /// 后缀组件；传入后不显示内置清除按钮。
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

    /// 输入文本样式。
    this.style,

    /// 光标颜色。
    this.cursorColor,
  }) : _multiline = true,
       obscureText = false,
       assert(controller == null || initialValue == null);

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

  /// 最大行数。
  final int? maxLines;

  /// 最小行数。
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

  /// 是否隐藏输入文本。
  final bool obscureText;

  /// 输入格式化器。
  final List<TextInputFormatter>? inputFormatters;

  /// Material 输入装饰逃逸口。
  final InputDecoration? decoration;

  /// 输入文本样式。
  final TextStyle? style;

  /// 光标颜色。
  final Color? cursorColor;

  final bool _multiline;

  @override
  State<TInput> createState() => _TInputState();
}

class _TInputState extends State<TInput> {
  late final TextEditingController _internalController;
  late TextEditingController _controller;
  bool _hasText = false;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController(text: widget.initialValue);
    _controller = _effectiveController;
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant TInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = _effectiveController;
    if (_controller == next) {
      return;
    }
    _controller.removeListener(_handleControllerChanged);
    _controller = next;
    _controller.addListener(_handleControllerChanged);
    _setHasText(_controller.text.isNotEmpty);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _internalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TInputThemeData>();
    final material = Theme.of(context);
    final tokenFont = context.tTheme.fontBodyLarge;
    final tokenStyle = TextStyle(
      color: context.tTheme.textColorPrimary,
      fontSize: tokenFont?.size,
      height: tokenFont?.height,
      fontWeight: tokenFont?.fontWeight,
    );
    final textStyle =
        widget.style ??
        theme?.textStyle ??
        tokenStyle
            .merge(material.tExplicitTextTheme?.bodyLarge)
            .copyWith(
              color:
                  material.tExplicitTextTheme?.bodyLarge?.color ??
                  material.tExplicitColorScheme?.onSurface ??
                  context.tTheme.textColorPrimary,
            );
    final cursorColor =
        widget.cursorColor ??
        theme?.cursorColor ??
        material.tExplicitColorScheme?.primary ??
        context.tTheme.brandNormalColor;
    final showClearButton = theme?.showClearButton ?? true;
    final clearButton = widget.suffix == null && showClearButton && _hasText
        ? IconButton(
            tooltip: '清除',
            onPressed: widget.enabled && !widget.readOnly ? _clear : null,
            iconSize: theme?.clearIconSize ?? 20,
            icon: Icon(
              TIcons.close_circle_filled,
              color:
                  theme?.clearIconColor ??
                  context.tExplicitIconTheme?.color ??
                  material.tExplicitColorScheme?.onSurfaceVariant ??
                  context.tTheme.textColorPlaceholder,
            ),
          )
        : null;
    final decoration = TInputResolve.resolveDecoration(
      base: widget.decoration,
      label: widget.label,
      hintText: widget.hintText,
      prefix: widget.prefix,
      suffix: widget.suffix ?? clearButton,
    );
    final formErrorText = TFormFieldScope.maybeOf(context)?.errorText;
    final itemScope = TFormItemScope.maybeOf(context);
    var effectiveDecoration =
        formErrorText != null &&
            itemScope?.presentsError != true &&
            decoration.errorText == null &&
            decoration.error == null
        ? decoration.copyWith(errorText: formErrorText)
        : decoration;
    final componentDecoration = theme?.decorationTheme;
    final materialDecoration = material.inputDecorationTheme;
    final tokenText = context.tTheme.fontBodyLarge;
    final tokenHintStyle = TextStyle(
      color: context.tTheme.textColorPlaceholder,
      fontSize: tokenText?.size,
      height: tokenText?.height,
      fontWeight: tokenText?.fontWeight,
    );
    InputBorder underline(Color color) =>
        UnderlineInputBorder(borderSide: BorderSide(color: color));
    effectiveDecoration = effectiveDecoration.copyWith(
      hintStyle:
          effectiveDecoration.hintStyle ??
          componentDecoration?.hintStyle ??
          materialDecoration.hintStyle ??
          tokenHintStyle,
      border:
          effectiveDecoration.border ??
          componentDecoration?.border ??
          materialDecoration.border ??
          underline(context.tTheme.componentBorderColor),
      enabledBorder:
          effectiveDecoration.enabledBorder ??
          componentDecoration?.enabledBorder ??
          materialDecoration.enabledBorder ??
          underline(context.tTheme.componentBorderColor),
      focusedBorder:
          effectiveDecoration.focusedBorder ??
          componentDecoration?.focusedBorder ??
          materialDecoration.focusedBorder ??
          underline(
            material.tExplicitColorScheme?.primary ??
                context.tTheme.brandNormalColor,
          ),
      disabledBorder:
          effectiveDecoration.disabledBorder ??
          componentDecoration?.disabledBorder ??
          materialDecoration.disabledBorder ??
          underline(context.tTheme.componentStrokeColor),
      errorBorder:
          effectiveDecoration.errorBorder ??
          componentDecoration?.errorBorder ??
          materialDecoration.errorBorder ??
          underline(context.tTheme.errorNormalColor),
      focusedErrorBorder:
          effectiveDecoration.focusedErrorBorder ??
          componentDecoration?.focusedErrorBorder ??
          materialDecoration.focusedErrorBorder ??
          underline(context.tTheme.errorNormalColor),
    );

    final configuredMinLines =
        widget.minLines ??
        (widget._multiline ? theme?.multilineMinLines ?? 4 : null);
    final minLines = configuredMinLines == null || widget.maxLines == null
        ? configuredMinLines
        : configuredMinLines.clamp(1, widget.maxLines!);

    return TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      minLines: minLines,
      maxLength: widget.maxLength,
      autofocus: widget.autofocus,
      keyboardType: widget.inputType,
      textInputAction: widget.inputAction,
      textAlign: widget.textAlign,
      obscureText: widget.obscureText,
      inputFormatters: widget.inputFormatters,
      style: textStyle,
      cursorColor: cursorColor,
      decoration: effectiveDecoration,
    );
  }

  void _handleControllerChanged() {
    _setHasText(_controller.text.isNotEmpty);
  }

  void _setHasText(bool value) {
    if (_hasText == value) {
      return;
    }
    setState(() => _hasText = value);
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
  }
}
