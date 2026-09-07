import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/basic.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import 't_nav_bar_theme_data.dart';

/// NavBar 组件
///
/// Material AppBar 薄包装（NavigationToolbar 实现）。
/// - A 类禁用：操作项 `onTap: null`。
/// - L4 样式（标题颜色/字体、背景、内边距等）→ [TNavBarThemeData]。
class TNavBar extends StatelessWidget implements PreferredSizeWidget {
  const TNavBar({
    Key? key,
    this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.useDefaultBack = false,
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
    this.height = 48,
    this.padding,
    this.titleMargin,
    this.opacity,
    this.useBorderStyle = false,
    this.border,
    this.boxShadow,
    this.useSafeArea = false,
  }) : super(key: key);

  /// 标题控件。
  ///
  /// 文本标题可传入 [Text]，用法与 [AppBar.title] 一致。
  final Widget? title;

  /// 左侧操作项（对齐 AppBar.leading）
  final List<TNavBarItem>? leading;

  /// 右侧操作项（对齐 AppBar.actions）
  final List<TNavBarItem>? actions;

  /// 标题是否居中
  final bool centerTitle;

  /// 是否使用默认的返回按钮，默认不显示
  final bool useDefaultBack;

  /// 返回事件。
  ///
  /// 提供该回调时，由调用方完全接管返回行为；未提供时，默认返回按钮会执行
  /// [Navigator.maybePop]。
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
  final double height;

  /// 内部填充
  final EdgeInsetsGeometry? padding;

  /// 中间文案左右两边间距
  final double? titleMargin;

  /// 透明度
  final double? opacity;

  /// 是否使用边框模式
  final bool useBorderStyle;

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
  Size get preferredSize => Size.fromHeight(height);

  TNavBarThemeData _themeData(BuildContext context) =>
      Theme.of(context).extension<TNavBarThemeData>() ??
      const TNavBarThemeData();

  // ---- ThemeData 取值辅助（构造器优先 > Theme > 默认） ----

  Color _effectiveTitleColor(BuildContext context) =>
      titleColor ??
      _themeData(context).titleColor ??
      Theme.of(context).appBarTheme.foregroundColor ??
      Theme.of(context).tExplicitColorScheme?.onSurface ??
      context.tTheme.textColorPrimary;

  Color _effectiveBackIconColor(BuildContext context) =>
      backIconColor ??
      _themeData(context).backIconColor ??
      Theme.of(context).appBarTheme.iconTheme?.color ??
      Theme.of(context).appBarTheme.foregroundColor ??
      Theme.of(context).tExplicitColorScheme?.onSurface ??
      context.tTheme.textColorPrimary;

  Color _effectiveBackgroundColor(BuildContext context) =>
      backgroundColor ??
      _themeData(context).backgroundColor ??
      Theme.of(context).appBarTheme.backgroundColor ??
      Theme.of(context).tExplicitColorScheme?.surface ??
      context.tTheme.bgColorContainer;

  double get _effectiveHeight => preferredSize.height;

  EdgeInsetsGeometry _effectivePadding(BuildContext context) =>
      padding ??
      _themeData(context).padding ??
      EdgeInsets.symmetric(
        horizontal: context.tTheme.spacer16,
        vertical: context.tTheme.spacer4,
      );

  double _effectiveTitleMargin(BuildContext context) =>
      titleMargin ?? _themeData(context).titleMargin ?? 16;

  double _effectiveOpacity(BuildContext context) =>
      opacity ?? _themeData(context).opacity ?? 1.0;

  TNavBarBorder _effectiveBorder(BuildContext context) =>
      border ?? _themeData(context).border ?? const TNavBarBorder();

  List<BoxShadow>? _effectiveBoxShadow(BuildContext context) =>
      boxShadow ?? _themeData(context).boxShadow;

