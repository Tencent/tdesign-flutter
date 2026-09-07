import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../../util/list_ext.dart';
import '../text/t_text.dart';
import 't_time_counter_controller.dart';
import 't_time_counter_style.dart';
import 't_time_counter_theme_data.dart';
import 't_time_counter_types.dart';

final RegExp _timeReg = RegExp(r'D+|H+|m+|s+|S+');
final RegExp _formatReg = RegExp(
  r'^(?:D+|H+|m+|s+|S+)(?:\S(?:D+|H+|m+|s+|S+))*\S?$',
);

/// 自定义计时内容构建器。
typedef TTimeCounterBuilder = Widget Function(int time);

String _toDigits(int n, int l) => n.toString().padLeft(l, '0');

String _getMark(String format, RegExpMatch match) =>
    match.end < format.length ? format.substring(match.end, match.end + 1) : '';

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

  /// 是否自动开始计时，默认为 true。
  final bool autoStart;

  /// 自定义计时内容；为空时使用标准数字块。
  final TTimeCounterBuilder? content;

  /// 时间格式，D-日、H-时、m-分、s-秒、S-毫秒。
  ///
  /// 每段可重复字符控制最小位数，相邻时间段之间仅允许一个非空白分隔符；
  /// 最后一段后可追加一个单位字符。例如 `HH:mm:ss`、`mmmm分sss秒`。
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

  /// 时间变化时按有效绘制帧触发回调，回调值为当前毫秒数。
  final ValueChanged<int>? onChanged;

  /// 计时自然到达终点时触发一次回调。
  final VoidCallback? onFinish;

  /// 计时方向，默认倒计时。
  final TTimeCounterDirection direction;

  /// 控制器，可控制开始/暂停/继续/重置
  final TTimeCounterController? controller;

  @override
  State<TTimeCounter> createState() => _TTimeCounterState();
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
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _validateConfiguration();
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
    if (widget.time != oldWidget.time || widget.format != oldWidget.format) {
      _validateConfiguration();
    }
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
    if (widget.time != oldWidget.time ||
        widget.direction != oldWidget.direction) {
      resetTimer(widget.time, false);
    } else if (widget.autoStart != oldWidget.autoStart) {
      if (widget.autoStart) {
        startTimer();
      } else {
        pauseTimer();
      }
    }
  }

  void _validateConfiguration() {
    if (widget.time < 0) {
      throw ArgumentError.value(widget.time, 'time', 'must not be negative');
    }
    if (!_formatReg.hasMatch(widget.format)) {
      throw ArgumentError.value(
        widget.format,
        'format',
        'has invalid structure',
      );
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
    if (!_canRun) {
      _finish();
      return;
    }
    _tempMilliseconds = 0;
    _ticker ??= createTicker((Duration elapsed) {
      if (!mounted) {
        return;
      }
      final delta = elapsed.inMilliseconds - _tempMilliseconds;
      _tempMilliseconds = elapsed.inMilliseconds;
      final previous = _time;
      final next = widget.direction == TTimeCounterDirection.down
          ? max(previous - delta, 0)
          : min(previous + delta, _maxTime);
      final shouldRender =
          _effectiveMillisecond ||
          next == 0 ||
          next == _maxTime ||
          next ~/ Duration.millisecondsPerSecond !=
              previous ~/ Duration.millisecondsPerSecond;
      _time = next;
      if (next != previous) {
        widget.onChanged?.call(next);
      }
      if (shouldRender && next != previous) {
        setState(() {});
      }
      if (!_canRun) {
        _finish();
      }
    });
    _ticker!.start();
  }

  bool get _canRun => widget.direction == TTimeCounterDirection.down
      ? _time > 0
      : _time < _maxTime;

  void _finish() {
    pauseTimer();
    if (!_finished) {
      _finished = true;
      widget.onFinish?.call();
    }
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
    _finished = false;
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
    if (widget.autoStart && _canRun) {
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
        mainAxisSize: MainAxisSize.min,
        children: _buildTimeWidget(context),
      );
    }
    return widget.content!(_time);
  }

  List<Widget> _buildTimeWidget(BuildContext context) {
    final format =
        _effectiveMillisecond &&
            !_timeReg
                .allMatches(widget.format)
                .any((match) => match.group(0)?.startsWith('S') ?? false)
        ? '${widget.format}:SSS'
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
                : _getMark(format, match),
          );
        })
        .expand((element) => element)
        .toList();
  }

  List<Widget> _buildTextWidget(String time, String split) {
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
