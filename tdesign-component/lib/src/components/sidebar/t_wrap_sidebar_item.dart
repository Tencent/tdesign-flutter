import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

class TWrapSideBarItem extends StatelessWidget {
  const TWrapSideBarItem({
    Key? key,
    this.badge,
    required this.disabled,
    this.icon,
    this.label = '',
    this.contentPadding,
    this.textStyle = const TextStyle(
      fontSize: 16,
      height: 1.5,
    ),
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
  final TSideBarStyle style;

  static const preLineWidth = 3.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: style == TSideBarStyle.normal
          ? renderNormalItem(context)
          : renderOutlineItem(context),
    );
  }

  Widget renderNormalItem(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selectedBgColor ?? TTheme.of(context).bgColorContainer,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? selectedBgColor ?? TTheme.of(context).bgColorContainer
              : unSelectedBgColor ??
                  TTheme.of(context).bgColorSecondaryContainer,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(
                topAdjacent ? TTheme.of(context).radiusLarge : 0),
            bottomRight: Radius.circular(
                bottomAdjacent ? TTheme.of(context).radiusLarge : 0),
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
          decoration: BoxDecoration(
              color: TTheme.of(context).bgColorSecondaryContainer),
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
                color: selected && !disabled
                    ? TTheme.of(context).bgColorContainer
                    : null,
                borderRadius:
                    BorderRadius.circular(TTheme.of(context).radiusDefault)),
            padding: const EdgeInsets.all(8),
            child: renderMainContent(context),
          ),
        ));
  }

  Widget renderMainContent(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        renderIcon(context),
        Expanded(child: renderLabel(context)),
        if (badge != null) renderBadge(context),
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
                    ? selectedTextStyle?.color
                    : (selectedColor ?? TTheme.of(context).brandNormalColor),
                borderRadius: BorderRadius.circular(4)),
          )
        ],
      ),
    );
  }

  Widget renderIcon(BuildContext context) {
    final iconColor = () {
      if (disabled) {
        return TTheme.of(context).textDisabledColor;
      }
      if (!selected) {
        return unSelectedColor ?? TTheme.of(context).textColorPrimary;
      }
      if (selectedTextStyle?.color != null) {
        return selectedTextStyle!.color!;
      }
      return selectedColor ?? TTheme.of(context).brandNormalColor;
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
      style: selected
          ? (selectedTextStyle ?? TextStyle(color: selectedColor))
          : textStyle,
      fontWeight: selected && !disabled ? FontWeight.w600 : FontWeight.w400,
      textColor: disabled
          ? TTheme.of(context).textDisabledColor
          : selected
              ? selectedColor ?? TTheme.of(context).brandNormalColor
              : unSelectedColor ?? TTheme.of(context).textColorPrimary,
      softWrap: true,
    );
  }

  Widget renderBadge(BuildContext context) {
    return SizedBox(
      width: 1,
      height: 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          badge != null ? Positioned(top: -6, child: badge!) : Container()
        ],
      ),
    );
  }
}
