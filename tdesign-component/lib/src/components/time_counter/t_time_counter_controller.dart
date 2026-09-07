import 'package:flutter/cupertino.dart';

/// 计时组件控制器状态。
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

/// 计时组件控制器，可控制开始、暂停、继续和重置。
///
/// Controller 由调用方创建并负责释放。
class TTimeCounterController extends ValueNotifier<TTimeCounterStatus> {
  TTimeCounterController() : super(TTimeCounterStatus.idle);

  int? _time;

  /// 最近一次 [reset] 显式提供的计时时长，单位毫秒。
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
    if (time != null && time < 0) {
      throw ArgumentError.value(time, 'time', 'must not be negative');
    }
    if (value == TTimeCounterStatus.reset) {
      _time = time;
      notifyListeners();
    } else {
      _time = time;
      value = TTimeCounterStatus.reset;
    }
  }
}
