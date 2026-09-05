import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../text/t_text.dart';
import 't_drawer.dart';
import 't_drawer_theme_data.dart';

/// 点击抽屉列表项时的回调。
///
/// [index] 是列表下标，[item] 是被点击的配置项。
typedef TDrawerItemClickCallback = void Function(int index, TDrawerItem item);

/// 抽屉内容组件，可用于 Scaffold 的 `drawer` 属性。
class TDrawerWidget extends StatelessWidget {
  const TDrawerWidget({
    super.key,
    this.footer,
    this.items,
    this.child,
    this.title,
    this.onItemClick,
    this.width,
    this.enableFeedback = true,
    this.backgroundColor,
    this.bordered = true,
    this.isShowLastBordered = true,
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

  /// 宽度；优先级高于 ThemeData，默认使用 280。
  final double? width;

  /// 点击时是否显示背景按压反馈，默认 true。
  final bool enableFeedback;

  /// 组件背景颜色；优先级高于 ThemeData 和默认值。
  final Color? backgroundColor;

  /// 是否显示菜单项分隔线，默认 true。
  final bool bordered;

  /// 是否显示最后一行分隔线，默认 true。
  final bool isShowLastBordered;

  @override
  Widget build(BuildContext context) {
    final drawerTheme = Theme.of(context).extension<TDrawerThemeData>();
    final effectiveWidth = width ?? drawerTheme?.width ?? 280;
    final effectiveBackgroundColor =
        backgroundColor ??
        drawerTheme?.backgroundColor ??
        context.tTheme.bgColorContainer;
    final content =
        child ??
        Column(
          children: [
            if (title != null)
              Padding(
                padding:
                    drawerTheme?.titlePadding ??
                    const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: DefaultTextStyle(
                  style: _titleTextStyle(context, drawerTheme),
                  child: title!,
                ),
              ),
            Expanded(
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
                    enableFeedback: enableFeedback,
                    textStyle: _itemTextStyle(context, drawerTheme),
                    backgroundColor:
                        drawerTheme?.itemBackgroundColor ??
                        context.tTheme.bgColorContainer,
                    pressedColor:
                        drawerTheme?.itemPressedColor ??
                        context.tTheme.bgColorSecondaryContainer,
                    padding:
                        drawerTheme?.itemPadding ??
                        const EdgeInsets.fromLTRB(16, 16, 0, 16),
                    iconColor:
                        drawerTheme?.itemIconColor ??
                        context.tTheme.textColorPrimary,
                    iconSize: drawerTheme?.itemIconSize ?? 24,
                    iconGap: drawerTheme?.itemIconGap ?? 8,
                    dividerColor:
                        drawerTheme?.dividerColor ??
                        context.tTheme.componentStrokeColor,
                    dividerIndent: drawerTheme?.dividerIndent ?? 16,
                    dividerThickness: drawerTheme?.dividerThickness ?? 0.5,
                    showDivider:
                        bordered &&
                        (index < (items?.length ?? 0) - 1 ||
                            isShowLastBordered),
                  );
                },
              ),
            ),
            if (footer != null)
              Container(
                padding:
                    drawerTheme?.footerPadding ??
                    const EdgeInsets.only(bottom: 20),
                child: footer,
              ),
          ],
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height;
        return Container(
          width: effectiveWidth,
          height: availableHeight,
          color: effectiveBackgroundColor,
          child: content,
        );
      },
    );
  }

  TextStyle _itemTextStyle(
    BuildContext context,
    TDrawerThemeData? drawerTheme,
  ) {
    final materialStyle = Theme.of(context).tExplicitTextTheme?.bodyLarge;
    final inheritedStyle = Theme.of(context).textTheme.bodyLarge;
    final tokenFont = context.tTheme.fontBodyLarge;
    final baseStyle =
        materialStyle ??
        TextStyle(
          color: context.tTheme.textColorPrimary,
          fontSize: tokenFont?.size ?? 16,
          height: tokenFont?.height,
          fontWeight: tokenFont?.fontWeight ?? FontWeight.w400,
          fontFamily: inheritedStyle?.fontFamily,
          fontFamilyFallback: inheritedStyle?.fontFamilyFallback,
        );
    return baseStyle.merge(drawerTheme?.itemTextStyle);
  }

  TextStyle _titleTextStyle(
    BuildContext context,
    TDrawerThemeData? drawerTheme,
  ) {
    final materialStyle = Theme.of(context).tExplicitTextTheme?.titleLarge;
    final inheritedStyle = Theme.of(context).textTheme.titleLarge;
    final tokenFont = context.tTheme.fontTitleLarge;
    final baseStyle =
        materialStyle ??
        TextStyle(
          color: context.tTheme.textColorPrimary,
          fontSize: tokenFont?.size ?? 20,
          height: tokenFont?.height,
          fontWeight: tokenFont?.fontWeight ?? FontWeight.w600,
          fontFamily: inheritedStyle?.fontFamily,
          fontFamilyFallback: inheritedStyle?.fontFamilyFallback,
        );
    return baseStyle.merge(drawerTheme?.titleStyle);
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
    required this.iconColor,
    required this.iconSize,
    required this.iconGap,
    required this.dividerColor,
    required this.dividerIndent,
    required this.dividerThickness,
    required this.showDivider,
  });

  final TDrawerItem item;
  final VoidCallback? onTap;
  final bool enableFeedback;
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color pressedColor;
  final EdgeInsetsGeometry padding;
  final Color iconColor;
  final double iconSize;
  final double iconGap;
  final Color dividerColor;
  final double dividerIndent;
  final double dividerThickness;
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
            IconTheme.merge(
              data: IconThemeData(
                color: widget.iconColor,
                size: widget.iconSize,
              ),
              child: widget.item.icon!,
            ),
            SizedBox(width: widget.iconGap),
          ],
          Expanded(
            child:
                widget.item.content ??
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
            onTapCancel: widget.enableFeedback
                ? () => _setPressed(false)
                : null,
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
          height: widget.dividerThickness,
          thickness: widget.dividerThickness,
          indent: widget.dividerIndent,
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

/// 抽屉里的列表项。
class TDrawerItem {
  const TDrawerItem({this.title, this.icon, this.content});

  /// 每列标题
  final String? title;

  /// 每列图标
  final Widget? icon;

  /// 完全自定义
  final Widget? content;
}
