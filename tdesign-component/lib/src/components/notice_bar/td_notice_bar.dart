import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../tdesign_flutter.dart';

class TDNoticeBar extends StatefulWidget {
  const TDNoticeBar({
    super.key,
    this.content,
    this.context,
    this.style,
    this.left,
    this.right,
    this.speed = 50,
    this.interval = 3000,
    this.marquee = false,
    this.direction = Axis.horizontal,
    this.theme = TDNoticeBarTheme.info,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.height = 22,
    this.maxLines = 1,
  })  : assert(content == null || content is String || content is List<String>,
            'content must be String or List<String>'),
        assert(speed == null || speed >= 0, 'speed must not be less than 0'),
        assert(interval == null || interval >= 0,
            'interval must not be less than 0');

  /// 文本内容（请使用content属性）
  @deprecated
  final dynamic context;

  /// 文本内容（字符串或字符串数组等）
  final dynamic content;

  /// 公告栏样式 [TDNoticeBarStyle]
  final TDNoticeBarStyle? style;

  /// 左侧内容（自定义左侧内容，优先级高于prefixIcon）
  final Widget? left;

  /// 右侧内容（自定义右侧内容，优先级高于suffixIcon）
  final Widget? right;

  /// 跑马灯效果
  final bool? marquee;

  /// 滚动速度
  final double? speed;

  /// 步进滚动间隔时间（毫秒）
  final int? interval;

  /// 滚动方向
  final Axis? direction;

  /// 主题
  final TDNoticeBarTheme? theme;

  /// 左侧图标
  final IconData? prefixIcon;

  /// 右侧图标
  final IconData? suffixIcon;

  /// 点击事件
  final ValueChanged? onTap;

  /// 文字高度 (当使用prefixIcon或suffixIcon时，icon大小值等于该属性）
  final double height;

  /// 文本行数（仅静态有效）
  final int? maxLines;

  @override
  State<StatefulWidget> createState() => _TDNoticeBarState();
}

class _TDNoticeBarState extends State<TDNoticeBar> {
  ScrollController? _scrollController;
  Timer? _timer;

  Size? _size;
  TDNoticeBarStyle? _style;
  Color? _backgroundColor;

  final GlobalKey _key = GlobalKey();
  final GlobalKey _contentKey = GlobalKey();

  dynamic _content;

