import 'package:flutter/material.dart';

import '../popup/td_popup_route.dart';

typedef TDDrawerItemClickCallback = void Function(int index, TDDrawerItem item);

/// 抽屉方向
enum TDDrawerPlacement { left, right }

/// 抽屉组件
class TDDrawer extends StatefulWidget {
  const TDDrawer({
    Key? key,
    this.closeOnOverlayClick,
    this.footer,
    this.items,
    this.placement,
    this.showOverlay,
    this.title,
    this.visible,
    this.onClose,
    this.onItemClick,
  }) : super(key: key);

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

  @override
  _TDDrawerState createState() => _TDDrawerState();
}

class _TDDrawerState extends State<TDDrawer> {
  // 定义一个变量用来存储当前抽屉的路由
  TDSlidePopupRoute? _drawerRoute;

  // 显示抽屉
  void _showDrawer() {
    if (_drawerRoute != null) {
      return; // 如果抽屉已经显示了，就不要再显示
    }

    _drawerRoute = TDSlidePopupRoute(
      slideTransitionFrom: SlideTransitionFrom.left,
      builder: (context) {
        return Container(
          color: Colors.white,
          width: 280,
        );
      },
    );

    Navigator.of(context).push(_drawerRoute!).then((_) {
      // 当抽屉关闭时，将_drawerRoute置为null
      _drawerRoute = null;
    });
  }

  // 隐藏抽屉
  void _hideDrawer() {
    if (_drawerRoute != null) {
      Navigator.of(context).removeRoute(_drawerRoute!);
      _drawerRoute = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.visible ?? false) {
      _showDrawer();
    } else {
      _hideDrawer();
    }

    return const SizedBox.shrink();
  }
}

/// 抽屉里的列表项
class TDDrawerItem {
  TDDrawerItem({required this.title, this.icon});

  /// 每列标题
  final String title;

  /// 每列图标
  final Widget? icon;
}
