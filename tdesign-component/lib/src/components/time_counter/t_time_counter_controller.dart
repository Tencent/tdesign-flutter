part of 't_time_counter.dart';

enum _TTimeCounterCommand { start, pause, reset }

/// 计时组件控制器，可控制开始、暂停和重置。
///
/// Controller 由调用方创建并负责释放。
class TTimeCounterController extends ChangeNotifier {
  _TTimeCounterCommand? _command;

  int? _time;

  /// 开始或继续计时。
  void start() {
    _command = _TTimeCounterCommand.start;
    notifyListeners();
  }

  /// 暂停计时。
  void pause() {
    _command = _TTimeCounterCommand.pause;
    notifyListeners();
  }

  /// 重置计时；[time] 为空时恢复为组件当前配置的时长。
  void reset([int? time]) {
    if (time != null && time < 0) {
      throw ArgumentError.value(time, 'time', 'must not be negative');
    }
    _time = time;
    _command = _TTimeCounterCommand.reset;
    notifyListeners();
  }
}
