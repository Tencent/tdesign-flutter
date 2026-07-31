import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../util/context_extension.dart';
import '../text/t_text.dart';
import 't_notice_bar_theme_data.dart';

/// 公告栏点击区域
enum TNoticeBarTapTarget {
  /// 左侧图标
  prefix,

  /// 公告内容
  content,

  /// 右侧图标
  suffix,
}

/// 公告栏
class TNoticeBar extends StatefulWidget {
  const TNoticeBar({
    super.key,
    this.content = '',
    this.items = const <String>[],
    this.left,
    this.right,
    this.prefixIcon,
    this.suffixIcon,
    this.direction = Axis.horizontal,
    this.maxLines = 1,
    this.marquee = false,
    this.speed = 50,
    this.interval = const Duration(seconds: 3),
    this.onPressed,
  }) : assert(speed > 0, 'speed must be greater than zero'),
       assert(maxLines > 0, 'maxLines must be greater than zero');

  /// 单条公告内容
  final String content;

  /// 多条公告内容，主要用于垂直轮播
  final List<String> items;

  /// 左侧内容（自定义左侧内容，优先级高于prefixIcon）
  final Widget? left;

  /// 右侧内容（自定义右侧内容，优先级高于suffixIcon）
  final Widget? right;

  /// 左侧图标；[left] 非空时不渲染。
  final IconData? prefixIcon;

  /// 右侧图标；[right] 非空时不渲染。
  final IconData? suffixIcon;

  /// 滚动方向
  final Axis direction;

  /// 文本行数（仅静态有效）
  final int maxLines;

  /// 是否启用滚动展示
  final bool marquee;

  /// 每秒滚动的逻辑像素
  final double speed;

  /// 垂直轮播的切换间隔
  final Duration interval;

  /// 点击事件
  final ValueChanged<TNoticeBarTapTarget>? onPressed;

  @override
  State<StatefulWidget> createState() => _TNoticeBarState();
}

class _TNoticeBarState extends State<TNoticeBar> {
  ScrollController? _scrollController;
  Timer? _timer;

  Size? _size;
  late TNoticeBarThemeData _resolved;

  final GlobalKey _key = GlobalKey();
  final GlobalKey _contentKey = GlobalKey();

