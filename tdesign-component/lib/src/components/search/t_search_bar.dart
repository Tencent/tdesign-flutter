import 'package:flutter/material.dart';
import 'package:tdesign_icons/tdesign_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import 't_search_bar_theme_data.dart';

const double _kSearchBarHeight = 56;
const double _kSearchIconSize = 24;
const double _kClearIconSize = 21;
const EdgeInsets _kSearchBarPadding = EdgeInsets.symmetric(
  horizontal: 16,
  vertical: 8,
);

/// v1 搜索输入框。
///
/// 文本控制遵循 D 类：优先使用 [controller]，无 controller 时内部创建控制器；
/// [initialValue] 仅用于初始化内部控制器。
class TSearchBar extends StatefulWidget {
  const TSearchBar({
    super.key,

    /// 文本控制器。
    this.controller,

    /// 初始文本；仅在未传 [controller] 时初始化一次。
    this.initialValue,

    /// 文本变化通知。
    this.onChanged,

    /// 提交回调。
    this.onSubmitted,

    /// 是否可交互。
    this.enabled = true,

    /// 是否只读。
    this.readOnly = false,

    /// 占位提示。
    this.hintText,

    /// 是否显示取消按钮。
    this.needCancel = false,

    /// 取消按钮文案。
    this.cancelText = '取消',

    /// 取消按钮点击回调。
    this.onCancelPressed,

    /// 清除按钮点击回调。
    this.onClearPressed,

    /// 是否自动聚焦。
    this.autoFocus = false,

    /// 键盘动作。
    this.inputAction = TextInputAction.search,

    /// 输入框装饰逃逸口。
    this.decoration,

    /// 自定义焦点。
    this.focusNode,
  });

  /// 文本控制器。
  final TextEditingController? controller;

  /// 初始文本；仅在未传 [controller] 时初始化一次。
  final String? initialValue;

  /// 文本变化通知。
  final ValueChanged<String>? onChanged;

  /// 提交回调。
  final ValueChanged<String>? onSubmitted;

  /// 是否可交互。
  final bool enabled;

  /// 是否只读。
  final bool readOnly;

  /// 占位提示。
  final String? hintText;

  /// 是否显示取消按钮。
  final bool needCancel;

  /// 取消按钮文案。
  final String cancelText;

  /// 取消按钮点击回调。
  final VoidCallback? onCancelPressed;

  /// 清除按钮点击回调。
  final VoidCallback? onClearPressed;

  /// 是否自动聚焦。
  final bool autoFocus;

  /// 键盘动作。
  final TextInputAction inputAction;

  /// 输入框装饰逃逸口。
  final InputDecoration? decoration;

  /// 自定义焦点。
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
  bool _hasFocus = false;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalController = TextEditingController(text: widget.initialValue);
    _internalFocusNode = FocusNode();
    _controller = _effectiveController;
    _focusNode = _effectiveFocusNode;
    _hasText = _controller.text.isNotEmpty;
    _hasFocus = _focusNode.hasFocus;
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
    final variant = theme?.variant ?? TSearchBarVariant.square;
    final textAlignment = theme?.textAlignment ?? TSearchBarAlignment.left;
    final padding = theme?.padding ?? _kSearchBarPadding;
    final backgroundColor = theme?.backgroundColor ?? token.bgColorContainer;
    final autoHeight = theme?.autoHeight ?? false;
    final inputDecoration = _buildDecoration(context);
    final textStyle = TextStyle(
      textBaseline: TextBaseline.ideographic,
      fontSize: token.fontBodyLarge?.size,
      height: token.fontBodyLarge?.height,
      color: widget.enabled ? token.textColorPrimary : token.textDisabledColor,
    );

