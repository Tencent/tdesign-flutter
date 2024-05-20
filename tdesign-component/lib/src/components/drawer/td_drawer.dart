import 'package:flutter/material.dart';

import '../popup/td_popup_route.dart';

typedef TDDrawerItemClickCallback = void Function(int index, TDDrawerItem item);

/// 抽屉方向
enum TDDrawerPlacement { left, right }

/// 抽屉组件
class TDDrawer {
  TDDrawer(
    this.context, {
    this.closeOnOverlayClick,
    this.footer,
    this.items,
    this.placement,
    this.showOverlay,
    this.title,
    this.visible,
    this.onClose,
    this.onItemClick,
  }) {
    if (visible == true) {
      show();
    }
  }

  /// 上下文
  final BuildContext context;

  /// 点击蒙层时是否关闭抽屉
  final bool? closeOnOverlayClick;

  /// 抽屉的底部
  final Widget? footer;

  /// 抽屉里的列表项
  final List<TDDrawerItem>? items;

  /// 抽屉方向
  final TDDrawerPlacement? placement;

  /// 是否显示遮罩层
  final bool? showOverlay;

  /// 抽屉的标题
  final Widget? title;

  /// 组件是否可见
  final bool? visible;

  /// 关闭时触发
  final VoidCallback? onClose;

  /// 点击抽屉里的列表项触发
  final TDDrawerItemClickCallback? onItemClick;

  static TDSlidePopupRoute? _drawerRoute;

  void show() {
    if (_drawerRoute != null) {
      return; // 如果抽屉已经显示了，就不要再显示
    }
    _drawerRoute = TDSlidePopupRoute(
      slideTransitionFrom: (placement ?? TDDrawerPlacement.right) == TDDrawerPlacement.right
          ? SlideTransitionFrom.right
          : SlideTransitionFrom.left,
      isDismissible: (showOverlay ?? true) ? (closeOnOverlayClick ?? true) : false,
      modalBarrierColor: (showOverlay ?? true) ? null : Colors.transparent,
      builder: (context) {
        return Container(
          color: Colors.white,
          width: 280,
        );
      },
    );
    Navigator.of(context).push(_drawerRoute!).then((_) {
      // 当抽屉关闭时，将_drawerRoute置为null
      _deleteRouter();
    });
  }

  @mustCallSuper
  void close() {
    if (_drawerRoute != null) {
      Navigator.of(context).removeRoute(_drawerRoute!);
      _deleteRouter();
    }
  }

  void _deleteRouter() {
    _drawerRoute = null;
    if (onClose != null) {
      onClose!();
    }
  }
}

/// 抽屉里的列表项
class TDDrawerItem {
  TDDrawerItem({required this.title, this.icon, this.content});

  /// 每列标题
  final String title;

  /// 每列图标
  final Widget? icon;

  /// 完全自定义
  final Widget? content;
}
