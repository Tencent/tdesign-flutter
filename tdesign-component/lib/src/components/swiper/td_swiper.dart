import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../../theme/td_colors.dart';
import '../../theme/td_theme.dart';

const _kAminatedDuration = 100;

/// TDesign风格的Swiper指示器样式，与flutter_swiper的Swiper结合使用
class TDSwiperPagination extends SwiperPlugin {
  const TDSwiperPagination(
      {this.alignment,
      this.key,
      this.margin = const EdgeInsets.all(10.0),
      this.builder = TDSwiperPagination.dots});

  /// 圆点样式
  static const SwiperPlugin dots = TDSwiperDotsPagination();

  /// 圆角矩形 + 圆点样式 默认宽度20，高度6
  static const SwiperPlugin dotsBar =
      TDSwiperDotsPagination(roundedRectangleWidth: 20);

  /// 数字样式
  static const SwiperPlugin fraction = TDFractionPagination();

  /// 箭头样式
  static const SwiperPlugin controls = TDSwiperArrowPagination();

  /// 当 scrollDirection== Axis.horizontal 时，默认Alignment.bottomCenter
  /// 当 scrollDirection== Axis.vertical 时，默认Alignment.centerRight
  final Alignment? alignment;

  /// 指示器和container之间的距离
  final EdgeInsetsGeometry margin;

  /// 具体样式
  final SwiperPlugin builder;

  final Key? key;

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    var alignment = this.alignment ??
        (config.scrollDirection == Axis.horizontal
            ? Alignment.bottomCenter
            : Alignment.centerRight);
    Widget child = Container(
      margin: margin,
      child: builder.build(context, config),
    );
    if (!config.outer) {
      child = Align(
        key: key,
        alignment: alignment,
        child: child,
      );
    }
    return child;
  }
}

class TDSwiperDotsPagination extends SwiperPlugin {
  /// 当前展示的索引，如果未设置，则为Theme.of(context).primaryColor
  final Color? activeColor;

  /// 如果未设置，则为 Theme.of(context).scaffoldBackgroundColor
  final Color? color;

  /// 选中状态圆点尺寸
  final double activeSize;

  /// 圆点尺寸
  final double size;

  /// 圆点间距
  final double space;

  /// 圆角矩形宽度（高度仍为activeSize）
  final double? roundedRectangleWidth;

  // 动画效果 默认100ms，设置为0则无动画
  final int? animationDuration;

  final Key? key;

  const TDSwiperDotsPagination({
    this.activeColor,
    this.color,
    this.key,
    this.size = 6.0,
    this.activeSize = 6.0,
    this.space = 4.0,
    this.roundedRectangleWidth,
    this.animationDuration,
  });

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    if (config.itemCount > 20) {
      print('warning: The itemCount is too big, '
          'we suggest use TDFractionPaginationBuilder');
    }
    var activeColor = this.activeColor ??
        (config.outer
            ? TDTheme.of(context).brandNormalColor
            : TDTheme.of(context).whiteColor1);
    var color = this.color ??
        (config.outer
            ? TDTheme.of(context).grayColor3
            : TDTheme.of(context).whiteColor1.withOpacity(0.55));

    if (config.indicatorLayout != PageIndicatorLayout.NONE &&
        config.layout == SwiperLayout.DEFAULT) {
      return PageIndicator(
        count: config.itemCount,
        controller: config.pageController,
        layout: config.indicatorLayout,
        size: size,
        activeColor: activeColor,
        color: color,
        space: space,
      );
    }

    var list = <Widget>[];

    var itemCount = config.itemCount;
    var activeIndex = config.activeIndex;

