import 'package:flutter/material.dart';

import '../../../td_export.dart';

// 向下箭头宽高
const double _kArrowWidth = 13.5;
// 向下箭头宽高
const double _kArrowHeight = 8;
// 选项弹窗 单个item最低高度
const double _kMenuItemMinHeight = 23;
// 选项弹窗 单个item默认高度
const double _kDefaultMenuItemHeight = 48;
// 选项弹窗 单个item默认宽度为按钮宽度-20
const double _kDefaultMenuItemWidthShrink = 20;
// 底部弹窗默认高度
const double _kDefaultNavBarHeight = 48;
// 弹窗弹出动画时间
const Duration _kPopupMenuDuration = Duration(milliseconds: 10);

enum TDBottomNavBarType {
  /// 单层级纯文本标签栏
  text,

  /// 文本加图标标签栏
  iconText,

  /// 纯图标标签栏
  icon,

  /// 双层级纯文本标签栏
  expansionPanel,

  // 自定义布局
  customLayout,
}

class TDBottomNavBarTabConfig {
  // 自定义未选中状态widget
  final Widget? unSelectWidget;

  // 自定义选中状态widget
  final Widget? selectWidget;

  // 图标
  final Widget? selectedIcon;

  // 未选中图标
  final Widget? unselectedIcon;

  // 选中文本
  final Text? selectedText;

  // 未选中文本
  final Text? unselectedText;

  // 点击事件
  final GestureTapCallback? onTap;

  // 是否展示消息样式
  final bool? showBadge;

  // 自定义消息样式
  final Widget? customBadgeWidget;

  // 使用TDBadge消息样式
  final TDBadge? tdBadge;

  // 消息顶部偏移量
  final double? badgeTopOffset;

  // 消息右侧偏移量
  final double? badgeRightOffset;

  final TDBottomNavBarPopUpBtnConfig? popUpButtonConfig;

  TDBottomNavBarTabConfig({
    required this.onTap,
    this.unSelectWidget,
    this.selectWidget,
    this.selectedIcon,
    this.unselectedIcon,
    this.selectedText,
    this.unselectedText,
    this.showBadge,
    this.customBadgeWidget,
    this.tdBadge,
    this.badgeTopOffset,
    this.badgeRightOffset,
    this.popUpButtonConfig,
  }) : assert(() {
          if (showBadge != null && showBadge) {
            if (customBadgeWidget == null && tdBadge == null) {
              throw FlutterError('[NavigationTab] if set showBadge = true, '
                  'you must set customBadgeWidget or tdBadge');
            }
          }
          return true;
        }());
}

class TDBottomNavBar extends StatefulWidget {
  final TDBottomNavBarType type;

  // tab
  final List<TDBottomNavBarTabConfig> navigationTabs;

  // tab高度
  final double? barHeight;

  // 是否使用竖线分隔
  final bool? useVerticalDivider;

  // 分割线高度（可选）
  final double? dividerHeight;

  // 分割线厚度（可选）
  final double? dividerThickness;

  // 分割线颜色（可选）
  final Color? dividerColor;

  // 是否展示bar上边线（设置为true 但是topBorder样式未设置，则使用默认值）
  final bool? showTopBorder;

  // 上边线样式
  final BorderSide? topBorder;

