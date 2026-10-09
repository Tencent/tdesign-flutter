import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_font_family.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import 't_horizontal_tab_bar.dart';
import 't_tab.dart';
import 't_tab_bar_theme_data.dart';

/// 选项卡文字尺寸。
enum TTabsBarSize {
  /// 小尺寸，使用 14px 字体 Token。
  small,

  /// 大尺寸，使用 16px 字体 Token。
  large,
}

/// 标签栏
///
/// 支持滚动、指示器自定义，以及 Line、Tag、Card 三种 TDesign 形态。
///
/// ### 主题配置
///
/// 组件主题通过 [TTabsBarThemeData] 配置，放入 Flutter [ThemeData.extensions]
/// 后作用于对应子树。可配置字段和未设置时的回退见本页的
/// `TTabsBarThemeData` 配置项。
class TTabsBar extends StatelessWidget {
  const TTabsBar({
    Key? key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.onTap,
    this.size = TTabsBarSize.small,
    this.variant = TTabsBarVariant.line,
  }) : super(key: key);

  /// tab数组
  final List<TTab> tabs;

  /// 可选的标签控制器；为空时使用最近的 [DefaultTabController]。
  ///
  /// 仅在需要读取当前索引、命令式切换或跨组件共享状态时显式传入。
  /// 必须存在显式控制器或祖先 DefaultTabController，其 length 须等于 tabs.length。显式控制器由调用方释放。
  final TabController? controller;

  /// 是否横向滚动。
  final bool isScrollable;

  /// 点击事件
  /// 仅用于点击通知；为 null 时仍可切换标签，禁用单项请使用 TTab.enabled。
  final ValueChanged<int>? onTap;

  /// 选项卡文字尺寸，默认为 [TTabsBarSize.small]。
  final TTabsBarSize size;

  /// 选项卡结构形态，默认为 [TTabsBarVariant.line]。
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
    final resolvedIndicator = themeData.indicator ?? _defaultIndicator(context);
    return Container(
      height: 48,
      decoration: variant == TTabsBarVariant.card
          ? BoxDecoration(color: backgroundColor)
          : BoxDecoration(
              color: backgroundColor,
              border: dividerHeight <= 0
                  ? null
                  : Border(
                      bottom: BorderSide(
                        color:
                            themeData.dividerColor ??
                            context.tTheme.componentStroke,
                        width: dividerHeight,
                      ),
                    ),
            ),
      child: THorizontalTabBar(
        isScrollable: isScrollable,
        indicator: resolvedIndicator,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: themeData.labelStyle?.color ?? context.tTheme.brandColor,
        labelStyle: themeData.labelStyle ?? _getLabelStyle(context),
        labelPadding:
            themeData.labelPadding ??
            (variant == TTabsBarVariant.tag
                // 标签之间的外间距；胶囊内部留白由 THorizontalTabBar 负责。
                ? const EdgeInsets.all(4)
                : const EdgeInsets.all(8)),
        unselectedLabelColor:
            themeData.unselectedLabelStyle?.color ??
            context.tTheme.textColorPrimary,
        unselectedLabelStyle:
            themeData.unselectedLabelStyle ?? _getUnSelectLabelStyle(context),
        tabs: tabs,
        variant: variant,
        controller: controller,
        backgroundColor: backgroundColor,
        selectedTagBackgroundColor: themeData.selectedTagBackgroundColor,
        tagBackgroundColor:
            themeData.tagBackgroundColor ??
            context.tTheme.bgColorSecondaryContainer,
        tabAlignment: isScrollable ? TabAlignment.start : TabAlignment.fill,
        overlayColor: const WidgetStatePropertyAll<Color?>(Colors.transparent),
        onTap: onTap,
      ),
    );
  }

  Decoration _defaultIndicator(BuildContext context) {
    if (variant != TTabsBarVariant.line) {
      return _TNoneIndicator();
    }
    return TTabsBarIndicator(indicatorColor: context.tTheme.brandColor);
  }

  TextStyle _getUnSelectLabelStyle(BuildContext context) {
    final tokenFont = size == TTabsBarSize.large
        ? context.tTheme.fontBodyLarge
        : context.tTheme.fontBodyMedium;
    final tokenFontFamily = context.tTheme.fontFamily;
    return TextStyle(
      fontSize: tokenFont?.size,
      height: tokenFont?.height,
      fontWeight: tokenFont?.fontWeight,
      fontFamily: tokenFontFamily?.flutterFontFamily,
      fontFamilyFallback: tokenFontFamily?.flutterFontFamilyFallback,
    ).copyWith(
      fontWeight: FontWeight.w400,
      color: context.tTheme.textColorPrimary,
    );
  }

  TextStyle _getLabelStyle(BuildContext context) {
    final tokenFont = size == TTabsBarSize.large
        ? context.tTheme.fontBodyLarge
        : context.tTheme.fontBodyMedium;
    final tokenFontFamily = context.tTheme.fontFamily;
    return TextStyle(
      fontSize: tokenFont?.size,
      height: tokenFont?.height,
      fontWeight: tokenFont?.fontWeight,
      fontFamily: tokenFontFamily?.flutterFontFamily,
      fontFamilyFallback: tokenFontFamily?.flutterFontFamilyFallback,
    ).copyWith(fontWeight: FontWeight.w600, color: context.tTheme.brandColor);
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
      Offset(
        offset.dx + (configuration.size!.width - _indicatorWidth()) / 2,
        configuration.size!.height - _indicatorHeight() / 2,
      ),
      Offset(
        offset.dx + (configuration.size!.width + _indicatorWidth()) / 2,
        configuration.size!.height - _indicatorHeight() / 2,
      ),
      _paint..strokeWidth = _indicatorHeight(),
    );
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