  Widget _addBorder(BuildContext context, List<Widget> items) {
    var border = _effectiveBorder(context);
    var borderColor = border.color ?? context.tTheme.componentStrokeColor;
    var children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      children.add(items[i]);
      if (useBorderStyle && i != items.length - 1) {
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

  Widget _buildBackButton(BuildContext context) {
    var iconColor = _effectiveBackIconColor(context);
    final item = TNavBarItem(
      icon: TIcons.chevron_left,
      iconSize: 24.0,
      iconColor: iconColor,
      onTap: () {
        if (onBack != null) {
          onBack!();
        } else {
          Navigator.maybePop(context);
        }
      },
    );
    return _buildItem(context, item, isLeading: true);
  }

  Widget _buildItem(
    BuildContext context,
    TNavBarItem item, {
    required bool isLeading,
  }) {
    final isDisabled = item.onTap == null;
    final child = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: item.onTap,
      child: Padding(
        padding:
            item.padding ??
            (isLeading
                ? EdgeInsets.only(right: context.tTheme.spacer8)
                : EdgeInsets.only(left: context.tTheme.spacer8)),
        child:
            item.customWidget ??
            Icon(
              item.icon,
              size: item.iconSize,
              color: isDisabled
                  ? context.tTheme.textDisabledColor
                  : item.iconColor,
            ),
      ),
    );
    return Semantics(
      enabled: !isDisabled,
      child: isDisabled && item.customWidget != null
          ? Opacity(opacity: 0.4, child: child)
          : child,
    );
  }

  Widget _buildTitleBarItems(BuildContext context, bool isLeading) {
    var barItems = (isLeading ? leading : actions) ?? [];
    var children = barItems
        .map((item) => _buildItem(context, item, isLeading: isLeading))
        .toList();

    return Row(
      children: [
        if (isLeading && useDefaultBack) _buildBackButton(context),
        if (children.isNotEmpty)
          useBorderStyle
              ? _addBorder(context, children)
              : Row(children: children, mainAxisSize: MainAxisSize.min),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }

  TextStyle _getTitleStyle(BuildContext context) {
    var titleColor = _effectiveTitleColor(context);

    final materialStyle = Theme.of(context).appBarTheme.titleTextStyle;
    final configuredFont = titleFont ?? _themeData(context).titleFont;
    final tokenFont = context.tTheme.fontTitleLarge;
    final configuredFamily =
        titleFontFamily ?? _themeData(context).titleFontFamily;

    return TextStyle(
      fontSize:
          configuredFont?.size ?? materialStyle?.fontSize ?? tokenFont?.size,
      // 显式 titleFont 延续既有语义，不额外施加 Font 中的行高；同时也不允许
      // 低优先级 Material 样式反向覆盖。未显式配置时才由 Material/Token 提供行高。
      height: configuredFont == null
          ? (materialStyle?.height ?? tokenFont?.height)
          : null,
      color: titleColor,
      fontWeight:
          titleFontWeight ??
          _themeData(context).titleFontWeight ??
          configuredFont?.fontWeight ??
          materialStyle?.fontWeight ??
          tokenFont?.fontWeight,
      decoration: TextDecoration.none,
      fontFamily: configuredFamily?.fontFamily ?? materialStyle?.fontFamily,
      // Material TextStyle 已将 package 编码进 fontFamily；只有 TDesign 的
      // FontFamily 配置需要在此传入 package。
      package: configuredFamily == null
          ? null
          : (configuredFamily.package ?? 'tdesign_flutter'),
    );
  }

  Widget _getTitleWidget(BuildContext context) {
    return DefaultTextStyle.merge(
      style: _getTitleStyle(context),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: title ?? const SizedBox.shrink(),
    );
  }

  Widget _getNavbarChild(BuildContext context) {
    final Widget toolbar = NavigationToolbar(
      leading: _buildTitleBarItems(context, true),
      middle: _getTitleWidget(context),
      trailing: _buildTitleBarItems(context, false),
      middleSpacing: _effectiveTitleMargin(context),
      centerMiddle: centerTitle,
    );
    if (belowTitleWidget == null) {
      return toolbar;
    }
    var children = <Widget>[Expanded(child: toolbar)];
    children.add(belowTitleWidget!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    var effectiveBackgroundColor = _effectiveBackgroundColor(context);
    if (effectiveBackgroundColor != Colors.transparent) {
      effectiveBackgroundColor = effectiveBackgroundColor.withValues(
        alpha: _effectiveOpacity(context),
      );
    }

    final paddingTop = useSafeArea ? MediaQuery.paddingOf(context).top : 0.0;
    var effectivePadding = _effectivePadding(context);
    Widget appBar = Container(
      height: _effectiveHeight + paddingTop,
      padding: effectivePadding.add(EdgeInsets.only(top: paddingTop)),
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        boxShadow: _effectiveBoxShadow(context),
      ),
      child: _getNavbarChild(context),
    );
    if (flexibleSpace != null) {
      appBar = Stack(
        fit: StackFit.passthrough,
        children: <Widget>[flexibleSpace!, appBar],
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
  final VoidCallback? onTap;

  /// 图标尺寸
  final double? iconSize;

  /// 内部填充
  final EdgeInsetsGeometry? padding;

  /// 自定义组件，优先级高于 icon，可以是任意 Widget
  final Widget? customWidget;

  const TNavBarItem({
    this.icon,
    this.iconColor,
    this.onTap,
    this.iconSize = 24.0,
    this.padding,
    this.customWidget,
  });
}
