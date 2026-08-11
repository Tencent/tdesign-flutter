import 'dart:collection';

import 'package:flutter/foundation.dart';

typedef Observer = void Function(dynamic arguments);

/// 广播工具
///
/// TODO(#996): Prevent callbacks from reaching disposed State objects.
///
/// flutter: TNotification postNotificationCallHandler onApiVisibleChange_165563855 error: setState() called after dispose(): _CodeWrapperState#1423d(lifecycle state: defunct, not mounted)
/// This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree (e.g., whose parent widget no longer includes the widget in its build). This error can occur when code calls setState() from a timer or an animation callback.
/// The preferred solution is to cancel the timer or stop listening to the animation in the dispose() callback. Another solution is to check the "mounted" property of this object before calling setState() to ensure the object is still in the tree.
/// This error might indicate a memory leak if setState() is being called because another object is retaining a reference to this State object after it has been removed from the tree. To avoid memory leaks, consider breaking the reference to this object during dispose().
///
/// ## 使用契约
///
/// 订阅方必须在 `dispose()` 中调用 [removeObserver] 解除订阅，否则通知中心会长期持有回调
/// 引用，导致内存泄漏，并可能在页面销毁后再次触发回调（`setState() called after dispose()`）。
///
/// 推荐用法：
/// ```dart
/// class _ExampleState extends State<Example> {
///   String? _observerId;
///
///   @override
///   void initState() {
///     super.initState();
///     _observerId = TNotification.addObserver('eventName', (arguments) {
///       if (mounted) {
///         setState(() { /* ... */ });
///       }
///     });
///   }
///
///   @override
///   void dispose() {
///     TNotification.removeObserver('eventName', _observerId);
///     super.dispose();
///   }
/// }
/// ```
class TNotification {
  static final Map<String, Map<String, Observer>> _eventMap = HashMap();

  /// 全局自增序号，用于生成全局唯一的 observerId。
  ///
  /// 不能直接依赖 `observer.hashCode`：Dart 的 hashCode 不保证唯一，对象被 GC 后哈希
  /// 还可能被新对象复用，会导致同一事件下不同观察者相互覆盖，或 removeObserver 误删
  /// 他人的订阅。使用自增序号可彻底规避该风险。
  static int _observerSeq = 0;

  /// 注册观察者，返回可用于 [removeObserver] 的唯一 ID。
  ///
  /// 返回空字符串表示注册失败（eventName 为空）。
  static String addObserver(String eventName, Observer observer) {
    if (eventName.isEmpty) {
      return '';
    }
    var observerMap = _eventMap[eventName];
    observerMap ??= HashMap<String, Observer>();
    var observerId = '${eventName}_${_observerSeq++}';
    observerMap[observerId] = observer;
    _eventMap[eventName] = observerMap;
    return observerId;
  }

  static void removeObserver(String eventName, String? observerId) {
    if (observerId == null) {
      return;
    }
    if (eventName.isNotEmpty) {
      var listenerMap = _eventMap[eventName];
      listenerMap?.remove(observerId);
      if ((listenerMap?.length ?? 0) <= 0) {
        _eventMap.remove(eventName);
      }
    }
  }

  static void postNotification(String eventName, dynamic arguments) {
    if (eventName.isNotEmpty) {
      var handlerArguments = {
        'eventName': eventName,
        'argumentsObj': arguments
      };
      _postNotificationCallHandler(handlerArguments);
    }
  }

  static void _postNotificationCallHandler(arguments) {
    var eventName = arguments['eventName'];
    var observerMap = _eventMap[eventName];
    // 先取快照再遍历，避免回调中修改 _eventMap 造成 ConcurrentModificationError。
    if (observerMap == null || observerMap.isEmpty) {
      return;
    }
    final snapshot = Map<String, Observer>.from(observerMap);
    snapshot.forEach((key, observer) {
      try {
        observer(arguments['argumentsObj']);
      } catch (e) {
        debugPrint('TNotification postNotificationCallHandler $key error: $e');
      }
    });
  }
}