    return Semantics(
      enabled: widget.enabled,
      textField: true,
      child: Container(
        padding: padding,
        height: autoHeight ? double.infinity : _kSearchBarHeight,
        color: backgroundColor,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: token.bgColorSecondaryContainer,
                      borderRadius: BorderRadius.circular(
                        variant == TSearchBarVariant.square ? 4 : 28,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 12),
                        Icon(
                          TIcons.search,
                          size: _kSearchIconSize,
                          color: widget.enabled
                              ? token.textColorPlaceholder
                              : token.textDisabledColor,
                        ),
                        const Padding(padding: EdgeInsets.only(left: 3)),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 1),
                            // 为了适配 TextField 与 Text 的差异，后续需要做通用适配。
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              autofocus: widget.autoFocus,
                              enabled: widget.enabled,
                              readOnly: widget.readOnly,
                              onChanged: widget.onChanged,
                              onSubmitted: widget.onSubmitted,
                              textInputAction: widget.inputAction,
                              cursorColor: token.brandNormalColor,
                              cursorHeight: theme?.cursorHeight,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign:
                                  textAlignment == TSearchBarAlignment.center
                                      ? TextAlign.center
                                      : TextAlign.left,
                              style: textStyle,
                              decoration: inputDecoration,
                              maxLines: 1,
                              cursorOpacityAnimates: false,
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 9)),
                        Offstage(
                            offstage: !_hasText,
                            child: GestureDetector(
                              onTap: widget.enabled ? _handleClear : null,
                              child: Icon(
                                TIcons.close_circle_filled,
                                size: _kClearIconSize,
                                color: widget.enabled
                                    ? token.textColorPlaceholder
                                    : token.textDisabledColor,
                              ),
                            )),
                        const Padding(padding: EdgeInsets.only(right: 9)),
                      ],
                    ),
                  ),
                ),
                Offstage(
                  offstage: !_hasFocus || !widget.needCancel,
                  child: GestureDetector(
                    onTap: _handleCancel,
                    child: Container(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        widget.cancelText,
                        style: TextStyle(
                          fontSize: token.fontBodyLarge?.size,
                          color: token.brandNormalColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildDecoration(BuildContext context) {
    final token = context.tTheme;
    if (widget.decoration == null) {
      return InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: token.fontBodyLarge?.size,
          height: token.fontBodyLarge?.height,
          color: widget.enabled
              ? token.textColorPlaceholder
              : token.textDisabledColor,
          textBaseline: TextBaseline.ideographic,
          overflow: TextOverflow.ellipsis,
        ),
        hintMaxLines: 1,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        filled: false,
        fillColor: Colors.transparent,
        isCollapsed: true,
        contentPadding: EdgeInsets.zero,
      );
    }

    final base = widget.decoration!;
    return base.copyWith(
      hintText: base.hintText ?? widget.hintText,
      hintStyle: base.hintStyle ??
          TextStyle(
            fontSize: token.fontBodyLarge?.size,
            height: token.fontBodyLarge?.height,
            color: widget.enabled
                ? token.textColorPlaceholder
                : token.textDisabledColor,
            textBaseline: TextBaseline.ideographic,
            overflow: TextOverflow.ellipsis,
          ),
      hintMaxLines: base.hintMaxLines ?? 1,
      border: base.border ?? InputBorder.none,
      enabledBorder: base.enabledBorder ?? InputBorder.none,
      focusedBorder: base.focusedBorder ?? InputBorder.none,
      disabledBorder: base.disabledBorder ?? InputBorder.none,
      filled: base.filled ?? false,
      fillColor: base.fillColor ?? Colors.transparent,
      isCollapsed: base.isCollapsed ?? true,
      contentPadding: base.contentPadding ?? EdgeInsets.zero,
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
    _setHasFocus(_focusNode.hasFocus);
  }

  void _handleTextChanged() {
    _setHasText(_controller.text.isNotEmpty);
  }

  void _handleFocusChanged() {
    _setHasFocus(_focusNode.hasFocus);
  }

  void _setHasText(bool value) {
    if (_hasText == value) {
      return;
    }
    setState(() => _hasText = value);
  }

  void _setHasFocus(bool value) {
    if (_hasFocus == value) {
      return;
    }
    setState(() => _hasFocus = value);
  }

  void _handleClear() {
    _controller.clear();
    widget.onClearPressed?.call();
    widget.onChanged?.call('');
  }

  void _handleCancel() {
    _controller.clear();
    widget.onCancelPressed?.call();
    widget.onChanged?.call('');
    _focusNode.unfocus();
  }
}
