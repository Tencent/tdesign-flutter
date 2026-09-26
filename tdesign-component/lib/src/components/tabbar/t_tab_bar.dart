import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/basic.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_shadows.dart';
import '../../theme/t_theme.dart';
import '../badge/t_badge.dart';
import '../badge/t_badge_internal.dart';
import '../badge/t_badge_layout.dart';
import '../text/t_text.dart';
import '../text/t_text_resolve.dart';
import 't_tab_bar_theme_data.dart';

/// 展开项 向下箭头宽
const double _kArrowWidth = 13.5;

/// 展开项  向下箭头高
const double _kArrowHeight = 8;

/// 展开项选项弹窗 单个item最低高度
const double _kMenuItemMinHeight = 23;

/// 展开项弹窗 单个item默认高度
const double _kDefaultMenuItemHeight = 48;

/// 展开项弹窗默认最小宽度
const double _kDefaultMenuMinWidth = 107;

/// 展开项弹窗默认宽度相对按钮宽度的收缩量
const double _kDefaultMenuItemWidthShrink = 20;

/// 导航栏默认高度
const double _kDefaultTabBarHeight = 56;

/// 图标项与图文项的默认图标尺寸；显式 Icon.size 仍优先。
const double _kDefaultTabIconSize = 20;

/// 左右图文项的内置图文间距；上下排列不留额外间距。
const double _kInlineIconTextGap = 4;

/// 标签栏的内边距与项间距；胶囊栏另有页面侧边距。
const double _kCapsuleOuterMargin = 16;
const double _kBarPadding = 8;
const double _kItemGap = 8;

/// 展开项弹窗弹出动画时间
const Duration _kPopupMenuDuration = Duration(milliseconds: 10);

/// 展开项弹窗距离触发按钮的间距
const double _kPopupButtonPadding = 8.0;

/// 展开项弹窗箭头和触发按钮的间距
const double _kPopupArrowGap = 4.0;

/// 纯文本标签比图标锚点宽，默认向逻辑起始方向收进 6px。
const Offset _kTextBadgeOffset = Offset(-6, 0);

/// 展开项弹窗距离视口边界的安全距离
const double _kPopupViewportPadding = 8.0;

/// 底部标签栏内容类型。
enum TTabBarType {
  /// 纯文本标签栏。
  text,

  /// 图标加文本标签栏。
  iconText,

  /// 纯图标标签栏。
  icon,

  /// 带弹出菜单的双层级文本标签栏。
  doubleLayer,
}

/// 单个标签项的选中样式。
enum TTabBarItemStyle {
  /// 仅改变前景色。
  normal,

  /// 使用浅色胶囊背景强调选中项。
  label,
}

/// 标签栏容器样式。
enum TTabBarStyle {
  /// 铺满父容器。
  filled,

  /// 带外边距、圆角和阴影的悬浮胶囊。
  capsule,
}

/// 图文标签项中图标与文字的排列方式，仅对 [TTabBarType.iconText] 生效。
enum TTabBarIconTextLayout {
  /// 图标在上、文字在下；默认布局。
  stacked,

  /// 图标在左、文字在右。
  inline,
}

/// 底部标签栏基本类型
enum _TTabBarBasicType {
  /// 单层级纯文本标签栏
  text,

  /// 文本加图标标签栏
  iconText,

  /// 纯图标标签栏
  icon,

  /// 双层级纯文本标签栏
  expansionPanel,
}

/// 底部标签栏组件样式
/// 指示器动画类型
enum TTabBarIndicatorAnimation {
  /// 无动画，瞬间切换
  none,

  /// 线性滑动：指示器匀速从一个 tab 滑到另一个
  linear,

  /// 弹性动画：指示器先拉伸后收缩
  elastic,
}

extension _TTabBarTypeResolve on TTabBarType {
  _TTabBarBasicType get basicType {
    switch (this) {
      case TTabBarType.text:
        return _TTabBarBasicType.text;
      case TTabBarType.iconText:
        return _TTabBarBasicType.iconText;
      case TTabBarType.icon:
        return _TTabBarBasicType.icon;
      case TTabBarType.doubleLayer:
        return _TTabBarBasicType.expansionPanel;
    }
  }
}

/// 单个 tab 配置
class TTabBarItemConfig {
  const TTabBarItemConfig({
    this.onTap,
    this.selectedIcon,
    this.unselectedIcon,
    this.tabText,
    this.selectTabTextStyle,
    this.unselectTabTextStyle,
    this.badge,
    this.popUpButtonConfig,
    this.onLongPress,
    this.allowMultipleTaps = false,
  });

  /// 选中时图标。未指定尺寸的 Icon 默认使用 TabBar 的 20px 图标尺寸；
  /// Icon 自身显式指定的尺寸优先。
  final Widget? selectedIcon;

  /// 未选中时图标。尺寸默认值与 [selectedIcon] 相同。
  final Widget? unselectedIcon;

