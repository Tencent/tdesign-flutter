import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/basic.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_shadows.dart';
import '../../theme/t_theme.dart';
import '../badge/t_badge.dart';
import '../text/t_text.dart';
import 't_tab_bar_theme_data.dart';

/// 展开项 向下箭头宽
const double _kArrowWidth = 13.5;

/// 展开项  向下箭头高
const double _kArrowHeight = 8;

/// 展开项选项弹窗 单个item最低高度
const double _kMenuItemMinHeight = 23;

/// 展开项弹窗 单个item默认高度
const double _kDefaultMenuItemHeight = 48;

/// 展开项弹窗 单个item默认宽度为按钮宽度-20
const double _kDefaultMenuItemWidthShrink = 20;

/// 导航栏默认高度
const double _kDefaultTabBarHeight = 56;

/// 展开项弹窗弹出动画时间
const Duration _kPopupMenuDuration = Duration(milliseconds: 10);

/// 展开项弹窗距离触发按钮的间距
const double _kPopupButtonPadding = 8.0;

/// 展开项弹窗箭头和触发按钮的间距
const double _kPopupArrowGap = 4.0;

/// 展开项弹窗距离视口边界的安全距离
const double _kPopupViewportPadding = 8.0;

/// 底部标签栏形态
enum TTabBarVariant {
  /// 单层级纯文本标签栏
  text,

  /// 文本加图标标签栏
  iconText,

  /// 纯图标标签栏
  icon,

  /// 双层级纯文本标签栏
  expansionPanel,

  /// 弱选中纯文本标签栏
  weakText,

  /// 弱选中纯图标标签栏
  weakIcon,

  /// 弱选中文本加图标标签栏
  weakIconText,

  /// 胶囊文本加图标标签栏
  capsule,
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
enum _TTabBarComponentType {
  /// 普通样式
  normal,

  /// 带胶囊背景的item选中样式
  label,
}

/// 底部标签栏选中背景样式
enum _TTabBarSelectionType {
  /// 填充样式
  filled,

  /// 胶囊样式
  capsule,
}

/// 指示器动画类型
enum TTabBarIndicatorAnimation {
  /// 无动画，瞬间切换
  none,

  /// 线性滑动：指示器匀速从一个 tab 滑到另一个
  linear,

  /// 弹性动画：指示器先拉伸后收缩
  elastic,
}

extension _TTabBarVariantResolve on TTabBarVariant {
  _TTabBarBasicType get basicType {
    switch (this) {
      case TTabBarVariant.text:
      case TTabBarVariant.weakText:
        return _TTabBarBasicType.text;
      case TTabBarVariant.iconText:
      case TTabBarVariant.weakIconText:
      case TTabBarVariant.capsule:
        return _TTabBarBasicType.iconText;
      case TTabBarVariant.icon:
      case TTabBarVariant.weakIcon:
        return _TTabBarBasicType.icon;
      case TTabBarVariant.expansionPanel:
        return _TTabBarBasicType.expansionPanel;
    }
  }

  _TTabBarComponentType get componentType {
    switch (this) {
      case TTabBarVariant.weakText:
      case TTabBarVariant.weakIcon:
      case TTabBarVariant.weakIconText:
        return _TTabBarComponentType.normal;
      case TTabBarVariant.text:
      case TTabBarVariant.iconText:
      case TTabBarVariant.icon:
      case TTabBarVariant.expansionPanel:
      case TTabBarVariant.capsule:
        return _TTabBarComponentType.label;
    }
  }

  _TTabBarSelectionType get selectionType {
    return this == TTabBarVariant.capsule
        ? _TTabBarSelectionType.capsule
        : _TTabBarSelectionType.filled;
  }
}

/// 飘新配置
class TTabBarBadgeConfig {
  TTabBarBadgeConfig({
    required this.showBadge,
    TBadge? tBadge,
    this.badgeTopOffset,
    this.badgeRightOffset,
  }) : tBadge = tBadge ?? const TBadge(variant: TBadgeVariant.dot);

