import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import 't_search_bar_theme_data.dart';

const double _kSearchBarHeight = 40;
const double _kIconSize = 24;
const double _kIconGap = 5;
const double _kActionGap = 15;
const EdgeInsets _kContentPadding = EdgeInsets.symmetric(horizontal: 12);

/// 基于 Material [TextField] 的搜索输入框。
///
/// [controller] 是主控制路径；未传时组件创建内部 controller，并使用
/// [initialValue] 初始化一次。搜索结果由调用方在组件外组合。
class TSearchBar extends StatefulWidget {
  const TSearchBar({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.onFocusChanged,
    this.enabled = true,
    this.readOnly = false,
    this.hintText,
    this.actionText,
    this.onActionPressed,
    this.onClearPressed,
    this.clearable = true,
    this.autofocus = false,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.search,
    this.maxLength,
    this.inputFormatters,
    this.variant,
    this.textAlignment,
    this.focusNode,
  }) : assert(controller == null || initialValue == null);

  /// 文本控制器。
  final TextEditingController? controller;

  /// 内部控制器的初始文本，仅初始化一次。
  final String? initialValue;

  /// 文本变化通知。
  final ValueChanged<String>? onChanged;

  /// 提交回调。
  final ValueChanged<String>? onSubmitted;

  /// 焦点变化通知。
  final ValueChanged<bool>? onFocusChanged;

  /// 是否可交互。
  final bool enabled;

  /// 是否只读。只读时仍可获得焦点和选择文字，但不显示清除按钮。
  final bool readOnly;

  /// 占位提示。
  final String? hintText;

  /// 右侧操作文案；为空时不占据布局空间。
  final String? actionText;

  /// 右侧操作点击回调。组件不会隐式清空输入或释放焦点。
  final VoidCallback? onActionPressed;

  /// 清除按钮点击回调。
  final VoidCallback? onClearPressed;

  /// 是否在聚焦且存在文本时显示清除按钮。
  final bool clearable;

  /// 是否自动聚焦。
  final bool autofocus;

  /// 键盘类型。
  final TextInputType inputType;

  /// 键盘动作。
  final TextInputAction inputAction;

  /// 最大字符数；不显示 Material 计数器。
  final int? maxLength;

  /// 输入格式化器。
  final List<TextInputFormatter>? inputFormatters;

  /// 搜索框形态；优先于 [TSearchBarThemeData.variant]。
  final TSearchBarVariant? variant;

  /// 文本对齐方式；优先于 [TSearchBarThemeData.textAlignment]。
  final TSearchBarAlignment? textAlignment;

  /// 自定义焦点节点。
  final FocusNode? focusNode;

  @override
  State<TSearchBar> createState() => _TSearchBarState();
}

class _TSearchBarState extends State<TSearchBar> {
  late final TextEditingController _internalController;
  late final FocusNode _internalFocusNode;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  bool _hasText = false;
  bool _isFocused = false;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode;

  bool get _showClear =>
      widget.clearable &&
      widget.enabled &&
      !widget.readOnly &&
      _hasText &&
      _isFocused;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController(text: widget.initialValue);
    _internalFocusNode = FocusNode();
    _controller = _effectiveController;
    _focusNode = _effectiveFocusNode;
    _hasText = _controller.text.isNotEmpty;
    _isFocused = _focusNode.hasFocus;
    _controller.addListener(_handleTextChanged);
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant TSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncController();
    _syncFocusNode();
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    _focusNode.removeListener(_handleFocusChanged);
    _internalController.dispose();
    _internalFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final token = context.tTheme;
    final theme = Theme.of(context).extension<TSearchBarThemeData>();
    final effectiveVariant =
        widget.variant ?? theme?.variant ?? TSearchBarVariant.square;
    final effectiveAlignment =
        widget.textAlignment ??
        theme?.textAlignment ??
        TSearchBarAlignment.left;
    final height = theme?.height ?? _kSearchBarHeight;
    final inputBackgroundColor =
        theme?.inputBackgroundColor ?? token.bgColorSecondaryContainer;
    final contentPadding = theme?.contentPadding ?? _kContentPadding;
    final actionText = widget.actionText;
    final hasAction = actionText != null && actionText.isNotEmpty;

