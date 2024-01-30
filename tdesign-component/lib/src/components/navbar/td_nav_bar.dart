import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

typedef TDBarItemAction = void Function();

class TDNavBar extends StatefulWidget implements PreferredSizeWidget {

  const TDNavBar({
    Key? key,
    this.leftBarItems,
    this.rightBarItems,
    this.titleWidget,
    this.title,
    this.titleColor,
    this.titleFont,
    this.titleFontFamily,
    this.titleFontWeight = FontWeight.w500,
    this.centerTitle = true,
    this.opacity = 1.0,
    this.backgroundColor,
    this.titleMargin = 16,
    this.padding,
    this.height = 44,
    this.screenAdaptation = true,
    this.useDefaultBack = true,
    this.onBack,
    this.useBorderStyle = false,
    this.border,
    this.belowTitleWidget,
  }) : super(key: key);

  /// 左边操作项
  final List<TDNavBarItem>? leftBarItems;
  /// 右边操作项
  final List<TDNavBarItem>? rightBarItems;
  /// 标题控件，优先级高于title文案
  final Widget? titleWidget;
  /// 标题文案
  final String? title;
  /// 标题颜色
  final Color? titleColor;
  /// 标题字体尺寸
  final Font? titleFont;
  /// 标题字体粗细
  final FontWeight? titleFontWeight;
  /// 标题字体样式
  final FontFamily? titleFontFamily;
  /// 标题是否居中
  final bool centerTitle;
  /// 透明度
  final double opacity;
  /// 背景颜色
  final Color? backgroundColor;
  /// 内部填充
  final EdgeInsetsGeometry? padding;

  /// 中间文案左右两边间距
  final double titleMargin;
  /// 高度
  final double height;

  /// 是否进行屏幕适配，默认true
  final bool screenAdaptation;

  /// 是否使用默认的返回
  final bool useDefaultBack;

  /// 返回事件
  final VoidCallback? onBack;

  /// 是否使用边框模式
  final bool useBorderStyle;

  /// 边框
  final TDNavBarItemBorder? border;

  /// belowTitleWidget navbar 下方的widget
  final Widget? belowTitleWidget;

  @override
  State<StatefulWidget> createState() => _TDNavBarState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _TDNavBarState extends State<TDNavBar> {
  Widget _addBorder(List<Widget> items) {
    var border = widget.border ?? TDNavBarItemBorder();
    var borderColor = border.color ?? TDTheme.of(context).grayColor3;
    var children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      children.add(items[i]);
      if (widget.useBorderStyle && i != items.length - 1) {
        children.add(
          Container(
            width: border.width,
            height: 16.0,
            color: borderColor,
          ),
        );
      }
    }
    var child = Row(
      children: children,
      mainAxisSize: MainAxisSize.min,
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(border.radius),
        border: Border.all(
          color: borderColor,
          width: border.width,
        ),
      ),
      padding: border.padding ??
          EdgeInsets.symmetric(horizontal: TDTheme.of(context).spacer4),
      child: child,
    );
  }

  Widget get backButton {
    return TDNavBarItem(
      icon: Icons.chevron_left,
      action: () {
        widget.onBack?.call();
        Navigator.maybePop(context);
      },
    ).toWidget(context);
  }

  Widget _buildTitleBarItems(bool isLeft) {
    var barItems =
        (isLeft ? widget.leftBarItems : widget.rightBarItems) ?? [];
    var children = barItems
        .map(
          (e) => e.toWidget(context, isLeft: isLeft),
        )
        .toList();

    return Row(
      children: [
        if (isLeft && widget.useDefaultBack)
          backButton,
        if (children.isNotEmpty)
          widget.useBorderStyle
              ? _addBorder(children)
              : Row(
                  children: children,
                  mainAxisSize: MainAxisSize.min,
                ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }

  TextStyle _getTitleStyle(BuildContext context) {
    var titleColor = widget.titleColor ?? TDTheme.of(context).fontGyColor1;

    var titleFont = widget.titleFont ?? TDTheme.of(context).fontBodyLarge;

    return widget.titleFontFamily == null
        ? TextStyle(
            fontSize: titleFont?.size,
            color: titleColor,
            fontWeight: widget.titleFontWeight ?? FontWeight.w500,
            decoration: TextDecoration.none,
          )
        : TextStyle(
            fontSize: titleFont?.size,
            color: titleColor,
            fontWeight: widget.titleFontWeight ?? FontWeight.w500,
            decoration: TextDecoration.none,
            fontFamily: widget.titleFontFamily!.fontFamily,
            package: 'tdesign_flutter');
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

  Widget _getNavbarChild(){
     final Widget toolbar = NavigationToolbar(
      leading: _buildTitleBarItems(true),
      middle: _getTitleWidget(context),
      trailing: _buildTitleBarItems(false),
      middleSpacing: widget.titleMargin,
      centerMiddle: widget.centerTitle,
    );
    if (widget.belowTitleWidget == null) {
      return toolbar;
    }
    var children = <Widget>[
      Expanded(child: toolbar)
    ];
    children.add(widget.belowTitleWidget as Widget);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    var bcc = widget.backgroundColor ?? TDTheme.of(context).whiteColor1;
    if (bcc != Colors.transparent) {
      bcc = bcc.withOpacity(widget.opacity);
    }

    var paddingTop = widget.screenAdaptation ? MediaQuery.of(context).padding.top : 0.0;
    var padding = widget.padding ??
        EdgeInsets.symmetric(
          horizontal: TDTheme.of(context).spacer16,
          vertical: TDTheme.of(context).spacer4,
        );

    print("screenAdaptation:${widget.screenAdaptation}, paddingTop:$paddingTop");
    return Container(
      color: bcc,
      height: widget.height + paddingTop,
      padding: padding.add(EdgeInsets.only(top: paddingTop)),
      child: _getNavbarChild()
    );
  }
}

class TDNavBarItem {
  /// 图标
  IconData? icon;
  /// 图标颜色
  Color? iconColor;
  /// 操作回调
  TDBarItemAction? action;
  /// 图标尺寸
  double? iconSize;
  /// 内部填充
  EdgeInsetsGeometry? padding;
  /// 图标组件，优先级高与icon
  Widget? iconWidget;

  TDNavBarItem({
    this.icon,
    this.iconColor,
    this.action,
    this.iconSize = 24.0,
    this.padding,
    this.iconWidget,
  });

  Widget toWidget(BuildContext context,{bool isLeft = true}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: action,
        child: Padding(
          padding:
          padding ?? (isLeft ? EdgeInsets.only(right: TDTheme.of(context).spacer8) : EdgeInsets.only(left: TDTheme.of(context).spacer8)),
          child: iconWidget ??
              Icon(
                icon,
                size: iconSize,
                color: iconColor,
              ),
        ),
      );
}

class TDNavBarItemBorder {
  double width;
  double radius;
  Color? color;
  EdgeInsetsGeometry? padding;

  TDNavBarItemBorder({
    this.width = 1.0,
    this.radius = 22.0,
    this.color,
    this.padding,
  });
}
