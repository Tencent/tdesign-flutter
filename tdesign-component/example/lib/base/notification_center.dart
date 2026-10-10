import 'dart:collection';

import 'package:flutter/foundation.dart';

typedef Observer = void Function(dynamic arguments);

/// 示例页面中的同步事件广播。
///
/// 调用方持有 [addObserver] 返回的标识，并在 dispose 中调用 [removeObserver]。
/// 涉及 State 的回调还应检查 mounted，避免向已卸载的页面更新状态。
class TNotification {
  static final Map<String, Map<String, Observer>> _eventMap = HashMap();

  static String addObserver(String eventName, Observer observer) {
    if (eventName.isNotEmpty) {
      var observerMap = _eventMap[eventName];
      observerMap ??= HashMap<String, Observer>();
      var observerId = '${eventName}_${observer.hashCode}';
      observerMap[observerId] = observer;
      _eventMap[eventName] = observerMap;
      return observerId;
    }
    return '';
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
        'eventName':eventName,
        'argumentsObj':arguments
      };
      _postNotificationCallHandler(handlerArguments);
    }
  }

  static void _postNotificationCallHandler(arguments) {

    var observerMap = _eventMap[arguments['eventName']];
    observerMap?.forEach((key, observer) {
      try {
        observer(arguments['argumentsObj']);
      } catch (e) {
        debugPrint('TNotification postNotificationCallHandler $key error: $e');
      }
    });
  }
}