  /// 是否展示消息
  final bool showBadge;

  /// 消息样式（未设置但 showBadge 为 true，则默认使用红点）
  final TBadge? tBadge;

  /// 消息顶部偏移量
  final double? badgeTopOffset;

  /// 消息右侧偏移量
  final double? badgeRightOffset;
}

/// 单个 tab 配置
class TTabBarItemConfig {
  TTabBarItemConfig({
    required this.onTap,
    this.selectedIcon,
    this.unselectedIcon,
    this.tabText,
    this.selectTabTextStyle,
    this.unselectTabTextStyle,
    this.badgeConfig,
    this.popUpButtonConfig,
    this.onLongPress,
    this.allowMultipleTaps = false,
  }) : assert(() {
         if (badgeConfig?.showBadge ?? false) {
           if (badgeConfig?.tBadge == null) {
             throw FlutterError(
               '[NavigationTab] if set showBadge = true, '
               'you must set a tBadge instance',
             );
           }
         }
         return true;
       }());

  /// 选中时图标
  final Widget? selectedIcon;

  /// 未选中时图标
  final Widget? unselectedIcon;

  /// tab 文本
  final String? tabText;

  /// 文本已选择样式 basicType为text时必填
  final TextStyle? selectTabTextStyle;

  /// 文本未选择样式 basicType为text时必填
  final TextStyle? unselectTabTextStyle;

  /// tab点击事件
  final GestureTapCallback? onTap;

  /// 消息配置
  final TTabBarBadgeConfig? badgeConfig;

  /// 弹窗配置
  final TTabBarPopUpBtnConfig? popUpButtonConfig;

  /// onTap 方法允许点击多次
  final bool allowMultipleTaps;