  TDBottomNavBar(
    this.type, {
    Key? key,
    required this.navigationTabs,
    this.barHeight = _kDefaultNavBarHeight,
    this.useVerticalDivider,
    this.dividerHeight,
    this.dividerThickness,
    this.dividerColor,
    this.showTopBorder = true,
    this.topBorder,
  })  : assert(() {
          if (type == TDBottomNavBarType.customLayout) {
            for (final item in navigationTabs) {
              if (item.selectWidget == null || item.unSelectWidget == null) {
                throw FlutterError(
                    '[TDBottomNavigationBar] customLayout request selectWidget and unSelectWidget,'
                    'but get null.');
              }
            }
          }
          if (type == TDBottomNavBarType.text) {
            for (final item in navigationTabs) {
              if (item.selectedText == null || item.unselectedText == null) {
                throw FlutterError(
                    '[TDBottomNavigationBar] type is TDBottomBarType.text, but not set text.');
              }
            }
          }
          if (type == TDBottomNavBarType.icon) {
            for (final item in navigationTabs) {
              if (item.selectedIcon == null || item.unselectedIcon == null) {
                throw FlutterError(
                    '[TDBottomNavigationBar] type is TDBottomBarType.icon,'
                    'but not set icon.');
              }
            }
          }
          if (type == TDBottomNavBarType.iconText) {
            for (final item in navigationTabs) {
              if (item.selectedIcon == null ||
                  item.unselectedIcon == null ||
                  item.selectedText == null ||
                  item.unselectedText == null) {
                throw FlutterError(
                    '[TDBottomNavigationBar] type is TDBottomBarType.iconText,'
                    'but not set icon or text.');
              }
            }
          }
          return true;
        }()),
        super(key: key);

  @override
  State<TDBottomNavBar> createState() => _TDBottomNavBarState();
}

class _TDBottomNavBarState extends State<TDBottomNavBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var maxWidth =
            double.parse(constraints.biggest.width.toStringAsFixed(1));
        var itemWidth = maxWidth / widget.navigationTabs.length;
        return Container(
            decoration: widget.showTopBorder!
                ? BoxDecoration(
                    border: Border(
                        top: widget.topBorder ??
                            BorderSide(
                                width: 0.5,
                                color: TDTheme.of(context).grayColor3)))
                : null,
            child: Stack(alignment: Alignment.center, children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      List.generate(widget.navigationTabs.length, (index) {
                    return _item(index, itemWidth);
                  })),
              _verticalDivider(),
            ]));
      },
    );
  }

  void _onTap(int index) {
    setState(() {
      if (selectedIndex != index) {
        selectedIndex = index;
        widget.navigationTabs[index].onTap?.call();
      }
    });
  }

  Widget _item(int index, double itemWidth) {
    return Container(
        height: widget.barHeight ?? _kDefaultNavBarHeight,
        width: itemWidth,
        alignment: Alignment.center,
        child: TDBottomNavBarItemWithBadge(
          item: _constructItem(index),
          itemHeight: widget.barHeight ?? _kDefaultNavBarHeight,
          itemWidth: itemWidth,
          onTap: () {
            _onTap(index);
          },
          showBage: widget.navigationTabs[index].showBadge ?? false,
          badge: _badge(index),
          rightOffset: widget.navigationTabs[index].badgeRightOffset,
          topOffset: widget.navigationTabs[index].badgeTopOffset,
          popUpButtonConfig: widget.navigationTabs[index].popUpButtonConfig,
        ));
  }

  Widget _constructItem(int index) {
    if (widget.type == TDBottomNavBarType.customLayout) {
      return index == selectedIndex
          ? widget.navigationTabs[index].selectWidget!
          : widget.navigationTabs[index].unSelectWidget!;
    }
    if (widget.type == TDBottomNavBarType.text) {
      return index == selectedIndex
          ? widget.navigationTabs[index].selectedText!
          : widget.navigationTabs[index].unselectedText!;
    }
    if (widget.type == TDBottomNavBarType.icon) {
      return index == selectedIndex
          ? widget.navigationTabs[index].selectedIcon!
          : widget.navigationTabs[index].unselectedIcon!;
    }

    if (widget.type == TDBottomNavBarType.iconText) {
      return index == selectedIndex
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                widget.navigationTabs[index].selectedIcon!,
                widget.navigationTabs[index].selectedText!
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                widget.navigationTabs[index].unselectedIcon!,
                widget.navigationTabs[index].unselectedText!
              ],
            );
    }
    return Container();
  }

  Widget _badge(int index) {
    if (widget.navigationTabs[index].showBadge ?? false) {
      if (widget.navigationTabs[index].tdBadge != null) {
        return widget.navigationTabs[index].tdBadge!;
      } else if (widget.navigationTabs[index].customBadgeWidget != null) {
        return widget.navigationTabs[index].customBadgeWidget!;
      }
    }
    return Container();
  }

  Widget _verticalDivider() {
    return Visibility(
      visible: widget.useVerticalDivider ?? false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(widget.navigationTabs.length - 1, (index) {
          return SizedBox(
            width: widget.dividerThickness ?? 0.5,
            height: widget.dividerHeight ?? 32,
            child: VerticalDivider(
              color: widget.dividerColor ?? TDTheme.of(context).grayColor3,
              thickness: widget.dividerThickness ?? 0.5,
            ),
          );
        }),
      ),
    );
  }
}