  /// tab 文本
  final String? tabText;

  /// 选中时的文字样式，按字段覆盖继承主题与内置默认值。
  final TextStyle? selectTabTextStyle;

  /// 未选中时的文字样式，按字段覆盖继承主题与内置默认值。
  final TextStyle? unselectTabTextStyle;

  /// 标签项被选中时的附加点击回调。
  ///
  /// 点击未选中项时，在 [TTabBar.onChanged] 之前调用；重复点击当前选中项时，
  /// 仅当 [allowMultipleTaps] 为 true 才调用。整栏禁用时不会调用。
  final GestureTapCallback? onTap;

  /// 展示在标签内容右上角的徽标；为空时不显示。
  ///
  /// 徽标内容和样式由 [TBadgeConfig] 描述，[TBadgeConfig.offset] 可用于逐项
  /// 调整默认位置。纯文本项未设置实例或 BadgeTheme offset 时使用 TabBar 的
  /// 文本徽标默认位置；纯图标项与上下排列的图文项以图标作为锚点，
  /// 左右排列的图文项以整组图文作为锚点，均使用徽标的默认右上角位置。
  ///
  /// TabBar 自己拥有徽标锚点与点击区域；点击行为通过 [onTap] 配置。调用方
  /// 已经拥有目标 Widget 时，应直接使用 [TBadge] 包装该 Widget。
  final TBadgeConfig? badge;

  /// 弹窗配置
  final TTabBarPopUpBtnConfig? popUpButtonConfig;

  /// 是否允许重复点击当前选中项时再次调用 [onTap]，默认为 false。
  ///
  /// 该字段不影响点击未选中项，也不会让 [TTabBar.onChanged] 重复通知当前值。
  final bool allowMultipleTaps;

  /// 长按事件
  final GestureLongPressCallback? onLongPress;
}

/// 底部标签栏
///
/// 支持文本、图文、图标与双层级内容，并将选项样式与容器外形作为独立配置。
class TTabBar extends StatefulWidget {
  TTabBar({
    Key? key,
    required this.type,
    required this.navigationTabs,
    this.itemStyle = TTabBarItemStyle.label,
    this.style = TTabBarStyle.filled,
    this.iconTextLayout = TTabBarIconTextLayout.stacked,
    this.barHeight,
    this.split = false,
    this.dividerHeight,
    this.dividerThickness,
    this.dividerColor,
    this.showTopBorder = true,
    this.topBorder,
    this.useSafeArea = true,
    this.placeholder = true,
    this.selectedBgColor,
    this.unselectedBgColor,
    this.backgroundColor,
    this.needInkWell = false,
    this.indicatorAnimation = TTabBarIndicatorAnimation.none,
    this.animationDuration,
    this.animationCurve,
    required this.value,
    this.onChanged,
  }) : assert(() {
         if (navigationTabs.isEmpty) {
           throw FlutterError('[TTabBar] please set at least one tab!');
         }
         final basicType = type.basicType;
         if (basicType == _TTabBarBasicType.text) {
           for (final item in navigationTabs) {
             if (item.tabText == null) {
               throw FlutterError(
                 '[TTabBar] type contains text, but not set tabText.',
               );
             }
           }
         }
         if (basicType == _TTabBarBasicType.icon) {
           for (final item in navigationTabs) {
             if (item.selectedIcon == null || item.unselectedIcon == null) {
               throw FlutterError(
                 '[TTabBar] type contains icon,'
                 'but has no set icon.',
               );
             }
           }
         }
         if (basicType == _TTabBarBasicType.iconText) {
           for (final item in navigationTabs) {
             if (item.tabText == null ||
                 item.selectedIcon == null ||
                 item.unselectedIcon == null) {
               throw FlutterError(
                 '[TTabBar] type contains iconText,'
                 'but not set tabText or icon.',
               );
             }
           }
         }
         if (value < 0 || value >= navigationTabs.length) {
           throw FlutterError(
             '[TTabBar] value must in [0,navigationTabs.length)',
           );
         }
         return true;
       }()),
       super(key: key);

  /// 标签栏内容类型。
  final TTabBarType type;

  /// 单个标签项的选中样式。
  final TTabBarItemStyle itemStyle;

  /// 标签栏容器样式。
  final TTabBarStyle style;

  /// 图文项的图标与文字排列方式；仅当 [type] 为 [TTabBarType.iconText] 时生效。
  ///
  /// 默认为 [TTabBarIconTextLayout.stacked]。上下排列时图文间距为 0px，
  /// 左右排列时为 4px。该参数不改变标签栏
  /// 自身的水平方向，也不影响双层级菜单入口。
  final TTabBarIconTextLayout iconTextLayout;

  _TTabBarBasicType get _basicType => type.basicType;

  TTabBarItemStyle get _componentType => itemStyle;

  TTabBarStyle get _selectionType => style;

