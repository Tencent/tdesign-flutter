import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../../../td_export.dart';

int currentIndex = 0;
bool isCustomStyle = false;
bool lastCustomStyle = false;

class TDTabBar extends StatefulWidget {
  /// tab数组
  final List<TDTab> tabs;

  /// tab控制器
  final TabController? controller;

  /// tabBar修饰
  final Decoration? decoration;

  /// tabBar背景色
  final Color? backgroundColor;

  /// tabBar下标颜色
  final Color? indicatorColor;

  /// tabBar下标高度
  final double? indicatorHeight;

  /// tabBar下标宽度
  final double? indicatorWidth;

  /// tabBar 已选标签颜色
  final Color? labelColor;

  /// tabBar未选标签颜色
  final Color? unselectedLabelColor;

  /// 是否滚动
  final bool isScrollable;

  /// 已选label字体
  final TextStyle? labelStyle;

  /// unselectedLabel字体
  final TextStyle? unselectedLabelStyle;

  /// tabBar宽度
  final double? width;

  /// tabBar高度
  final double? height;

  /// 引导padding
  final EdgeInsets? indicatorPadding;

  /// 自定义引导控件
  final Decoration? indicator;

  /// 是否展示引导控件
  final bool showIndicator;

  /// 自定义滑动
  final ScrollPhysics? physics;

  /// 点击事件
  final Function(int)? onTap;

  @override
  const TDTabBar(
      {Key? key,
      required this.tabs,
      this.controller,
      this.decoration,
      this.backgroundColor,
      this.indicatorColor,
      this.indicatorWidth,
      this.indicatorHeight,
      this.labelColor,
      this.unselectedLabelColor,
      this.isScrollable = false,
      this.unselectedLabelStyle,
      this.labelStyle,
      this.width,
      this.height,
      this.indicatorPadding,
      this.indicator,
      this.physics,
      this.onTap,
      this.showIndicator = false})
      : assert(
          backgroundColor == null || decoration == null,
          'Cannot provide both a backgroundColor and a decoration\n'
          'To provide both, use "decoration: BoxDecoration(color: color)".',
        ),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _TDTabBarState();
}

class _TDTabBarState extends State<TDTabBar> {
  /// 默认高度
  static const double _defaultHeight = 46;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? _defaultHeight,
      decoration:
          widget.decoration ?? BoxDecoration(color: widget.backgroundColor),
      child: TabBar(
        physics: widget.physics,
        isScrollable: widget.isScrollable,
        indicator: widget.indicator ?? _getIndicator(context),
        indicatorColor:
            widget.indicatorColor ?? TDTheme.of(context).brandNormalColor,
        unselectedLabelColor:
            widget.unselectedLabelColor ?? TDTheme.of(context).fontGyColor2,
        labelColor: widget.labelColor ?? TDTheme.of(context).brandNormalColor,
        labelStyle: widget.labelStyle ?? _getLabelStyle(context),
        unselectedLabelStyle:
            widget.unselectedLabelStyle ?? _getUnSelectLabelStyle(context),
        tabs: widget.tabs,
        indicatorPadding: widget.indicatorPadding ?? EdgeInsets.zero,
        controller: widget.controller,
        onTap: (index){
          widget.onTap?.call(index);
        },
      ),
    );
  }

  TextStyle _getUnSelectLabelStyle(BuildContext context) {
    return TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: TDTheme.of(context).fontXS?.size ?? 14,
        color: TDTheme.of(context).fontGyColor2);
  }

  TextStyle _getLabelStyle(BuildContext context) {
    return TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: TDTheme.of(context).fontXS?.size ?? 14,
        color: TDTheme.of(context).fontGyColor2);
  }

  Decoration _getIndicator(BuildContext context) {
    return widget.showIndicator
        ? TDTabBarIndicator(
            context: context,
            indicatorHeight: widget.indicatorHeight,
            indicatorWidth: widget.indicatorWidth)
        : TDNoneIndicator();
  }
}

/// TDesign自定义下标
class TDTabBarIndicator extends Decoration {
  final BuildContext? context;
  final double? indicatorWidth;
  final double? indicatorHeight;

  const TDTabBarIndicator(
      {this.context, this.indicatorWidth, this.indicatorHeight});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _TDTabBarIndicatorPainter(this, onChanged!);
}

class _TDTabBarIndicatorPainter extends BoxPainter {
  /// 下标宽度
  static const double _defaultIndicatorWidth = 56;

  /// 下标高度
  static const double _defaultIndicatorHeight = 1.5;

  final TDTabBarIndicator decoration;

  final _paint = Paint();

  _TDTabBarIndicatorPainter(this.decoration, VoidCallback onChanged) {
    if (isCustomStyle) {
      _paint.shader = ui.Gradient.linear(Offset.zero, Offset.zero, <Color>[
        TDTheme.of(decoration.context).brandNormalColor,
        TDTheme.of(decoration.context).brandNormalColor,
      ]);
    } else {
      /// 下标颜色
      _paint.color = TDTheme.of(decoration.context).brandNormalColor;
    }
    _paint.strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    canvas.drawLine(
        Offset(offset.dx + (configuration.size!.width - _indicatorWidth()) / 2,
            configuration.size!.height - _indicatorHeight()),
        Offset(offset.dx + (configuration.size!.width + _indicatorWidth()) / 2,
            configuration.size!.height - _indicatorHeight()),
        _paint..strokeWidth = _indicatorHeight());
  }

  double _indicatorHeight() =>
      decoration.indicatorHeight ?? _defaultIndicatorHeight;

  double _indicatorWidth() =>
      decoration.indicatorWidth ?? _defaultIndicatorWidth;
}

/// TDesign不展示下标
class TDNoneIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _TDNoneIndicatorPainter();
}

class _TDNoneIndicatorPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {}
}
