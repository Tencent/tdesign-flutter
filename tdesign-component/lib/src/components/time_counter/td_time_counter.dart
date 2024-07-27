import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';

RegExp _timeReg = RegExp(r'D{2}|H{2}|m{2}|s{2}|S{3}');

String _toDigits(int n, int l) => n.toString().padLeft(l, '0');

String _getMark(String format, String? type) {
  var part = format.split(type ?? '')[1];
  if (part.isEmpty) {
    return '';
  }
  return part.split('')[0];
}

/// 倒计时组件
class TDTimeCounter extends StatefulWidget {
  const TDTimeCounter({
    Key? key,
    this.autoStart = true,
    this.content = 'default',
    this.format = 'HH:mm:ss',
    this.millisecond = false,
    this.size = TDTimeCounterSize.medium,
    this.splitWithUnit = false,
    this.theme = TDTimeCounterTheme.defaultTheme,
    required this.time,
    this.style,
    this.onChange,
    this.onFinish,
    this.direction = TDTimeCounterDirection.down,
    this.controller,
  }) : super(key: key);

  /// 是否自动开始倒计时
  final bool autoStart;

  /// 'default' / Widget Function(int time) / Widget
  final dynamic content;

  /// 时间格式，DD-日，HH-时，mm-分，ss-秒，SSS-毫秒
  final String format;

  /// 是否开启毫秒级渲染
  final bool millisecond;

  /// 倒计时尺寸
  final TDTimeCounterSize size;

  /// 使用时间单位分割
  final bool splitWithUnit;

  /// 倒计时风格
  final TDTimeCounterTheme theme;

  /// 必需；倒计时时长，单位毫秒
  final int time;

  /// 自定义样式，有则优先用它，没有则根据size和theme选取
  final TDTimeCounterStyle? style;

  /// 时间变化时触发回调
  final Function(int time)? onChange;

  /// 倒计时结束时触发回调
  final VoidCallback? onFinish;

  /// 计时方向，默认倒计时
  final TDTimeCounterDirection direction;

  /// 控制器，可控制开始/暂停/继续/重置
  final TDTimeCounterController? controller;

  @override
  _TDTimeCounterState createState() => _TDTimeCounterState();
}

class _TDTimeCounterState extends State<TDTimeCounter>
    with SingleTickerProviderStateMixin {
  late TDTimeCounterStyle _style;
  late Map<String, String> timeUnitMap;
  Ticker? _ticker;
  int _time = 0;
  int _tempMilliseconds = 0;

  @override
  void initState() {
    super.initState();
    if (widget.direction == TDTimeCounterDirection.down) {
      _time = widget.time;
    }
    if (widget.autoStart) {
      startTimer();
    }
    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _style = widget.style ??
        TDTimeCounterStyle.generateStyle(
          context,
          size: widget.size,
          theme: widget.theme,
          splitWithUnit: widget.splitWithUnit,
        );
    timeUnitMap = {
      'DD': context.resource.days,
      'HH': context.resource.hours,
      'mm': context.resource.minutes,
      'ss': context.resource.seconds,
      'SSS': context.resource.milliseconds,
    };
  }

  @override
  void didUpdateWidget(TDTimeCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  /// 开始倒计时
  void startTimer() {
    if (_ticker?.isActive == true) {
      return;
    }
    _tempMilliseconds = 0;
    _ticker ??= createTicker((Duration elapsed) {
      if ((widget.direction == TDTimeCounterDirection.down && _time > 0) || widget.direction == TDTimeCounterDirection.up && _time <= widget.time) {
        setState(() {
          if (widget.direction == TDTimeCounterDirection.down) {
            _time = max(_time - (elapsed.inMilliseconds - _tempMilliseconds), 0);
          } else {
            _time = min(_time + (elapsed.inMilliseconds - _tempMilliseconds), widget.time);
          }
        });
        _tempMilliseconds = elapsed.inMilliseconds;
        widget.onChange?.call(_time);
      } else {
        _time = 0;
        _ticker!.dispose();
        widget.onFinish?.call();
      }
      setState(() {});
    });
    _ticker!.start();
  }

  /// 暂停
  void pauseTimer() {
    _ticker?.stop();
  }

  /// 继续
  void resumeTimer() {
    startTimer();
  }

  /// 重置倒计时
  void resetTimer([int? time]) {
    _ticker?.stop();
    if (widget.direction == TDTimeCounterDirection.down) {
      _time = time ?? widget.time;
    } else {
      _time = 0;
    }
    setState(() {});
    if (widget.autoStart) {
      startTimer();
    }
  }

  void _onControllerChanged() {
    switch (widget.controller?.value) {
      case TDTimeCounterStatus.start:
        startTimer();
        break;
      case TDTimeCounterStatus.pause:
        pauseTimer();
        break;
      case TDTimeCounterStatus.resume:
        resumeTimer();
        break;
      case TDTimeCounterStatus.reset:
        resetTimer(widget.controller?.time);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.content == 'default') {
      return Row(
          mainAxisSize: MainAxisSize.min, children: _buildTimeWidget(context));
    }
    if (widget.content is Function) {
      return widget.content(_time);
    }
    return widget.content;
  }

  List<Widget> _buildTimeWidget(BuildContext context) {
    var format = widget.millisecond
        ? '${widget.format.replaceAll(':SSS', '')}:SSS'
        : widget.format;
    var matches = _timeReg.allMatches(format);
    var timeMap = _getTimeMap(_time);
    return matches
        .map((match) {
          var timeType = match.group(0);
          var timeData = timeUnitMap[timeType] ?? '';
          return _buildTextWidget(
            timeMap[timeType] ?? '0',
            widget.splitWithUnit ? timeData : _getMark(format, timeType),
          );
        })
        .expand((element) => element)
        .toList();
  }

  List<Widget> _buildTextWidget(
    String time,
    String split,
  ) {
    var children = <Widget>[
      Container(
        width: _style.timeWidth,
        height: _style.timeHeight,
        padding: _style.timePadding,
        margin: _style.timeMargin,
        decoration: _style.timeBox,
        child: Center(
          child: TDText(
            time,
            style: TextStyle(
              fontFamily: _style.timeFontFamily?.fontFamily,
              package: _style.timeFontFamily?.package,
              fontSize: _style.timeFontSize,
              height: _style.timeFontHeight,
              fontWeight: _style.timeFontWeight,
              color: _style.timeColor,
            ),
          ),
        ),
      ),
    ];
    if (split.isNotEmpty) {
      children.addAll([
        SizedBox(width: _style.space),
        TDText(
          split,
          style: TextStyle(
            fontSize: _style.splitFontSize,
            height: _style.splitFontHeight,
            fontWeight: _style.splitFontWeight,
            color: _style.splitColor,
          ),
        ),
        SizedBox(width: _style.space),
      ]);
    }
    return children;
  }

  Map<String, String> _getTimeMap(int m) {
    var duration = Duration(milliseconds: m);
    var days = _toDigits(duration.inDays, 2);
    var hours = _toDigits(duration.inHours, 2);
    var minutes = _toDigits(duration.inMinutes.remainder(60), 2);
    var seconds = _toDigits(duration.inSeconds.remainder(60), 2);
    var milliseconds = _toDigits(duration.inMilliseconds.remainder(1000), 3);
    return {
      'DD': days,
      'HH': hours,
      'mm': minutes,
      'ss': seconds,
      'SSS': milliseconds
    };
  }
}
