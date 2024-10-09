import 'dart:async';

import 'package:flutter/widgets.dart';

class Throttle {
  Duration delay;
  Timer? _timer;

  Throttle({required this.delay});

  void call(VoidCallback callback) {
    if (_timer?.isActive ?? false) {
      // 如果 _timer 正在运行，则不执行任何操作
      return;
    }

    // 创建一个新的计时器
    _timer = Timer(delay, () {
      callback();
      _timer = null; // 计时器执行完毕后，将其置为 null
    });
  }
}