  @override
  void initState() {
    /// todo 初始化内容数据，兼用旧版本，后续版本待移除
    _content = widget.content ?? widget.context;

    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      if (widget.marquee == true) {
        _startTimer();
      }
    });
  }

  void _init() {
    // 初始化样式及左右widget
    if (widget.style != null) {
      _style = widget.style;
    } else {
      _style = TDNoticeBarStyle.generateTheme(context, theme: widget.theme);
    }
    _backgroundColor = _style!.backgroundColor;
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _scrollController?.dispose();
  }

  void _startTimer() {
    if (widget.direction == Axis.horizontal) {
      _scroll();
    } else if (widget.direction == Axis.vertical) {
      _step();
    }
  }

  void _scroll() {
    var scrollDistance =
        _getContextWidth() + (_size!.width - _style!.getPadding.horizontal);
    var remainder = scrollDistance % widget.speed!;
    _scrollController!.jumpTo(0);
    var offset = 0.0 + widget.speed!;
    _scrollController!.animateTo(offset,
        duration: const Duration(seconds: 1), curve: Curves.linear);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (offset < scrollDistance - remainder) {
        offset += widget.speed!;
        await _scrollController!.animateTo(offset,
            duration: const Duration(seconds: 1), curve: Curves.linear);
      } else {
        // 剩余距离小于50 先滚动这部分 然后滚动剩余部分
        // 剩余距离滚动所需时间
        var time = (remainder / widget.speed! * 1000).round();
        // 滚动最后一部分（触底）
        await _scrollController!.animateTo(scrollDistance,
            duration: Duration(milliseconds: time), curve: Curves.linear);
        // 回到顶部（衔接）
        _scrollController!.jumpTo(0);
        // 修改起始位置
        offset = widget.speed! - remainder;
        // 计算新起点最后阶段滚动距离
        remainder = (scrollDistance - offset) % widget.speed!;
        // 滚动至新起点（弥补触底speed滚动长度）
        await _scrollController!.animateTo(offset,
            duration: Duration(milliseconds: 1000 - time),
            curve: Curves.linear);
      }
    });
  }

  void _step() {
    var step = 0;
    var offset = 0.0;
    _timer = Timer.periodic(Duration(milliseconds: widget.interval!), (timer) {
      var time = (widget.height / widget.speed! * 1000).round();
      if (step >= _content.length) {
        step = 0;
        offset = 0;
        _scrollController!.jumpTo(0);
      }
      step++;
      // 固定滚动行高（22）
      offset += widget.height;
      _scrollController!.animateTo(offset,
          duration: Duration(milliseconds: time), curve: Curves.linear);
    });
  }

  /// 获取文本内容尺寸消息
  Size _getFontSize() {
    var text = _content;
    if (_content is List<String>) {
      text = _content[0];
    }
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: _style!.textStyle,
      ),
      locale: Localizations.localeOf(context),
      textDirection: TextDirection.ltr,
      maxLines: widget.marquee! ? 1 : widget.maxLines,
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
            ?.findRenderObject()
            ?.paintBounds
            .size
            .width ??
        (_size!.width - _style!.getPadding.horizontal);
  }

  /// 获取文字高度
  double _getTextHeight() {
    return _getFontSize().height;
  }

  /// 内容区域
  Widget _contentWidget() {
    Widget? textWidget;

    String? displayText;
    if (_content is String) {
      displayText = _content as String;
    } else if (_content is List<String> && _content.isNotEmpty) {
      displayText = _content[0];
    }

    if (displayText != null) {
      textWidget = SizedBox(
        height: _getTextHeight(),
        child: Align(
          alignment: Alignment.centerLeft,
          child: TDText(
            displayText,
            style: _style?.textStyle,
            maxLines: widget.marquee == true ? 1 : widget.maxLines,
            forceVerticalCenter: true,
          ),
        ),
      );
    } else {
      // 如果 content 类型不支持或为空，返回空容器
      textWidget = const SizedBox.shrink();
    }

    if (widget.marquee == false) {
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
              SizedBox(
                key: _key,
                height: textHeight,
                child: textWidget,
              ),
              SizedBox(width: emptyWidth),
              SizedBox(
                width: math.max(emptyWidth, contextWidth),
                height: textHeight,
                child: textWidget,
              )
            ],
          ),
        );
        break;
      case Axis.vertical:
        var content = _content as List<String>;
        child = SizedBox(
          height: widget.height,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            // physics: const NeverScrollableScrollPhysics(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < content.length; i++)
                    SizedBox(
                      height: widget.height,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TDText(
                          content[i],
                          style: _style!.textStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  SizedBox(
                    key: _key,
                    height: widget.height,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TDText(
                        content[0],
                        style: _style?.textStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ]),
          ),
        );
        break;
      default:
        child = textWidget;
        break;
    }
    return child;
  }

  void _onTap(trigger) {
    if (widget.onTap != null) {
      widget.onTap!(trigger);
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    _size = MediaQuery.of(context).size;
    return Container(
      padding: _style!.getPadding,
      color: _backgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        // spacing: 8,
        children: [
          /// 左侧widget
          if (widget.left != null)
            widget.left!
          else if (widget.prefixIcon != null)
            GestureDetector(
              onTap: () => _onTap('prefix-icon'),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                child: Icon(
                  widget.prefixIcon,
                  color: _style?.leftIconColor,
                  size: widget.height,
                ),
              ),
            ),

          /// 中间内容
          Expanded(
            key: _contentKey,
            child: GestureDetector(
              onTap: () => _onTap('context'),
              child: _contentWidget(),
            ),
          ),

          /// 左侧widget
          if (widget.right != null)
            widget.right!
          else if (widget.suffixIcon != null)
            GestureDetector(
                onTap: () => _onTap('suffix-icon'),
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: Icon(
                    widget.suffixIcon,
                    color: _style?.rightIconColor,
                    size: widget.height,
                  ),
                )),
        ],
      ),
    );
  }
}
