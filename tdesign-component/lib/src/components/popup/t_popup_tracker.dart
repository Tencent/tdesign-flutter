import 'package:flutter/material.dart';

import 't_popup.dart';

/// 按 Navigator 追踪当前展示的 [TPopupHandle] 栈。
class TPopupTracker {
  TPopupTracker._();

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
