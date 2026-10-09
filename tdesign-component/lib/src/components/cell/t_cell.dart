import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../text/t_text_style_scope.dart';
import 't_cell_theme_data.dart';

/// 单元格内容垂直对齐方式。
enum TCellAlign {
  /// 顶部对齐。
  top,

  /// 居中对齐。
  center,

  /// 底部对齐。
  bottom,
}

/// 单元格组件。
///
/// ### 主题配置
///
/// 组件主题通过 [TCellThemeData] 配置，放入 Flutter [ThemeData.extensions]
/// 后作用于对应子树。字段含义、未配置时的回退及复制/过渡行为见本页的
/// `TCellThemeData` 说明。
class TCell extends StatefulWidget {
  const TCell({
    this.title,
    this.subtitle,
    this.prefix,
    this.image,
    this.note,
    this.trailing,
    this.arrow = false,
    this.required = false,
    this.align,
    this.enableFeedback = true,
    this.onTap,
    this.onLongPress,
    super.key,
  });

  /// 标题区。
  final Widget? title;

  /// 副标题区。
  final Widget? subtitle;

  /// 标题左侧内容。
  final Widget? prefix;

  /// 单元格左侧图片区。
  final Widget? image;

  /// 右侧说明内容。
  final Widget? note;

  /// 最右侧内容。
  final Widget? trailing;

  /// 是否显示右箭头。
  final bool arrow;

  /// 是否显示必填标记。
  final bool required;

  /// 内容垂直对齐方式；未设置时为 [TCellAlign.center]。
  final TCellAlign? align;

  /// 点击时是否显示背景反馈。
  final bool enableFeedback;

  /// 点击回调；为空时不创建点击行为。
  final GestureTapCallback? onTap;

  /// 长按回调。
  final GestureLongPressCallback? onLongPress;

  @override
  State<TCell> createState() => _TCellState();
}

class _TCellState extends State<TCell> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TCellThemeData>();
    final token = context.tTheme;
    final titleStyle = TextStyle(
      color: token.textColorPrimary,
      fontSize: token.fontBodyLarge?.size ?? 16,
      height: token.fontBodyLarge?.height,
      fontWeight: token.fontBodyLarge?.fontWeight ?? FontWeight.w400,
    ).merge(theme?.titleStyle);
    final subtitleStyle = TextStyle(
      color: token.textColorSecondary,
      fontSize: token.fontBodyMedium?.size ?? 14,
      height: token.fontBodyMedium?.height,
      fontWeight: token.fontBodyMedium?.fontWeight ?? FontWeight.w400,
    ).merge(theme?.subtitleStyle);
    final noteStyle = TextStyle(
      color: token.textColorPlaceholder,
      fontSize: token.fontBodyLarge?.size ?? 16,
      height: token.fontBodyLarge?.height,
      fontWeight: token.fontBodyLarge?.fontWeight ?? FontWeight.w400,
    ).merge(theme?.noteStyle);
    final align = widget.align ?? TCellAlign.center;
    final crossAxisAlignment = switch (align) {
      TCellAlign.top => CrossAxisAlignment.start,
      TCellAlign.center => CrossAxisAlignment.center,
      TCellAlign.bottom => CrossAxisAlignment.end,
    };
    final noteAlignment = switch (align) {
      TCellAlign.top => AlignmentDirectional.topEnd,
      TCellAlign.center => AlignmentDirectional.centerEnd,
      TCellAlign.bottom => AlignmentDirectional.bottomEnd,
    };
    final hasMainContent = widget.title != null || widget.subtitle != null;
    final content = Container(
      height: theme?.height,
      padding: theme?.padding ?? EdgeInsets.all(context.tTheme.spacer2),
      decoration: BoxDecoration(
        color: _pressed
            ? theme?.pressedColor ?? context.tTheme.bgColorSecondaryContainer
            : theme?.backgroundColor ?? context.tTheme.bgColorContainer,
        border: theme?.showBottomBorder ?? false
            ? Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: theme?.borderColor ?? context.tTheme.componentStroke,
                ),
              )
            : null,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            if (widget.image != null) ...[
              widget.image!,
              SizedBox(width: context.tTheme.spacer1),
            ],
            if (widget.prefix != null) ...[
              widget.prefix!,
              SizedBox(width: context.tTheme.spacer1),
            ],
            if (hasMainContent || widget.note == null)
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.title != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: TTextStyleScope(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: titleStyle,
                              child: widget.title!,
                            ),
                          ),
                          if (widget.required)
                            Text(
                              ' *',
                              style: TextStyle(
                                color: token.errorColor,
                              ).merge(theme?.requiredStyle),
                            ),
                        ],
                      ),
                    if (widget.title != null && widget.subtitle != null)
                      const SizedBox(height: 4.0),
                    if (widget.subtitle != null)
                      TTextStyleScope(
                        style: subtitleStyle,
                        child: widget.subtitle!,
                      ),
                  ],
                ),
              ),
            if (widget.note != null) ...[
              if (hasMainContent) const SizedBox(width: 4.0),
              if (hasMainContent)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth:
                        constraints.maxWidth *
                        (constraints.maxWidth < 240 ? 0.5 : 0.75),
                  ),
                  child: TTextStyleScope(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: noteStyle,
                    child: widget.note!,
                  ),
                )
              else
                Expanded(
                  child: Align(
                    alignment: noteAlignment,
                    child: TTextStyleScope(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: noteStyle,
                      child: widget.note!,
                    ),
                  ),
                ),
            ],
            if (widget.trailing != null) ...[
              const SizedBox(width: 4.0),
              widget.trailing!,
            ],
            if (widget.arrow) ...[
              const SizedBox(width: 4.0),
              Icon(
                TIcons.chevron_right,
                size: 24,
                color: theme?.arrowColor ?? context.tTheme.textColorPlaceholder,
              ),
            ],
          ],
        ),
      ),
    );

    if (widget.onTap == null && widget.onLongPress == null) {
      return content;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: widget.enableFeedback ? (_) => _setPressed(true) : null,
      onTapUp: widget.enableFeedback ? (_) => _setPressed(false) : null,
      onTapCancel: widget.enableFeedback ? () => _setPressed(false) : null,
      child: content,
    );
  }

  void _setPressed(bool value) {
    if (_pressed != value && mounted) {
      setState(() => _pressed = value);
    }
  }
}
