import 'package:flutter/cupertino.dart';

/// 倒计时组件控制器转态
enum TDCountDownStatus {
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
class TDCountDownController extends ValueNotifier<TDCountDownStatus> {
  TDCountDownController() : super(TDCountDownStatus.idle);

  int? _time;

  int? get time => _time;

  /// 开始
  void start() {
    value = TDCountDownStatus.start;
  }

  /// 暂停
  void pause() {
    value = TDCountDownStatus.pause;
  }

  /// 继续
  void resume() {
    value = TDCountDownStatus.resume;
  }

  /// 重置
  void reset([int? time]) {
    if (value == TDCountDownStatus.reset && _time != time) {
       _time = time;
      notifyListeners();
    } else {
      _time = time;
      value = TDCountDownStatus.reset;
    }
  }
}
