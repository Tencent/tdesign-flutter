import 'package:flutter/cupertino.dart';

import 't_dropdown_menu.dart';
import 't_dropdown_popup.dart';

/// 下拉菜单的 InheritedWidget，用于向子树传递弹出状态和方向
class TDropdownInherited<T> extends InheritedWidget {
  const TDropdownInherited({required Widget child, required this.popupState, required this.directionListenable, Key? key})
      : super(child: child, key: key);

  /// 下拉弹出状态
  final TDropdownPopup<T> popupState;

  /// 方向监听器
  final ValueNotifier<TDropdownMenuDirection> directionListenable;

  @override
  bool updateShouldNotify(covariant TDropdownInherited<T> oldWidget) {
    return true;
  }

  /// 获取最近的 [TDropdownInherited] 实例
  static TDropdownInherited<T>? of<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TDropdownInherited<T>>();
  }
}
