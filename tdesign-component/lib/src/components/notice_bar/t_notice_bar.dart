import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../util/context_extension.dart';
import '../typography/t_text.dart';
import 't_notice_bar_theme_data.dart';
import 't_notice_bar_types.dart';

/// 公告栏点击区域
enum TNoticeBarTapTarget {
  /// 前缀区域
  prefix,

  /// 公告内容
  content,

  /// 右侧操作区
  operation,

  /// 尾部图标
  suffix,
}

/// 公告栏
class TNoticeBar extends StatefulWidget {
  const TNoticeBar({
    super.key,
    this.content = '',
    this.items = const <String>[],
    this.status = TNoticeBarStatus.info,
    this.prefix,
    this.operation,
    this.suffixIcon,
    this.direction = Axis.horizontal,
    this.maxLines = 1,
    this.marquee = false,
    this.speed = 50,
    this.interval = const Duration(seconds: 2),
    this.onPressed,
  }) : assert(speed > 0, 'speed must be greater than zero'),
       assert(maxLines > 0, 'maxLines must be greater than zero');

  /// 单条公告内容。
  ///
  /// 当 [items] 非空时不显示此内容。
  final String content;

  /// 多条公告内容，主要用于垂直轮播。
  ///
  /// 非空时作为内容数据源，并优先于 [content]。
  final List<String> items;

  /// 公告栏业务状态，决定默认配色和默认前缀图标。
  final TNoticeBarStatus status;

  /// 自定义前缀区域。
  ///
  /// 为 null 时根据 [status] 显示默认图标；传入 [SizedBox.shrink] 可隐藏
  /// 前缀区域。自定义内容负责该区域的间距；其中未显式指定颜色或尺寸的
  /// [Icon] 会继承公告栏的状态图标颜色和标准图标尺寸。
  final Widget? prefix;

  /// 内容右侧、[suffixIcon] 左侧的自定义操作区。
  ///
  /// 可以和 [suffixIcon] 同时显示。
  final Widget? operation;

  /// 尾部图标，可以和 [operation] 同时显示。
  final IconData? suffixIcon;

  /// 滚动方向
  final Axis direction;

  /// 文本行数（仅静态有效）
  final int maxLines;

  /// 是否启用横向跑马灯展示。
  final bool marquee;

  /// 横向跑马灯每秒滚动的逻辑像素，仅在 [direction] 为 [Axis.horizontal]
  /// 且 [marquee] 为 true 时生效。
  final double speed;

  /// 垂直轮播的切换间隔，仅在 [direction] 为 [Axis.vertical] 时生效。
  final Duration interval;

  /// 点击事件
  final ValueChanged<TNoticeBarTapTarget>? onPressed;

  @override
  State<StatefulWidget> createState() => _TNoticeBarState();
}

class _TNoticeBarState extends State<TNoticeBar> {
  ScrollController? _scrollController;
  Timer? _timer;

  double _contentViewportWidth = 0;
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
    return (ext ?? const TNoticeBarThemeData()).resolve(
      context,
      status: widget.status,
    );
  }

  double get _effectiveSpeed =>
      widget.speed.isFinite && widget.speed > 0 ? widget.speed : 50;

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

  bool get _shouldAnimate => widget.direction == Axis.horizontal
      ? widget.marquee
      : widget.items.length > 1;

  void _scheduleMarqueeStart() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _shouldAnimate) {
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
    // 滚动距离 = 文本宽度 + 公告栏可视区宽度（而非屏幕宽度），
    // 保证文本滚出可视区后紧跟一个等宽的空白段再回绕，窄屏/宽屏表现一致。
    var scrollDistance = _getContextWidth() + _getEmptyWidth();
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
    _timer = Timer.periodic(widget.interval, (timer) {
      if (!mounted ||
          _scrollController == null ||
          !_scrollController!.hasClients) {
        timer.cancel();
        return;
      }
      if (step >= content.length) {
        step = 0;
        offset = 0;
        _scrollController!.jumpTo(0);
      }
      step++;
      offset += _effectiveHeight;
      _scrollController!.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
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
      maxLines: widget.marquee ? 1 : widget.maxLines,
    )..layout(maxWidth: _getEmptyWidth());
    return textPainter.size;
  }

  /// 获取文本内容宽度
  double _getContextWidth() {
    var contextWidth = _renderWidth(_key) ?? 0;
    if (contextWidth == 0) {
      contextWidth = _getFontSize().width;
    }
    return contextWidth;
  }

  double? _renderWidth(GlobalKey key) {
    final renderObject = key.currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      return renderObject.size.width;
    }
    return null;
  }

  /// 获取滚动区域宽度
  double _getEmptyWidth() {
    final measuredWidth = _renderWidth(_contentKey);
    if (measuredWidth != null && measuredWidth > 0) {
      return measuredWidth;
    }
    return _contentViewportWidth;
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
            maxLines: widget.marquee ? 1 : widget.maxLines,
          ),
        ),
      );
    } else {
      textWidget = const SizedBox.shrink();
    }

    if (widget.direction == Axis.horizontal && !widget.marquee) {
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

  Widget _buildCustomTapTarget(TNoticeBarTapTarget target, Widget child) {
    if (widget.onPressed == null) {
      return child;
    }
    // 自定义 Widget 内部可能拥有自己的手势识别器。使用原始指针
    // 监听可在子组件处理业务点击的同时，稳定报告 NoticeBar 的自定义区域目标。
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerUp: (_) => widget.onPressed!(target),
      child: child,
    );
  }

  IconData get _defaultPrefixIcon {
    switch (widget.status) {
      case TNoticeBarStatus.info:
        return TIcons.info_circle_filled;
      case TNoticeBarStatus.success:
        return TIcons.check_circle_filled;
      case TNoticeBarStatus.warning:
      case TNoticeBarStatus.error:
        return TIcons.error_circle_filled;
    }
  }

  Widget _buildPrefix() {
    final prefix = widget.prefix;
    if (prefix != null) {
      return _buildCustomTapTarget(
        TNoticeBarTapTarget.prefix,
        IconTheme.merge(
          data: IconThemeData(
            color: _resolved.leftIconColor,
            size: _effectiveHeight,
          ),
          child: prefix,
        ),
      );
    }
    return _buildBuiltInTapTarget(
      TNoticeBarTapTarget.prefix,
      Container(
        margin: const EdgeInsets.only(right: 8),
        child: Icon(
          _defaultPrefixIcon,
          color: _resolved.leftIconColor,
          size: _effectiveHeight,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _init();
    final suffixIcon = widget.suffixIcon;
    return Container(
      padding: _effectivePadding,
      color: _resolved.backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// 前缀区域
          _buildPrefix(),

          /// 中间内容
          Expanded(
            key: _contentKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                _contentViewportWidth = constraints.hasBoundedWidth
                    ? constraints.maxWidth
                    : 0;
                return _buildBuiltInTapTarget(
                  TNoticeBarTapTarget.content,
                  _contentWidget(),
                );
              },
            ),
          ),

          /// 右侧操作区
          if (widget.operation != null)
            _buildCustomTapTarget(
              TNoticeBarTapTarget.operation,
              widget.operation!,
            ),

          /// 尾部图标
          if (suffixIcon != null)
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
