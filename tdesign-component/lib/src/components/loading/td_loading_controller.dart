import 'package:flutter/material.dart';
import 'td_loading.dart';

class TDLoadingController {
  static BuildContext? _context;
  static OverlayEntry? _overlayEntry;

  static bool _isShowing = false;

  // 展示
  static void show(BuildContext context,
      {Widget? child,
      TDLoadingSize size = TDLoadingSize.medium,
      TDLoadingIcon? icon = TDLoadingIcon.circle,
      Color? iconColor,
      String text = '加载中',
      Widget? refreshWidget,
      Color textColor = Colors.black,
      Axis axis = Axis.vertical,
      Widget? customIcon,
      int duration = 2000}) {

    if (_isShowing) {
      print('warn: TDLoading is showing!');
      return;
    }

    _overlayEntry = OverlayEntry(builder: (context) {
      return Center(
        child: child ??
            TDLoading(
              size: size,
              icon: icon,
              customIcon: customIcon,
              text: text,
              textColor: textColor,
              refreshWidget: refreshWidget,
              duration: duration,
              iconColor: iconColor,
              axis: axis,
            ),
      );
    });

    _context = context;
    if (_context == null || _overlayEntry == null) {
      print('error: TDLoading is not init!:${_context} ${_overlayEntry}');
      return;
    }
    _isShowing = true;
    Overlay.of(_context!).insert(_overlayEntry!);
  }

  // 消失
  static void dismiss() {
    if (_isShowing) {
     if (_overlayEntry != null && _overlayEntry!.mounted) {
       _overlayEntry?.remove();
       _overlayEntry = null;
     }
      _isShowing = false;
    }
  }
}
