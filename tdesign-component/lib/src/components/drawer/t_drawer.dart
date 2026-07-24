import 'package:flutter/material.dart';

import '../popup/t_popup.dart';
import 't_drawer_theme_data.dart';
import 't_drawer_widget.dart';

/// 抽屉方向
enum TDrawerPlacement {
  /// 从左侧滑出
  left,

  /// 从右侧滑出
  right,
}

/// 抽屉组件
class TDrawer {
  TDrawer(
    this.context, {
    this.closeOnOverlayClick = true,
    this.footer,
    this.items,
    this.placement = TDrawerPlacement.right,
    this.showOverlay = true,
    this.title,
    this.onClose,
    this.onItemClick,
    this.width,
    this.drawerTop,
    this.child,
  });

  /// 上下文
  final BuildContext context;

  /// 点击蒙层时是否关闭抽屉
  final bool? closeOnOverlayClick;

  /// 抽屉的底部
  final Widget? footer;

  /// 抽屉里的列表项
  final List<TDrawerItem>? items;

  /// 自定义内容，优先级高于[items]/[footer]/[title]
  final Widget? child;

  /// 抽屉方向
  final TDrawerPlacement? placement;

  /// 是否显示遮罩层
  final bool? showOverlay;

  /// 抽屉的标题组件
  final Widget? title;

  /// 关闭时触发
  final VoidCallback? onClose;

  /// 点击抽屉里的列表项触发
  final TDrawerItemClickCallback? onItemClick;

  /// 宽度（优先级高于 ThemeData）
  final double? width;

  /// 距离顶部的距离
  final double? drawerTop;

  TPopupHandle? _drawerHandle;

  /// 从 ThemeData 解析有效值
  TDrawerThemeData _resolveTheme() {
    final theme = Theme.of(context).extension<TDrawerThemeData>() ??
        const TDrawerThemeData();
    return theme;
  }

  TDrawerHandle show() {
    if (_drawerHandle?.isShowing == true) {
      return TDrawerHandle._(_drawerHandle);
    }

    final theme = _resolveTheme();
    final overlayEnabled = showOverlay ?? true;
    final dismissible = overlayEnabled && (closeOnOverlayClick ?? true);
    final popupPlacement = placement == TDrawerPlacement.right
        ? TPopupPlacement.right
        : TPopupPlacement.left;
    final popupInset = placement == TDrawerPlacement.right
        ? TPopupRightInset(top: drawerTop ?? theme.drawerTop ?? 0)
        : TPopupLeftInset(top: drawerTop ?? theme.drawerTop ?? 0);

    _drawerHandle = TPopup.show(
      context,
      options: TPopupOptions(
        placement: popupPlacement,
        width: width ?? theme.width ?? 280,
        inset: popupInset,
        showOverlay: overlayEnabled,
        closeOnOverlayClick: dismissible,
        overlayColor: overlayEnabled ? null : Colors.transparent,
        useSafeArea: false,
        onClosed: _deleteRouter,
        child: TDrawerWidget(
          footer: footer,
          items: items,
          child: child,
          title: title,
          onItemClick: onItemClick,
          width: width ?? theme.width ?? 280,
          style: theme.style,
          hover: theme.hover ?? true,
          backgroundColor: theme.backgroundColor,
          bordered: theme.bordered ?? true,
          isShowLastBordered: theme.isShowLastBordered ?? true,
        ),
      ),
    );
    return TDrawerHandle._(_drawerHandle);
  }

  void _deleteRouter() {
    _drawerHandle = null;
    onClose?.call();
  }
}

class TDrawerHandle {
  const TDrawerHandle._(this._handle);

  final TPopupHandle? _handle;

  bool get isShowing => _handle?.isShowing ?? false;

  void close() {
    _handle?.close();
  }
}