  /// tabs配置
  final List<TTabBarItemConfig> navigationTabs;

  /// tab高度
  final double? barHeight;

  /// 是否使用竖线分隔；[itemStyle] 为 [TTabBarItemStyle.label] 时不显示。
  final bool split;

  /// 分割线高度（可选）
  final double? dividerHeight;

  /// 分割线厚度（可选）
  final double? dividerThickness;

  /// 分割线颜色（可选）
  final Color? dividerColor;

  /// 是否展示bar上边线（设置为true 但是topBorder样式未设置，则使用默认值，非胶囊型才生效）
  final bool showTopBorder;

  /// 上边线样式
  final BorderSide? topBorder;

  /// 使用安全区域
  final bool useSafeArea;

  /// 是否添加安全区域占位
  final bool placeholder;

  /// 选中时背景颜色
  final Color? selectedBgColor;

  /// 未选中时背景颜色
  final Color? unselectedBgColor;

  /// 背景颜色 （可选）
  final Color? backgroundColor;

  /// 是否需要水波纹效果
  final bool needInkWell;

  /// 指示器动画类型
  final TTabBarIndicatorAnimation indicatorAnimation;

  /// 动画时长
  final Duration? animationDuration;

  /// 动画曲线
  final Curve? animationCurve;

  /// 选中的 index
  final int value;

  /// 选中项变化；null 时整栏禁用
  final ValueChanged<int>? onChanged;

  @override
  State<TTabBar> createState() => _TTabBarState();
}

