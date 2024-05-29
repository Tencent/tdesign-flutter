import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../icon/td_icons.dart';

enum TdNoticeBarType {
  none,
  scroll,
  step,
}

class TDNoticeBar extends StatefulWidget {
  const TDNoticeBar({
    super.key,
    this.text,
    this.textList,
    this.textStyle,
    this.left,
    this.right,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.duration = 2000,
    this.stepDuration = 2000,
    this.type = TdNoticeBarType.none,
  });

  /// 显示内容
  final String? text;

  /// 步进滚动内容
  final List<String>? textList;

  /// 文字样式
  final TextStyle? textStyle;

  /// 左侧内容
  final Widget? left;

  /// 右侧内容
  final Widget? right;

  /// 背景色
  final Color? backgroundColor;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 滚动周期
  final int? duration;

  /// 步进滚动停留时间
  final int? stepDuration;

  /// 滚动类型
  final TdNoticeBarType? type;

  @override
  State<StatefulWidget> createState() => _TDNoticeBarState();
}

class _TDNoticeBarState extends State<TDNoticeBar> {
  late ScrollController _scrollController;
  final GlobalKey _key = GlobalKey();
  Timer? _timer;
  late Size _size;

  @override
  void initState() {
    super.initState();
    if (widget.duration! <= 0) {
      throw Exception('duration must not be less than 0');
    }
    if (widget.stepDuration! <= 0) {
      throw Exception('stepDuration must not be less than 0');
    }
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      _startTimer();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _scrollController.dispose();
  }

  void _startTimer() {
    if (widget.type == TdNoticeBarType.scroll) {
      _scrollScroll();
    } else if (widget.type == TdNoticeBarType.step) {
      _stepScroll();
    }
  }

  void _scrollScroll() {
    if (widget.text == null) {
      throw Exception('text must not be null when type is scroll');
    }
    _scrollController.jumpTo(0);
    _scrollController.animateTo(_size.width,
        duration: Duration(milliseconds: widget.duration!),
        curve: Curves.linear);
    _timer =
        Timer.periodic(Duration(milliseconds: widget.duration!), (Timer timer) {
      _scrollController.jumpTo(0);
      _scrollController.animateTo(_size.width,
          duration: Duration(milliseconds: widget.duration!),
          curve: Curves.linear);
    });
  }

  Future<void> _stepScroll() async {
    if (widget.textList == null) {
      throw Exception('textList must not be null when type is step');
    }
    var index = 0;
    var offset = 0.0;
    _scrollController.jumpTo(0);
    await Future.delayed(Duration(milliseconds: widget.stepDuration!), () {
      offset += _size.width;
      _scrollController.animateTo(offset,
          duration: Duration(milliseconds: widget.duration!),
          curve: Curves.linear);
      index++;
    });
    _timer = Timer.periodic(
        Duration(milliseconds: widget.stepDuration! + widget.duration!),
        (Timer timer) {
      if (index > widget.textList!.length - 1) {
        index = 0;
        offset = 0;
        _scrollController.jumpTo(0);
      }
      offset += _size.width;
      index++;
      _scrollController.animateTo(offset,
          duration: Duration(milliseconds: widget.duration!),
          curve: Curves.linear);
    });
  }

  Widget _children() {
    if (widget.textList != null) {
      return Row(
        children: [
          for (var i = 0; i < widget.textList!.length; i++)
            SizedBox(
              width: _size.width,
              child: Text(
                widget.textList![i],
                style: widget.textStyle,
              ),
            ),
          SizedBox(width: _size.width, child: Text(widget.textList![0]))
        ],
      );
    }
    return Row(
      children: [
        SizedBox(
          width: _size.width,
          child: Text(
            widget.text!,
            style: widget.textStyle,
          ),
        ),
        SizedBox(
          width: _size.width,
          child: Text(
            widget.text!,
            style: widget.textStyle,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
      ),
      child: Row(
        children: [
          Visibility(
            visible: widget.left != null,
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              child: widget.left,
            ),
          ),
          Expanded(
              key: _key,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  child: _children())),
          Visibility(
            visible: widget.right != null,
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              child: widget.right,
            ),
          ),
        ],
      ),
    );
  }
}
