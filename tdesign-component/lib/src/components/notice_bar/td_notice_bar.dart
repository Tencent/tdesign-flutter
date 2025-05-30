import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../tdesign_flutter.dart';

class TDNoticeBar extends StatefulWidget {
  const TDNoticeBar({
    super.key,
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
  });

  /// 文本内容
  final dynamic context;

  /// 公告栏样式
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
  Widget? _left;
  Widget? _right;
  final GlobalKey _key = GlobalKey();
  final GlobalKey _contextKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.speed! < 0) {
      throw Exception('speed must not be less than 0');
    }
    if (widget.interval! <= 0) {
      throw Exception('interval must not be less than 0');
    }
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      if (widget.marquee == true) {
        _startTimer();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _scrollController?.dispose();
  }

  void _init() {
    if (widget.style != null) {
      _style = widget.style;
    } else {
      _style = TDNoticeBarStyle.generateTheme(context, theme: widget.theme);
    }
    _backgroundColor = _style!.backgroundColor;
    _setLeftWidget();
    _setRightWidget();
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
      if (step >= widget.context.length) {
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
    var text = widget.context;
    if (widget.context is List<String>) {
      text = widget.context[0];
    }
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: _style!.getTextStyle,
      ),
      locale: Localizations.localeOf(context),
      textDirection: TextDirection.ltr,
      maxLines: widget.marquee! ? 1 : widget.maxLines,
    )..layout(maxWidth: _size!.width);
    return textPainter.size;
  }

  /// 设置左侧内容
  void _setLeftWidget() {
    if (widget.prefixIcon != null) {
      _left = Icon(
        widget.prefixIcon,
        color: _style!.leftIconColor,
        size: widget.height,
      );
    }
    if (widget.left != null) {
      _left = widget.left;
    }
  }

  /// 设置右侧内容
  void _setRightWidget() {
    if (widget.suffixIcon != null) {
      _right = Icon(
        widget.suffixIcon,
        color: _style!.rightIconColor,
        size: widget.height,
      );
    }
    if (widget.right != null) {
      _right = widget.right;
    }
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
    return _contextKey.currentContext
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
  Widget _contextWidget() {
    var valid = false;
    Widget? textWidget;
    if (widget.context is String) {
      valid = true;
      textWidget = SizedBox(
        height: _getTextHeight(),
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: _getTextHeight(),
            child: TDText(
              widget.context,
              style: _style?.getTextStyle,
              maxLines: widget.marquee! ? 1 : widget.maxLines,
              forceVerticalCenter: true,
            ),
          ),
        ),
      );
    }
    if (widget.context is List<String>) {
      valid = true;
      textWidget = SizedBox(
        height: _getTextHeight(),
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: _getTextHeight(),
            child: TDText(
              widget.context[0],
              style: _style?.getTextStyle,
              maxLines: 1,
              forceVerticalCenter: true,
            ),
          ),
        ),
      );
    }
    if (!valid) {
      throw Exception('context must be String or List<String>');
    }
    if (widget.marquee == false) {
      return textWidget!;
    }
    Widget? child;
    switch (widget.direction) {
      case Axis.horizontal:
        child = SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: [
              SizedBox(
                key: _key,
                height: _getTextHeight(),
                child: textWidget,
              ),
              SizedBox(width: _getEmptyWidth()),
              SizedBox(
                width: _getEmptyWidth() > _getContextWidth()
                    ? _getEmptyWidth()
                    : _getContextWidth(),
                height: _getTextHeight(),
                child: textWidget,
              )
            ],
          ),
        );
        break;
      case Axis.vertical:
        var contexts = widget.context as List<String>;
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
                  for (int i = 0; i < contexts.length; i++)
                    SizedBox(
                      height: widget.height,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TDText(
                          contexts[i],
                          style: _style!.getTextStyle,
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
                        contexts[0],
                        style: _style?.getTextStyle,
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
    return child!;
  }

  void _onTap(trigger) {
    if (widget.onTap != null) {
      widget.onTap!(trigger);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 初始化样式及左右widget
    _init();
    _size = MediaQuery.of(context).size;
    return Container(
      padding: _style!.getPadding,
      decoration: BoxDecoration(
        color: _backgroundColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Visibility(
            visible: _left != null,
            child: GestureDetector(
              onTap: () => _onTap('prefix-icon'),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                child: _left,
              ),
            ),
          ),
          Expanded(
            key: _contextKey,
            child: GestureDetector(
              onTap: () => _onTap('context'),
              child: _contextWidget(),
            ),
          ),
          Visibility(
            visible: _right != null,
            child: GestureDetector(
              onTap: () => _onTap('suffix-icon'),
              child: _right,
            ),
          ),
        ],
      ),
    );
  }
}