class _TTabBarState extends State<TTabBar> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  Animation<double>? _animation;

  /// P1 ThemeExtension 回退后的有效值
  late double _effectiveBarHeight;
  late Color _effectiveSelectedBgColor;
  late Color? _effectiveUnselectedBgColor;
  late Color _effectiveBackgroundColor;
  late double _effectiveDividerHeight;
  late double _effectiveDividerThickness;
  late Color _effectiveDividerColor;
  late BorderSide? _effectiveTopBorder;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.value;

    // 初始化动画控制器
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // 初始化动画（初始位置）
    _animation = AlwaysStoppedAnimation(_selectedIndex.toDouble());
  }

  @override
  void didUpdateWidget(covariant TTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resolveEffectiveValues();
    if (widget.value != _selectedIndex) {
      _animateToIndex(widget.value);
    } else if (widget.indicatorAnimation != oldWidget.indicatorAnimation) {
      _animationController.stop();
      _animation = AlwaysStoppedAnimation(_selectedIndex.toDouble());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveEffectiveValues();
  }

  void _resolveEffectiveValues() {
    final theme = Theme.of(context).extension<TTabBarThemeData>();
    _effectiveBarHeight =
        widget.barHeight ?? theme?.barHeight ?? _kDefaultTabBarHeight;
    _effectiveSelectedBgColor =
        widget.selectedBgColor ??
        theme?.selectedBgColor ??
        context.tTheme.brandLightColor;
    _effectiveUnselectedBgColor =
        widget.unselectedBgColor ?? theme?.unselectedBgColor;
    _effectiveBackgroundColor =
        widget.backgroundColor ??
        theme?.backgroundColor ??
        context.tTheme.bgColorContainer;
    _effectiveDividerHeight =
        widget.dividerHeight ?? theme?.dividerHeight ?? 32;
    _effectiveDividerThickness =
        widget.dividerThickness ?? theme?.dividerThickness ?? 0.5;
    _effectiveDividerColor =
        widget.dividerColor ??
        theme?.dividerColor ??
        context.tTheme.componentStrokeColor;
    _effectiveTopBorder = widget.topBorder ?? theme?.topBorder;
    _animationController.duration =
        widget.animationDuration ?? const Duration(milliseconds: 300);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isCapsuleOutlineType = widget._selectionType == TTabBarStyle.capsule;
    var safeAreaBottomHeight = MediaQuery.of(context).padding.bottom;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final count = widget.navigationTabs.length;
            final barWidth = math.max(
              0.0,
              constraints.maxWidth -
                  (isCapsuleOutlineType ? 2 * _kCapsuleOuterMargin : 0),
            );
            final barPadding = math.min(_kBarPadding, barWidth / 2);
            final contentWidth = barWidth - 2 * barPadding;
            final itemGap = count > 1
                ? math.min(_kItemGap, contentWidth / (count - 1))
                : 0.0;
            final itemWidth = math.max(
              0.0,
              (contentWidth - itemGap * (count - 1)) / count,
            );

            Widget result = Container(
              height: _effectiveBarHeight,
              alignment: Alignment.center,
              margin: isCapsuleOutlineType
                  ? const EdgeInsets.symmetric(horizontal: _kCapsuleOuterMargin)
                  : null,
              decoration: isCapsuleOutlineType
                  ? ShapeDecoration(
                      color: _effectiveBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          context.tTheme.radiusRound,
                        ),
                      ),
                      shadows: context.tTheme.shadowsTop,
                    )
                  : BoxDecoration(color: _effectiveBackgroundColor),
              foregroundDecoration:
                  !isCapsuleOutlineType && widget.showTopBorder
                  ? BoxDecoration(
                      border: Border(
                        top:
                            _effectiveTopBorder ??
                            BorderSide(
                              color: context.tTheme.componentStrokeColor,
                              width: 0.5,
                            ),
                      ),
                    )
                  : null,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 动画指示器（在底层）
                  _buildAnimatedIndicator(
                    context,
                    itemWidth,
                    barPadding: barPadding,
                    itemGap: itemGap,
                  ),
                  // Tab 项（在上层）
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: barPadding,
                      vertical: math.min(_kBarPadding, _effectiveBarHeight / 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(count, (index) {
                        return _item(index, itemWidth);
                      }),
                    ),
                  ),
                  // 分割线（在最上层）
                  _verticalDivider(),
                ],
              ),
            );
            if (widget.useSafeArea) {
              if (widget.placeholder) {
                result = Container(
                  padding: EdgeInsets.only(bottom: safeAreaBottomHeight),
                  color: _effectiveBackgroundColor,
                  child: result,
                );
              } else {
                result = SafeArea(child: result);
              }
            }
            final isDisabled = widget.onChanged == null;
            return Semantics(
              enabled: !isDisabled,
              child: AnimatedOpacity(
                opacity: isDisabled ? 0.4 : 1,
                duration: const Duration(milliseconds: 150),
                child: AbsorbPointer(absorbing: isDisabled, child: result),
              ),
            );
          },
        );
      },
    );
  }

  void _onTap(int index) {
    final onChanged = widget.onChanged;
    if (onChanged == null) {
      return;
    }
    if (_selectedIndex == index) {
      if (widget.navigationTabs[index].allowMultipleTaps) {
        widget.navigationTabs[index].onTap?.call();
      }
      return;
    }
    widget.navigationTabs[index].onTap?.call();
    onChanged(index);
  }

  /// 动画切换到指定索引
  void _animateToIndex(int index) {
    final start = _animation?.value ?? _selectedIndex.toDouble();
    _selectedIndex = index;
    _animationController.stop();

    if (widget.indicatorAnimation == TTabBarIndicatorAnimation.none) {
      // 无动画，直接切换
      _animation = AlwaysStoppedAnimation(index.toDouble());
      return;
    }

    // 创建新的动画
    _animation = _animationController.drive(
      Tween<double>(begin: start, end: index.toDouble()).chain(
        CurveTween(curve: widget.animationCurve ?? Curves.easeInOutCubic),
      ),
    );

    // 播放动画
    _animationController.forward(from: 0.0);
  }

  /// 构建动画指示器
  Widget _buildAnimatedIndicator(
    BuildContext context,
    double itemWidth, {
    required double barPadding,
    required double itemGap,
  }) {
    // 只有 label 样式才显示背景指示器
    if (widget._componentType != TTabBarItemStyle.label) {
      return const SizedBox.shrink();
    }

    // 无动画模式不显示（由各个 item 自己渲染）
    if (widget.indicatorAnimation == TTabBarIndicatorAnimation.none) {
      return const SizedBox.shrink();
    }

    final animValue = _animation?.value ?? _selectedIndex.toDouble();

    switch (widget.indicatorAnimation) {
      case TTabBarIndicatorAnimation.linear:
        return _buildLinearIndicator(
          context,
          itemWidth,
          animValue,
          barPadding: barPadding,
          itemGap: itemGap,
        );
      case TTabBarIndicatorAnimation.elastic:
        return _buildElasticIndicator(
          context,
          itemWidth,
          animValue,
          barPadding: barPadding,
          itemGap: itemGap,
        );
      case TTabBarIndicatorAnimation.none:
        return const SizedBox.shrink();
    }
  }

  /// 线性滑动指示器
  Widget _buildLinearIndicator(
    BuildContext context,
    double itemWidth,
    double animValue, {
    required double barPadding,
    required double itemGap,
  }) {
    final left = barPadding + animValue * (itemWidth + itemGap);
    final height = math.max(0.0, _effectiveBarHeight - 2 * _kBarPadding);

    return Positioned(
      left: left,
      child: Container(
        width: itemWidth,
        height: height,
        decoration: BoxDecoration(
          color: _effectiveSelectedBgColor,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
        ),
      ),
    );
  }

  /// 弹性拉伸指示器
  Widget _buildElasticIndicator(
    BuildContext context,
    double itemWidth,
    double animValue, {
    required double barPadding,
    required double itemGap,
  }) {
    final step = itemWidth + itemGap;
    final start = barPadding;

    // 计算起始和目标索引
    final fromIndex = animValue.floor();
    final toIndex = animValue.ceil();
    final progress = animValue - fromIndex;

    // 弹性曲线：前半段快速拉伸，后半段缓慢收缩
    double width;
    double left;

    if (progress < 0.5) {
      // 前半段：从起点向终点拉伸
      final stretchProgress = progress * 2; // 0 -> 1
      width = itemWidth + stretchProgress * (toIndex - fromIndex) * step;
      left = start + fromIndex * step;
    } else {
      // 后半段：从终点收缩到正常宽度
      final shrinkProgress = (progress - 0.5) * 2; // 0 -> 1
      width = itemWidth + (1 - shrinkProgress) * (toIndex - fromIndex) * step;
      left =
          start +
          fromIndex * step +
          shrinkProgress * (toIndex - fromIndex) * step;
    }

    // 计算高度
    final height = math.max(0.0, _effectiveBarHeight - 2 * _kBarPadding);

    return Positioned(
      left: left,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: _effectiveSelectedBgColor,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
        ),
      ),
    );
  }

  Widget _item(int index, double itemWidth) {
    var tabItemConfig = widget.navigationTabs[index];
    final itemHeight = math.max(0.0, _effectiveBarHeight - 2 * _kBarPadding);
    return Container(
      height: itemHeight,
      width: itemWidth,
      alignment: Alignment.center,
      child: _TTabBarItemWithBadge(
        basicType: widget._basicType,
        componentType: widget._componentType,
        selectionType: widget._selectionType,
        itemConfig: tabItemConfig,
        isSelected: index == _selectedIndex,
        itemHeight: itemHeight,
        itemWidth: itemWidth,
        selectedBgColor: _effectiveSelectedBgColor,
        unselectedBgColor: _effectiveUnselectedBgColor,
        iconTextLayout: widget.iconTextLayout,
        needInkWell: widget.needInkWell,
        showItemBackground:
            widget.indicatorAnimation == TTabBarIndicatorAnimation.none,
        onTap: () {
          _onTap(index);
        },
        onLongPress: () {
          tabItemConfig.onLongPress?.call();
        },
      ),
    );
  }

  Widget _verticalDivider() {
    return Visibility(
      visible: widget._componentType != TTabBarItemStyle.label && widget.split,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(widget.navigationTabs.length - 1, (index) {
          return SizedBox(
            width: _effectiveDividerThickness,
            height: _effectiveDividerHeight,
            child: VerticalDivider(
              color: _effectiveDividerColor,
              thickness: _effectiveDividerThickness,
            ),
          );
        }),
      ),
    );
  }
}