class TDBottomNavBarItemWithBadge extends StatelessWidget {
  final Widget item;
  final double itemHeight;
  final double itemWidth;
  final GestureTapCallback onTap;
  final bool showBage;
  final Widget badge;
  final double? rightOffset;
  final double? topOffset;
  final TDBottomNavBarPopUpBtnConfig? popUpButtonConfig;

  const TDBottomNavBarItemWithBadge({
    Key? key,
    required this.item,
    required this.itemHeight,
    required this.itemWidth,
    required this.onTap,
    required this.showBage,
    required this.badge,
    this.rightOffset,
    this.topOffset,
    this.popUpButtonConfig,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap.call();
        if (popUpButtonConfig != null) {
          Navigator.push(
              context,
              PopRoute(
                child: PopupDialog(
                  itemWidth - _kDefaultMenuItemWidthShrink,
                  btnContext: context,
                  config: popUpButtonConfig!.popUpDialogConfig,
                  items: popUpButtonConfig!.items,
                  onClickMenu: (value) {
                    popUpButtonConfig!.onChanged(value);
                  },
                ),
              ));
        }
      },
      child: Container(
        height: itemHeight,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            item,
            Visibility(
              visible: showBage,
              child: Positioned(
                  top: topOffset ?? -5,
                  right: rightOffset ?? -10,
                  child: badge),
            )
          ],
        ),
      ),
    );
  }
}

class TDBottomNavBarPopUpBtnConfig {
  // 选项list
  final List<PopUpMenuItem> items;

  // 统一在 onChanged 中处理各item点击事件
  final ValueChanged<String> onChanged;

  final TDBottomNavBarPopUpShapeConfig? popUpDialogConfig;

  TDBottomNavBarPopUpBtnConfig(
      {required this.items, required this.onChanged, this.popUpDialogConfig})
      : assert(() {
          if (popUpDialogConfig != null) {
            if ((popUpDialogConfig.arrowHeight != null &&
                    popUpDialogConfig.arrowHeight! <= 0.0) ||
                (popUpDialogConfig.arrowWidth != null &&
                    popUpDialogConfig.arrowWidth! <= 0.0)) {
              throw FlutterError(
                  '[TDBottomNavBarPopUpBtnConfig] arrowHeight or arrowHeight can '
                  'not set less than or equal to zero');
            }
          }
          return true;
        }());
}

class TDBottomNavBarPopUpShapeConfig {
  // 弹窗宽度（不设置，默认为按钮宽度 - 20）
  final double? popUpWidth;

  // 单个选项高度 所有选项等高 不设置则使用默认值 48
  final double? popUpitemHeight;

  // 弹窗背景颜色
  Color? backgroundColor;

  /// pannel圆角 默认0
  double? radius;

  /// 箭头宽度 默认13.5
  double? arrowWidth;

  // 箭头高度 默认8
  double? arrowHeight;

  TDBottomNavBarPopUpShapeConfig(
      {this.popUpWidth,
      this.popUpitemHeight = _kDefaultMenuItemHeight,
      this.backgroundColor,
      this.radius,
      this.arrowWidth,
      this.arrowHeight});
}

class PopUpMenuItem extends StatelessWidget {
  // 选项widget
  final Widget? itemWidget;

  // 选项值
  final String value;

  // 对齐方式
  final AlignmentGeometry alignment;

