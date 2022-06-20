import 'package:flutter/material.dart';
import 'package:tdesign_flutter/td_export.dart';

typedef TDBarItemAction = void Function();

class TDNavBar extends StatefulWidget {
  final List<TDNavBarItem>? leftBarItems;
  final List<TDNavBarItem>? rightBarItems;
  final Widget? titleWidget;
  final String? title;
  final Color? titleColor;
  final Font? titleFont;
  final FontWeight? titleFontWeight;
  final FontFamily? titleFontFamily;
  final Alignment? titleAlignment;
  final double opacity;
  final Color? backgroundColor;

  /// 左边按钮间间距
  final double leftItemMargin;

  /// 右边按钮间间距
  final double rightItemMargin;

  /// 中间文案左右两边间距
  final double titleMargin;
  final double height;

  /// 是否进行屏幕适配，默认true
  final bool screenAdaptation;

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
    this.titleAlignment = Alignment.center,
    this.opacity = 1.0,
    this.backgroundColor,
    this.leftItemMargin = 16,
    this.rightItemMargin = 16,
    this.titleMargin = 16,
    this.height = 44,
    this.screenAdaptation = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TDNavBarState();
}

class _TDNavBarState extends State<TDNavBar> {
  Widget? _buildTitleBarItems(BuildContext context, bool isLeft) {
    var leading = <Widget>[];
    List<TDNavBarItem>? barItems =
        isLeft ? widget.leftBarItems : widget.rightBarItems ?? [];

    var padding = isLeft
        ? EdgeInsets.only(left: widget.leftItemMargin)
        : EdgeInsets.only(right: widget.rightItemMargin);
    barItems?.forEach((item) {
      leading.add(GestureDetector(
        child: Container(
          padding: padding,
          child: item.title != null
              ? Text(item.title!, style: _getItemTitleStyle(context))
              : item.icon,
        ),
        onTap: () {
          if (item.action == null) return;
          item.action!();
        },
      ));
    });
    return leading.isNotEmpty
        ? Row(
            children: leading,
            mainAxisSize: MainAxisSize.min,
          )
        : null;
  }

  TextStyle _getItemTitleStyle(BuildContext context) {
    return TextStyle(
        fontSize: TDTheme.of(context).fontM?.size,
        color: TDTheme.of(context).fontGyColor1,
        decoration: TextDecoration.none);
  }

  TextStyle _getTitleStyle(BuildContext context) {
    var titleColor = widget.titleColor ?? TDTheme.of(context).fontGyColor1;

    var titleFont = widget.titleFont ?? TDTheme.of(context).fontM;

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
    return Container(
      alignment: widget.titleAlignment,
      child: widget.titleWidget ?? Text(widget.title ?? '',
              maxLines: 1,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: _getTitleStyle(context)),
    );
  }

  late final top = MediaQuery.of(context).padding.top;

  @override
  Widget build(BuildContext context) {
    var bcc = widget.backgroundColor ?? TDTheme.of(context).whiteColor1;
    if (bcc != Colors.transparent) {
      bcc = bcc.withOpacity(widget.opacity);
    }

    var padding = widget.screenAdaptation ? top : 0.0;

    return Container(
      color: bcc,
      height: widget.height + padding,
      padding: EdgeInsets.only(top: padding),
      child: NavigationToolbar(
        leading: _buildTitleBarItems(context, true),
        middle: _getTitleWidget(context),
        trailing: _buildTitleBarItems(context, false),
        middleSpacing: widget.titleMargin,
        centerMiddle: widget.titleWidget == null,
      ),
    );
  }
}

class TDNavBarItem {
  Icon? icon;
  String? title;
  Color? titleColor;
  Color? iconColor;
  TDBarItemAction? action;
  double? iconWidth;
  double? iconHeight;

  TDNavBarItem({
    this.icon,
    this.title,
    this.titleColor,
    this.action,
    this.iconWidth = 24,
    this.iconHeight = 24,
  });
}