/// 带徽标的底部标签栏单项
class _TTabBarItemWithBadge extends StatelessWidget {
  const _TTabBarItemWithBadge({
    Key? key,
    required this.basicType,
    required this.componentType,
    required this.selectionType,
    required this.itemConfig,
    required this.isSelected,
    required this.itemHeight,
    required this.itemWidth,
    required this.onTap,
    required this.selectedBgColor,
    required this.unselectedBgColor,
    required this.iconTextLayout,
    this.onLongPress,
    this.needInkWell = false,
    this.showItemBackground = true,
  }) : super(key: key);

  /// tab基本类型
  final _TTabBarBasicType basicType;

  /// tab选中背景类型
  final TTabBarItemStyle componentType;

  /// tab 选中背景类型
  final TTabBarStyle selectionType;

  /// 单个tab的属性配置
  final TTabBarItemConfig itemConfig;

  /// 选中状态
  final bool isSelected;

  /// tab高度
  final double itemHeight;

  /// tab宽度
  final double itemWidth;

  /// 点击事件
  final GestureTapCallback onTap;

  /// 选中时背景颜色
  final Color? selectedBgColor;

  /// 未选中时背景颜色
  final Color? unselectedBgColor;

  /// 图文项内部排列方式。
  final TTabBarIconTextLayout iconTextLayout;

  /// 长按事件
  final GestureLongPressCallback? onLongPress;

  /// 是否需要水波纹效果
  final bool needInkWell;

