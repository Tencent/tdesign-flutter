import 'package:flutter/cupertino.dart';

/// 计时组件控制器转态
enum TTimeCounterStatus {
  /// 开始
  start,

  /// 暂停
  pause,

  /// 继续
  resume,

  /// 重置
  reset,

  /// 空，默认值
  idle,
}

/// 倒计时组件控制器，可控制开始(`start()`)/暂停(`pause()`)/继续(`resume()`)/重置(`reset([int? time])`)
class TTimeCounterController extends ValueNotifier<TTimeCounterStatus> {
  TTimeCounterController() : super(TTimeCounterStatus.idle);

  int? _time;

  int? get time => _time;

  /// 开始
  void start() {
    value = TTimeCounterStatus.start;
  }

  /// 暂停
  void pause() {
    value = TTimeCounterStatus.pause;
  }

  /// 继续
  void resume() {
    value = TTimeCounterStatus.resume;
  }

  /// 重置
  void reset([int? time]) {
    if (value == TTimeCounterStatus.reset) {
       _time = time;
      notifyListeners();
    } else {
      _time = time;
      value = TTimeCounterStatus.reset;
    }
  }
}
