import 'dart:collection';

typedef Observer = void Function(dynamic arguments);

/// 广播工具
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
        print('TNotification postNotificationCallHandler $key error: $e');
      }
    });
  }
}