  /// 是否显示 item 自身的背景（无动画模式下为 true，有动画模式下为 false）
  final bool showItemBackground;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: needInkWell ? null : () => handleTap(context),
      onLongPress: () {
        onLongPress?.call();
      },
      child: Container(
        height: itemHeight,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // 只在无动画模式下显示 item 自身的背景
            if (showItemBackground && (isSelected || unselectedBgColor != null))
              Visibility(
                visible: componentType == TTabBarItemStyle.label,
                child: Container(
                  width: itemWidth,
                  height: itemHeight,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectedBgColor ?? context.tTheme.brandLightColor
                        : unselectedBgColor,
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                  ),
                ),
              ),
            _buildItem(context),
          ],
        ),
      ),
    );
  }

  Widget _constructItem(BuildContext context) {
    Widget child = Container();
    if (basicType == _TTabBarBasicType.text) {
      child = _textItem(
        context,
        itemConfig,
        isSelected,
        context.tTheme.fontTitleMedium!,
      );
    }
    if (basicType == _TTabBarBasicType.expansionPanel) {
      if (itemConfig.popUpButtonConfig != null) {
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              TIcons.view_list,
              size: 16.0,
              color: isSelected
                  ? context.tTheme.brandNormalColor
                  : context.tTheme.textColorPrimary,
            ),
            const SizedBox(width: 5),
            _textItem(
              context,
              itemConfig,
              isSelected,
              context.tTheme.fontTitleMedium!,
            ),
          ],
        );
      } else {
        child = _textItem(
          context,
          itemConfig,
          isSelected,
          context.tTheme.fontTitleMedium!,
        );
      }
    }
    if (basicType == _TTabBarBasicType.icon) {
      var selectedIcon = itemConfig.selectedIcon;
      var unSelectedIcon = itemConfig.unselectedIcon;
      child = IconTheme(
        data: IconThemeData(
          size: _kDefaultTabIconSize,
          color: isSelected
              ? context.tTheme.brandNormalColor
              : context.tTheme.textColorPrimary,
        ),
        child: isSelected ? selectedIcon! : unSelectedIcon!,
      );
    }

    if (basicType == _TTabBarBasicType.iconText) {
      var selectedIcon = itemConfig.selectedIcon;
      var unSelectedIcon = itemConfig.unselectedIcon;
      final icon = IconTheme(
        data: IconThemeData(
          size: _kDefaultTabIconSize,
          color: isSelected
              ? context.tTheme.brandNormalColor
              : context.tTheme.textColorPrimary,
        ),
        child: isSelected ? selectedIcon! : unSelectedIcon!,
      );
      final text = itemConfig.tabText?.isNotEmpty ?? false
          ? _textItem(
              context,
              itemConfig,
              isSelected,
              iconTextLayout == TTabBarIconTextLayout.inline
                  ? context.tTheme.fontBodyLarge!
                  : context.tTheme.fontBodyExtraSmall!,
              singleLine: iconTextLayout == TTabBarIconTextLayout.inline,
            )
          : const SizedBox.shrink();
      final badge = itemConfig.badge;
      if (iconTextLayout == TTabBarIconTextLayout.inline) {
        final content = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: _kInlineIconTextGap),
            Flexible(child: text),
          ],
        );
        return badge == null ? content : _attachBadge(context, badge, content);
      }
      final iconWithBadge = badge == null
          ? icon
          : _attachBadge(context, badge, icon);
      child = OverflowBox(
        alignment: Alignment.center,
        minHeight: 0,
        maxHeight: itemHeight + 2 * _kBarPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [iconWithBadge, text],
        ),
      );
      return child;
    }

    final badge = itemConfig.badge;
    if (badge == null) {
      return child;
    }
    return _attachBadge(context, badge, child);
  }

  Widget _attachBadge(BuildContext context, TBadgeConfig badge, Widget child) {
    return TBadgeFromConfig(
      config: badge,
      fallbackOffset: basicType == _TTabBarBasicType.text
          ? resolveBadgeFallbackOffset(
              context,
              _kTextBadgeOffset,
              alignment: badge.alignment,
            )
          : null,
      child: child,
    );
  }

  Widget _textItem(
    BuildContext context,
    TTabBarItemConfig config,
    bool isSelected,
    Font font, {
    bool singleLine = false,
  }) {
    return TText(
      config.tabText ?? '',
      maxLines: singleLine ? 1 : null,
      overflow: singleLine ? TextOverflow.ellipsis : null,
      style: TTextResolve.resolve(
        context: context,
        defaults: TextStyle(
          fontSize: font.size,
          height: font.height,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected
              ? context.tTheme.brandNormalColor
              : context.tTheme.textColorPrimary,
        ),
        style: isSelected
            ? config.selectTabTextStyle
            : config.unselectTabTextStyle,
      ),
    );
  }

  _buildItem(BuildContext context) {
    var isInOrOutCapsule =
        componentType == TTabBarItemStyle.label ||
        selectionType == TTabBarStyle.capsule;

    var child = Container(
      alignment: Alignment.center,
      color: Colors.transparent,
      child: _constructItem(context),
    );

    if (!needInkWell) {
      return child;
    }
    return Material(
      color: Colors.transparent,
      shape: isInOrOutCapsule
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.tTheme.radiusRound),
            )
          : null,
      child: InkWell(
        customBorder: isInOrOutCapsule
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.tTheme.radiusRound),
              )
            : null,
        splashFactory: InkRipple.splashFactory,
        splashColor: selectedBgColor ?? context.tTheme.brandLightColor,
        highlightColor: selectedBgColor ?? context.tTheme.brandLightColor,
        onTap: () => handleTap(context),
        child: child,
      ),
    );
  }

  void handleTap(BuildContext context) {
    onTap.call();

    var popUpButtonConfig = itemConfig.popUpButtonConfig;
    if (popUpButtonConfig != null) {
      final navigator = Navigator.of(context);
      final capturedThemes = InheritedTheme.capture(
        from: context,
        to: navigator.context,
      );
      navigator.push<void>(
        _TabBarPopupRoute(
          barrierLabel: MaterialLocalizations.of(
            context,
          ).modalBarrierDismissLabel,
          child: capturedThemes.wrap(
            _TabBarPopupDialog(
              math.max(
                _kDefaultMenuMinWidth,
                itemWidth - _kDefaultMenuItemWidthShrink,
              ),
              btnContext: context,
              config: popUpButtonConfig.popUpDialogConfig,
              items: popUpButtonConfig.items,
              onClickMenu: (value) {
                popUpButtonConfig.onChanged(value);
              },
            ),
          ),
        ),
      );
    }
  }
}

