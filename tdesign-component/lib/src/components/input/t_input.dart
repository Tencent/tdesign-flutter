import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import '../form/t_field_scope.dart';
import '../form/t_form_item_scope.dart';
import 't_input_resolve.dart';
import 't_input_theme_data.dart';
import 't_input_types.dart';

/// 基于 Flutter [TextField] 编辑内核的 TDesign 文本输入框。
///
/// [controller] 是主控制路径；未传时由组件创建内部 controller，并使用
/// [initialValue] 初始化一次。两者不能同时传入。输入框外层由 TDesign
/// 自有布局绘制，Material [InputDecorationTheme] 不会覆盖默认边框和内边距。
class TInput extends StatefulWidget {
  const TInput({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.enabled = true,
    this.readOnly = false,
    this.hintText,
    this.prefix,
    this.suffix,
    this.clearButtonMode,
    this.status = TInputStatus.normal,
    this.borderless = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.maxCharacter,
    this.indicator = false,
    this.autofocus = false,
    this.focusNode,
    this.inputType = TextInputType.text,
    this.inputAction,
    this.textAlign = TextAlign.start,
    this.obscureText = false,
    this.inputFormatters,
    this.decoration,
    this.style,
    this.cursorColor,
  }) : _multiline = false,
       assert(controller == null || initialValue == null),
       assert(!obscureText || maxLines == 1),
       assert(maxLength == null || maxCharacter == null),
       assert(maxLength == null || maxLength >= 0),
       assert(maxCharacter == null || maxCharacter >= 0);

  /// 创建多行输入框。
  const TInput.multiline({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.enabled = true,
    this.readOnly = false,
    this.hintText,
    this.prefix,
    this.suffix,
    this.clearButtonMode,
    this.status = TInputStatus.normal,
    this.borderless = false,
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
    this.decoration,
    this.style,
    this.cursorColor,
  }) : _multiline = true,
       obscureText = false,
       assert(controller == null || initialValue == null),
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
  ///
  /// 设为 `false` 时表示禁用输入框，禁止编辑、聚焦和选择，并使用禁用态文字颜色。
  final bool enabled;

  /// 是否只读。
  ///
  /// 设为 `true` 时禁止修改内容，但保留只读文本的选择和复制能力；文字仍使用正常态颜色。
  final bool readOnly;

  /// 占位提示文案。
  final String? hintText;

  /// 前缀组件。
  final Widget? prefix;

  /// 后缀组件；传入后不显示内置清除按钮。
  final Widget? suffix;

  /// 清除按钮显示模式。
  final TInputClearButtonMode? clearButtonMode;

  /// 输入框语义状态。
  final TInputStatus status;

  /// 是否隐藏输入框边框。
  final bool borderless;

  /// 最大行数。
  final int? maxLines;

  /// 最小行数。
  final int? minLines;

  /// 最大字符数，使用 Flutter grapheme 计数语义。
  final int? maxLength;

  /// 最大字符数，按 ASCII 字符 1、非 ASCII 字符 2 计数。
  ///
  /// 与 [maxLength] 二选一；用于对齐小程序 `maxcharacter`。
  final int? maxCharacter;

  /// 是否显示当前字符计数。
  ///
  /// 主要用于 [TInput.multiline] 对齐小程序 Textarea
  /// 的 `indicator`。未配置长度限制时不会显示。
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

  /// 是否隐藏输入文本。
  final bool obscureText;

  /// 输入格式化器。
  final List<TextInputFormatter>? inputFormatters;

