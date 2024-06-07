import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

/// 用于警告或提示
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
  });

  /// 文本内容
  final dynamic context;

  /// 文字样式
  final TDNoticeBarStyle? style;

  /// 左侧内容
  final Widget? left;

  /// 右侧内容
  final Widget? right;

  /// 跑马灯效果
  final bool? marquee;

  /// 滚动速度
  final double? speed;

  /// 步进滚动间隔时间（毫秒）
  final int? interval;

  /// 滚动方向（步进可选）
  final Axis? direction;

  /// 内置主题
  final TDNoticeBarTheme? theme;

  /// 前置图标
  final IconData? prefixIcon;

  /// 右侧图标
  final IconData? suffixIcon;

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

  @override
  void initState() {
    super.initState();
    if (widget.speed! < 0) {
      throw Exception('speed must not be less than 0');
    }
    if (widget.interval! <= 0) {
      throw Exception('stepDuration must not be less than 0');
    }
    _scrollController = ScrollController();
    _init();
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
    var scrollDistance = _getContextWidth() + _size!.width;
    if (_getContextWidth() > _size!.width) {
      scrollDistance = _getContextWidth() + _getEmptyWidth();
    }
    _scrollController!.jumpTo(0);
    var offset = 0.0 + widget.speed!;
    _scrollController!.animateTo(offset,
        duration: const Duration(seconds: 1), curve: Curves.linear);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      offset += widget.speed!;
      if (offset >= scrollDistance) {
        // 最后一阶段未滚动距离转化时间比（毫秒数）
        offset = 50;
        _scrollController!.jumpTo(0);
      }
      _scrollController!.animateTo(offset,
          duration: const Duration(seconds: 1), curve: Curves.linear);
    });
  }

  void _step() {}

  double _getFontSize() {
    return _style!.getTextStyle.fontSize ?? 16;
  }

  void _setLeftWidget() {
    if (widget.prefixIcon != null) {
      _left = Icon(
        widget.prefixIcon,
        color: widget.style?.leftIconColor,
      );
    }
    if (widget.left != null) {
      _left = widget.left;
    }
  }

  void _setRightWidget() {
    if (widget.suffixIcon != null) {
      _right = Icon(
        widget.suffixIcon,
        color: widget.style?.rightIconColor,
      );
    }
    if (widget.right != null) {
      _right = widget.right;
    }
  }

  double _getContextWidth() {
    var contextWidth = _getFontSize() * widget.context!.length;
    if (contextWidth > _size!.width) {
      return contextWidth;
    }
    return _size!.width;
  }

  double _getEmptyWidth() {
    print('32ssss::::::::::${_style!.getPadding}:::${_style!.getPadding.horizontal}');
    return _size!.width - _style!.getPadding.horizontal;
  }

  Widget _contextWidget() {
    Widget textWidget = TDText(widget.context, style: _style?.getTextStyle);
    Widget? child = textWidget;
    switch (widget.direction) {
      case Axis.horizontal:
        child = SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: widget.direction!,
          // physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: [
              SizedBox(
                width: _getContextWidth(),
                height: _getFontSize(),
                child: textWidget,
              ),
              SizedBox(width: _getEmptyWidth()),
              SizedBox(
                width: _getContextWidth(),
                height: _getFontSize(),
                child: textWidget,
              )
            ],
          ),
        );
        break;
      case Axis.vertical:
        break;
      default:
        child = textWidget;
        break;
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Container(
      width: _size!.width,
      height: _getFontSize() + _style!.getPadding.vertical,
      padding: _style!.getPadding,
      decoration: BoxDecoration(
        color: _backgroundColor,
      ),
      child: Row(
        children: [
          Visibility(
            visible: _left != null,
            child: Container(
              child: _left,
            ),
          ),
          Expanded(
            child: _contextWidget(),
          ),
          Visibility(
            visible: _right != null,
            child: Container(
              child: _right,
            ),
          ),
        ],
      ),
    );
  }
}
