part of 't_popup.dart';

/// 按 Navigator 追踪已打开的 [TPopupHandle] 栈，供 [TPopup.close] 查找栈顶。
abstract class TPopupTracker {
  static final Map<NavigatorState, List<TPopupHandle>> _stacks = {};

  static void push(NavigatorState navigator, TPopupHandle handle) {
    _stacks.putIfAbsent(navigator, () => []).add(handle);
  }

  static void remove(NavigatorState navigator, TPopupHandle handle) {
    _stacks[navigator]?.remove(handle);
    if (_stacks[navigator]?.isEmpty ?? false) {
      _stacks.remove(navigator);
    }
  }

  static TPopupHandle? top(NavigatorState navigator) {
    final stack = _stacks[navigator];
    if (stack == null || stack.isEmpty) {
      return null;
    }
    return stack.last;
  }
}
