import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../form/t_field_scope.dart';
import '../form/t_form_item_scope.dart';
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
    this.showPasswordToggle = false,
    this.inputFormatters,
    this.style,
    this.cursorColor,
  }) : _multiline = false,
       assert(controller == null || initialValue == null),
       assert(!obscureText || maxLines == 1),
       assert(!showPasswordToggle || maxLines == 1),
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
    this.style,
    this.cursorColor,
  }) : _multiline = true,
       obscureText = false,
       showPasswordToggle = false,
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
  ///
  /// 状态色用于输入壳层、计数器和错误提示；
  /// 已输入文字仍使用正常正文色，除非通过 [style] 或 [TInputThemeData.textStyle] 显式覆盖。
  final TInputStatus status;

  /// 是否隐藏输入框边框。
  final bool borderless;

  /// 最大行数。
  final int? maxLines;

  /// 最小行数。
  final int? minLines;

  /// 最大字符数，使用 Flutter grapheme 计数语义。
  final int? maxLength;

  /// 最大字符权重，按 Unicode code point 计算：ASCII code point 计 1，
  /// 非 ASCII code point 计 2。
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

  /// 是否在后置插槽显示内置密码显隐按钮。
  ///
  /// 初始显隐状态由 [obscureText] 决定，按钮点击后的显隐状态由输入框
  /// 自身维护。启用后会使用 TDesign 的浏览图标和 24dp 图标槽，且不会
  /// 额外撑高输入框；仅支持单行输入。如果同时传入 [suffix]，自定义后置内容
  /// 会紧跟在该按钮之后。
  final bool showPasswordToggle;

  /// 输入格式化器。
  final List<TextInputFormatter>? inputFormatters;

  /// 输入文本样式。
  ///
  /// 未指定的字段继承 TDesign `fontBodyLarge`；显式颜色可覆盖默认正文色。
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
  late bool _obscureText;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController(text: widget.initialValue);
    _internalFocusNode = FocusNode();
    _controller = _effectiveController;
    _focusNode = widget.focusNode ?? _internalFocusNode;
    _obscureText = widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant TInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = _effectiveController;
    if (_controller != next) {
      _controller = next;
    }
    _focusNode = widget.focusNode ?? _internalFocusNode;
    if (oldWidget.obscureText != widget.obscureText ||
        oldWidget.showPasswordToggle != widget.showPasswordToggle) {
      _obscureText = widget.obscureText;
    }
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
    final inputTextColor = _inputTextColor(token, material);
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
    final configuredTextStyle = inheritedTextStyle
        .merge(themeTextStyle)
        .merge(widget.style);
    final configuredTextColor = widget.enabled
        ? themeTextStyle?.color ??
              material.tExplicitTextTheme?.bodyLarge?.color ??
              material.tExplicitColorScheme?.onSurface ??
              inputTextColor
        : inputTextColor;
    final textStyle = configuredTextStyle.copyWith(
      color: widget.style?.color ?? configuredTextColor,
    );
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
    final hintFont = widget._multiline
        ? token.fontBodyMedium
        : token.fontBodyLarge;
    final themeHintStyle = theme?.hintStyle;
    final hintStyle =
        TextStyle(
              color: widget.enabled
                  ? material.tExplicitColorScheme?.onSurfaceVariant ??
                        token.textColorPlaceholder
                  : token.textDisabledColor,
              fontSize: hintFont?.size,
              height: hintFont?.height,
              fontWeight: hintFont?.fontWeight,
            )
            .merge(material.tExplicitTextTheme?.bodyLarge)
            .merge(themeHintStyle)
            .copyWith(
              color: widget.enabled
                  ? themeHintStyle?.color ??
                        material.tExplicitTextTheme?.bodyLarge?.color ??
                        material.tExplicitColorScheme?.onSurfaceVariant ??
                        token.textColorPlaceholder
                  : token.textDisabledColor,
            );
    final innerDecoration = InputDecoration(
      hintText: widget.hintText,
      hintStyle: hintStyle,
      hintMaxLines: 1,
      filled: false,
      fillColor: Colors.transparent,
      isCollapsed: true,
      contentPadding: EdgeInsets.zero,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
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
      obscureText: widget.showPasswordToggle
          ? _obscureText
          : widget.obscureText,
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
      showPasswordToggle: widget.showPasswordToggle,
      obscureText: widget.showPasswordToggle
          ? _obscureText
          : widget.obscureText,
      onTogglePassword: _togglePassword,
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
          : widget._multiline
          ? token.textColorPlaceholder
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
      counterGap: widget._multiline ? token.spacer8 : 2,
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

  void _togglePassword() {
    if (!widget.enabled) {
      return;
    }
    setState(() => _obscureText = !_obscureText);
  }

  Color _inputTextColor(TThemeData token, ThemeData material) => widget.enabled
      ? material.tExplicitColorScheme?.onSurface ?? token.textColorPrimary
      : token.textDisabledColor;

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
    required this.showPasswordToggle,
    required this.obscureText,
    required this.onTogglePassword,
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
    required this.counterGap,
    this.prefix,
    this.suffix,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Widget editor;
  final Widget? prefix;
  final Widget? suffix;
  final bool showPasswordToggle;
  final bool obscureText;
  final VoidCallback onTogglePassword;
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
  final double counterGap;

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
        !widget.showPasswordToggle &&
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
    final passwordButton = widget.showPasswordToggle
        ? SizedBox(
            width: _inputIconSize,
            height: _inputIconSize,
            child: IconButton(
              tooltip: widget.obscureText ? '显示密码' : '隐藏密码',
              onPressed: widget.enabled ? widget.onTogglePassword : null,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(
                width: _inputIconSize,
                height: _inputIconSize,
              ),
              iconSize: _inputIconSize,
              icon: Icon(
                widget.obscureText ? TIcons.browse_off : TIcons.browse,
                color: widget.enabled
                    ? context.tTheme.textColorPlaceholder
                    : context.tTheme.textDisabledColor,
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
                  _TInputSlot(
                    color: widget.enabled
                        ? context.tTheme.textColorPrimary
                        : context.tTheme.textDisabledColor,
                    child: widget.prefix!,
                  ),
                  const SizedBox(width: _inputIconGap),
                ],
                Expanded(child: widget.editor),
                if (clearButton != null) ...[
                  const SizedBox(width: 4),
                  clearButton,
                ],
                if (passwordButton != null) ...[
                  const SizedBox(width: 4),
                  passwordButton,
                ],
                if (widget.suffix != null) ...[
                  const SizedBox(width: _inputIconGap),
                  _TInputSlot(
                    color: widget.enabled
                        ? context.tTheme.textColorPlaceholder
                        : context.tTheme.textDisabledColor,
                    child: widget.suffix!,
                  ),
                ],
              ],
            ),
            if (counter != null) ...[
              SizedBox(height: widget.counterGap),
              counter,
            ],
          ],
        ),
      ),
    );
  }
}

const double _inputIconSize = 24;
const double _inputIconGap = 8;

class _TInputSlot extends StatelessWidget {
  const _TInputSlot({required this.child, required this.color});

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: color, size: _inputIconSize),
      child: Center(child: child),
    );
  }
}

int _inputLength(String value, int? maxCharacter) =>
    maxCharacter == null ? value.characters.length : _characterLength(value);

int _characterLength(String value) =>
    value.runes.fold<int>(0, (length, rune) => length + (rune <= 0x7f ? 1 : 2));
