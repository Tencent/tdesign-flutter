import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/basic.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import 't_nav_bar_theme_data.dart';

/// NavBar 操作项回调类型
typedef TBarItemAction = void Function();

/// NavBar 组件 v1.0
///
/// Material AppBar 薄包装（NavigationToolbar 实现）。
/// - A 类禁用：操作项 `onTap: null`。
/// - L4 样式（标题颜色/字体、背景、内边距等）→ [TNavBarThemeData]。
class TNavBar extends StatefulWidget implements PreferredSizeWidget {
  const TNavBar({
    Key? key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.useDefaultBack = true,
    this.onBack,
    this.belowTitleWidget,
    this.flexibleSpace,
    // L4 样式参数（可覆盖 Theme）
    this.titleColor,
    this.backIconColor,
    this.titleFont,
    this.titleFontWeight,
    this.titleFontFamily,
    this.backgroundColor,
    this.height,
    this.padding,
    this.titleMargin,
    this.opacity,
    this.useBorderStyle,
    this.border,
    this.boxShadow,
    this.useSafeArea = false,
  }) : super(key: key);

  /// 标题文案
  final String? title;

  /// 标题控件，优先级高于 [title] 文案
  final Widget? titleWidget;

  /// 左侧操作项（对齐 AppBar.leading）
  final List<TNavBarItem>? leading;

  /// 右侧操作项（对齐 AppBar.actions）
  final List<TNavBarItem>? actions;

  /// 标题是否居中
  final bool centerTitle;

  /// 是否使用默认的返回按钮
  final bool useDefaultBack;

  /// 返回事件；默认返回按钮点击时先触发该回调，再执行 Navigator.maybePop。
  final VoidCallback? onBack;

  /// NavBar 下方的 Widget
  final Widget? belowTitleWidget;

  /// 固定背景 Widget
  final Widget? flexibleSpace;

  // ---- L4 样式（可覆盖 ThemeData 默认值） ----

  /// 标题颜色
  final Color? titleColor;

  /// 左边返回图标颜色
  final Color? backIconColor;

  /// 标题字体尺寸
  final Font? titleFont;

  /// 标题字体粗细
  final FontWeight? titleFontWeight;

  /// 标题字体样式
  final FontFamily? titleFontFamily;

  /// 背景颜色
  final Color? backgroundColor;

  /// 高度；作为 [PreferredSizeWidget.preferredSize] 的唯一高度来源
  final double? height;

  /// 内部填充
  final EdgeInsetsGeometry? padding;

  /// 中间文案左右两边间距
  final double? titleMargin;

  /// 透明度
  final double? opacity;

  /// 是否使用边框模式
  final bool? useBorderStyle;

  /// 操作项边框配置
  final TNavBarBorder? border;

  /// 底部阴影
  final List<BoxShadow>? boxShadow;

  /// 是否避让顶部系统安全区。
  ///
  /// 默认为 false。仅当导航栏直接位于页面顶部且外层未处理安全区时开启。
  /// 开启后，安全区高度只计入实际渲染高度，不计入 [preferredSize]；
  /// [height] 始终表示导航栏内容高度。
  final bool useSafeArea;

  @override
  State<StatefulWidget> createState() => _TNavBarState();

  @override
  Size get preferredSize => Size.fromHeight(height ?? 48);
}

class _TNavBarState extends State<TNavBar> {
  TNavBarThemeData get _themeData =>
      Theme.of(context).extension<TNavBarThemeData>() ??
      const TNavBarThemeData();

  // ---- ThemeData 取值辅助（构造器优先 > Theme > 默认） ----

  Color _effectiveTitleColor(BuildContext context) =>
      widget.titleColor ??
      _themeData.titleColor ??
      Theme.of(context).appBarTheme.foregroundColor ??
      Theme.of(context).tExplicitColorScheme?.onSurface ??
      context.tTheme.textColorPrimary;

  Color _effectiveBackIconColor(BuildContext context) =>
      widget.backIconColor ??
      _themeData.backIconColor ??
      Theme.of(context).appBarTheme.iconTheme?.color ??
      Theme.of(context).appBarTheme.foregroundColor ??
      Theme.of(context).tExplicitColorScheme?.onSurface ??
      context.tTheme.textColorPrimary;

  Font? get _effectiveTitleFont => widget.titleFont ?? _themeData.titleFont;

  FontWeight? get _effectiveTitleFontWeight =>
      widget.titleFontWeight ?? _themeData.titleFontWeight;

  FontFamily? get _effectiveTitleFontFamily =>
      widget.titleFontFamily ?? _themeData.titleFontFamily;

  Color get _effectiveBackgroundColor =>
      widget.backgroundColor ??
      _themeData.backgroundColor ??
      Theme.of(context).appBarTheme.backgroundColor ??
      Theme.of(context).tExplicitColorScheme?.surface ??
      context.tTheme.bgColorContainer;

  double get _effectiveHeight => widget.preferredSize.height;

  EdgeInsetsGeometry get _effectivePadding =>
      widget.padding ??
      _themeData.padding ??
      EdgeInsets.symmetric(
        horizontal: context.tTheme.spacer16,
        vertical: context.tTheme.spacer4,
      );

  double get _effectiveTitleMargin =>
      widget.titleMargin ?? _themeData.titleMargin ?? 16;

  double get _effectiveOpacity => widget.opacity ?? _themeData.opacity ?? 1.0;

  bool get _effectiveUseBorderStyle =>
      widget.useBorderStyle ?? _themeData.useBorderStyle ?? false;

  TNavBarBorder get _effectiveBorder =>
      widget.border ?? _themeData.border ?? const TNavBarBorder();