  List<String> get _contentList =>
      widget.items.isNotEmpty ? widget.items : <String>[widget.content];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scheduleMarqueeStart();
  }

  TNoticeBarThemeData get _theme {
    final ext = Theme.of(context).extension<TNoticeBarThemeData>();
    return (ext ?? const TNoticeBarThemeData()).resolve(context);
  }

  bool get _effectiveMarquee => widget.marquee;

  double get _effectiveSpeed =>
      widget.speed.isFinite && widget.speed > 0 ? widget.speed : 50;

  Duration get _effectiveInterval => widget.interval;

  double get _effectiveHeight => _theme.height ?? 22;

  EdgeInsetsGeometry get _effectivePadding =>
      _theme.padding ?? TNoticeBarThemeData.defaultPadding;

  void _init() {
    _resolved = _theme;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TNoticeBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content ||
        oldWidget.items != widget.items ||
        oldWidget.direction != widget.direction ||
        oldWidget.maxLines != widget.maxLines ||
        oldWidget.marquee != widget.marquee ||
        oldWidget.speed != widget.speed ||
        oldWidget.interval != widget.interval) {
      _restartMarquee();
    }
  }

  void _scheduleMarqueeStart() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _effectiveMarquee) {
        _startTimer();
      }
    });
  }

  void _restartMarquee() {
    _timer?.cancel();
    _timer = null;
    if (!mounted) {
      return;
    }
    _scheduleMarqueeStart();
  }

  void _startTimer() {
    if (widget.direction == Axis.horizontal) {
      _scroll();
    } else if (widget.direction == Axis.vertical) {
      _step();
    }
  }

  void _scroll() {
    final controller = _scrollController;
    if (!mounted || controller == null || !controller.hasClients) {
      return;
    }
    var scrollDistance =
        _getContextWidth() + (_size!.width - _effectivePadding.horizontal);
    var remainder = scrollDistance % _effectiveSpeed;
    controller.jumpTo(0);
    var offset = 0.0 + _effectiveSpeed;
    controller.animateTo(
      offset,
      duration: const Duration(seconds: 1),
      curve: Curves.linear,
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted ||
          _scrollController == null ||
          !_scrollController!.hasClients) {
        timer.cancel();
        return;
      }
      if (offset < scrollDistance - remainder) {
        offset += _effectiveSpeed;
        await _scrollController!.animateTo(
          offset,
          duration: const Duration(seconds: 1),
          curve: Curves.linear,
        );
        if (!mounted) {
          timer.cancel();
          return;
        }
      } else {
        var time = (remainder / _effectiveSpeed * 1000)
            .round(); // coverage:ignore-line
        await _scrollController!.animateTo(
          scrollDistance, // coverage:ignore-line
          duration: Duration(milliseconds: time),
          curve: Curves.linear,
        ); // coverage:ignore-line
        if (!mounted) {
          timer.cancel();
          return;
        }
        _scrollController!.jumpTo(0); // coverage:ignore-line
        offset = _effectiveSpeed - remainder; // coverage:ignore-line
        remainder =
            (scrollDistance - offset) % _effectiveSpeed; // coverage:ignore-line
        await _scrollController!.animateTo(
          offset, // coverage:ignore-line
          duration: Duration(milliseconds: 1000 - time), // coverage:ignore-line
          curve: Curves.linear,
        );
        if (!mounted) {
          timer.cancel();
          return;
        }
      }
    });
  }

  void _step() {
    var step = 0;
    var offset = 0.0;
    final content = _contentList;
    if (content.isEmpty) {
      return;
    }
    _timer = Timer.periodic(_effectiveInterval, (timer) {
      if (!mounted ||
          _scrollController == null ||
          !_scrollController!.hasClients) {
        timer.cancel();
        return;
      }
      var time = (_effectiveHeight / _effectiveSpeed * 1000).round();
      if (step >= content.length) {
        step = 0;
        offset = 0;
        _scrollController!.jumpTo(0);
      }
      step++;
      offset += _effectiveHeight;
      _scrollController!.animateTo(
        offset,
        duration: Duration(milliseconds: time),
        curve: Curves.linear,
      );
    });
  }

  /// 获取文本内容尺寸消息
  Size _getFontSize() {
    final text = _contentList.isEmpty ? '' : _contentList.first;
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: _resolved.textStyle),
      locale: Localizations.localeOf(context),
      textDirection: TextDirection.ltr,
      maxLines: _effectiveMarquee ? 1 : widget.maxLines,
    )..layout(maxWidth: _size!.width);
    return textPainter.size;
  }

  /// 获取文本内容宽度
  double _getContextWidth() {
    var contextWidth =
        _key.currentContext?.findRenderObject()?.paintBounds.size.width ?? 0;
    if (contextWidth == 0) {
      contextWidth = _getFontSize().width;
    }
    return contextWidth;
  }

  /// 获取滚动区域宽度
  double _getEmptyWidth() {
    return _contentKey.currentContext
            ?.findRenderObject() // coverage:ignore-line
            ?.paintBounds // coverage:ignore-line
            .size // coverage:ignore-line
            .width ?? // coverage:ignore-line
        (_size!.width - _effectivePadding.horizontal);
  }

  /// 获取文字高度
  double _getTextHeight() {
    return _getFontSize().height;
  }

  /// 内容区域
  Widget _contentWidget() {
    Widget? textWidget;

    final displayText = _contentList.isEmpty ? null : _contentList.first;

    if (displayText != null) {
      textWidget = SizedBox(
        height: _getTextHeight(),
        child: Align(
          alignment: Alignment.centerLeft,
          child: TText(
            displayText,
            style: _resolved.textStyle,
            maxLines: _effectiveMarquee ? 1 : widget.maxLines,
          ),
        ),
      );
    } else {
      textWidget = const SizedBox.shrink();
    }

    if (!_effectiveMarquee) {
      return textWidget;
    }

    Widget? child;
    switch (widget.direction) {
      case Axis.horizontal:
        final emptyWidth = _getEmptyWidth();
        final textHeight = _getTextHeight();
        final contextWidth = _getContextWidth();

        child = SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: [
              SizedBox(key: _key, height: textHeight, child: textWidget),
              SizedBox(width: emptyWidth),
              SizedBox(
                width: math.max(emptyWidth, contextWidth),
                height: textHeight,
                child: textWidget,
              ),
            ],
          ),
        );
        break;
      case Axis.vertical:
        var content = _contentList;
        if (content.isEmpty) {
          child = textWidget;
          break;
        }
        child = SizedBox(
          height: _effectiveHeight,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < content.length; i++)
                  SizedBox(
                    height: _effectiveHeight,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TText(
                        content[i],
                        style: _resolved.textStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                SizedBox(
                  key: _key,
                  height: _effectiveHeight,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TText(
                      content[0],
                      style: _resolved.textStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        break;
    }
    return child;
  }

  Widget _buildBuiltInTapTarget(TNoticeBarTapTarget target, Widget child) {
    if (widget.onPressed == null) {
      return child;
    }
    return GestureDetector(
      onTap: () => widget.onPressed!(target),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    _init();
    _size = MediaQuery.of(context).size;
    final prefixIcon = widget.prefixIcon;
    final suffixIcon = widget.suffixIcon;
    return Container(
      padding: _effectivePadding,
      color: _resolved.backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// 左侧widget
          if (widget.left != null)
            widget.left!
          else if (prefixIcon != null)
            _buildBuiltInTapTarget(
              TNoticeBarTapTarget.prefix,
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: Icon(
                  prefixIcon,
                  color: _resolved.leftIconColor,
                  size: _effectiveHeight,
                ),
              ),
            ),

          /// 中间内容
          Expanded(
            key: _contentKey,
            child: _buildBuiltInTapTarget(
              TNoticeBarTapTarget.content,
              _contentWidget(),
            ),
          ),

          /// 右侧widget
          if (widget.right != null)
            widget.right!
          else if (suffixIcon != null)
            _buildBuiltInTapTarget(
              TNoticeBarTapTarget.suffix,
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: Icon(
                  suffixIcon,
                  color: _resolved.rightIconColor,
                  size: _effectiveHeight,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