/// 展开项配置
class TTabBarPopUpBtnConfig {
  TTabBarPopUpBtnConfig({
    required this.items,
    required this.onChanged,
    this.popUpDialogConfig,
  }) : assert(() {
         if (popUpDialogConfig != null) {
           if ((popUpDialogConfig.arrowHeight != null &&
                   popUpDialogConfig.arrowHeight! <= 0.0) ||
               (popUpDialogConfig.arrowWidth != null &&
                   popUpDialogConfig.arrowWidth! <= 0.0)) {
             throw FlutterError(
               '[TTabBarPopUpBtnConfig] arrowHeight or arrowHeight can '
               'not set less than or equal to zero',
             );
           }
         }
         return true;
       }());

  /// 选项list
  final List<TTabBarMenuItem> items;

  /// 统一在 onChanged 中处理各item点击事件
  final ValueChanged<String> onChanged;

  /// 弹窗UI配置
  final TTabBarPopUpShapeConfig? popUpDialogConfig;
}

/// 弹窗UI配置
class TTabBarPopUpShapeConfig {
  TTabBarPopUpShapeConfig({
    this.popUpWidth,
    this.popUpItemHeight = _kDefaultMenuItemHeight,
    this.backgroundColor,
    this.radius,
    this.arrowWidth,
    this.arrowHeight,
  });

  /// 弹窗宽度。
  ///
  /// 不设置时使用 `max(107, 标签项宽度 - 20)`；显式设置时覆盖该默认值。
  final double? popUpWidth;

  /// 单个选项高度 所有选项等高 不设置则使用默认值 48
  final double? popUpItemHeight;

  /// 弹窗背景颜色
  final Color? backgroundColor;

  /// 弹层面板圆角。
  ///
  /// 不设置时使用当前 TDesign 主题的 `radiusDefault`（默认 6px）；
  /// 显式设置时覆盖主题默认值。
  final double? radius;

  /// 箭头宽度 默认13.5
  final double? arrowWidth;

  /// 箭头高度 默认8
  final double? arrowHeight;
}

/// 弹窗菜单item
class TTabBarMenuItem extends StatelessWidget {
  const TTabBarMenuItem({
    Key? key,
    this.itemWidget,
    required this.value,
    this.alignment = AlignmentDirectional.center,
  }) : super(key: key);

  /// 选项widget
  final Widget? itemWidget;

  /// 选项值
  final String value;

  /// 对齐方式
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: _kMenuItemMinHeight),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
      alignment: alignment,
      child:
          itemWidget ??
          TText(
            value,
            style: TTextResolve.resolve(
              context: context,
              defaults: TextStyle(
                fontSize: context.tTheme.fontBodyLarge?.size ?? 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
    );
  }
}

/// 弹出菜单路由
class _TabBarPopupRoute extends PopupRoute<void> {
  /// 子内容
  final Widget child;

  /// 弹窗屏障无障碍文案
  final String? _barrierLabel;

  _TabBarPopupRoute({required this.child, String? barrierLabel})
    : _barrierLabel = barrierLabel;

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => _barrierLabel;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return child;
  }

  @override
  Duration get transitionDuration => _kPopupMenuDuration;
}

/// 弹出菜单对话框
class _TabBarPopupDialog extends StatefulWidget {
  /// 按钮context
  final BuildContext btnContext;

  /// 点击事件
  final ValueChanged<String> onClickMenu;

  /// 弹窗选项列表
  final List<TTabBarMenuItem> items;

  /// 弹窗配置
  final TTabBarPopUpShapeConfig? config;

  /// 默认弹窗宽度
  final double defaultPopUpWidth;

  const _TabBarPopupDialog(
    this.defaultPopUpWidth, {
    Key? key,
    required this.btnContext,
    required this.onClickMenu,
    required this.items,
    required this.config,
  }) : super(key: key);

  @override
  _TabBarPopupDialogState createState() => _TabBarPopupDialogState();
}

class _TabBarPopupDialogState extends State<_TabBarPopupDialog> {
  RenderBox? button;
  RenderBox? overlay;
  RelativeRect? position;
  Size? size;

