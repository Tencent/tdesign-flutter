import 'package:flutter/cupertino.dart';

/// 计时组件控制器转态
enum TDTimeCounterStatus {
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
class TDTimeCounterController extends ValueNotifier<TDTimeCounterStatus> {
  TDTimeCounterController() : super(TDTimeCounterStatus.idle);

  int? _time;

  int? get time => _time;

  /// 开始
  void start() {
    value = TDTimeCounterStatus.start;
  }

  /// 暂停
  void pause() {
    value = TDTimeCounterStatus.pause;
  }

  /// 继续
  void resume() {
    value = TDTimeCounterStatus.resume;
  }

  /// 重置
  void reset([int? time]) {
    if (value == TDTimeCounterStatus.reset) {
       _time = time;
      notifyListeners();
    } else {
      _time = time;
      value = TDTimeCounterStatus.reset;
    }
  }
}
