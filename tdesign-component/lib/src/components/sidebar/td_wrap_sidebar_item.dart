import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

class TDWrapSideBarItem extends StatelessWidget {
  const TDWrapSideBarItem({
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

  final TDBadge? badge;
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
  final TDSideBarStyle style;

  static const preLineWidth = 3.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: style == TDSideBarStyle.normal
          ? renderNormalItem(context)
          : renderOutlineItem(context),
    );
  }

  Widget renderNormalItem(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selectedBgColor ?? TDTheme.of(context).bgColorContainer,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? selectedBgColor ?? TDTheme.of(context).bgColorContainer
              : unSelectedBgColor ??
                  TDTheme.of(context).bgColorSecondaryContainer,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(
                topAdjacent ? TDTheme.of(context).radiusLarge : 0),
            bottomRight: Radius.circular(
                bottomAdjacent ? TDTheme.of(context).radiusLarge : 0),
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
              color: TDTheme.of(context).bgColorSecondaryContainer),
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
                color: selected && !disabled
                    ? TDTheme.of(context).bgColorContainer
                    : null,
                borderRadius:
                    BorderRadius.circular(TDTheme.of(context).radiusDefault)),
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
        if (label.length > 4) renderBadge(context),
        // SizedBox(
        //   width: !disabled && selected ? 0 : preLineWidth,
        // )
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
                    : (selectedColor ?? TDTheme.of(context).brandNormalColor),
                borderRadius: BorderRadius.circular(4)),
          )
        ],
      ),
    );
  }

  Widget renderIcon(BuildContext context) {
    final iconColor = () {
      if (disabled) {
        return TDTheme.of(context).textDisabledColor;
      }
      if (!selected) {
        return unSelectedColor ?? TDTheme.of(context).textColorPrimary;
      }
      if (selectedTextStyle?.color != null) {
        return selectedTextStyle!.color!;
      }
      return selectedColor ?? TDTheme.of(context).brandNormalColor;
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
    return TDText.rich(
      TextSpan(
        children: [
          WidgetSpan(
              child: TDText(
            label,
            style: selected
                ? (selectedTextStyle ?? TextStyle(color: selectedColor))
                : textStyle,
            fontWeight:
                selected && !disabled ? FontWeight.w600 : FontWeight.w400,
            textColor: disabled
                ? TDTheme.of(context).textDisabledColor
                : selected
                    ? selectedColor ?? TDTheme.of(context).brandNormalColor
                    : unSelectedColor ?? TDTheme.of(context).textColorPrimary,
            // forceVerticalCenter: true,
          )),

          /// todo label.length 长度小于则不展示，为什么？？？
          /// 应再判断有无icon，无icon时位置够，可以展示 badge
          if (label.length <= 4 || icon == null)
            WidgetSpan(
                child: SizedBox(
              width: 1,
              height: 16,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  badge != null
                      ? Positioned(top: -6, child: badge!)
                      : Container()
                ],
              ),
            ))
        ],
      ),
      softWrap: true,
      style: selectedTextStyle,
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
