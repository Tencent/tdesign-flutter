
import 'package:flutter/material.dart';

import 'td_popover_style.dart';
import 'td_popover_widget.dart';

class TDPopover {

  static Future showPopover({
    required BuildContext context,
    required String content,
    double? offset = 10,
    TDPopoverTheme? theme,
  }) {
    return showDialog(
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      context: context,
      builder: (ctx) => TDPopoverWidget(
        context: context,
        content: content,
        offset: offset,
        theme: theme,
      ),
    );
  }
}