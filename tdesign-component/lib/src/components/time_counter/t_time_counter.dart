import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../theme/basic.dart' show Font, FontFamily;
import '../../theme/t_colors.dart';
import '../../theme/t_font_family.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../../util/list_ext.dart';
import '../text/t_text.dart';
import 't_time_counter_theme_data.dart';
import 't_time_counter_types.dart';

part 't_time_counter_controller.dart';
part 't_time_counter_style.dart';

final RegExp _timeReg = RegExp(r'D+|H+|m+|s+|S+');

List<RegExpMatch>? _parseTimeFormat(String format) {
  final matches = _timeReg.allMatches(format).toList();
  if (matches.isEmpty || matches.first.start != 0) {
    return null;
  }

  final units = <String>{};
  for (var index = 0; index < matches.length; index++) {
    final match = matches[index];
    final unit = match.group(0)![0];
    if (!units.add(unit)) {
      return null;
    }
    if (index == 0) {
      continue;
    }
    final separator = format.substring(matches[index - 1].end, match.start);
    if (separator.length != 1 || separator.trim().isEmpty) {
      return null;
    }
  }

  final suffix = format.substring(matches.last.end);
  if (suffix.isNotEmpty && (suffix.length != 1 || suffix.trim().isEmpty)) {
    return null;
  }
  return matches;
}

/// 自定义计时内容构建器。
typedef TTimeCounterBuilder = Widget Function(int time);

String _toDigits(int n, int l) => n.toString().padLeft(l, '0');

String _getMark(String format, RegExpMatch match) =>
    match.end < format.length ? format.substring(match.end, match.end + 1) : '';

/// 通用计时器组件，支持正向计时与倒计时。
class TTimeCounter extends StatefulWidget {
  const TTimeCounter({
    super.key,
    this.autoStart = true,
    this.content,
    this.format = 'HH:mm:ss',
    this.size,
    this.splitWithUnit = false,
    this.variant,
    required this.time,
    this.onChanged,
    this.onFinish,
    this.direction = TTimeCounterDirection.down,
    this.controller,
  }) : assert(time >= 0, 'time must not be negative');

  /// 首次挂载时是否自动开始计时，默认为 true。
  ///
  /// 该值只决定初始行为；挂载后的开始、暂停和重置由 [controller] 控制。
  /// 设置为 false 后仍需启动计时时，应同时传入 [controller]。
  final bool autoStart;

  /// 自定义计时内容；为空时使用标准数字块。
  final TTimeCounterBuilder? content;

  /// 时间格式，D-日、H-时、m-分、s-秒、S-毫秒，默认为 `HH:mm:ss`。
  ///
  /// 每段可重复字符控制最小位数，相邻时间段之间仅允许一个非空白分隔符；
  /// 最后一段后可追加一个单位字符。例如 `HH:mm:ss`、`mmmm分sss秒`。
  /// 两位 `H`、`m`、`s` 分别按 24、60、60 取余；需要展示累计值时，
  /// 可将对应时间段扩展为三位及以上，例如 `HHH:mm:ss` 会展示累计小时数。
  /// 包含 `S` 段时按绘制帧更新，否则仅在格式化后的可见值变化时更新。
  /// 使用 [content] 时，该字段仍决定计时更新精度。
  final String format;

  /// 计时器尺寸；优先于组件 Theme。
  final TTimeCounterSize? size;

  /// 是否使用本地化时间单位分隔，默认为 false。
  final bool splitWithUnit;

  /// 视觉形态；优先于组件 Theme。
  final TTimeCounterVariant? variant;

  /// 必需；计时时长，单位毫秒。
  ///
  /// 父组件更新该值时会按新的声明式配置重置计时，并覆盖此前
  /// [TTimeCounterController.reset] 传入的临时目标时长。
  final int time;

  /// 格式化后的可见值变化时触发，回调值为当前毫秒数。
  ///
  /// [format] 包含毫秒段时按绘制帧触发，否则仅在可见时间段变化时触发。
  final ValueChanged<int>? onChanged;

  /// 计时到达终点时触发一次回调。
  ///
  /// 初始值或重置值已在终点时不会自动触发；此时显式调用
  /// [TTimeCounterController.start] 会触发一次。
  final VoidCallback? onFinish;

  /// 计时方向，默认倒计时。
  final TTimeCounterDirection direction;

  /// 控制器，可控制开始、暂停和重置。
  final TTimeCounterController? controller;

  @override
  State<TTimeCounter> createState() => _TTimeCounterState();
}

