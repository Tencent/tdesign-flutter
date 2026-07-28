import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';
import 't_horizontal_tab_bar.dart';
import 't_tab.dart';
import 't_tab_bar_theme_data.dart';

/// 标签栏
///
/// 支持滚动、指示器自定义、胶囊/填充/卡片样式等。
class TTabsBar extends StatelessWidget {
  const TTabsBar({
    Key? key,
    required this.tabs,
    this.controller,
    this.decoration,
    this.isScrollable = false,
    this.indicator,
    this.onTap,
    this.variant = TTabsBarVariant.filled,
  }) : super(key: key);

  /// tab数组
  final List<TTab> tabs;

  /// tab控制器
  final TabController? controller;

  /// tabBar 修饰；非空时覆盖 Theme 的背景和分割线。
  final Decoration? decoration;

  /// 是否横向滚动。
  final bool isScrollable;

  /// 自定义指示器；非空时覆盖 Theme 指示器。
  final Decoration? indicator;

  /// 点击事件
  final ValueChanged<int>? onTap;

  /// 选项卡样式。
  final TTabsBarVariant variant;
  TTabsBarThemeData _themeData(BuildContext context) =>
      Theme.of(context).extension<TTabsBarThemeData>() ??
      const TTabsBarThemeData();

  @override
  Widget build(BuildContext context) {
    final themeData = _themeData(context);
    final dividerHeight = themeData.dividerHeight ?? 0.5;
    final backgroundColor =
        themeData.backgroundColor ?? context.tTheme.bgColorContainer;
    return Container(
      height: 48,
      decoration: decoration ??
          (variant == TTabsBarVariant.card
              ? BoxDecoration(color: backgroundColor)
              : BoxDecoration(
                  color: backgroundColor,
                  border: dividerHeight <= 0
                      ? null
                      : Border(
                          bottom: BorderSide(
                              color: themeData.dividerColor ??
                                  context.tTheme.componentStrokeColor,
                              width: dividerHeight)))),
      child: THorizontalTabBar(
        isScrollable: isScrollable,
        indicator: indicator ?? themeData.indicator ?? _TNoneIndicator(),
        labelStyle: themeData.labelStyle ?? _getLabelStyle(context),
        labelPadding: themeData.labelPadding ?? const EdgeInsets.all(8),
        unselectedLabelStyle:
            themeData.unselectedLabelStyle ?? _getUnSelectLabelStyle(context),
        tabs: tabs,
        variant: variant,
        controller: controller,
        backgroundColor: themeData.backgroundColor,
        selectedBgColor: themeData.selectedBgColor,
        unSelectedBgColor: themeData.unSelectedBgColor ??
            context.tTheme.bgColorSecondaryContainer,
        tabAlignment: isScrollable ? TabAlignment.start : TabAlignment.fill,
        onTap: (index) {
          onTap?.call(index);
        },
      ),
    );
  }

  TextStyle _getUnSelectLabelStyle(BuildContext context) {
    return (Theme.of(context).textTheme.bodyMedium ?? const TextStyle())
        .copyWith(
      fontWeight: FontWeight.w400,
      color: context.tTheme.textColorPrimary,
    );
  }

  TextStyle _getLabelStyle(BuildContext context) {
    return (Theme.of(context).textTheme.bodyMedium ?? const TextStyle())
        .copyWith(
      fontWeight: FontWeight.w600,
      color: context.tTheme.textColorPrimary,
    );
  }
}

/// TDesign自定义下标
class TTabsBarIndicator extends Decoration {
  /// 指示器宽度
  final double? indicatorWidth;

  /// 指示器高度
  final double? indicatorHeight;

  /// 指示器颜色
  final Color indicatorColor;

  const TTabsBarIndicator({
    required this.indicatorColor,
    this.indicatorWidth,
    this.indicatorHeight,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _TTabsBarIndicatorPainter(this, onChanged);
}

class _TTabsBarIndicatorPainter extends BoxPainter {
  static const double _defaultIndicatorWidth = 16;
  static const double _defaultIndicatorHeight = 3;

  final TTabsBarIndicator decoration;
  final _paint = Paint();

  _TTabsBarIndicatorPainter(this.decoration, VoidCallback? onChanged) {
    _paint.color = decoration.indicatorColor;
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

  double _indicatorHeight() =>
      decoration.indicatorHeight ?? _defaultIndicatorHeight;

  double _indicatorWidth() =>
      decoration.indicatorWidth ?? _defaultIndicatorWidth;
}

/// 空指示器（不渲染任何内容）
class _TNoneIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _TNoneIndicatorPainter();
}

class _TNoneIndicatorPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {}
}