  @override
  void initState() {
    super.initState();
    if (!widget.btnContext.mounted) {
      return;
    }
    final buttonRenderObject = widget.btnContext.findRenderObject();
    final overlayState = Overlay.maybeOf(widget.btnContext);
    final overlayRenderObject = overlayState?.context.findRenderObject();
    if (buttonRenderObject is! RenderBox || overlayRenderObject is! RenderBox) {
      return;
    }
    if (!buttonRenderObject.attached || !overlayRenderObject.attached) {
      return;
    }
    button = buttonRenderObject;
    size = button!.size;
    overlay = overlayRenderObject;
    position = RelativeRect.fromRect(
      Rect.fromPoints(
        button!.localToGlobal(Offset.zero, ancestor: overlay),
        button!.localToGlobal(Offset.zero, ancestor: overlay),
      ),
      Offset.zero & overlay!.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (position == null || size == null || widget.items.isEmpty) {
      return const SizedBox.shrink();
    }
    var popUpItemHeight =
        widget.config?.popUpItemHeight ?? _kDefaultMenuItemHeight;
    var popUpItemWidth = widget.config?.popUpWidth ?? widget.defaultPopUpWidth;
    var menuItems = widget.items
        .map(
          (e) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              widget.onClickMenu(e.value);
              Navigator.of(context).pop();
            },
            child: SizedBox(height: popUpItemHeight, child: e),
          ),
        )
        .toList();

    // 计算弹窗整体高度（含箭头），用于将其约束在视口内避免被裁切到屏幕外
    final popUpPanelHeight =
        popUpItemHeight * widget.items.length +
        (widget.config?.arrowHeight ?? _kArrowHeight);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final rawTop =
        position!.top -
        popUpPanelHeight -
        _kPopupButtonPadding -
        _kPopupArrowGap;
    final maxTop = screenHeight - popUpPanelHeight - _kPopupViewportPadding;
    final safeTop = rawTop.clamp(
      _kPopupViewportPadding,
      maxTop < _kPopupViewportPadding ? _kPopupViewportPadding : maxTop,
    );
    final rawLeft = position!.left + (size!.width - popUpItemWidth) / 2;
    final maxLeft = screenWidth - popUpItemWidth - _kPopupViewportPadding;
    final safeLeft = rawLeft.clamp(
      _kPopupViewportPadding,
      maxLeft < _kPopupViewportPadding ? _kPopupViewportPadding : maxLeft,
    );

    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: <Widget>[
            Container(
              width: screenWidth,
              height: screenHeight,
              color: Colors.transparent,
            ),
            Positioned(
              top: safeTop,
              left: safeLeft,
              child: Container(
                width: popUpItemWidth,
                height:
                    popUpItemHeight * widget.items.length +
                    (widget.config?.arrowHeight ?? _kArrowHeight),
                decoration: BoxDecoration(boxShadow: context.tTheme.shadowsTop),
                child: CustomPaint(
                  painter: _TabBarPanelPainter(
                    config: widget.config,
                    backgroundColor:
                        widget.config?.backgroundColor ??
                        context.tTheme.bgColorContainer,
                    radius:
                        widget.config?.radius ?? context.tTheme.radiusDefault,
                  ),
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: popUpItemHeight * widget.items.length,
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: popUpItemHeight * widget.items.length,
                      ),
                      child: Stack(
                        children: [
                          Column(children: menuItems),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              widget.items.length - 1,
                              (index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Divider(
                                  thickness: 0.5,
                                  height: 0.5,
                                  color: context.tTheme.componentStrokeColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 带下箭头的展开panel
class _TabBarPanelPainter extends CustomPainter {
  /// 弹出面板形状配置
  final TTabBarPopUpShapeConfig? config;

  /// 背景颜色
  final Color backgroundColor;

  /// 已解析的弹层圆角。
  final double radius;

  _TabBarPanelPainter({
    this.config,
    required this.backgroundColor,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    var path = Path();
    var panelWidth = size.width;
    var panelHeight = size.height - (config?.arrowHeight ?? _kArrowHeight);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, panelWidth, panelHeight),
        Radius.circular(radius),
      ),
      paint,
    );

    /// 下方箭头
    if (config?.arrowWidth != 0.0 && config?.arrowHeight != 0.0) {
      var left = (panelWidth - _kArrowWidth) / 2;
      var right = (panelWidth + _kArrowWidth) / 2;
      var bottom = panelHeight + _kArrowHeight;
      if (config?.arrowWidth != null) {
        left = (panelWidth - config!.arrowWidth!) / 2;
        right = (panelWidth + config!.arrowWidth!) / 2;
      }
      if (config?.arrowHeight != null) {
        bottom = panelHeight + config!.arrowHeight!;
      }

      path.moveTo(left, panelHeight);
      path.lineTo(panelWidth / 2, bottom);
      path.lineTo(right, panelHeight);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TabBarPanelPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.config != config ||
        oldDelegate.radius != radius;
  }
}