    final bodyFont = token.fontBodyLarge;
    final defaultTextStyle = TextStyle(
      fontSize: bodyFont?.size ?? 16,
      height: bodyFont?.height ?? 1.5,
      fontWeight: bodyFont?.fontWeight ?? FontWeight.w400,
      color: token.textColorPrimary,
    );
    final defaultHintStyle = defaultTextStyle.copyWith(
      color: token.textColorPlaceholder,
    );
    final textStyle = defaultTextStyle
        .merge(theme?.textStyle)
        .copyWith(
          color: widget.enabled
              ? theme?.textStyle?.color ?? token.textColorPrimary
              : token.textDisabledColor,
        );
    final hintStyle = defaultHintStyle
        .merge(theme?.hintStyle)
        .copyWith(
          color: widget.enabled
              ? theme?.hintStyle?.color ?? token.textColorPlaceholder
              : token.textDisabledColor,
        );
    final actionStyle = defaultTextStyle
        .copyWith(color: token.brandNormalColor)
        .merge(theme?.actionTextStyle);
    var searchIconTheme = IconThemeData(
      size: _kIconSize,
      color: token.textColorPlaceholder,
    ).merge(theme?.searchIconTheme);
    var clearIconTheme = IconThemeData(
      size: _kIconSize,
      color: token.textColorPlaceholder,
    ).merge(theme?.clearIconTheme);
    if (!widget.enabled) {
      searchIconTheme = searchIconTheme.copyWith(
        color: token.textDisabledColor,
      );
      clearIconTheme = clearIconTheme.copyWith(color: token.textDisabledColor);
    }

    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: inputBackgroundColor,
                borderRadius: BorderRadius.circular(
                  effectiveVariant == TSearchBarVariant.round
                      ? height / 2
                      : token.radiusDefault,
                ),
              ),
              child: Padding(
                padding: contentPadding,
                child: Row(
                  children: [
                    IconTheme(
                      data: searchIconTheme,
                      child: const Icon(TIcons.search),
                    ),
                    const SizedBox(width: _kIconGap),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        autofocus: widget.autofocus,
                        enabled: widget.enabled,
                        readOnly: widget.readOnly,
                        onChanged: widget.onChanged,
                        onSubmitted: widget.onSubmitted,
                        keyboardType: widget.inputType,
                        textInputAction: widget.inputAction,
                        inputFormatters: widget.inputFormatters,
                        maxLength: widget.maxLength,
                        buildCounter:
                            (
                              _, {
                              required currentLength,
                              required isFocused,
                              required maxLength,
                            }) => null,
                        cursorColor: token.brandNormalColor,
                        cursorHeight: theme?.cursorHeight,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign:
                            effectiveAlignment == TSearchBarAlignment.center
                            ? TextAlign.center
                            : TextAlign.left,
                        style: textStyle,
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: hintStyle,
                          hintMaxLines: 1,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          isCollapsed: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        maxLines: 1,
                        cursorOpacityAnimates: false,
                      ),
                    ),
                    if (_showClear)
                      Semantics(
                        button: true,
                        label: '清除',
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _handleClear,
                          child: SizedBox(
                            width: 32,
                            height: height,
                            child: IconTheme(
                              data: clearIconTheme,
                              child: const Icon(TIcons.close_circle_filled),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (hasAction) ...[
            SizedBox(width: theme?.actionGap ?? _kActionGap),
            Semantics(
              button: true,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.enabled ? widget.onActionPressed : null,
                child: SizedBox(
                  height: height,
                  child: Center(child: Text(actionText, style: actionStyle)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _syncController() {
    final next = _effectiveController;
    if (_controller == next) {
      return;
    }
    _controller.removeListener(_handleTextChanged);
    _controller = next;
    _controller.addListener(_handleTextChanged);
    _setHasText(_controller.text.isNotEmpty);
  }

  void _syncFocusNode() {
    final next = _effectiveFocusNode;
    if (_focusNode == next) {
      return;
    }
    _focusNode.removeListener(_handleFocusChanged);
    _focusNode = next;
    _focusNode.addListener(_handleFocusChanged);
    _setFocused(_focusNode.hasFocus);
  }

  void _handleTextChanged() {
    _setHasText(_controller.text.isNotEmpty);
  }

  void _handleFocusChanged() {
    _setFocused(_focusNode.hasFocus);
    widget.onFocusChanged?.call(_focusNode.hasFocus);
  }

  void _setFocused(bool value) {
    if (_isFocused == value || !mounted) {
      return;
    }
    setState(() => _isFocused = value);
  }

  void _setHasText(bool value) {
    if (_hasText == value || !mounted) {
      return;
    }
    setState(() => _hasText = value);
  }

  void _handleClear() {
    _controller.clear();
    widget.onClearPressed?.call();
    widget.onChanged?.call('');
  }
}