  List<BoxShadow>? get _effectiveBoxShadow =>
      widget.boxShadow ?? _themeData.boxShadow;

  Widget _addBorder(List<Widget> items) {
    var border = _effectiveBorder;
    var borderColor = border.color ?? context.tTheme.componentStrokeColor;
    var children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      children.add(items[i]);
      if (_effectiveUseBorderStyle && i != items.length - 1) {
        children.add(
          Container(width: border.width, height: 16.0, color: borderColor),
        );
      }
    }
    var child = Row(children: children, mainAxisSize: MainAxisSize.min);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(border.radius),
        border: Border.all(color: borderColor, width: border.width),
      ),
      padding:
          border.padding ??
          EdgeInsets.symmetric(horizontal: context.tTheme.spacer4),
      child: child,
    );
  }

  Widget get backButton {
    var iconColor = _effectiveBackIconColor(context);
    return TNavBarItem(
      icon: TIcons.chevron_left,
      iconSize: 28.0,
      iconColor: iconColor,
      onTap: () {
        widget.onBack?.call();
        Navigator.maybePop(context);
      },
    ).toWidget(context);
  }

  Widget _buildTitleBarItems(bool isLeading) {
    var barItems = (isLeading ? widget.leading : widget.actions) ?? [];
    var children = barItems
        .map((e) => e.toWidget(context, isLeading: isLeading))
        .toList();

    return Row(
      children: [
        if (isLeading && widget.useDefaultBack) backButton,
        if (children.isNotEmpty)
          _effectiveUseBorderStyle
              ? _addBorder(children)
              : Row(children: children, mainAxisSize: MainAxisSize.min),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }

  TextStyle _getTitleStyle(BuildContext context) {
    var titleColor = _effectiveTitleColor(context);

    final materialStyle = Theme.of(context).appBarTheme.titleTextStyle;
    var titleFont = _effectiveTitleFont ?? context.tTheme.fontBodyLarge;

    return _effectiveTitleFontFamily == null
        ? TextStyle(
            fontSize: materialStyle?.fontSize ?? titleFont?.size,
            color: titleColor,
            fontWeight:
                _effectiveTitleFontWeight ??
                materialStyle?.fontWeight ??
                FontWeight.w500,
            decoration: TextDecoration.none,
          )
        : TextStyle(
            fontSize: materialStyle?.fontSize ?? titleFont?.size,
            color: titleColor,
            fontWeight:
                _effectiveTitleFontWeight ??
                materialStyle?.fontWeight ??
                FontWeight.w500,
            decoration: TextDecoration.none,
            fontFamily: _effectiveTitleFontFamily!.fontFamily,
            package: 'tdesign_flutter',
          );
  }

  Widget _getTitleWidget(BuildContext context) {
    return widget.titleWidget ??
        Text(
          widget.title ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: _getTitleStyle(context),
        );
  }

  Widget _getNavbarChild() {
    final Widget toolbar = NavigationToolbar(
      leading: _buildTitleBarItems(true),
      middle: _getTitleWidget(context),
      trailing: _buildTitleBarItems(false),
      middleSpacing: _effectiveTitleMargin,
      centerMiddle: widget.centerTitle,
    );
    if (widget.belowTitleWidget == null) {
      return toolbar;
    }
    var children = <Widget>[Expanded(child: toolbar)];
    children.add(widget.belowTitleWidget as Widget);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    var _backgroundColor = _effectiveBackgroundColor;
    if (_backgroundColor != Colors.transparent) {
      _backgroundColor = _backgroundColor.withValues(alpha: _effectiveOpacity);
    }

    final paddingTop = widget.useSafeArea
        ? MediaQuery.paddingOf(context).top
        : 0.0;
    var padding = _effectivePadding;
    Widget appBar = Container(
      height: _effectiveHeight + paddingTop,
      padding: padding.add(EdgeInsets.only(top: paddingTop)),
      decoration: BoxDecoration(
        color: _backgroundColor,
        boxShadow: _effectiveBoxShadow,
      ),
      child: _getNavbarChild(),
    );
    if (widget.flexibleSpace != null) {
      appBar = Stack(
        fit: StackFit.passthrough,
        children: <Widget>[widget.flexibleSpace!, appBar],
      );
    }

    return appBar;
  }
}

/// NavBar 操作项
class TNavBarItem {
  /// 图标
  final IconData? icon;

  /// 图标颜色
  final Color? iconColor;

  /// 点击回调；`null` 表示禁用
  final TBarItemAction? onTap;

  /// 图标尺寸
  final double? iconSize;

  /// 内部填充
  final EdgeInsetsGeometry? padding;

  /// 自定义组件，优先级高于 icon，可以是任意 Widget
  final Widget? customWidget;

  TNavBarItem({
    this.icon,
    this.iconColor,
    this.onTap,
    this.iconSize = 24.0,
    this.padding,
    this.customWidget,
  });

  Widget toWidget(BuildContext context, {bool isLeading = true}) {
    final isDisabled = onTap == null;
    final item = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding:
            padding ??
            (isLeading
                ? EdgeInsets.only(right: context.tTheme.spacer8)
                : EdgeInsets.only(left: context.tTheme.spacer8)),
        child:
            customWidget ??
            Icon(
              icon,
              size: iconSize,
              color: isDisabled ? context.tTheme.textDisabledColor : iconColor,
            ),
      ),
    );
    return Semantics(
      enabled: !isDisabled,
      child: isDisabled && customWidget != null
          ? Opacity(opacity: 0.4, child: item)
          : item,
    );
  }
}
