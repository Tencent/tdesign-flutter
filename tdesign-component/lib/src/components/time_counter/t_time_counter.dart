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

bool _isValidFormat(String format) {
  final matches = _timeReg.allMatches(format).toList();
  if (matches.isEmpty || matches.first.start != 0) {
    return false;
  }

  final units = <String>{};
  for (var index = 0; index < matches.length; index++) {
    final match = matches[index];
    final unit = match.group(0)![0];
    if (!units.add(unit)) {
      return false;
    }
    if (index == 0) {
      continue;
    }
    final separator = format.substring(matches[index - 1].end, match.start);
    if (separator.length != 1 || separator.trim().isEmpty) {
      return false;
    }
  }

  final suffix = format.substring(matches.last.end);
  return suffix.isEmpty || (suffix.length == 1 && suffix.trim().isNotEmpty);
}

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
    this.size,
    this.splitWithUnit = false,
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

  /// 时间格式，D-日、H-时、m-分、s-秒、S-毫秒，默认为 `HH:mm:ss`。
  ///
  /// 每段可重复字符控制最小位数，相邻时间段之间仅允许一个非空白分隔符；
  /// 最后一段后可追加一个单位字符。例如 `HH:mm:ss`、`mmmm分sss秒`。
  /// 包含 `S` 段时按绘制帧更新，否则仅在展示秒值变化时更新。
  /// 使用 [content] 时，该字段仍决定计时更新精度。
  final String format;

  /// 计时器尺寸；优先于组件 Theme。
  final TTimeCounterSize? size;

  /// 是否使用本地化时间单位分隔，默认为 false。
  final bool splitWithUnit;

  /// 视觉形态；优先于组件 Theme。
  final TTimeCounterVariant? variant;

  /// 必需；计时时长，单位毫秒
  final int time;

  /// 展示值变化时触发，回调值为当前毫秒数。
  ///
  /// [format] 包含毫秒段时按绘制帧触发，否则仅跨秒或到达终点时触发。
  final ValueChanged<int>? onChanged;

  /// 计时自然到达终点时触发一次回调。
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
    if (!_isValidFormat(widget.format)) {
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
          _showsMilliseconds ||
          next == 0 ||
          next == _maxTime ||
          next ~/ Duration.millisecondsPerSecond !=
              previous ~/ Duration.millisecondsPerSecond;
      _time = next;
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
        widget.onChanged?.call(_time);
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
    switch (widget.controller?._command) {
      case _TTimeCounterCommand.start:
        startTimer();
        break;
      case _TTimeCounterCommand.pause:
        pauseTimer();
        break;
      case _TTimeCounterCommand.reset:
        resetTimer(widget.controller?._time);
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
    final format = widget.format;
    final matches = _timeReg.allMatches(format);
    final timeMap = _getTimeMap(matches.map((e) => e.group(0) ?? '').toList());
    return matches
        .map((match) {
          final timeType = match.group(0) ?? '';
          return _buildTextWidget(
            timeMap[timeType] ?? '0',
            widget.splitWithUnit
                ? timeUnitMap[timeType[0]] ?? ''
                : _getMark(format, match),
          );
        })
        .expand((element) => element)
        .toList();
  }

  bool get _showsMilliseconds => _timeReg
      .allMatches(widget.format)
      .any((match) => match.group(0)?.startsWith('S') ?? false);

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
