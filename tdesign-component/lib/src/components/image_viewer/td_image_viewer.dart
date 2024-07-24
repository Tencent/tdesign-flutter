import 'package:flutter/material.dart';

import '../../theme/td_colors.dart';
import '../../theme/td_theme.dart';
import '../popup/td_popup_route.dart';
import 'td_image_viewer_widget.dart';

/// 图片预览工具
class TDImageViewer {

  /// 显示图片预览
  static void showImageViewer({
    required BuildContext context,
    required List<dynamic> images,
    bool? closeBtn = true,
    bool? deleteBtn = false,
    bool? showIndex = false,
    int? defaultIndex,
    double? width,
    double? height,
    OnIndexChange? onIndexChange,
    OnClose? onClose,
    OnDelete? onDelete,
    OnLongPress? onLongPress,
  }) {
    var modalBarrierColor = TDTheme.of(context).fontGyColor1;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: modalBarrierColor,
      useSafeArea: false,
      builder: (context) {
        return TDImageViewerWidget(
          images: images,
          closeBtn: closeBtn,
          deleteBtn: deleteBtn,
          showIndex: showIndex,
          defaultIndex: defaultIndex,
          onIndexChange: onIndexChange,
          width: width,
          height: height,
          onClose: onClose,
          onDelete: onDelete,
          onLongPress: onLongPress,
        );
      },
    );
  }
}
