import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../text/t_text.dart';
import 't_drawer.dart';
import 't_drawer_theme_data.dart';

typedef TDrawerItemClickCallback = void Function(int index, TDrawerItem item);

/// 抽屉内容组件
/// 可用于 Scaffold 中的 drawer 属性
class TDrawerWidget extends StatelessWidget {
  const TDrawerWidget({
    super.key,
    this.footer,
    this.items,
    this.child,
    this.title,
    this.onItemClick,
    this.width,
    this.hover,
    this.backgroundColor,
    this.bordered,
    this.isShowLastBordered,
  });

  /// 抽屉的底部
  final Widget? footer;

  /// 抽屉里的列表项
  final List<TDrawerItem>? items;

  /// 自定义内容，优先级高于[items]/[footer]/[title]
  final Widget? child;

  /// 抽屉的标题组件
  final Widget? title;

  /// 点击抽屉里的列表项触发
  final TDrawerItemClickCallback? onItemClick;

  /// 宽度
  final double? width;

  /// 是否开启点击反馈
  final bool? hover;

  /// 组件背景颜色
  final Color? backgroundColor;

  /// 是否显示边框
  final bool? bordered;

  /// 是否显示最后一行分割线
  final bool? isShowLastBordered;

  @override
  Widget build(BuildContext context) {
    final drawerTheme = Theme.of(context).extension<TDrawerThemeData>();
    final effectiveWidth = width ?? drawerTheme?.width ?? 280;
    final effectiveHover = hover ?? drawerTheme?.hover ?? true;
    final effectiveBackgroundColor = backgroundColor ??
        drawerTheme?.backgroundColor ??
        context.tTheme.bgColorContainer;
    final effectiveBordered = bordered ?? drawerTheme?.bordered ?? true;
    final effectiveShowLastBordered =
        isShowLastBordered ?? drawerTheme?.isShowLastBordered ?? true;
    final content = child ??
        Column(
          children: [
            if (title != null)
              Padding(
                padding: EdgeInsets.all(context.tTheme.spacer16),
                child: title,
              ),
            Expanded(
              child: Container(
                decoration: effectiveBordered
                    ? BoxDecoration(
                        border: Border.all(
                          color: drawerTheme?.dividerColor ??
                              context.tTheme.componentStrokeColor,
                        ),
                      )
                    : null,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: items?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = items![index];
                    return _DrawerMenuItem(
                      item: item,
                      onTap: onItemClick == null
                          ? null
                          : () => onItemClick!(index, item),
                      enableFeedback: effectiveHover,
                      textStyle: _itemTextStyle(context, drawerTheme),
                      backgroundColor: drawerTheme?.itemBackgroundColor ??
                          context.tTheme.bgColorContainer,
                      pressedColor: drawerTheme?.itemPressedColor ??
                          context.tTheme.bgColorContainerHover,
                      padding: drawerTheme?.itemPadding ??
                          EdgeInsets.all(context.tTheme.spacer16),
                      dividerColor: drawerTheme?.dividerColor ??
                          context.tTheme.componentStrokeColor,
                      showDivider: index < (items?.length ?? 0) - 1 ||
                          effectiveShowLastBordered,
                    );
                  },
                ),
              ),
            ),
            if (footer != null)
              Container(
                padding: EdgeInsets.all(context.tTheme.spacer16),
                child: footer,
              ),
          ],
        );

    return Container(
      color: effectiveBackgroundColor,
      width: effectiveWidth,
      height: double.infinity,
      child: content,
    );
  }

  TextStyle _itemTextStyle(
    BuildContext context,
    TDrawerThemeData? drawerTheme,
  ) {
    final materialStyle = Theme.of(context).textTheme.bodyMedium;
    final tokenFont = context.tTheme.fontBodyMedium;
    return drawerTheme?.itemTextStyle ??
        materialStyle ??
        TextStyle(
          color: context.tTheme.textColorPrimary,
          fontSize: tokenFont?.size ?? 14,
          height: tokenFont?.height,
          fontWeight: tokenFont?.fontWeight ?? FontWeight.w400,
        );
  }
}

class _DrawerMenuItem extends StatefulWidget {
  const _DrawerMenuItem({
    required this.item,
    required this.onTap,
    required this.enableFeedback,
    required this.textStyle,
    required this.backgroundColor,
    required this.pressedColor,
    required this.padding,
    required this.dividerColor,
    required this.showDivider,
  });

  final TDrawerItem item;
  final VoidCallback? onTap;
  final bool enableFeedback;
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color pressedColor;
  final EdgeInsetsGeometry padding;
  final Color dividerColor;
  final bool showDivider;

  @override
  State<_DrawerMenuItem> createState() => _DrawerMenuItemState();
}

class _DrawerMenuItemState extends State<_DrawerMenuItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      color: _pressed ? widget.pressedColor : widget.backgroundColor,
      padding: widget.padding,
      child: Row(
        children: [
          if (widget.item.icon != null) ...[
            widget.item.icon!,
            SizedBox(width: context.tTheme.spacer12),
          ],
          Expanded(
            child: widget.item.content ??
                (widget.item.title == null
                    ? const SizedBox.shrink()
                    : TText(
                        widget.item.title!,
                        style: widget.textStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
          ),
        ],
      ),
    );
    final item = widget.onTap == null
        ? content
        : GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
            onTapDown: widget.enableFeedback ? (_) => _setPressed(true) : null,
            onTapUp: widget.enableFeedback ? (_) => _setPressed(false) : null,
            onTapCancel:
                widget.enableFeedback ? () => _setPressed(false) : null,
            child: content,
          );
    if (!widget.showDivider) {
      return item;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        item,
        Divider(
          height: 0.5,
          thickness: 0.5,
          indent: 16,
          color: widget.dividerColor,
        ),
      ],
    );
  }

  void _setPressed(bool value) {
    if (_pressed != value && mounted) {
      setState(() => _pressed = value);
    }
  }
}

/// 抽屉里的列表项
class TDrawerItem {
  TDrawerItem({this.title, this.icon, this.content});

  /// 每列标题
  final String? title;

  /// 每列图标
  final Widget? icon;

  /// 完全自定义
  final Widget? content;
}
