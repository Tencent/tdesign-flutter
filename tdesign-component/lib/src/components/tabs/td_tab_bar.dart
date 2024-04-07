import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 'td_horizontal_tab_bar.dart';

enum TDTabBarOutlineType {
  // 填充样式
  filled,
  // 胶囊样式
  capsule,
  // 卡片
  card
}

class TDTabBar extends StatefulWidget {
  const TDTabBar({
    Key? key,
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
    this.labelPadding,
    this.indicator,
    this.physics,
    this.onTap,
    this.outlineType = TDTabBarOutlineType.filled,
    this.showIndicator = false,
    this.dividerColor,
    this.dividerHeight = 0.5,
  })  : assert(
          backgroundColor == null || decoration == null,
          'Cannot provide both a backgroundColor and a decoration\n'
          'To provide both, use "decoration: BoxDecoration(color: color)".',
        ),
        super(key: key);

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

  /// tab间距
  final EdgeInsetsGeometry? labelPadding;

  /// 选项卡样式
  final TDTabBarOutlineType outlineType;

  /// 分割线颜色
  final Color? dividerColor;

  /// 分割线高度,小于等于0则不展示分割线
  final double dividerHeight;

  @override
  State<StatefulWidget> createState() => _TDTabBarState();
}

class _TDTabBarState extends State<TDTabBar> {
  /// 默认高度
  static const double _defaultHeight = 48;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? _defaultHeight,
      decoration: widget.decoration ??
          (widget.outlineType == TDTabBarOutlineType.card
              ? BoxDecoration(color: widget.backgroundColor)
              : BoxDecoration(
                  color: widget.backgroundColor,
                  border: widget.dividerHeight <= 0
                      ? null
                      : Border(
                          bottom: BorderSide(
                              color: widget.dividerColor ?? TDTheme.of(context).grayColor3,
                              width: widget.dividerHeight)))),
      child: TDHorizontalTabBar(
        physics: widget.physics,
        isScrollable: widget.isScrollable,
        indicator: widget.indicator ?? _getIndicator(context),
        indicatorColor: widget.indicatorColor ?? TDTheme.of(context).brandNormalColor,
        unselectedLabelColor: widget.unselectedLabelColor ?? TDTheme.of(context).fontGyColor2,
        labelColor: widget.labelColor ?? TDTheme.of(context).brandNormalColor,
        labelStyle: widget.labelStyle ?? _getLabelStyle(context),
        labelPadding: widget.labelPadding ?? const EdgeInsets.all(8),
        unselectedLabelStyle: widget.unselectedLabelStyle ?? _getUnSelectLabelStyle(context),
        tabs: widget.tabs,
        indicatorPadding: widget.indicatorPadding ?? EdgeInsets.zero,
        outlineType: widget.outlineType,
        controller: widget.controller,
        onTap: (index) {
          widget.onTap?.call(index);
        },
      ),
    );
  }

  TextStyle _getUnSelectLabelStyle(BuildContext context) {
    return TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: TDTheme.of(context).fontBodySmall?.size ?? 14,
        color: TDTheme.of(context).fontGyColor2);
  }

  TextStyle _getLabelStyle(BuildContext context) {
    return TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: TDTheme.of(context).fontBodySmall?.size ?? 14,
        color: TDTheme.of(context).fontGyColor2);
  }

  Decoration _getIndicator(BuildContext context) {
    return widget.showIndicator
        ? TDTabBarIndicator(
            context: context,
            indicatorHeight: widget.indicatorHeight,
            indicatorWidth: widget.indicatorWidth,
            indicatorColor: widget.indicatorColor)
        : TDNoneIndicator();
  }
}

/// TDesign自定义下标
class TDTabBarIndicator extends Decoration {
  final BuildContext? context;
  final double? indicatorWidth;
  final double? indicatorHeight;
  final Color? indicatorColor;

  const TDTabBarIndicator({this.context, this.indicatorWidth, this.indicatorHeight, this.indicatorColor});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _TDTabBarIndicatorPainter(this, onChanged!);
}

class _TDTabBarIndicatorPainter extends BoxPainter {
  /// 下标宽度
  static const double _defaultIndicatorWidth = 16;

  /// 下标高度
  static const double _defaultIndicatorHeight = 3;

  final TDTabBarIndicator decoration;

  final _paint = Paint();

  _TDTabBarIndicatorPainter(this.decoration, VoidCallback onChanged) {
    /// 下标颜色
    _paint.color = decoration.indicatorColor ?? TDTheme.of(decoration.context).brandNormalColor;
    _paint.strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    canvas.drawLine(
        Offset(offset.dx + (configuration.size!.width - _indicatorWidth()) / 2,
            configuration.size!.height - _indicatorHeight() / 2),
        Offset(offset.dx + (configuration.size!.width + _indicatorWidth()) / 2,
            configuration.size!.height - _indicatorHeight() / 2),
        _paint..strokeWidth = _indicatorHeight());
  }

  double _indicatorHeight() => decoration.indicatorHeight ?? _defaultIndicatorHeight;

  double _indicatorWidth() => decoration.indicatorWidth ?? _defaultIndicatorWidth;
}

/// TDesign自定义下标 竖向
class TDTabBarVerticalIndicator extends Decoration {
  final BuildContext? context;
  final double? indicatorWidth;
  final double? indicatorHeight;

  const TDTabBarVerticalIndicator({this.context, this.indicatorWidth, this.indicatorHeight});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _TDTabBarVerticalIndicatorPainter(this, onChanged!);
}

class _TDTabBarVerticalIndicatorPainter extends BoxPainter {
  /// 下标宽度
  static const double _defaultIndicatorWidth = 1.5;

  /// 下标高度
  static const double _defaultIndicatorHeight = 54;

  final TDTabBarVerticalIndicator decoration;

  final _paint = Paint();

  _TDTabBarVerticalIndicatorPainter(this.decoration, VoidCallback onChanged) {
    /// 下标颜色
    _paint.color = TDTheme.of(decoration.context).brandNormalColor;
    _paint.strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    canvas.drawLine(
        Offset(
          0 + _indicatorWidth() / 2,
          offset.dx + (configuration.size!.width - _indicatorHeight()) / 2,
        ),
        Offset(
          0 + _indicatorWidth() / 2,
          offset.dx + (configuration.size!.width + _indicatorHeight()) / 2,
        ),
        _paint..strokeWidth = _indicatorWidth());
  }

  double _indicatorHeight() => decoration.indicatorHeight ?? _defaultIndicatorHeight;

  double _indicatorWidth() => decoration.indicatorWidth ?? _defaultIndicatorWidth;
}

/// TDesign不展示下标
class TDNoneIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _TDNoneIndicatorPainter();
}

class _TDNoneIndicatorPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {}
}
