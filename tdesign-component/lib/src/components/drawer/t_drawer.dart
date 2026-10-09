import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../popup/t_popup.dart';
import '../text/t_text.dart';
import '../text/t_text_styled.dart';
import '../text/t_text_theme_data.dart';
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
///
/// ### 主题配置
///
/// 组件主题通过 [TDrawerThemeData] 配置，放入 Flutter [ThemeData.extensions]
/// 后作用于对应子树。字段含义、未配置时的回退及复制/过渡行为见本页的
/// `TDrawerThemeData` 说明。
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
    this.child,
  });

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
/// [topInset] 设置抽屉相对屏幕顶部的可选偏移，默认 0，必须大于或等于 0。
/// [useSafeArea] 控制浮层是否避让系统安全区域，默认 true。
/// [destroyOnClose] 默认 false；为 true 时路由 maintainState 为 false，
/// 被其他不透明路由覆盖时可释放内容 State。关闭路由后内容始终会释放。
/// [onClose] 在抽屉浮层关闭后触发。
///
/// 返回的 [TDrawerHandle] 可用于查询显示状态或主动关闭抽屉。
///
/// ## 返回值
/// 已经发起打开的抽屉控制句柄，可用于查询状态与关闭抽屉。
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
      width: theme.width ?? 280,
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
