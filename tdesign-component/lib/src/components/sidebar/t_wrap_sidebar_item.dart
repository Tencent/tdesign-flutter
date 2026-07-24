import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import '../badge/t_badge.dart';
import '../text/t_text.dart';
import 't_sidebar_theme_data.dart';

class TWrapSideBarItem extends StatelessWidget {
  const TWrapSideBarItem({
    Key? key,
    this.badge,
    required this.disabled,
    this.icon,
    this.label = '',
    this.contentPadding,
    this.textStyle,
    this.selectedTextStyle,
    this.value = -1,
    this.selected = false,
    this.selectedColor,
    this.topAdjacent = false,
    this.bottomAdjacent = false,
    this.onTap,
    this.selectedBgColor,
    this.unSelectedBgColor,
    this.unSelectedColor,
    required this.style,
  }) : super(key: key);

  final TBadge? badge;
  final bool disabled;
  final IconData? icon;
  final String label;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  final int value;
  final bool selected;
  final Color? selectedColor;
  final Color? selectedBgColor;
  final Color? unSelectedColor;
  final Color? unSelectedBgColor;
  final bool topAdjacent;
  final bool bottomAdjacent;
  final VoidCallback? onTap;
  final TSideBarVariant style;

  static const preLineWidth = 3.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: style == TSideBarVariant.normal
          ? renderNormalItem(context)
          : renderOutlineItem(context),
    );
  }

  Widget renderNormalItem(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selectedBgColor ?? context.tTheme.bgColorContainer,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? selectedBgColor ?? context.tTheme.bgColorContainer
              : unSelectedBgColor ??
                  context
                      .tTheme.bgColorSecondaryContainer, // coverage:ignore-line
          borderRadius: BorderRadius.only(
            topRight:
                Radius.circular(topAdjacent ? context.tTheme.radiusLarge : 0),
            bottomRight: Radius.circular(
                bottomAdjacent ? context.tTheme.radiusLarge : 0),
          ),
        ),
        child: Row(
          children: [
            renderPreLine(context),
            Expanded(
                child: Padding(
                    padding: contentPadding ?? const EdgeInsets.all(16),
                    child: renderMainContent(context)))
          ],
        ),
      ),
    );
  }

  Widget renderOutlineItem(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Container(
          // height: 86,
          decoration:
              BoxDecoration(color: context.tTheme.bgColorSecondaryContainer),
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
                color: selected && !disabled
                    ? context.tTheme.bgColorContainer
                    : null,
                borderRadius:
                    BorderRadius.circular(context.tTheme.radiusDefault)),
            padding: const EdgeInsets.all(8),
            child: renderMainContent(context),
          ),
        ));
  }

  Widget renderMainContent(BuildContext context) {
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        renderIcon(context),
        Expanded(child: renderLabel(context)),
      ],
    );
    if (badge == null) {
      return content;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: content,
        ),
        Positioned(
          top: -8,
          right: -4,
          child: badge!,
        ),
      ],
    );
  }

  Widget renderPreLine(BuildContext context) {
    return Visibility(
      visible: !disabled && selected,
      replacement: const SizedBox(
        width: preLineWidth,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: preLineWidth,
            height: 14,
            decoration: BoxDecoration(
                color: selectedTextStyle != null
                    ? selectedTextStyle?.color // coverage:ignore-line
                    : (selectedColor ?? context.tTheme.brandNormalColor),
                borderRadius: BorderRadius.circular(4)),
          )
        ],
      ),
    );
  }

  Widget renderIcon(BuildContext context) {
    final iconColor = () {
      if (disabled) {
        return context.tTheme.textDisabledColor;
      }
      if (!selected) {
        return unSelectedColor ?? context.tTheme.textColorPrimary;
      }
      if (selectedTextStyle?.color != null) {
        return selectedTextStyle!.color!; // coverage:ignore-line
      }
      return selectedColor ?? context.tTheme.brandNormalColor;
    }();

    return Visibility(
      visible: icon != null,
      child: Padding(
        padding: const EdgeInsets.only(right: 2),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }

  Widget renderLabel(BuildContext context) {
    return TText(
      label,
      style: selectedTextStyle,
      fontWeight: selected && !disabled ? FontWeight.w600 : FontWeight.w400,
      textColor: disabled
          ? context.tTheme.textDisabledColor
          : selected
              ? selectedColor ?? context.tTheme.brandNormalColor
              : unSelectedColor ?? context.tTheme.textColorPrimary,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
