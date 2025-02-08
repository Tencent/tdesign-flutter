import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

class TDPopover {

  static Future showPopover({
    required BuildContext context,
    String? content,
    Widget? contentWidget,
    double offset = 4,
    TDPopoverTheme? theme,
    bool closeOnClickOutside = true,
    TDPopoverPlacement? placement,
    bool? showArrow = true,
    double arrowSize = 8,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
    Color? overlayColor = Colors.transparent,
    OnTap? onTap,
    OnLongTap? onLongTap,
  }) {
    return showDialog(
      barrierDismissible: closeOnClickOutside,
      barrierColor: overlayColor,
      useSafeArea: false,
      context: context,
      builder: (ctx) => TDPopoverWidget(
        context: context,
        content: content,
        contentWidget: contentWidget,
        offset: offset,
        theme: theme,
        placement: placement,
        showArrow: showArrow,
        arrowSize: arrowSize,
        padding: padding,
        width: width,
        height: height,
        onTap: onTap,
        onLongTap: onLongTap,
      ),
    );
  }
}