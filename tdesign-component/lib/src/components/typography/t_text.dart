import 'dart:async';
import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart';

import '../../theme/basic.dart';
import '../icon/t_icon.dart';
import 't_text_resolve.dart';
import 't_text_theme_data.dart';

/// Flutter [Text] 的 TDesign Token 薄封装。
///
/// 文字布局、字体 fallback、无障碍缩放和语义均由 Flutter 原生 Text 负责。
/// 固定容器居中与图文 baseline 应由父布局表达。
///
/// 支持 TDesign Typography 的 [copyable]（可复制）与
/// [expandable]（展开/收起）交互能力。
class TText extends StatelessWidget {
  const TText(
    String this.data, {
    this.font,
    this.fontWeight,
    this.fontFamily,
    this.textColor,
    this.isTextThrough,
    this.lineThroughColor,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.copyable = false,
    this.expandable = false,
    this.expanded,
    this.onExpandedChange,
    this.onCopied,
    super.key,
  }) : textSpan = null;

  /// 创建 TDesign 富文本。
  const TText.rich(
    InlineSpan this.textSpan, {
    this.font,
    this.fontWeight,
    this.fontFamily,
    this.textColor,
    this.isTextThrough,
    this.lineThroughColor,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.semanticsIdentifier,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.copyable = false,
    this.expandable = false,
    this.expanded,
    this.onExpandedChange,
    this.onCopied,
    super.key,
  }) : data = null;

  /// TDesign 字体 Token，包含字号、行高和字重。
  final Font? font;

  /// 字体粗细。
  final FontWeight? fontWeight;

  /// 字体族及可选资源 package。
  final FontFamily? fontFamily;

  /// 文字颜色。
  final Color? textColor;

  /// 是否显示删除线。为 null 时继承 Theme 或父级样式。
  final bool? isTextThrough;

  /// 删除线颜色。
  final Color? lineThroughColor;

  /// Flutter 原生文字样式，具有最高优先级。
  final TextStyle? style;

  /// 文本内容。
  final String? data;

  /// 富文本内容。
  final InlineSpan? textSpan;

  /// 透传至 [Text.strutStyle]。
  final StrutStyle? strutStyle;

  /// 透传至 [Text.textAlign]。
  final TextAlign? textAlign;

  /// 透传至 [Text.textDirection]。
  final TextDirection? textDirection;

  /// 透传至 [Text.locale]。
  final Locale? locale;

  /// 透传至 [Text.softWrap]。
  final bool? softWrap;

  /// 透传至 [Text.overflow]。
  final TextOverflow? overflow;

  /// Flutter 原生文字缩放器；为 null 时继承 MediaQuery。
  final TextScaler? textScaler;

  /// 透传至 [Text.maxLines]。
  final int? maxLines;

  /// 透传至 [Text.semanticsLabel]。
  final String? semanticsLabel;

  /// 透传至 [Text.semanticsIdentifier]。
  final String? semanticsIdentifier;

  /// 透传至 [Text.textWidthBasis]。
  final TextWidthBasis? textWidthBasis;

  /// 透传至 [Text.textHeightBehavior]。
  final ui.TextHeightBehavior? textHeightBehavior;

  /// 透传至 [Text.selectionColor]。
  final Color? selectionColor;

  /// 是否可复制。为 true 时在文本后显示复制图标，点击写入系统剪贴板，
  /// 成功后短暂切换为 check 图标并回调 [onCopied]。
  final bool copyable;

  /// 是否支持展开/收起。为 true 且内容超出 [maxLines] 时显示操作。
  final bool expandable;

  /// 展开状态（受控）。为 null 时组件内部自管理；非 null 时由外部驱动。
  final bool? expanded;

  /// 展开状态变化回调。
  final ValueChanged<bool>? onExpandedChange;

  /// 复制成功回调。
  final VoidCallback? onCopied;