  const PopUpMenuItem({
    Key? key,
    this.itemWidget,
    required this.value,
    this.alignment = AlignmentDirectional.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: _kMenuItemMinHeight),
      alignment: alignment,
      child: itemWidget ??
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
    );
  }
}

class PopRoute extends PopupRoute {
  Widget child;

  PopRoute({required this.child});

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'popUpMenuBarrierLabel';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _kPopupMenuDuration;
}

class PopupDialog extends StatefulWidget {
  // 按钮context
  final BuildContext btnContext;

  // 点击事件
  final ValueChanged<String> onClickMenu;

  // 弹窗选项列表
  final List<PopUpMenuItem> items;

  // 弹窗配置
  final TDBottomNavBarPopUpShapeConfig? config;

  // 默认弹窗宽度
  final double defaultPopUpWidth;

  const PopupDialog(this.defaultPopUpWidth,
      {Key? key,
      required this.btnContext,
      required this.onClickMenu,
      required this.items,
      required this.config})
      : super(key: key);

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
    button = widget.btnContext.findRenderObject() as RenderBox;
    size = button!.size;
    overlay =
        Overlay.of(widget.btnContext)?.context.findRenderObject() as RenderBox;
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
    var popUpitemHeight =
        widget.config?.popUpitemHeight ?? _kDefaultMenuItemHeight;
    var popUpItemWidth = widget.config?.popUpWidth ?? widget.defaultPopUpWidth;
    var menuItems = widget.items
        .map((e) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              widget.onClickMenu(e.value);
              Navigator.of(context).pop();
            },
            child: SizedBox(
              height: popUpitemHeight,
              child: e,
            )))
        .toList();

    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
            Positioned(
                top: position!.top -
                    (popUpitemHeight * widget.items.length +
                        (widget.config?.arrowHeight ?? _kArrowHeight)),
                right: position!.right - (popUpItemWidth + size!.width) / 2,
                child: SizedBox(
                  width: popUpItemWidth,
                  height: popUpitemHeight * widget.items.length +
                      (widget.config?.arrowHeight ?? _kArrowHeight),
                  child: CustomPaint(
                    painter: PannelWithDownArrow(config: widget.config),
                    child: Container(
                      alignment: Alignment.topCenter,
                      height: popUpitemHeight * widget.items.length,
                      child: Container(
                        constraints: BoxConstraints(
                            maxHeight: popUpitemHeight * widget.items.length),
                        child: Stack(
                          children: [
                            Column(children: menuItems),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                  widget.items.length - 1,
                                  (index) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Divider(
                                          thickness: 0.5,
                                          height: 0.5,
                                          color: TDTheme.of(context).grayColor3,
                                        ),
                                      )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

/// 带下箭头的展开pannel
class PannelWithDownArrow extends CustomPainter {
  TDBottomNavBarPopUpShapeConfig? config;

  PannelWithDownArrow({
    this.config,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..isAntiAlias = true
      ..color = config?.backgroundColor ?? Colors.white
      ..style = PaintingStyle.fill;
    var path = Path();
    var pannelWidth = size.width;
    var pannelHeight = size.height - (config?.arrowHeight ?? _kArrowHeight);

    canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, pannelWidth, pannelHeight),
            Radius.circular(config?.radius ?? 0.0)),
        paint);

    // 下方箭头
    if (config?.arrowWidth != 0.0 && config?.arrowHeight != 0.0) {
      var left = (pannelWidth - _kArrowWidth) / 2;
      var right = (pannelWidth + _kArrowWidth) / 2;
      var bottom = pannelHeight + _kArrowHeight;
      if (config?.arrowWidth != null) {
        left = (pannelWidth - config!.arrowWidth!) / 2;
        right = (pannelWidth + config!.arrowWidth!) / 2;
      }
      if (config?.arrowHeight != null) {
        bottom = pannelHeight + config!.arrowHeight!;
      }

      path.moveTo(left, pannelHeight);
      path.lineTo(pannelWidth / 2, bottom);
      path.lineTo(right, pannelHeight);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