    for (var i = 0; i < itemCount; ++i) {
      var active = i == activeIndex;
      var isActiviRectangle =
          roundedRectangleWidth != null && roundedRectangleWidth! > 0 && active;
      double? scalableLen;
      double? fixedLen;

      scalableLen = isActiviRectangle
          ? roundedRectangleWidth
          : (active ? activeSize : size);
      fixedLen = active ? activeSize : size;

      list.add(Container(
        key: Key('pagination_$i'),
        margin: EdgeInsets.all(space),
        child: AnimatedContainer(
          duration:
              Duration(milliseconds: animationDuration ?? _kAminatedDuration),
          width: config.scrollDirection == Axis.horizontal ? scalableLen : fixedLen,
          height: config.scrollDirection == Axis.horizontal ? fixedLen : scalableLen,
          decoration: BoxDecoration(
              color: active ? activeColor : color,
              borderRadius: BorderRadius.circular(activeSize / 2)),
        ),
      ));
    }

    if (config.scrollDirection == Axis.vertical) {
      return Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    } else {
      return Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      );
    }
  }
}

class TDFractionPagination extends SwiperPlugin {
  // container宽度
  final double? width;

  // container高度
  final double? height;

  // 圆角角度
  final double? borderRadius;

  // 背景色
  final Color? backgroundColor;

  /// 如果未设置，则为 Theme.of(context).scaffoldBackgroundColor
  final Color? color;

  /// 当前展示的索引，如果未设置，则为Theme.of(context).primaryColor
  final Color? activeColor;

  final TextStyle? textStyle;

  final TextStyle? activeTextStyle;

  final Key? key;

  const TDFractionPagination({
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.color = Colors.white,
    this.textStyle = const TextStyle(fontSize: 12.0, color: Colors.white),
    this.activeTextStyle = const TextStyle(fontSize: 12.0, color: Colors.white),
    this.key,
    this.activeColor = Colors.white,
  });

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    Widget child;
    if (Axis.vertical == config.scrollDirection) {
      child = Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '${config.activeIndex + 1}',
            style: activeTextStyle,
          ),
          Text(
            '/',
            style: textStyle,
          ),
          Text(
            '${config.itemCount}',
            style: textStyle,
          )
        ],
      );
    } else {
      child = Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '${config.activeIndex + 1}',
            style: activeTextStyle,
          ),
          Text(
            '/${config.itemCount}',
            style: textStyle,
          )
        ],
      );
    }
    return Container(
      width: width ?? 37,
      height: height ?? 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0x66000000),
          borderRadius: BorderRadius.circular(borderRadius ?? 10)),
      child: child,
    );
  }
}

class TDSwiperArrowPagination extends SwiperPlugin {
  // 当设置 loop = false时，滑动到边界是否自动隐藏边界箭头
  final bool? autoHideWhenAtBoundary;

  // 左箭头widget
  final Widget? backArrow;

  // 右箭头widget
  final Widget? forwardArrow;

  // 背景圆形半径
  final double? radius;

  // 背景圆形颜色
  final Color? backgroundColor;

  const TDSwiperArrowPagination(
      {this.radius,
      this.backgroundColor,
      this.backArrow,
      this.forwardArrow,
      this.autoHideWhenAtBoundary = true});

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    var itemCount = config.itemCount;
    var activeIndex = config.activeIndex;

    return Row(children: [
      Visibility(
        visible: config.loop ||
            ((autoHideWhenAtBoundary ?? false) && activeIndex != 0),
        child: GestureDetector(
          child: CircleAvatar(
            radius: radius ?? 10.0,
            backgroundColor:
                backgroundColor ?? TDTheme.of(context).fontGyColor3,
            child: backArrow ??
                const Icon(
                  Icons.arrow_back_ios_outlined,
                  color: Colors.white,
                  size: 9,
                ),
          ),
          onTap: () {
            config.controller.previous();
          },
        ),
      ),
      const Spacer(),
      Visibility(
        visible: config.loop ||
            ((autoHideWhenAtBoundary ?? false) && activeIndex != itemCount - 1),
        child: GestureDetector(
          child: CircleAvatar(
            radius: radius ?? 10.0,
            backgroundColor:
                backgroundColor ?? TDTheme.of(context).fontGyColor3,
            child: forwardArrow ??
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.white,
                  size: 9,
                ),
          ),
          onTap: () {
            config.controller.next();
          },
        ),
      ),
    ]);
  }
}