  /// Material 输入装饰迁移逃逸口。
  ///
  /// 该属性可以补充 Flutter 输入内核支持的 hint、label、语义和文本
  /// 配置；默认 TDesign 外层边框、内边距和清除按钮仍由本组件负责。
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
  late final FocusNode _internalFocusNode;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController(text: widget.initialValue);
    _internalFocusNode = FocusNode();
    _controller = _effectiveController;
    _focusNode = widget.focusNode ?? _internalFocusNode;
  }

  @override
  void didUpdateWidget(covariant TInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = _effectiveController;
    if (_controller != next) {
      _controller = next;
    }
    _focusNode = widget.focusNode ?? _internalFocusNode;
  }

  @override
  void dispose() {
    _internalController.dispose();
    _internalFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TInputThemeData>();
    final material = Theme.of(context);
    final token = context.tTheme;
    final fieldScope = TFieldScope.maybeOf(context);
    final formErrorText = fieldScope?.errorText;
    final inputErrorText = fieldScope?.showErrorInInput == false
        ? null
        : formErrorText;
    final effectiveStatus = inputErrorText != null
        ? TInputStatus.error
        : widget.status;
    final inputTextColor = _inputTextColor(token, effectiveStatus);
    final tokenFont = token.fontBodyLarge;
    final tokenStyle = TextStyle(
      color: inputTextColor,
      fontSize: tokenFont?.size,
      height: tokenFont?.height,
      fontWeight: tokenFont?.fontWeight,
    );
    final inheritedTextStyle = tokenStyle.merge(
      material.tExplicitTextTheme?.bodyLarge,
    );
    final themeTextStyle = theme?.textStyle;
    final textStyle =
        widget.style ??
        (themeTextStyle == null
            ? inheritedTextStyle.copyWith(color: inputTextColor)
            : widget.enabled
            ? themeTextStyle
            : themeTextStyle.copyWith(color: inputTextColor));
    final cursorColor =
        widget.cursorColor ??
        theme?.cursorColor ??
        material.tExplicitColorScheme?.primary ??
        token.brandNormalColor;
    final clearMode =
        widget.clearButtonMode ??
        theme?.clearButtonMode ??
        TInputClearButtonMode.never;
    final statusColor = _statusColor(token, effectiveStatus);
    final hintFont = token.fontBodyLarge;
    final hintStyle =
        theme?.decorationTheme?.hintStyle ??
        TextStyle(
          color: widget.enabled
              ? token.textColorPlaceholder
              : token.textDisabledColor,
          fontSize: hintFont?.size,
          height: hintFont?.height,
          fontWeight: hintFont?.fontWeight,
        );
    final sourceDecoration = TInputResolve.resolveDecoration(
      base: widget.decoration,
      hintText: widget.hintText,
    );
    final innerDecoration = sourceDecoration.copyWith(
      hintStyle: sourceDecoration.hintStyle ?? hintStyle,
      isCollapsed: sourceDecoration.isCollapsed ?? true,
      contentPadding: sourceDecoration.contentPadding ?? EdgeInsets.zero,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      errorText: null,
      error: null,
    );

    final configuredMinLines =
        widget.minLines ??
        (widget._multiline ? theme?.multilineMinLines ?? 4 : null);
    final minLines = configuredMinLines == null || widget.maxLines == null
        ? configuredMinLines
        : configuredMinLines.clamp(1, widget.maxLines!);
    final editor = TextField(
      controller: _controller,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      minLines: minLines,
      maxLength: null,
      autofocus: widget.autofocus,
      keyboardType: widget.inputType,
      textInputAction: widget.inputAction,
      textAlign: widget.textAlign,
      obscureText: widget.obscureText,
      inputFormatters: _effectiveFormatters(),
      style: textStyle,
      cursorColor: cursorColor,
      decoration: innerDecoration,
    );
    final contentPadding =
        theme?.contentPadding ??
        (TFormItemScope.maybeOf(context)
            ? EdgeInsets.zero
            : const EdgeInsets.all(16));
    final counterLimit = widget.maxLength ?? widget.maxCharacter;
    final borderSide = BorderSide(
      color: !widget.enabled
          ? theme?.borderColor ?? token.componentStrokeColor
          : theme?.borderColor ?? _borderColor(token, effectiveStatus),
      width: theme?.borderWidth ?? 1,
    );
    final borderRadius = BorderRadius.circular(
      theme?.borderRadius ?? (widget._multiline ? token.radiusDefault : 0),
    );
    final shell = _TInputShell(
      controller: _controller,
      focusNode: _focusNode,
      editor: editor,
      prefix: widget.prefix,
      suffix: widget.suffix,
      clearButtonMode: clearMode,
      clearIconSize: theme?.clearIconSize ?? 20,
      clearIconColor:
          theme?.clearIconColor ??
          material.tExplicitColorScheme?.onSurfaceVariant ??
          token.textColorPlaceholder,
      onClear: _clear,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      multiline: widget._multiline,
      indicator: widget.indicator,
      counterLimit: counterLimit,
      maxCharacter: widget.maxCharacter,
      counterColor: effectiveStatus == TInputStatus.error
          ? token.errorNormalColor
          : token.textColorSecondary,
      counterStyle: TextStyle(
        fontSize: token.fontBodySmall?.size,
        height: token.fontBodySmall?.height,
      ),
      backgroundColor:
          theme?.backgroundColor ??
          (TFormItemScope.maybeOf(context)
              ? Colors.transparent
              : token.bgColorContainer),
      borderless: widget.borderless,
      borderSide: borderSide,
      focusedBorderSide: borderSide.copyWith(color: statusColor),
      borderRadius: borderRadius,
      contentPadding: contentPadding,
    );
    final error = inputErrorText == null
        ? null
        : Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              inputErrorText,
              style: TextStyle(
                color: token.errorNormalColor,
                fontSize: token.fontBodySmall?.size,
                height: token.fontBodySmall?.height,
              ),
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [shell, if (error != null) error],
    );
  }

  List<TextInputFormatter>? _effectiveFormatters() {
    final formatters = <TextInputFormatter>[...?widget.inputFormatters];
    if (widget.maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(widget.maxLength));
    }
    if (widget.maxCharacter != null) {
      formatters.add(
        TextInputFormatter.withFunction((oldValue, newValue) {
          return _characterLength(newValue.text) <= widget.maxCharacter!
              ? newValue
              : oldValue;
        }),
      );
    }
    return formatters.isEmpty ? null : formatters;
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  Color _inputTextColor(TThemeData token, TInputStatus status) {
    if (!widget.enabled) {
      return token.textDisabledColor;
    }
    return switch (status) {
      TInputStatus.normal => token.textColorPrimary,
      TInputStatus.success => token.successNormalColor,
      TInputStatus.warning => token.warningNormalColor,
      TInputStatus.error => token.errorNormalColor,
    };
  }

  Color _statusColor(TThemeData token, TInputStatus status) => switch (status) {
    TInputStatus.normal => token.brandNormalColor,
    TInputStatus.success => token.successNormalColor,
    TInputStatus.warning => token.warningNormalColor,
    TInputStatus.error => token.errorNormalColor,
  };

  Color _borderColor(TThemeData token, TInputStatus status) => switch (status) {
    TInputStatus.normal => token.componentBorderColor,
    TInputStatus.success => token.successNormalColor,
    TInputStatus.warning => token.warningNormalColor,
    TInputStatus.error => token.errorNormalColor,
  };
}

