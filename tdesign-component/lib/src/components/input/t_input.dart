import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../form/t_form.dart';
import '../form/t_form_item.dart';
import 't_input_resolve.dart';
import 't_input_theme_data.dart';

/// label 与输入区的排布方式。
enum TInputLayout {
  /// 横向：label 在输入框左侧，同一行排列。
  horizontal,

  /// 纵向：label 在输入框上方，换行排列。
  vertical,
}

/// 输入框状态，影响边框与提示文本颜色。
enum TInputStatus {
  /// 默认状态。
  normal,

  /// 成功状态。
  success,

  /// 警告状态。
  warning,

  /// 错误状态。
  error,
}

/// 输入内容的位置。
enum TInputAlign {
  /// 居左。
  left,

  /// 居中。
  center,

  /// 居右。
  right,
}

/// 内置清除按钮的触发方式。
enum TInputClearTrigger {
  /// 输入框有值时始终显示。
  always,

  /// 输入框聚焦且有值时显示。
  focus,
}

/// 基于 Material [TextField] 的 v1 文本输入框。
///
/// [controller] 是主控制路径；未传时由组件创建内部 controller，并使用
/// [initialValue] 初始化一次。两者不能同时传入。
///
/// [label] 作为输入框左侧的固定标签展示（横向布局，[layout] 为
/// [TInputLayout.vertical] 时展示在上方）；[required] 为 true 时在标签后
/// 追加红色 `*`。
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

    /// 标签文案（输入框左侧的固定标签）。
    this.label,

    /// 是否必填；为 true 且存在 [label] 时在标签后展示红色 `*`。
    this.required = false,

    /// 标签与输入区的排布方式，默认横向（label 在左）。
    this.layout = TInputLayout.horizontal,

    /// 输入框状态，影响边框与 [tips] 文本颜色。
    this.status = TInputStatus.normal,

    /// 输入区下方提示文本，颜色随 [status]。
    this.tips,

    /// 输入内容位置；未传时回退到 [textAlign]。
    this.align,

    /// 是否可清空；为 false 时不显示内置清除按钮。
    this.clearable,

    /// 内置清除按钮的触发方式。
    this.clearTrigger = TInputClearTrigger.always,

    /// 最大字符数，一个汉字计 2 个字符；与 [maxLength] 二选一使用。
    this.maxcharacter,

    /// 是否开启无边框模式。
    this.borderless = false,

    /// 超出 [maxLength] / [maxcharacter] 后是否允许继续输入。
    this.allowInputOverMax = false,

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

    /// 标签文案（输入框左侧的固定标签）。
    this.label,

    /// 是否必填；为 true 且存在 [label] 时在标签后展示红色 `*`。
    this.required = false,

    /// 标签与输入区的排布方式，默认横向（label 在左）。
    this.layout = TInputLayout.horizontal,

    /// 输入框状态，影响边框与 [tips] 文本颜色。
    this.status = TInputStatus.normal,

    /// 输入区下方提示文本，颜色随 [status]。
    this.tips,

    /// 输入内容位置；未传时回退到 [textAlign]。
    this.align,

    /// 是否可清空；为 false 时不显示内置清除按钮。
    this.clearable,

    /// 内置清除按钮的触发方式。
    this.clearTrigger = TInputClearTrigger.always,

    /// 最大字符数，一个汉字计 2 个字符；与 [maxLength] 二选一使用。
    this.maxcharacter,

    /// 是否开启无边框模式。
    this.borderless = false,

    /// 超出 [maxLength] / [maxcharacter] 后是否允许继续输入。
    this.allowInputOverMax = false,

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

  /// 标签文案（输入框左侧的固定标签）。
  final String? label;

  /// 是否必填；为 true 且存在 [label] 时在标签后展示红色 `*`。
  final bool required;

  /// 标签与输入区的排布方式，默认横向（label 在左）。
  final TInputLayout layout;

  /// 输入框状态，影响边框与 [tips] 文本颜色。
  final TInputStatus status;

  /// 输入区下方提示文本，颜色随 [status]。
  final String? tips;

  /// 输入内容位置；未传时回退到 [textAlign]。
  final TInputAlign? align;

  /// 是否可清空；为 false 时不显示内置清除按钮。
  final bool? clearable;

  /// 内置清除按钮的触发方式。
  final TInputClearTrigger clearTrigger;

  /// 最大字符数，一个汉字计 2 个字符；与 [maxLength] 二选一使用。
  final int? maxcharacter;

  /// 是否开启无边框模式。
  final bool borderless;

  /// 超出 [maxLength] / [maxcharacter] 后是否允许继续输入。
  final bool allowInputOverMax;

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
  late final FocusNode _internalFocusNode;
  FocusNode? _listenedFocusNode;
  bool _hasText = false;
  bool _focused = false;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController(text: widget.initialValue);
    _controller = _effectiveController;
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_handleControllerChanged);
    _internalFocusNode = FocusNode();
    _attachFocusListener();
    _focused = _effectiveFocusNode.hasFocus;
  }

  @override
  void didUpdateWidget(covariant TInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = _effectiveController;
    if (_controller != next) {
      _controller.removeListener(_handleControllerChanged);
      _controller = next;
      _controller.addListener(_handleControllerChanged);
      _setHasText(_controller.text.isNotEmpty);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      _attachFocusListener();
      _handleFocusChanged();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _internalController.dispose();
    _detachFocusListener();
    _internalFocusNode.dispose();
    super.dispose();
  }

  void _attachFocusListener() {
    _detachFocusListener();
    final node = _effectiveFocusNode;
    _listenedFocusNode = node;
    node.addListener(_handleFocusChanged);
  }

  void _detachFocusListener() {
    _listenedFocusNode?.removeListener(_handleFocusChanged);
    _listenedFocusNode = null;
  }

  void _handleFocusChanged() {
    final focused = _effectiveFocusNode.hasFocus;
    if (_focused == focused) {
      return;
    }
    setState(() => _focused = focused);
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
    // 输入框状态对应的边框/提示颜色；normal 为 null，保持默认（不覆盖）。
    final statusColor = switch (widget.status) {
      TInputStatus.success => context.tTheme.successNormalColor,
      TInputStatus.warning => context.tTheme.warningNormalColor,
      TInputStatus.error => context.tTheme.errorNormalColor,
      TInputStatus.normal => null,
    };
    // 提示文本颜色：随 status（normal 用占位色）。
    final tipsColor =
        statusColor ?? context.tTheme.textColorPlaceholder;
    final showClearButton =
        widget.clearable ?? (theme?.showClearButton ?? true);
    final clearTrigger = widget.clearTrigger;
    final shouldShowClear =
        widget.suffix == null &&
        showClearButton &&
        _hasText &&
        (clearTrigger == TInputClearTrigger.always || _focused);
    final clearButton = shouldShowClear
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
    // 无边框模式：所有状态边框一律置空。
    InputBorder statusBorder(Color color) =>
        widget.borderless ? InputBorder.none : underline(color);
    effectiveDecoration = effectiveDecoration.copyWith(
      helperText: widget.tips ?? effectiveDecoration.helperText,
      helperStyle:
          widget.tips == null
          ? effectiveDecoration.helperStyle
          : effectiveDecoration.helperStyle?.copyWith(color: tipsColor) ??
                TextStyle(color: tipsColor),
      hintStyle:
          effectiveDecoration.hintStyle ??
          componentDecoration?.hintStyle ??
          materialDecoration.hintStyle ??
          tokenHintStyle,
      border:
          widget.borderless
          ? InputBorder.none
          : effectiveDecoration.border ??
                componentDecoration?.border ??
                materialDecoration.border ??
                underline(context.tTheme.componentBorderColor),
      enabledBorder:
          widget.borderless
          ? InputBorder.none
          : statusColor != null
          ? statusBorder(statusColor)
          : effectiveDecoration.enabledBorder ??
                componentDecoration?.enabledBorder ??
                materialDecoration.enabledBorder ??
                underline(context.tTheme.componentBorderColor),
      focusedBorder:
          widget.borderless
          ? InputBorder.none
          : statusColor != null
          ? statusBorder(statusColor)
          : effectiveDecoration.focusedBorder ??
                componentDecoration?.focusedBorder ??
                materialDecoration.focusedBorder ??
                underline(
                  material.tExplicitColorScheme?.primary ??
                      context.tTheme.brandNormalColor,
                ),
      disabledBorder:
          widget.borderless
          ? InputBorder.none
          : effectiveDecoration.disabledBorder ??
                componentDecoration?.disabledBorder ??
                materialDecoration.disabledBorder ??
                underline(context.tTheme.componentStrokeColor),
      errorBorder:
          widget.borderless
          ? InputBorder.none
          : effectiveDecoration.errorBorder ??
                componentDecoration?.errorBorder ??
                materialDecoration.errorBorder ??
                underline(context.tTheme.errorNormalColor),
      focusedErrorBorder:
          widget.borderless
          ? InputBorder.none
          : effectiveDecoration.focusedErrorBorder ??
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

    // 内容对齐：align 优先，其次 textAlign。
    final effectiveTextAlign = switch (widget.align) {
      TInputAlign.left => TextAlign.start,
      TInputAlign.center => TextAlign.center,
      TInputAlign.right => TextAlign.end,
      null => widget.textAlign,
    };
    // 组合格式化器：maxcharacter（汉字算 2）追加到用户提供的格式化器之后。
    final effectiveFormatters = [
      ...?widget.inputFormatters,
      if (widget.maxcharacter != null)
        _TInputMaxCharacterTextInputFormatter(
          widget.maxcharacter!,
          allowOverMax: widget.allowInputOverMax,
        ),
    ];
    // allowInputOverMax 时不让 TextField 硬性截断 maxLength。
    final effectiveMaxLength =
        widget.allowInputOverMax ? null : widget.maxLength;

    final inputField = TextField(
      controller: _controller,
      focusNode: _effectiveFocusNode,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      minLines: minLines,
      maxLength: effectiveMaxLength,
      autofocus: widget.autofocus,
      keyboardType: widget.inputType,
      textInputAction: widget.inputAction,
      textAlign: effectiveTextAlign,
      obscureText: widget.obscureText,
      inputFormatters: effectiveFormatters,
      style: textStyle,
      cursorColor: cursorColor,
      decoration: effectiveDecoration,
    );

    final label = widget.label;
    if (label == null) {
      return inputField;
    }

    // 左侧固定标签（默认横向布局）；required 时在标签后追加红色 `*`。
    final labelStyle = textStyle.copyWith(
      color: context.tTheme.textColorPrimary,
    );
    final labelWidget = Text.rich(
      TextSpan(
        text: label,
        style: labelStyle,
        children: [
          if (widget.required)
            TextSpan(
              text: ' *',
              style: TextStyle(
                color: context.tTheme.errorColor6,
                fontSize: textStyle.fontSize,
                height: textStyle.height,
                fontWeight: textStyle.fontWeight,
              ),
            ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    return switch (widget.layout) {
      TInputLayout.vertical => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: labelWidget,
          ),
          inputField,
        ],
      ),
      TInputLayout.horizontal => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: labelWidget,
          ),
          Expanded(child: inputField),
        ],
      ),
    };
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

/// 按“一个汉字计 2 个字符”计数并截断的输入格式化器，用于对齐 H5 `maxcharacter`。
///
/// [allowOverMax] 为 true 时不截断，仅保留计数语义（配合校验使用）。
class _TInputMaxCharacterTextInputFormatter extends TextInputFormatter {
  _TInputMaxCharacterTextInputFormatter(
    this.maxLength, {
    required this.allowOverMax,
  });

  /// 允许的最大“字符长度”，一个汉字计为 2。
  final int maxLength;

  /// 超出上限后是否允许继续输入（不截断）。
  final bool allowOverMax;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (allowOverMax) {
      return newValue;
    }
    final text = newValue.text;
    if (_charLength(text) <= maxLength) {
      return newValue;
    }
    final truncated = _truncate(text, maxLength);
    return TextEditingValue(
      text: truncated,
      selection: TextSelection.collapsed(offset: truncated.length),
    );
  }

  int _charLength(String value) {
    var length = 0;
    for (final rune in value.runes) {
      length += _isChinese(rune) ? 2 : 1;
    }
    return length;
  }

  String _truncate(String value, int maxLength) {
    final buffer = StringBuffer();
    var length = 0;
    for (final rune in value.runes) {
      final add = _isChinese(rune) ? 2 : 1;
      if (length + add > maxLength) {
        break;
      }
      buffer.writeCharCode(rune);
      length += add;
    }
    return buffer.toString();
  }

  bool _isChinese(int rune) => rune >= 0x4E00 && rune <= 0x9FFF;
}
