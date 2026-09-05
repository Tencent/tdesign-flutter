import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../popup/t_popup.dart';
import '../text/t_text.dart';
import 't_drawer_theme_data.dart';

part 't_drawer_content.dart';

/// 抽屉方向。
enum TDrawerPlacement {
  /// 从左侧滑出。
  left,

  /// 从右侧滑出。
  right,
}

/// TDesign 抽屉内容组件，可放入 [Scaffold.drawer] 或 [Scaffold.endDrawer]。
///
/// 需要通过浮层展示时，使用 [showTDrawer]。
class TDrawer extends StatelessWidget {
  const TDrawer({
    super.key,
    this.showDivider = true,
    this.footer,
    this.items,
    this.enableFeedback = true,
    this.showLastDivider = true,
    this.title,
    this.onItemClick,
    this.width,
    this.child,
    this.backgroundColor,
  }) : assert(width == null || width > 0);

  /// 是否显示菜单项分隔线，默认 true。
  final bool showDivider;

  /// 抽屉的底部
  final Widget? footer;

  /// 抽屉里的列表项
  final List<TDrawerItem>? items;

  /// 点击时是否显示背景按压反馈，默认 true。
  final bool enableFeedback;

  /// 是否显示最后一行分隔线，默认 true。
  final bool showLastDivider;

  /// 自定义内容，优先级高于[items]/[footer]/[title]
  final Widget? child;

  /// 抽屉的标题组件
  final Widget? title;

  /// 点击抽屉里的列表项触发
  final TDrawerItemClickCallback? onItemClick;

  /// 宽度；优先级高于 ThemeData，默认使用 280。
  final double? width;

  /// 组件背景颜色；优先级高于 ThemeData 和默认值。
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return _TDrawerContent(
      showDivider: showDivider,
      enableFeedback: enableFeedback,
      footer: footer,
      items: items,
      showLastDivider: showLastDivider,
      child: child,
      title: title,
      onItemClick: onItemClick,
      width: width,
      backgroundColor: backgroundColor,
    );
  }
}

/// 通过 Popup 展示一个 [TDrawer]。
///
/// [drawer] 只描述抽屉内容；方向、蒙层、顶部偏移和生命周期由本函数负责。
/// [context] 用于查找承载抽屉浮层的 Navigator。
/// [placement] 控制抽屉从左侧或右侧滑出，默认从右侧滑出。
/// [showOverlay] 控制是否显示蒙层，默认 true。
/// [closeOnOverlayClick] 控制点击蒙层时是否关闭抽屉，默认 true。
/// [onOverlayClick] 在蒙层被点击时触发，不受是否自动关闭影响。
/// [topInset] 设置抽屉相对屏幕顶部的可选偏移，默认 0。
/// [useSafeArea] 控制浮层是否避让系统安全区域，默认 true。
/// [destroyOnClose] 控制关闭后是否立即销毁浮层路由，默认 false。
/// [onClose] 在抽屉浮层关闭后触发。
///
/// 返回的 [TDrawerHandle] 可用于查询显示状态或主动关闭抽屉。
TDrawerHandle showTDrawer(
  BuildContext context, {
  required TDrawer drawer,
  TDrawerPlacement placement = TDrawerPlacement.right,
  bool showOverlay = true,
  bool closeOnOverlayClick = true,
  VoidCallback? onOverlayClick,
  double? topInset,
  bool useSafeArea = true,
  bool destroyOnClose = false,
  VoidCallback? onClose,
}) {
  assert(topInset == null || topInset >= 0);
  final theme =
      Theme.of(context).extension<TDrawerThemeData>() ??
      const TDrawerThemeData();
  final popupPlacement = placement == TDrawerPlacement.right
      ? TPopupPlacement.right
      : TPopupPlacement.left;
  final popupInset = placement == TDrawerPlacement.right
      ? TPopupRightInset(top: topInset ?? 0)
      : TPopupLeftInset(top: topInset ?? 0);
  final handle = TPopup.show(
    context,
    options: TPopupOptions(
      placement: popupPlacement,
      width: drawer.width ?? theme.width ?? 280,
      inset: popupInset,
      overlay: TPopupOverlayConfig(
        showOverlay: showOverlay,
        closeOnClick: closeOnOverlayClick,
        color: showOverlay ? null : Colors.transparent,
        onClick: onOverlayClick,
      ),
      destroyOnClose: destroyOnClose,
      useSafeArea: useSafeArea,
      onClosed: onClose,
      child: Theme(data: Theme.of(context), child: drawer),
    ),
  );
  return TDrawerHandle._(handle);
}

/// [showTDrawer] 返回的抽屉生命周期控制句柄。
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
