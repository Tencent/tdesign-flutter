import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import '../../util/list_ext.dart';

RegExp _timeReg = RegExp(r'D+|H+|m+|s+|S+');

String _toDigits(int n, int l) => n.toString().padLeft(l, '0');

String _getMark(String format, String? type) {
  var part = format.split(type ?? '')[1];
  if (part.isEmpty) {
    return '';
  }
  return part.split('')[0];
}

/// 计时组件
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

  /// 时间格式，DD-日，HH-时，mm-分，ss-秒，SSS-毫秒（分隔符必须为长度为1的非空格的字符）
  final String format;

  /// 是否开启毫秒级渲染
  final bool millisecond;

  /// 尺寸
  final TDTimeCounterSize size;

  /// 使用时间单位分割
  final bool splitWithUnit;

  /// 风格
  final TDTimeCounterTheme theme;

  /// 必需；计时时长，单位毫秒
  final int time;

  /// 自定义样式，有则优先用它，没有则根据size和theme选取
  final TDTimeCounterStyle? style;

  /// 时间变化时触发回调
  final Function(int time)? onChange;

  /// 计时结束时触发回调
  final VoidCallback? onFinish;

  /// 计时方向，默认倒计时
  final TDTimeCounterDirection direction;

  /// 控制器，可控制开始/暂停/继续/重置
  final TDTimeCounterController? controller;

  @override
  _TDTimeCounterState createState() => _TDTimeCounterState();
}

class _TDTimeCounterState extends State<TDTimeCounter> with SingleTickerProviderStateMixin {
  late TDTimeCounterStyle _style;
  late Map<String, String> timeUnitMap;
  Ticker? _ticker;
  int _time = 0;
  int _tempMilliseconds = 0;
  int _maxTime = 0;

  @override
  void initState() {
    super.initState();
    resetTimer(widget.time, false);
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
      'D': context.resource.days,
      'H': context.resource.hours,
      'm': context.resource.minutes,
      's': context.resource.seconds,
      'S': context.resource.milliseconds,
    };
  }

  @override
  void didUpdateWidget(TDTimeCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
    if (widget.time != oldWidget.time) {
      resetTimer(widget.time, false);
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
      if ((widget.direction == TDTimeCounterDirection.down && _time > 0) ||
          widget.direction == TDTimeCounterDirection.up && _time < _maxTime) {
        setState(() {
          if (widget.direction == TDTimeCounterDirection.down) {
            _time = max(_time - (elapsed.inMilliseconds - _tempMilliseconds), 0);
          } else {
            _time = min(_time + (elapsed.inMilliseconds - _tempMilliseconds), _maxTime);
          }
        });
        _tempMilliseconds = elapsed.inMilliseconds;
        widget.onChange?.call(_time);
      } else {
        pauseTimer();
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

  /// 重置计时
  void resetTimer([int? time, bool update = true]) {
    _ticker?.stop();
    if (widget.direction == TDTimeCounterDirection.down) {
      _time = time ?? widget.time;
    } else {
      _time = 0;
      _maxTime = time ?? widget.time;
    }
    if (update) {
      setState(() {});
    }
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        startTimer();
      });
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
      return Row(mainAxisSize: MainAxisSize.min, children: _buildTimeWidget(context));
    }
    if (widget.content is Function) {
      return widget.content(_time);
    }
    return widget.content;
  }

  List<Widget> _buildTimeWidget(BuildContext context) {
    final format = widget.millisecond ? '${widget.format.replaceAll(RegExp(r':S+$'), '')}:SSS' : widget.format;
    final matches = _timeReg.allMatches(format);
    final timeMap = _getTimeMap(matches.map((e) => e.group(0) ?? '').toList());
    return matches
        .map((match) {
          final timeType = match.group(0) ?? '';
          return _buildTextWidget(
            timeMap[timeType] ?? '0',
            widget.splitWithUnit ? timeUnitMap[timeType[0]] ?? '' : _getMark(format, timeType),
          );
        })
        .expand((element) => element)
        .toList();
  }

  List<Widget> _buildTextWidget(
    String time,
    String split,
  ) {
    final children = <Widget>[
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

  Map<String, String> _getTimeMap(List<String> timeType) {
    var duration = Duration(milliseconds: _time);
    final map = <String, String>{};
    final dayKey = timeType.find((item) => item.startsWith('D'));
    final hourKey = timeType.find((item) => item.startsWith('H'));
    final minuteKey = timeType.find((item) => item.startsWith('m'));
    final secondKey = timeType.find((item) => item.startsWith('s'));
    final millisecondKey = timeType.find((item) => item.startsWith('S'));
    if (dayKey != null) {
      final length = dayKey.length;
      map[dayKey] = _toDigits(duration.inDays, length);
      duration = duration - Duration(days: duration.inDays);
    }
    if (hourKey != null) {
      final length = hourKey.length;
      final upNum = length > 2 ? pow(10, length).toInt() : 24;
      final time = duration.inHours.remainder(upNum);
      map[hourKey] = _toDigits(time, length);
      duration = duration - Duration(hours: time);
    }
    if (minuteKey != null) {
      final length = minuteKey.length;
      final upNum = length > 2 ? pow(10, length).toInt() : 60;
      final time = duration.inMinutes.remainder(upNum);
      map[minuteKey] = _toDigits(time, length);
      duration = duration - Duration(minutes: time);
    }
    if (secondKey != null) {
      final length = secondKey.length;
      final upNum = length > 2 ? pow(10, length).toInt() : 60;
      final time = duration.inSeconds.remainder(upNum);
      map[secondKey] = _toDigits(time, length);
      duration = duration - Duration(seconds: time);
    }
    if (millisecondKey != null) {
      final length = millisecondKey.length;
      map[millisecondKey] = _toDigits(duration.inMilliseconds, length);
    }
    return map;
  }
}
