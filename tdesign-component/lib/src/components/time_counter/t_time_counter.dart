import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../../util/list_ext.dart';
import '../typography/t_text.dart';
import 't_time_counter_controller.dart';
import 't_time_counter_style.dart';
import 't_time_counter_theme_data.dart';
import 't_time_counter_types.dart';

final RegExp _timeReg = RegExp(r'D+|H+|m+|s+|S+');

/// 自定义计时内容构建器。
typedef TTimeCounterBuilder = Widget Function(int time);

String _toDigits(int n, int l) => n.toString().padLeft(l, '0');

String _getMark(String format, String? type) {
  var part = format.split(type ?? '')[1];
  if (part.isEmpty) {
    return '';
  }
  return part.split('')[0];
}

/// 计时组件
class TTimeCounter extends StatefulWidget {
  const TTimeCounter({
    super.key,
    this.autoStart = true,
    this.content,
    this.format = 'HH:mm:ss',
    this.showMillisecond,
    this.size,
    this.splitWithUnit,
    this.variant,
    required this.time,
    this.onChanged,
    this.onFinish,
    this.direction = TTimeCounterDirection.down,
    this.controller,
  }) : assert(time >= 0, 'time must not be negative');

  /// 是否自动开始倒计时
  final bool autoStart;

  /// 自定义计时内容；为空时使用标准数字块。
  final TTimeCounterBuilder? content;

  /// 时间格式，DD-日，HH-时，mm-分，ss-秒，SSS-毫秒（分隔符必须为长度为1的非空格的字符）
  final String format;

  /// 是否显示毫秒；优先于组件 Theme。
  final bool? showMillisecond;

  /// 计时器尺寸；优先于组件 Theme。
  final TTimeCounterSize? size;

  /// 是否使用本地化时间单位分隔；优先于组件 Theme。
  final bool? splitWithUnit;

  /// 视觉形态；优先于组件 Theme。
  final TTimeCounterVariant? variant;

  /// 必需；计时时长，单位毫秒
  final int time;

  /// 时间变化时触发回调
  final ValueChanged<int>? onChanged;

  /// 计时结束时触发回调
  final VoidCallback? onFinish;

  /// 计时方向，默认倒计时
  final TTimeCounterDirection direction;

  /// 控制器，可控制开始/暂停/继续/重置
  final TTimeCounterController? controller;

  @override
  _TTimeCounterState createState() => _TTimeCounterState();
}

class _TTimeCounterState extends State<TTimeCounter>
    with SingleTickerProviderStateMixin {
  late TTimeCounterStyle _style;
  late Map<String, String> timeUnitMap;

  /// P1 回退后的有效值
  late bool _effectiveMillisecond;
  late bool _effectiveSplitWithUnit;
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
    // P1: 组件级 ThemeExtension
    final tTheme = Theme.of(context).extension<TTimeCounterThemeData>();
    final effectiveSize =
        widget.size ?? tTheme?.size ?? TTimeCounterSize.medium;
    final effectiveVariant =
        widget.variant ?? tTheme?.variant ?? TTimeCounterVariant.defaultTheme;
    _effectiveMillisecond =
        widget.showMillisecond ?? tTheme?.showMillisecond ?? false;
    _effectiveSplitWithUnit =
        widget.splitWithUnit ?? tTheme?.splitWithUnit ?? false;
    _style = TTimeCounterStyle.generateStyle(
      context,
      size: effectiveSize,
      theme: effectiveVariant,
      splitWithUnit: _effectiveSplitWithUnit,
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
  void didUpdateWidget(TTimeCounter oldWidget) {
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
      if (!mounted) {
        return;
      }
      if ((widget.direction == TTimeCounterDirection.down && _time > 0) ||
          widget.direction == TTimeCounterDirection.up && _time < _maxTime) {
        setState(() {
          if (widget.direction == TTimeCounterDirection.down) {
            _time =
                max(_time - (elapsed.inMilliseconds - _tempMilliseconds), 0);
          } else {
            _time = min(
                _time + (elapsed.inMilliseconds - _tempMilliseconds), _maxTime);
          }
        });
        _tempMilliseconds = elapsed.inMilliseconds;
        widget.onChanged?.call(_time);
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
    if (widget.direction == TTimeCounterDirection.down) {
      _time = time ?? widget.time;
    } else {
      _time = 0;
      _maxTime = time ?? widget.time;
    }
    if (update) {
      if (mounted) {
        setState(() {});
      }
    }
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (!mounted) {
          return;
        }
        startTimer();
      });
    }
  }

  void _onControllerChanged() {
    switch (widget.controller?.value) {
      case TTimeCounterStatus.start:
        startTimer();
        break;
      case TTimeCounterStatus.pause:
        pauseTimer();
        break;
      case TTimeCounterStatus.resume:
        resumeTimer();
        break;
      case TTimeCounterStatus.reset:
        resetTimer(widget.controller?.time);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.content == null) {
      return Row(
          mainAxisSize: MainAxisSize.min, children: _buildTimeWidget(context));
    }
    return widget.content!(_time);
  }

  List<Widget> _buildTimeWidget(BuildContext context) {
    final format = _effectiveMillisecond
        ? '${widget.format.replaceAll(RegExp(r':S+$'), '')}:SSS'
        : widget.format;
    final matches = _timeReg.allMatches(format);
    final timeMap = _getTimeMap(matches.map((e) => e.group(0) ?? '').toList());
    return matches
        .map((match) {
          final timeType = match.group(0) ?? '';
          return _buildTextWidget(
            timeMap[timeType] ?? '0',
            _effectiveSplitWithUnit
                ? timeUnitMap[timeType[0]] ?? ''
                : _getMark(format, timeType),
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
          child: TText(
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
        TText(
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
