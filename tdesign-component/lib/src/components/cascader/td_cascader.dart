import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

class TDCascader {
  /// 显示多级选择器
  static void showMultiCascader(context,
      {String? title,
      required List<Map> data,
      List<int>? initialIndexes,
      String? theme,
      required onChange,
      Duration duration = const Duration(milliseconds: 100),
      Color? barrierColor,
      double cascaderHeight = 500,
      String? initialData,
      String? closeText,
        bool  isLetterSort=false,
      List<String>? subTitles,
      Function? onClose}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: barrierColor ?? TDTheme.of(context).fontGyColor2.withOpacity(0.6),
        builder: (context) {
          return TDMultiCascader(
              title: title,
              onClose: onClose,
              data: data,
              initialIndexes: initialIndexes,
              cascaderHeight: cascaderHeight,
              initialData: initialData,
              onChange: onChange,
              closeText: closeText,
              theme: theme,
              isLetterSort:isLetterSort,
              subTitles: subTitles);
        });
  }
}