  /// 长按事件
  final GestureLongPressCallback? onLongPress;
}

/// 底部标签栏
///
/// 支持文本/图标/图文/展开面板四种基本类型，
/// 普通和胶囊两种选中样式，填充和胶囊两种轮廓样式。
class TTabBar extends StatefulWidget {
  TTabBar({
    Key? key,
    required this.variant,
    required this.navigationTabs,
    this.barHeight,
    this.useVerticalDivider,
    this.dividerHeight,
    this.dividerThickness,
    this.dividerColor,
    this.showTopBorder,
    this.topBorder,
    this.useSafeArea = true,
    this.placeholder = true,
    this.selectedBgColor,
    this.unselectedBgColor,
    this.backgroundColor,
    this.centerDistance,
    this.needInkWell,
    this.indicatorAnimation = TTabBarIndicatorAnimation.none,
    this.animationDuration,
    this.animationCurve,
    required this.value,
    this.onChanged,
  }) : assert(() {
         if (navigationTabs.isEmpty) {
           throw FlutterError('[TTabBar] please set at least one tab!');
         }
         final basicType = variant.basicType;
         if (basicType == _TTabBarBasicType.text) {
           for (final item in navigationTabs) {
             if (item.tabText == null) {
               throw FlutterError(
                 '[TTabBar] variant contains text, but not set tabText.',
               );
             }
           }
         }
         if (basicType == _TTabBarBasicType.icon) {
           for (final item in navigationTabs) {
             if (item.selectedIcon == null || item.unselectedIcon == null) {
               throw FlutterError(
                 '[TTabBar] variant contains icon,'
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
                 '[TTabBar] variant contains iconText,'
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

  /// 标签栏形态
  final TTabBarVariant variant;

  _TTabBarBasicType get _basicType => variant.basicType;

  _TTabBarComponentType get _componentType => variant.componentType;

  _TTabBarSelectionType get _selectionType => variant.selectionType;

  /// tabs配置
  final List<TTabBarItemConfig> navigationTabs;

  /// tab高度
  final double? barHeight;

  /// 是否使用竖线分隔（如果选项样式为 label，则强制为 false）
  final bool? useVerticalDivider;

  /// 分割线高度（可选）
  final double? dividerHeight;

  /// 分割线厚度（可选）
  final double? dividerThickness;

  /// 分割线颜色（可选）
  final Color? dividerColor;

  /// 是否展示bar上边线（设置为true 但是topBorder样式未设置，则使用默认值，非胶囊型才生效）
  final bool? showTopBorder;

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

  /// icon与文本中间距离（可选）
  final double? centerDistance;

  /// 是否需要水波纹效果
  final bool? needInkWell;

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
  late double _effectiveCenterDistance;
  late bool _effectiveUseVerticalDivider;
  late double _effectiveDividerHeight;
  late double _effectiveDividerThickness;
  late Color _effectiveDividerColor;
  late bool _effectiveShowTopBorder;
  late BorderSide? _effectiveTopBorder;
  late bool _effectiveNeedInkWell;
  late Duration _effectiveAnimationDuration;
  late Curve _effectiveAnimationCurve;

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
    _animation =
        Tween<double>(
          begin: _selectedIndex.toDouble(),
          end: _selectedIndex.toDouble(),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOutCubic,
          ),
        );
  }

  @override
  void didUpdateWidget(covariant TTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resolveEffectiveValues();
    if (widget.value != _selectedIndex) {
      _animateToIndex(widget.value);
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
    _effectiveCenterDistance =
        widget.centerDistance ?? theme?.centerDistance ?? 0;
    _effectiveUseVerticalDivider =
        widget.useVerticalDivider ?? theme?.useVerticalDivider ?? false;
    _effectiveDividerHeight =
        widget.dividerHeight ?? theme?.dividerHeight ?? 32;
    _effectiveDividerThickness =
        widget.dividerThickness ?? theme?.dividerThickness ?? 0.5;
    _effectiveDividerColor =
        widget.dividerColor ??
        theme?.dividerColor ??
        context.tTheme.componentStrokeColor;
    _effectiveShowTopBorder =
        widget.showTopBorder ?? theme?.showTopBorder ?? true;
    _effectiveTopBorder = widget.topBorder ?? theme?.topBorder;
    _effectiveNeedInkWell = widget.needInkWell ?? theme?.needInkWell ?? false;
    _effectiveAnimationDuration =
        widget.animationDuration ??
        theme?.animationDuration ??
        const Duration(milliseconds: 300);
    _effectiveAnimationCurve =
        widget.animationCurve ?? theme?.animationCurve ?? Curves.easeInOutCubic;
    _animationController.duration = _effectiveAnimationDuration;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isCapsuleOutlineType =
        widget._selectionType == _TTabBarSelectionType.capsule;
    var safeAreaBottomHeight = MediaQuery.of(context).padding.bottom;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            /// -2 是为了增加边框
            var maxWidth =
                double.parse(constraints.biggest.width.toStringAsFixed(1)) - 2;

            /// 胶囊样式 比正常样式宽度要小32
            if (isCapsuleOutlineType) {
              maxWidth -= 32;
            }
            var itemWidth = maxWidth / widget.navigationTabs.length;

            Widget result = Container(
              height: _effectiveBarHeight,
              alignment: Alignment.center,
              margin: isCapsuleOutlineType
                  ? const EdgeInsets.symmetric(horizontal: 16)
                  : null,
              decoration: BoxDecoration(
                color: _effectiveBackgroundColor,
                borderRadius: isCapsuleOutlineType
                    ? BorderRadius.circular(context.tTheme.radiusCircle)
                    : null,
                border: _effectiveShowTopBorder && !isCapsuleOutlineType
                    ? Border(
                        top:
                            _effectiveTopBorder ??
                            BorderSide(
                              color: context.tTheme.componentStrokeColor,
                              width: 0.5,
                            ),
                      )
                    : null,
                boxShadow: isCapsuleOutlineType
                    ? context.tTheme.shadowsTop
                    : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 动画指示器（在底层）
                  _buildAnimatedIndicator(context, itemWidth),
                  // Tab 项（在上层）
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(widget.navigationTabs.length, (
                      index,
                    ) {
                      return _item(index, itemWidth);
                    }),
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
    final oldIndex = _selectedIndex;
    _selectedIndex = index;

    if (widget.indicatorAnimation == TTabBarIndicatorAnimation.none) {
      // 无动画，直接切换
      return;
    }

    // 创建新的动画
    _animation =
        Tween<double>(
          begin: oldIndex.toDouble(),
          end: index.toDouble(),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: _effectiveAnimationCurve,
          ),
        );

    // 播放动画
    _animationController.forward(from: 0.0);
  }

  /// 构建动画指示器
  Widget _buildAnimatedIndicator(BuildContext context, double itemWidth) {
    // 只有 label 样式才显示背景指示器
    if (widget._componentType != _TTabBarComponentType.label) {
      return const SizedBox.shrink();
    }

    // 无动画模式不显示（由各个 item 自己渲染）
    if (widget.indicatorAnimation == TTabBarIndicatorAnimation.none) {
      return const SizedBox.shrink();
    }

    final animValue = _animation?.value ?? _selectedIndex.toDouble();

    switch (widget.indicatorAnimation) {
      case TTabBarIndicatorAnimation.linear:
        return _buildLinearIndicator(context, itemWidth, animValue);
      case TTabBarIndicatorAnimation.elastic:
        return _buildElasticIndicator(context, itemWidth, animValue);
      case TTabBarIndicatorAnimation.none:
        return const SizedBox.shrink();
    }
  }

  /// 线性滑动指示器
  Widget _buildLinearIndicator(
    BuildContext context,
    double itemWidth,
    double animValue,
  ) {
    final horizontalPadding = widget.navigationTabs.length > 3 ? 8.0 : 12.0;
    final indicatorWidth = itemWidth - horizontalPadding * 2;

    // 计算指示器位置
    final left = animValue * itemWidth + horizontalPadding;

    // 计算高度
    final height =
        widget._basicType == _TTabBarBasicType.text ||
            widget._basicType == _TTabBarBasicType.expansionPanel
        ? 32.0
        : null;

    return Positioned(
      left: left,
      child: Container(
        width: indicatorWidth,
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
    double animValue,
  ) {
    final horizontalPadding = widget.navigationTabs.length > 3 ? 8.0 : 12.0;

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
      width =
          (itemWidth - horizontalPadding * 2) *
          (1 + stretchProgress * (toIndex - fromIndex));
      left = fromIndex * itemWidth + horizontalPadding;
    } else {
      // 后半段：从终点收缩到正常宽度
      final shrinkProgress = (progress - 0.5) * 2; // 0 -> 1
      width =
          (itemWidth - horizontalPadding * 2) *
          (1 + (1 - shrinkProgress) * (toIndex - fromIndex));
      left =
          fromIndex * itemWidth +
          horizontalPadding +
          shrinkProgress * (toIndex - fromIndex) * itemWidth;
    }

    // 计算高度
    final height =
        widget._basicType == _TTabBarBasicType.text ||
            widget._basicType == _TTabBarBasicType.expansionPanel
        ? 32.0
        : null;

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
    // iconText 且存在 centerDistance 间距时，压缩上下内边距为图标+文本+间距腾出空间，
    // 避免 Column 内容溢出（centerDistance 默认为 0，不影响常规渲染与 Golden 基线）。
    final isIconTextWithGap =
        widget._basicType == _TTabBarBasicType.iconText &&
        _effectiveCenterDistance > 0;
    return Container(
      height: _effectiveBarHeight,
      width: itemWidth,
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        top: isIconTextWithGap ? 4 : 7,
        bottom: isIconTextWithGap
            ? 1
            : (widget._basicType == _TTabBarBasicType.iconText ? 5 : 7),
      ),
      child: TTabBarItemWithBadge(
        basicType: widget._basicType,
        componentType: widget._componentType,
        selectionType: widget._selectionType,
        itemConfig: tabItemConfig,
        isSelected: index == _selectedIndex,
        itemHeight: _effectiveBarHeight,
        itemWidth: itemWidth,
        tabsLength: widget.navigationTabs.length,
        selectedBgColor: _effectiveSelectedBgColor,
        unselectedBgColor: _effectiveUnselectedBgColor,
        centerDistance: _effectiveCenterDistance,
        needInkWell: _effectiveNeedInkWell,
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
      visible:
          widget._componentType != _TTabBarComponentType.label &&
          (_effectiveUseVerticalDivider),
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
class TTabBarItemWithBadge extends StatelessWidget {
  const TTabBarItemWithBadge({
    Key? key,
    required this.basicType,
    required this.componentType,
    required this.selectionType,
    required this.itemConfig,
    required this.isSelected,
    required this.itemHeight,
    required this.itemWidth,
    required this.onTap,
    required this.tabsLength,
    required this.selectedBgColor,
    required this.unselectedBgColor,
    required this.centerDistance,
    this.onLongPress,
    this.needInkWell = false,
    this.showItemBackground = true,
  }) : super(key: key);

  /// tab基本类型
  final _TTabBarBasicType basicType;

  /// tab选中背景类型
  final _TTabBarComponentType componentType;

  /// tab 选中背景类型
  final _TTabBarSelectionType selectionType;

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

  /// tab总个数
  final int tabsLength;

  /// 选中时背景颜色
  final Color? selectedBgColor;

  /// 未选中时背景颜色
  final Color? unselectedBgColor;

  /// icon与文本中间距离
  final double centerDistance;

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
      onTap: () => handleTap(context),
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
                visible: componentType == _TTabBarComponentType.label,
                child: Container(
                  /// 设计稿上 tab个数大于3时，左右边距为8，小于等于3时，左右边距为12
                  width: itemWidth - (tabsLength > 3 ? 16 : 24),
                  height:
                      basicType == _TTabBarBasicType.text ||
                          basicType == _TTabBarBasicType.expansionPanel
                      ? 32
                      : null,
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

  Widget _badge(TTabBarBadgeConfig? badgeConfig) {
    if (badgeConfig?.showBadge ?? false) {
      if (badgeConfig?.tBadge != null) {
        return badgeConfig!.tBadge!;
      }
    }
    return Container();
  }

  Widget _constructItem(
    BuildContext context,
    TTabBarBadgeConfig? badgeConfig,
    bool isInOrOutCapsule,
  ) {
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
      child = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconTheme(
            data: IconThemeData(
              color: isSelected
                  ? context.tTheme.brandNormalColor
                  : context.tTheme.textColorPrimary,
            ),
            child: isSelected ? selectedIcon! : unSelectedIcon!,
          ),
          if (centerDistance > 0) SizedBox(height: centerDistance),
          itemConfig.tabText?.isNotEmpty ?? false
              ? _textItem(
                  context,
                  itemConfig,
                  isSelected,
                  context.tTheme.fontBodyExtraSmall!,
                )
              : Container(),
        ],
      );
    }

    var top = badgeConfig?.badgeTopOffset ?? -2;
    var right = badgeConfig?.badgeRightOffset ?? -10;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Visibility(
          visible: badgeConfig?.showBadge ?? false,
          child: Positioned(top: top, right: right, child: _badge(badgeConfig)),
        ),
      ],
    );
  }

  Widget _textItem(
    BuildContext context,
    TTabBarItemConfig config,
    bool isSelected,
    Font font,
  ) {
    return TText(
      config.tabText,
      font: font,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      style: isSelected
          ? config.selectTabTextStyle
          : config.unselectTabTextStyle,
      textColor: isSelected
          ? context.tTheme.brandNormalColor
          : context.tTheme.textColorPrimary,
    );
  }

  _buildItem(BuildContext context) {
    var badgeConfig = itemConfig.badgeConfig;
    var isInOrOutCapsule =
        componentType == _TTabBarComponentType.label ||
        selectionType == _TTabBarSelectionType.capsule;

    // centerDistance > 0 时进一步压缩顶部内边距，为图标与文本的间距腾出空间
    final reduceTopPad =
        basicType == _TTabBarBasicType.iconText && centerDistance > 0;
    final itemPadding = basicType == _TTabBarBasicType.text
        ? EdgeInsets.zero
        : EdgeInsets.only(
            top: (isInOrOutCapsule ? 3.0 : 2.0) - (reduceTopPad ? 1.0 : 0.0),
            bottom: isInOrOutCapsule
                ? (basicType == _TTabBarBasicType.iconText ? 0.0 : 1.0)
                : 0.0,
          );
    var child = Container(
      alignment: Alignment.center,
      padding: itemPadding,
      color: Colors.transparent,
      child: _constructItem(context, badgeConfig, isInOrOutCapsule),
    );

    if (!needInkWell) {
      return child;
    }
    return Material(
      color: Colors.transparent,
      borderRadius: isInOrOutCapsule ? BorderRadius.circular(24) : null,
      child: InkWell(
        borderRadius: isInOrOutCapsule ? BorderRadius.circular(24) : null,
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
      Navigator.push(
        context,
        PopRoute(
          barrierLabel: MaterialLocalizations.of(
            context,
          ).modalBarrierDismissLabel,
          child: PopupDialog(
            itemWidth - _kDefaultMenuItemWidthShrink,
            btnContext: context,
            config: popUpButtonConfig.popUpDialogConfig,
            items: popUpButtonConfig.items,
            onClickMenu: (value) {
              popUpButtonConfig.onChanged(value);
            },
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

  /// 弹窗宽度（不设置，默认为按钮宽度 - 20）
  final double? popUpWidth;

  /// 单个选项高度 所有选项等高 不设置则使用默认值 48
  final double? popUpItemHeight;

  /// 弹窗背景颜色
  final Color? backgroundColor;

  /// panel圆角 默认0
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
        color: context.tTheme.bgColorContainer,
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
      alignment: alignment,
      child:
          itemWidget ??
          TText(
            value,
            style: TextStyle(
              fontSize: context.tTheme.fontBodyLarge?.size ?? 16,
              fontWeight: FontWeight.w400,
            ),
          ),
    );
  }
}

/// 弹出菜单路由
class PopRoute extends PopupRoute {
  /// 子内容
  Widget child;

  /// 弹窗屏障无障碍文案
  final String? _barrierLabel;

  PopRoute({required this.child, String? barrierLabel})
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
class PopupDialog extends StatefulWidget {
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

  const PopupDialog(
    this.defaultPopUpWidth, {
    Key? key,
    required this.btnContext,
    required this.onClickMenu,
    required this.items,
    required this.config,
  }) : super(key: key);

  @override
  PopupDialogState createState() => PopupDialogState();
}

class PopupDialogState extends State<PopupDialog> {
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
                  painter: PanelWithDownArrow(
                    config: widget.config,
                    backgroundColor:
                        widget.config?.backgroundColor ??
                        context.tTheme.bgColorContainer,
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
class PanelWithDownArrow extends CustomPainter {
  /// 弹出面板形状配置
  TTabBarPopUpShapeConfig? config;

  /// 背景颜色
  Color backgroundColor;

  PanelWithDownArrow({this.config, required this.backgroundColor});

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
        Radius.circular(config?.radius ?? 0.0),
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
