import 'package:flutter/material.dart';

import 't_popover_theme_data.dart';
import 't_popover_widget.dart';

/// 气泡弹层
///
/// 通过 [showPopover] 静态方法弹出，支持 12 个方向定位和箭头。
class TPopover {
  /// 显示气泡弹层
  static Future showPopover({
    required BuildContext context,
    String? content,
    Widget? contentWidget,

    /// 弹层与触发元素的间距。
    double? offset,

    /// 气泡语义色。
    TPopoverColorScheme? colorScheme,

    /// 点击气泡外部区域时是否关闭弹层。
    bool closeOnClickOutside = true,
    TPopoverPlacement? placement,

    /// 是否显示气泡箭头。
    bool? showArrow,

    /// 箭头尺寸。
    double? arrowSize,

    /// 内容内边距。
    EdgeInsetsGeometry? padding,

    /// 内容宽度。
    double? width,

    /// 内容高度。
    double? height,

    /// 蒙层颜色。
    Color? overlayColor,
    TPopoverTapCallback? onTap,
    TPopoverLongPressCallback? onLongTap,

    /// 气泡圆角。
    BorderRadius? radius,
  }) {
    final theme = Theme.of(context).extension<TPopoverThemeData>() ??
        const TPopoverThemeData();
    return showDialog(
      barrierDismissible: closeOnClickOutside,
      barrierColor: overlayColor ?? theme.barrierColor ?? Colors.transparent,
      useSafeArea: false,
      context: context,
      builder: (ctx) => TPopoverWidget(
        context: context,
        content: content,
        contentWidget: contentWidget,
        offset: offset ?? theme.offset,
        colorScheme: colorScheme ?? theme.colorScheme,
        placement: placement,
        showArrow: showArrow ?? theme.showArrow,
        arrowSize: arrowSize ?? theme.arrowSize,
        padding: padding ?? theme.padding,
        width: width ?? theme.minWidth,
        height: height ?? theme.maxHeight,
        onTap: onTap,
        onLongTap: onLongTap,
        radius: radius ??
            (theme.borderRadius == null
                ? null
                : BorderRadius.circular(theme.borderRadius!)),
      ),
    );
  }
}