class _TTimeCounterState extends State<TTimeCounter>
    with SingleTickerProviderStateMixin {
  late _TTimeCounterStyle _style;
  late Map<String, String> timeUnitMap;

  Ticker? _ticker;
  int _currentTime = 0;
  int _lastElapsedMilliseconds = 0;
  int _targetTime = 0;
  bool _finished = false;
  List<RegExpMatch> _formatMatches = const [];
  List<String> _timeTypes = const [];
  int _visibleResolutionMilliseconds = Duration.millisecondsPerSecond;
  int _visibleBucket = 0;

  @override
  void initState() {
    super.initState();
    _validateConfiguration();
    _resetTimer(time: widget.time, notify: false);
    widget.controller?.addListener(_onControllerChanged);
    if (widget.autoStart && _canRun) {
      _startTimer();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveStyle();
    timeUnitMap = {
      'D': context.resource.days,
      'H': context.resource.hours,
      'm': context.resource.minutes,
      's': context.resource.seconds,
      'S': context.resource.milliseconds,
    };
  }

  void _resolveStyle() {
    final tTheme = Theme.of(context).extension<TTimeCounterThemeData>();
    final effectiveSize =
        widget.size ?? tTheme?.defaultSize ?? TTimeCounterSize.medium;
    final effectiveVariant =
        widget.variant ?? tTheme?.defaultVariant ?? TTimeCounterVariant.plain;
    _style = _TTimeCounterStyle.generateStyle(
      context,
      size: effectiveSize,
      variant: effectiveVariant,
      splitWithUnit: widget.splitWithUnit,
    );
  }

  @override
  void didUpdateWidget(TTimeCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.time != oldWidget.time || widget.format != oldWidget.format) {
      _validateConfiguration();
      _visibleBucket = _visibleBucketFor(_currentTime);
    }
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
    if (widget.size != oldWidget.size ||
        widget.variant != oldWidget.variant ||
        widget.splitWithUnit != oldWidget.splitWithUnit) {
      _resolveStyle();
    }
    if (widget.time != oldWidget.time ||
        widget.direction != oldWidget.direction) {
      final wasRunning = _ticker?.isActive == true;
      _resetTimer(time: widget.time, notify: false);
      if (wasRunning && _canRun) {
        _startTimer();
      }
    }
  }

  void _validateConfiguration() {
    if (widget.time < 0) {
      throw ArgumentError.value(widget.time, 'time', 'must not be negative');
    }
    final matches = _parseTimeFormat(widget.format);
    if (matches == null) {
      throw ArgumentError.value(
        widget.format,
        'format',
        'has invalid structure',
      );
    }
    _formatMatches = matches;
    _timeTypes = matches.map((match) => match.group(0) ?? '').toList();
    _visibleResolutionMilliseconds =
        _timeTypes.any((type) => type.startsWith('S'))
        ? 1
        : _timeTypes.any((type) => type.startsWith('s'))
        ? Duration.millisecondsPerSecond
        : _timeTypes.any((type) => type.startsWith('m'))
        ? Duration.millisecondsPerMinute
        : _timeTypes.any((type) => type.startsWith('H'))
        ? Duration.millisecondsPerHour
        : Duration.millisecondsPerDay;
  }

  @override
  void dispose() {
    _ticker?.dispose();
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _startTimer() {
    if (_ticker?.isActive == true) {
      return;
    }
    if (!_canRun) {
      _finish();
      return;
    }
    _lastElapsedMilliseconds = 0;
    _ticker ??= createTicker((Duration elapsed) {
      if (!mounted) {
        return;
      }
      final delta = elapsed.inMilliseconds - _lastElapsedMilliseconds;
      _lastElapsedMilliseconds = elapsed.inMilliseconds;
      final previous = _currentTime;
      final next = widget.direction == TTimeCounterDirection.down
          ? max(previous - delta, 0)
          : min(previous + delta, _targetTime);
      final nextVisibleBucket = _visibleBucketFor(next);
      final shouldRender = nextVisibleBucket != _visibleBucket;
      _currentTime = next;
      _visibleBucket = nextVisibleBucket;
      if (shouldRender && next != previous) {
        widget.onChanged?.call(next);
        setState(() {});
      }
      if (!_canRun) {
        _finish();
      }
    });
    _ticker!.start();
  }

  bool get _canRun => widget.direction == TTimeCounterDirection.down
      ? _currentTime > 0
      : _currentTime < _targetTime;

  void _finish() {
    _pauseTimer();
    if (!_finished) {
      _finished = true;
      widget.onFinish?.call();
    }
  }

  void _pauseTimer() {
    _ticker?.stop();
  }

  /// 重置计时并保持暂停。
  void _resetTimer({int? time, bool notify = true}) {
    _ticker?.stop();
    _finished = false;
    final previousVisibleBucket = _visibleBucket;
    _targetTime = time ?? widget.time;
    if (widget.direction == TTimeCounterDirection.down) {
      _currentTime = _targetTime;
    } else {
      _currentTime = 0;
    }
    _visibleBucket = _visibleBucketFor(_currentTime);
    if (notify && mounted) {
      final visibleValueChanged = previousVisibleBucket != _visibleBucket;
      if (visibleValueChanged) {
        widget.onChanged?.call(_currentTime);
      }
      setState(() {});
    }
  }

  void _onControllerChanged() {
    switch (widget.controller?._command) {
      case _TTimeCounterCommand.start:
        _startTimer();
        break;
      case _TTimeCounterCommand.pause:
        _pauseTimer();
        break;
      case _TTimeCounterCommand.reset:
        _resetTimer(time: widget.controller?._resetTime);
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
    return widget.content!(_currentTime);
  }

  List<Widget> _buildTimeWidget(BuildContext context) {
    final timeMap = _getTimeMap(_timeTypes, _currentTime);
    return _formatMatches
        .map((match) {
          final timeType = match.group(0) ?? '';
          return _buildTextWidget(
            timeMap[timeType] ?? '0',
            widget.splitWithUnit
                ? timeUnitMap[timeType[0]] ?? ''
                : _getMark(widget.format, match),
          );
        })
        .expand((element) => element)
        .toList();
  }

  int _visibleBucketFor(int time) => time ~/ _visibleResolutionMilliseconds;

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

  Map<String, String> _getTimeMap(List<String> timeType, int time) {
    var duration = Duration(milliseconds: time);
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
