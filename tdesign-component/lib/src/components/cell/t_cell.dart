import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
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

  /// 内容垂直对齐方式。
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
    final materialTheme = Theme.of(context);
    final listTileTheme = materialTheme.listTileTheme;
    final colorScheme = materialTheme.tExplicitColorScheme;
    final align = widget.align ?? theme?.align ?? TCellAlign.center;
    final crossAxisAlignment = switch (align) {
      TCellAlign.top => CrossAxisAlignment.start,
      TCellAlign.center => CrossAxisAlignment.center,
      TCellAlign.bottom => CrossAxisAlignment.end,
    };
    final content = Container(
      height: theme?.height,
      padding: theme?.padding ?? EdgeInsets.all(context.tTheme.spacer16),
      decoration: BoxDecoration(
        color: _pressed
            ? theme?.pressedColor ?? context.tTheme.bgColorContainerHover
            : theme?.backgroundColor ??
                  listTileTheme.tileColor ??
                  colorScheme?.surface ??
                  context.tTheme.bgColorContainer,
        border: theme?.showBottomBorder ?? false
            ? Border(
                bottom: BorderSide(
                  width: 0.5,
                  color:
                      theme?.borderColor ?? context.tTheme.componentStrokeColor,
                ),
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          if (widget.image != null) ...[
            widget.image!,
            SizedBox(width: context.tTheme.spacer12),
          ],
          if (widget.prefix != null) ...[
            widget.prefix!,
            SizedBox(width: context.tTheme.spacer12),
          ],
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
                        child: DefaultTextStyle.merge(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style:
                              theme?.titleStyle ??
                              listTileTheme.titleTextStyle ??
                              TextStyle(
                                color:
                                    colorScheme?.onSurface ??
                                    context.tTheme.textColorPrimary,
                                fontSize:
                                    context.tTheme.fontBodyLarge?.size ?? 16,
                                height: context.tTheme.fontBodyLarge?.height,
                                fontWeight:
                                    context.tTheme.fontBodyLarge?.fontWeight ??
                                    FontWeight.w400,
                              ),
                          child: widget.title!,
                        ),
                      ),
                      if (widget.required)
                        Text(
                          ' *',
                          style:
                              theme?.requiredStyle ??
                              TextStyle(
                                color:
                                    colorScheme?.error ??
                                    context.tTheme.errorNormalColor,
                              ),
                        ),
                    ],
                  ),
                if (widget.title != null && widget.subtitle != null)
                  SizedBox(height: context.tTheme.spacer4),
                if (widget.subtitle != null)
                  DefaultTextStyle.merge(
                    style:
                        theme?.subtitleStyle ??
                        listTileTheme.subtitleTextStyle ??
                        TextStyle(
                          color:
                              colorScheme?.onSurfaceVariant ??
                              context.tTheme.textColorSecondary,
                          fontSize: context.tTheme.fontBodyMedium?.size ?? 14,
                          height: context.tTheme.fontBodyMedium?.height,
                          fontWeight:
                              context.tTheme.fontBodyMedium?.fontWeight ??
                              FontWeight.w400,
                        ),
                    child: widget.subtitle!,
                  ),
              ],
            ),
          ),
          if (widget.note != null) ...[
            SizedBox(width: context.tTheme.spacer4),
            Flexible(
              child: DefaultTextStyle.merge(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style:
                    theme?.noteStyle ??
                    TextStyle(
                      color:
                          colorScheme?.onSurfaceVariant ??
                          context.tTheme.textColorPlaceholder,
                      fontSize: context.tTheme.fontBodyMedium?.size ?? 14,
                      height: context.tTheme.fontBodyMedium?.height,
                      fontWeight:
                          context.tTheme.fontBodyMedium?.fontWeight ??
                          FontWeight.w400,
                    ),
                child: widget.note!,
              ),
            ),
          ],
          if (widget.trailing != null) ...[
            SizedBox(width: context.tTheme.spacer4),
            widget.trailing!,
          ],
          if (widget.arrow) ...[
            SizedBox(width: context.tTheme.spacer4),
            Icon(
              TIcons.chevron_right,
              size: 24,
              color:
                  theme?.arrowColor ??
                  listTileTheme.iconColor ??
                  colorScheme?.onSurfaceVariant ??
                  context.tTheme.textColorPlaceholder,
            ),
          ],
        ],
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