/// 只监听输入值和焦点变化的 TInput 外壳。
///
/// 编辑器作为 [editor] 保持稳定，避免输入法连接或文本变化时重新创建
/// [TextField]。外壳只负责边框、清除按钮和字数指示器等派生视觉状态。
class _TInputShell extends StatefulWidget {
  const _TInputShell({
    required this.controller,
    required this.focusNode,
    required this.editor,
    required this.clearButtonMode,
    required this.clearIconSize,
    required this.clearIconColor,
    required this.onClear,
    required this.enabled,
    required this.readOnly,
    required this.multiline,
    required this.indicator,
    required this.counterLimit,
    required this.maxCharacter,
    required this.counterColor,
    required this.counterStyle,
    required this.backgroundColor,
    required this.borderless,
    required this.borderSide,
    required this.focusedBorderSide,
    required this.borderRadius,
    required this.contentPadding,
    this.prefix,
    this.suffix,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Widget editor;
  final Widget? prefix;
  final Widget? suffix;
  final TInputClearButtonMode clearButtonMode;
  final double clearIconSize;
  final Color clearIconColor;
  final VoidCallback onClear;
  final bool enabled;
  final bool readOnly;
  final bool multiline;
  final bool indicator;
  final int? counterLimit;
  final int? maxCharacter;
  final Color counterColor;
  final TextStyle counterStyle;
  final Color backgroundColor;
  final bool borderless;
  final BorderSide borderSide;
  final BorderSide focusedBorderSide;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry contentPadding;

  @override
  State<_TInputShell> createState() => _TInputShellState();
}

class _TInputShellState extends State<_TInputShell> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleStateChanged);
    widget.focusNode.addListener(_handleStateChanged);
  }

  @override
  void didUpdateWidget(covariant _TInputShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleStateChanged);
      widget.controller.addListener(_handleStateChanged);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_handleStateChanged);
      widget.focusNode.addListener(_handleStateChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleStateChanged);
    widget.focusNode.removeListener(_handleStateChanged);
    super.dispose();
  }

  void _handleStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.isNotEmpty;
    final hasFocus = widget.focusNode.hasFocus;
    final showClearButton =
        widget.suffix == null &&
        widget.clearButtonMode != TInputClearButtonMode.never &&
        hasText &&
        (widget.clearButtonMode == TInputClearButtonMode.always || hasFocus);
    final clearButton = showClearButton
        ? SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              tooltip: '清除',
              onPressed: widget.enabled && !widget.readOnly
                  ? widget.onClear
                  : null,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
              iconSize: widget.clearIconSize,
              icon: Icon(
                TIcons.close_circle_filled,
                color: widget.clearIconColor,
              ),
            ),
          )
        : null;
    final counter = widget.indicator && widget.counterLimit != null
        ? Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              '${_inputLength(widget.controller.text, widget.maxCharacter)}/${widget.counterLimit}',
              style: widget.counterStyle.copyWith(color: widget.counterColor),
            ),
          )
        : null;
    final border = widget.borderless
        ? null
        : widget.multiline || widget.borderRadius != BorderRadius.zero
        ? Border.fromBorderSide(
            hasFocus ? widget.focusedBorderSide : widget.borderSide,
          )
        : Border(
            bottom: hasFocus ? widget.focusedBorderSide : widget.borderSide,
          );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: border,
        borderRadius: widget.borderRadius,
      ),
      child: Padding(
        padding: widget.contentPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: widget.multiline
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                if (widget.prefix != null) ...[
                  widget.prefix!,
                  const SizedBox(width: 8),
                ],
                Expanded(child: widget.editor),
                if (clearButton != null) ...[
                  const SizedBox(width: 4),
                  clearButton,
                ],
                if (widget.suffix != null) ...[
                  const SizedBox(width: 8),
                  widget.suffix!,
                ],
              ],
            ),
            if (counter != null) ...[const SizedBox(height: 2), counter],
          ],
        ),
      ),
    );
  }
}

int _inputLength(String value, int? maxCharacter) =>
    maxCharacter == null ? value.runes.length : _characterLength(value);

int _characterLength(String value) =>
    value.runes.fold<int>(0, (length, rune) => length + (rune <= 0x7f ? 1 : 2));
