import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../tdesign_flutter.dart';

Map<String, String> timeUnitMap = {
  'DD': '天',
  'HH': '时',
  'mm': '分',
  'ss': '秒',
  'SSS': '毫秒',
};

RegExp timeReg = RegExp(r'D{2}|H{2}|m{2}|s{2}|S{3}');

String toDigits(int n, int l) => n.toString().padLeft(l, '0');

String getMark(String format, String? type) {
  var part = format.split(type ?? '')[1];
  if (part.isEmpty) {
    return '';
  }
  return part.split('')[0];
}

/// 倒计时组件
class TDCountDown extends StatefulWidget {
  const TDCountDown({
    Key? key,
    this.autoStart = true,
    this.content = 'default',
    this.format = 'HH:mm:ss',
    this.millisecond = false,
    this.size = TDCountDownSize.medium,
    this.splitWithUnit = false,
    this.theme = TDCountDownTheme.defaultTheme,
    required this.time,
    this.style,
    this.onChange,
    this.onFinish,
  }) : super(key: key);

  /// 是否自动开始倒计时
  final bool autoStart;

  /// 'default'/Widget Function(int time)/Widget
  final dynamic content;

  /// 时间格式，DD-日，HH-时，mm-分，ss-秒，SSS-毫秒
  final String format;

  /// 是否开启毫秒级渲染
  final bool millisecond;

  /// 倒计时尺寸
  final TDCountDownSize size;

  /// 使用时间单位分割
  final bool splitWithUnit;

  /// 倒计时风格
  final TDCountDownTheme theme;

  /// 必需；倒计时时长，单位毫秒
  final int time;

  /// 自定义样式，有则优先用它，没有则根据size和theme选取
  final TDCountDownStyle? style;

  /// 时间变化时触发回调
  final Function(int time)? onChange;

  /// 倒计时结束时触发回调
  final VoidCallback? onFinish;

  @override
  _TDCountDownState createState() => _TDCountDownState();
}

class _TDCountDownState extends State<TDCountDown>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  int _time = 0;

  @override
  void initState() {
    super.initState();
    _time = widget.time;
    if (_time > 0 && widget.autoStart) {
      startTimer();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void startTimer() {
    var tempMilliseconds = 0;
    _ticker = createTicker((Duration elapsed) {
      if (_time > 0) {
        setState(() {
          _time = max(_time - (elapsed.inMilliseconds - tempMilliseconds), 0);
        });
        tempMilliseconds = elapsed.inMilliseconds;
        widget.onChange?.call(_time);
      } else {
        _ticker.dispose();
        widget.onFinish?.call();
      }
    });
    _ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.content == 'default') {
      return Row(
          mainAxisSize: MainAxisSize.min,
          children: _buildTimeWidget(context));
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
    var matches = timeReg.allMatches(format);
    var timeMap = _getTimeMap(_time);
    return matches
        .map((match) {
          var timeType = match.group(0);
          var timeData = timeUnitMap[timeType] ?? '';
          return _buildTextWidget(
              timeMap[timeType] ?? '0',
              widget.splitWithUnit ? timeData : getMark(format, timeType),
              widget.style ??
                  TDCountDownStyle.generateStyle(context,
                      size: widget.size,
                      theme: widget.theme,
                      splitWithUnit: widget.splitWithUnit));
        })
        .expand((element) => element)
        .toList();
  }

  List<Widget> _buildTextWidget(
    String time,
    String split,
    TDCountDownStyle style,
  ) {
    var children = <Widget>[
      Container(
        width: style.timeWidth,
        height: style.timeHeight,
        padding: style.timePadding,
        margin: style.timeMargin,
        decoration: style.timeBox,
        child: Center(
            child: Text(time,
                style: TextStyle(
                    fontFamily: style.timeFontFamily?.fontFamily,
                    package: style.timeFontFamily?.package,
                    fontSize: style.timeFontSize,
                    height: style.timeFontHeight,
                    fontWeight: style.timeFontWeight,
                    color: style.timeColor))),
      ),
    ];
    if (split.isNotEmpty) {
      children.addAll([
        SizedBox(width: style.space),
        Text(split,
            style: TextStyle(
                fontSize: style.splitFontSize,
                height: style.splitFontHeight,
                fontWeight: style.splitFontWeight,
                color: style.splitColor)),
        SizedBox(width: style.space),
      ]);
    }
    return children;
  }

  Map<String, String> _getTimeMap(int m) {
    var duration = Duration(milliseconds: m);
    var days = toDigits(duration.inDays, 2);
    var hours = toDigits(duration.inHours, 2);
    var minutes = toDigits(duration.inMinutes.remainder(60), 2);
    var seconds = toDigits(duration.inSeconds.remainder(60), 2);
    var milliseconds = toDigits(duration.inMilliseconds.remainder(1000), 3);
    return {
      'DD': days,
      'HH': hours,
      'mm': minutes,
      'ss': seconds,
      'SSS': milliseconds
    };
  }
}
