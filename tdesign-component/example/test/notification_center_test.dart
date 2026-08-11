import 'package:flutter_test/flutter_test.dart';

import 'package:tdesign_flutter_example/base/notification_center.dart';

void main() {
  group('TNotification (example)', () {
    setUp(() {
      // TNotification 的静态状态在多个测试间共享，必须重置以避免观察者泄漏和顺序依赖。
      TNotification.reset();
    });

    test('observerId 唯一：相同事件下多个观察者互不覆盖', () {
      var called1 = <dynamic>[];
      var called2 = <dynamic>[];
      final id1 = TNotification.addObserver('evt', (a) => called1.add(a));
      final id2 = TNotification.addObserver('evt', (a) => called2.add(a));

      // 不同观察者的 observerId 必须不同
      expect(id1, isNot(id2));

      TNotification.postNotification('evt', 'x');
      expect(called1, ['x']);
      expect(called2, ['x']);
    });

    test('removeObserver 后不再触发回调', () {
      var called = 0;
      final id = TNotification.addObserver('evt', (_) => called++);

      TNotification.postNotification('evt', null);
      expect(called, 1);

      TNotification.removeObserver('evt', id);
      TNotification.postNotification('evt', null);
      expect(called, 1);
    });

    test('removeObserver(null) 安全不报错', () {
      // 不应抛异常
      TNotification.removeObserver('evt', null);
    });

    test('不同事件的观察者互不影响', () {
      var calledA = 0;
      var calledB = 0;
      final idA = TNotification.addObserver('evtA', (_) => calledA++);
      final idB = TNotification.addObserver('evtB', (_) => calledB++);

      TNotification.postNotification('evtA', null);
      expect(calledA, 1);
      expect(calledB, 0);

      TNotification.postNotification('evtB', null);
      expect(calledA, 1);
      expect(calledB, 1);

      // 删除 evtA 的订阅不影响 evtB
      TNotification.removeObserver('evtA', idA);
      TNotification.postNotification('evtB', null);
      expect(calledB, 2);

      TNotification.removeObserver('evtB', idB);
    });

    test('空事件名不注册、不触发', () {
      final id = TNotification.addObserver('', (_) {});
      expect(id, '');

      // 不应抛异常
      TNotification.postNotification('', null);
    });

    test('某个观察者抛异常不影响其他观察者', () {
      var okCalled = 0;
      TNotification.addObserver('evt', (_) => throw StateError('boom'));
      TNotification.addObserver('evt', (_) => okCalled++);

      // 不应因异常中断后续观察者
      TNotification.postNotification('evt', null);
      expect(okCalled, 1);
    });
  });
}
