import 'package:flutter/material.dart';

import '../popup/t_popup.dart';
import 't_drawer_theme_data.dart';
import 't_drawer_widget.dart';

/// 抽屉方向。
enum TDrawerPlacement {
  /// 从左侧滑出。
  left,

  /// 从右侧滑出。
  right,
}

/// 命令式抽屉组件。
///
/// 调用 [show] 打开抽屉，并使用返回的 [TDrawerHandle] 查询或关闭当前展示周期。
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
    this.onOverlayClick,
    this.onItemClick,
    this.width,
    this.drawerTop,
    this.useSafeArea = true,
    this.destroyOnClose = false,
    this.child,
  }) : assert(width == null || width > 0),
       assert(drawerTop == null || drawerTop >= 0);

  /// 上下文
  final BuildContext context;

  /// 点击可见蒙层时是否关闭抽屉，默认 true。
  final bool closeOnOverlayClick;

  /// 抽屉的底部
  final Widget? footer;

  /// 抽屉里的列表项
  final List<TDrawerItem>? items;

  /// 自定义内容，优先级高于[items]/[footer]/[title]
  final Widget? child;

  /// 抽屉方向，默认 [TDrawerPlacement.right]。
  final TDrawerPlacement placement;

  /// 是否显示可见遮罩层，默认 true。
  final bool showOverlay;

  /// 抽屉的标题组件
  final Widget? title;

  /// 当前展示周期真正结束时触发。
  final VoidCallback? onClose;

  /// 点击可见蒙层时触发。
  ///
  /// 是否同时关闭由 [closeOnOverlayClick] 决定。
  final VoidCallback? onOverlayClick;

  /// 点击抽屉里的列表项触发
  final TDrawerItemClickCallback? onItemClick;

  /// 宽度（优先级高于 ThemeData）
  final double? width;

  /// 距离顶部的距离
  final double? drawerTop;

  /// 是否避让系统安全区域
  final bool useSafeArea;

  /// 关闭后是否销毁 Popup 路由内状态，默认 false。
  final bool destroyOnClose;

  TPopupHandle? _drawerHandle;

  /// 从 ThemeData 解析有效值。
  TDrawerThemeData _resolveTheme() {
    final theme =
        Theme.of(context).extension<TDrawerThemeData>() ??
        const TDrawerThemeData();
    return theme;
  }

  TDrawerHandle show() {
    if (_drawerHandle?.isShowing == true) {
      return TDrawerHandle._(_drawerHandle);
    }

    final theme = _resolveTheme();
    final overlayEnabled = showOverlay;
    final popupPlacement = placement == TDrawerPlacement.right
        ? TPopupPlacement.right
        : TPopupPlacement.left;
    final popupInset = placement == TDrawerPlacement.right
        ? TPopupRightInset(top: drawerTop ?? 0)
        : TPopupLeftInset(top: drawerTop ?? 0);

    _drawerHandle = TPopup.show(
      context,
      options: TPopupOptions(
        placement: popupPlacement,
        width: width ?? theme.width ?? 280,
        inset: popupInset,
        overlay: TPopupOverlayConfig(
          showOverlay: overlayEnabled,
          closeOnClick: closeOnOverlayClick,
          color: overlayEnabled ? null : Colors.transparent,
          onClick: onOverlayClick,
        ),
        destroyOnClose: destroyOnClose,
        useSafeArea: useSafeArea,
        onClosed: _deleteRouter,
        child: Theme(
          data: Theme.of(context),
          child: TDrawerWidget(
            footer: footer,
            items: items,
            child: child,
            title: title,
            onItemClick: onItemClick,
            width: width,
          ),
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

/// [TDrawer.show] 返回的抽屉生命周期控制句柄。
class TDrawerHandle {
  const TDrawerHandle._(this._handle);

  final TPopupHandle? _handle;

  /// 当前抽屉是否仍显示在路由中。
  bool get isShowing => _handle?.isShowing ?? false;

  /// 关闭当前抽屉；重复调用安全。
  void close() {
    _handle?.close();
  }
}
