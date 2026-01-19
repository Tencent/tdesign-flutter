import 'dart:collection';

typedef Observer = void Function(dynamic arguments);

/// 广播工具
///
///
/// todo bug
/// flutter: TNotification postNotificationCallHandler onApiVisibleChange_165563855 error: setState() called after dispose(): _CodeWrapperState#1423d(lifecycle state: defunct, not mounted)
/// This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree (e.g., whose parent widget no longer includes the widget in its build). This error can occur when code calls setState() from a timer or an animation callback.
/// The preferred solution is to cancel the timer or stop listening to the animation in the dispose() callback. Another solution is to check the "mounted" property of this object before calling setState() to ensure the object is still in the tree.
/// This error might indicate a memory leak if setState() is being called because another object is retaining a reference to this State object after it has been removed from the tree. To avoid memory leaks, consider breaking the reference to this object during dispose().
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