  @override
  Widget build(BuildContext context) {
    final interactive = copyable || expandable;
    if (!interactive) {
      return _rawText(context);
    }
    return _TInteractiveText(
      copyText: data ?? textSpan?.toPlainText() ?? '',
      copyable: copyable,
      expandable: expandable,
      expanded: expanded,
      maxLines: maxLines,
      overflow: overflow,
      onExpandedChange: onExpandedChange,
      onCopied: onCopied,
      rebuildText: (maxLines, overflow) => _rawText(
        context,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }

  /// 获取与当前 TText 配置等价的 Flutter 原生 [Text]。
  Text getRawText({required BuildContext context}) {
    return _rawText(context, includeKey: true);
  }

  /// 获取最终 Flutter [TextStyle]。
  TextStyle getTextStyle(BuildContext context) {
    return TTextResolve.resolve(
      context: context,
      style: style,
      font: font,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      textColor: textColor,
      isTextThrough: isTextThrough,
      lineThroughColor: lineThroughColor,
    );
  }

  Text _rawText(
    BuildContext context, {
    bool includeKey = false,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    final theme = Theme.of(context).extension<TTextThemeData>();
    final effectiveStrutStyle = strutStyle ?? theme?.strutStyle;
    final effectiveTextWidthBasis = textWidthBasis ?? theme?.textWidthBasis;
    final effectiveTextHeightBehavior =
        textHeightBehavior ?? theme?.textHeightBehavior;
    final effectiveKey = includeKey ? key : null;

    final effectiveMaxLines = maxLines ?? this.maxLines;
    final effectiveOverflow = overflow ?? this.overflow;

    if (textSpan != null) {
      return Text.rich(
        textSpan!,
        key: effectiveKey,
        style: getTextStyle(context),
        strutStyle: effectiveStrutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: effectiveOverflow,
        textScaler: textScaler,
        maxLines: effectiveMaxLines,
        semanticsLabel: semanticsLabel,
        semanticsIdentifier: semanticsIdentifier,
        textWidthBasis: effectiveTextWidthBasis,
        textHeightBehavior: effectiveTextHeightBehavior,
        selectionColor: selectionColor,
      );
    }
    return Text(
      data!,
      key: effectiveKey,
      style: getTextStyle(context),
      strutStyle: effectiveStrutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: effectiveOverflow,
      textScaler: textScaler,
      maxLines: effectiveMaxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsIdentifier,
      textWidthBasis: effectiveTextWidthBasis,
      textHeightBehavior: effectiveTextHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}

/// 处理 TText 复制与展开/收起交互状态。
class _TInteractiveText extends StatefulWidget {
  const _TInteractiveText({
    required this.copyText,
    required this.copyable,
    required this.expandable,
    required this.expanded,
    required this.maxLines,
    required this.overflow,
    required this.onExpandedChange,
    required this.onCopied,
    required this.rebuildText,
  });

  final String copyText;
  final bool copyable;
  final bool expandable;
  final bool? expanded;
  final int? maxLines;
  final TextOverflow? overflow;
  final ValueChanged<bool>? onExpandedChange;
  final VoidCallback? onCopied;
  final Text Function(int? maxLines, TextOverflow? overflow) rebuildText;

  @override
  State<_TInteractiveText> createState() => _TInteractiveTextState();
}

class _TInteractiveTextState extends State<_TInteractiveText> {
  bool _copied = false;
  bool? _internalExpanded;
  Timer? _copyTimer;

  @override
  void dispose() {
    _copyTimer?.cancel();
    super.dispose();
  }

  bool get _isExpanded => widget.expanded ?? _internalExpanded ?? false;

  void _toggleExpand() {
    final next = !_isExpanded;
    if (widget.expanded == null) {
      setState(() => _internalExpanded = next);
    }
    widget.onExpandedChange?.call(next);
  }

  Future<void> _copy() async {
    if (widget.copyText.isEmpty) {
      return;
    }
    await Clipboard.setData(ClipboardData(text: widget.copyText));
    if (!mounted) {
      return;
    }
    setState(() => _copied = true);
    _copyTimer?.cancel();
    _copyTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _copied = false);
      }
    });
    widget.onCopied?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final collapsed = widget.expandable && !_isExpanded;
    final effectiveMaxLines = collapsed ? (widget.maxLines ?? 1) : widget.maxLines;
    final effectiveOverflow =
        collapsed ? (widget.overflow ?? TextOverflow.ellipsis) : widget.overflow;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: widget.rebuildText(effectiveMaxLines, effectiveOverflow),
        ),
        if (widget.copyable)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _copy,
            child: Padding(
              padding: const EdgeInsets.only(left: 6),
              child: TIcon(
                _copied ? TIcons.check : TIcons.file_copy,
                size: 16,
                color: primaryColor,
                semanticLabel: _copied ? '已复制' : '复制',
              ),
            ),
          ),
        if (widget.expandable)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _toggleExpand,
            child: Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                _isExpanded ? _localizedCollapse(context) : _localizedExpand(context),
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _localizedExpand(BuildContext context) {
    final locale = Localizations.maybeLocaleOf(context)?.toString() ?? 'zh';
    return locale.startsWith('en') ? 'Expand' : '展开';
  }

  String _localizedCollapse(BuildContext context) {
    final locale = Localizations.maybeLocaleOf(context)?.toString() ?? 'zh';
    return locale.startsWith('en') ? 'Collapse' : '收起';
  }
}

/// 支持 TDesign 字体便利参数的 Flutter [TextSpan]。
///
/// 未显式配置的字段保持为空，并继承父 Span 样式。
class TTextSpan extends TextSpan {
  TTextSpan({
    /// TDesign 字体 Token，包含字号、行高和字重。
    Font? font,

    /// 字体粗细。
    FontWeight? fontWeight,

    /// 字体族及可选资源 package。
    FontFamily? fontFamily,

    /// 文字颜色。
    Color? textColor,

    /// 是否显示删除线。为 null 时继承父 Span。
    bool? isTextThrough,

    /// 删除线颜色。
    Color? lineThroughColor,

    /// 透传至 [TextSpan.text]。
    String? text,

    /// 透传至 [TextSpan.children]。
    List<InlineSpan>? children,

    /// Flutter 原生文字样式，具有最高优先级。
    TextStyle? style,

    /// 透传至 [TextSpan.recognizer]。
    GestureRecognizer? recognizer,

    /// 透传至 [TextSpan.mouseCursor]。
    MouseCursor? mouseCursor,

    /// 透传至 [TextSpan.onEnter]。
    PointerEnterEventListener? onEnter,

    /// 透传至 [TextSpan.onExit]。
    PointerExitEventListener? onExit,

    /// 透传至 [TextSpan.semanticsLabel]。
    String? semanticsLabel,

    /// 透传至 [TextSpan.semanticsIdentifier]。
    String? semanticsIdentifier,

    /// 透传至 [TextSpan.locale]。
    Locale? locale,

    /// 透传至 [TextSpan.spellOut]。
    bool? spellOut,
  }) : super(
         text: text,
         children: children,
         style: TTextResolve.resolveSpan(
           style: style,
           font: font,
           fontWeight: fontWeight,
           fontFamily: fontFamily,
           textColor: textColor,
           isTextThrough: isTextThrough,
           lineThroughColor: lineThroughColor,
         ),
         recognizer: recognizer,
         mouseCursor: mouseCursor,
         onEnter: onEnter,
         onExit: onExit,
         semanticsLabel: semanticsLabel,
         semanticsIdentifier: semanticsIdentifier,
         locale: locale,
         spellOut: spellOut,
       );
}
