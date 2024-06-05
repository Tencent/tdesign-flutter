import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../icon/td_icons.dart';

enum TdNoticeBarType {
  none,
  scroll,
  step,
}

/// 用于警告或提示
class TDNoticeBar extends StatefulWidget {
  const TDNoticeBar({
    super.key,
    this.context,
    this.contexts,
    this.textStyle,
    this.left,
    this.right,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.duration = 3000,
    this.interval = 2000,
    this.type = TdNoticeBarType.scroll,
    this.direction = Axis.horizontal,
  });

  /// 文本内容
  final String? context;

  /// 步进滚动内容
  final List<String>? contexts;

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

  /// 滚动周期（毫秒）
  final int? duration;

  /// 步进滚动间隔时间（毫秒）
  final int? interval;

  /// 滚动类型
  final TdNoticeBarType? type;

  /// 滚动方向（步进可选）
  final Axis? direction;

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
    if (widget.interval! <= 0) {
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
    if (widget.context == null) {
      throw Exception('text must not be null when type is scroll');
    }
    if (widget.direction == Axis.vertical) {
      throw Exception('direction must be horizontal when type is scroll');
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
    if (widget.contexts == null || widget.contexts!.isEmpty) {
      throw Exception('textList must not be null when type is step');
    }
    var index = 0;
    var offset = 0.0;
    var scrollDistance =
        widget.direction == Axis.horizontal ? _size.width : _getFontSize();
    _scrollController.jumpTo(0);
    await Future.delayed(Duration(milliseconds: widget.interval!), () {
      offset += scrollDistance;
      _scrollController.animateTo(offset,
          duration: Duration(milliseconds: widget.duration!),
          curve: Curves.linear);
      index++;
    });
    _timer = Timer.periodic(
        Duration(milliseconds: widget.interval! + widget.duration!),
        (Timer timer) {
      if (index > widget.contexts!.length - 1) {
        index = 0;
        offset = 0;
        _scrollController.jumpTo(0);
      }
      offset += scrollDistance;
      index++;
      _scrollController.animateTo(offset,
          duration: Duration(milliseconds: widget.duration!),
          curve: Curves.linear);
    });
  }

  Widget _buildWidget() {
    if (widget.direction == Axis.horizontal) {
      return Row(children: _children());
    }
    return Column(children: _children());
  }

  List<Widget> _children() {
    if (widget.contexts != null) {
      var items = <Widget>[];
      for (var i = 0; i < widget.contexts!.length; i++) {
        items.add(
          SizedBox(
            width: _size.width,
            child: Text(
              widget.contexts![i],
              style: widget.textStyle,
            ),
          ),
        );
      }
      items.add(SizedBox(width: _size.width, child: Text(widget.contexts![0])));
      return items;
    }
    return [
      SizedBox(
        width: _size.width,
        child: Text(
          widget.context!,
          style: widget.textStyle,
        ),
      ),
      SizedBox(
        width: _size.width,
        child: Text(
          widget.context!,
          style: widget.textStyle,
        ),
      ),
    ];
  }

  double _getFontSize() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.context ?? widget.contexts![0],
        style: widget.textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: _size.width);
    return textPainter.size.height;
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Container(
      height: _getFontSize() + widget.padding!.vertical,
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
                  scrollDirection: widget.direction!,
                  controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  child: _buildWidget())),
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
