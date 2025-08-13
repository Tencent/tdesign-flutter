import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/td_colors.dart';
import '../../theme/td_fonts.dart';
import '../../theme/td_theme.dart';
import '../icon/td_icons.dart';
import '../text/td_text.dart';
import './td_dropdown_item.dart';
import 'td_dropdown_popup.dart';

/// 菜单展开方向
enum TDDropdownMenuDirection {
  /// 向下
  down,

  /// 向上
  up,

  /// 根据内容高度动态展示方向
  auto,
}

/// 下拉菜单构建器
typedef TDDropdownItemBuilder = List<TDDropdownItem> Function(BuildContext context);

/// 自定义标签内容
typedef LabelBuilder = Widget Function(BuildContext context, String label, bool isOpened, int index);

/// 下拉菜单
class TDDropdownMenu extends StatefulWidget {
  const TDDropdownMenu({
    Key? key,
    this.builder,
    this.items,
    this.closeOnClickOverlay = true,
    this.direction = TDDropdownMenuDirection.auto,
    this.duration = 200.0,
    this.showOverlay = true,
    this.isScrollable = false,
    this.arrowIcon,
    this.labelBuilder,
    this.onMenuOpened,
    this.onMenuClosed,
    this.width,
    this.height = 48,
    this.tabBarAlign = MainAxisAlignment.center,
    this.decoration,
  }) : super(key: key);

  /// 下拉菜单构建器，优先级高于[items]
  final TDDropdownItemBuilder? builder;

  /// 下拉菜单
  final List<TDDropdownItem>? items;

  /// 是否在点击遮罩层后关闭菜单
  final bool closeOnClickOverlay;

  /// 菜单展开方向（down、up、auto）
  final TDDropdownMenuDirection? direction;

  /// 动画时长，毫秒
  final double? duration;

  /// 是否显示遮罩层
  final bool? showOverlay;

  /// 自定义箭头图标
  final IconData? arrowIcon;

  /// 自定义标签内容
  final LabelBuilder? labelBuilder;

  /// 展开菜单事件
  final ValueChanged<int>? onMenuOpened;

  /// 关闭菜单事件
  final ValueChanged<int>? onMenuClosed;

  /// 是否开启滚动列表
  final bool? isScrollable;

  /// menu的宽度
  final double? width;

  /// menu的高度
  final double? height;

  /// [TDDropdownItem.label]和[arrowIcon]/[TDDropdownItem.arrowIcon]的对齐方式
  final MainAxisAlignment? tabBarAlign;

  /// 下拉菜单的装饰器
  final Decoration? decoration;

  @override
  _TDDropdownMenuState createState() => _TDDropdownMenuState();
}

class _TDDropdownMenuState extends State<TDDropdownMenu> with TickerProviderStateMixin {
  List<TDDropdownItem>? _items;
  List<AnimationController>? _iconControllers;
  late List<Animation<double>> _iconAnimations;
  late List<bool> _isOpened;
  TDDropdownPopup? _dropdownPopup;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _iconControllers?.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  void didUpdateWidget(TDDropdownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.builder != oldWidget.builder || widget.items != oldWidget.items) {
      _init();
    }
  }

  @override
  Widget build(BuildContext context) {
    var tabBar = widget.isScrollable == true
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(
                _items?.length ?? 0,
                (index) => SizedBox(
                  width: _items![index].tabBarWidth,
                  child: _tabBarContent(index),
                ),
              ),
            ),
          )
        : Row(
            children: List.generate(
              _items?.length ?? 0,
              (index) {
                return Expanded(
                  flex: _items![index].tabBarFlex ?? 1,
                  child: _tabBarContent(index),
                );
              },
            ),
          );
    return Container(
      height: widget.height,
      width: widget.width ?? double.infinity,
      decoration: widget.decoration ??
          BoxDecoration(
            color: TDTheme.of(context).whiteColor1,
            border: Border(
              bottom: BorderSide(
                color: TDTheme.of(context).grayColor3,
                width: 1,
              ),
            ),
          ),
      child: tabBar,
    );
  }

  void _init() {
    var items = widget.builder?.call(context) ?? widget.items ?? [];
    if (items.length == _items?.length) {
      _items = items;
      return;
    }
    _isOpened = List.filled(items.length, false);
    _items = items;
    _iconControllers?.forEach((controller) {
      controller.dispose();
    });
    _iconControllers = List.generate(
        _items?.length ?? 0,
        (index) => AnimationController(
              duration: Duration(milliseconds: (widget.duration ?? 200).toInt()),
              vsync: this,
            ));
    _iconAnimations = _iconControllers?.map((e) => Tween<double>(begin: 0, end: 0.5).animate(e)).toList() ?? [];
  }

  Widget _tabBarContent(int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (_disabled(index)) {
          return;
        }
        _isOpened[index] ? await Navigator.maybePop(context) : _openMenu(index);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: _items![index].tabBarAlign ?? widget.tabBarAlign ?? MainAxisAlignment.center,
        children: [Flexible(child: _getText(index)), _getIcon(index)],
      ),
    );
  }

  Widget _getText(int index) {
    final label = _items![index].getLabel();
    if (widget.labelBuilder != null) {
      return widget.labelBuilder!(context, label, _isOpened[index], index);
    }
    var textColor = _disabled(index)
        ? TDTheme.of(context).fontGyColor4
        : _isOpened[index]
            ? TDTheme.of(context).brandColor7
            : TDTheme.of(context).fontGyColor1;
    return TDText(
      label,
      font: TDTheme.of(context).fontBodyMedium,
      textColor: textColor,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _getIcon(int index) {
    var arrowIcon = _items![index].arrowIcon ??
        widget.arrowIcon ??
        (widget.direction == TDDropdownMenuDirection.up ? TDIcons.caret_up_small : TDIcons.caret_down_small);
    return RotationTransition(
      turns: _iconAnimations[index],
      child: Icon(
        arrowIcon,
        size: 24,
        color: _disabled(index)
            ? TDTheme.of(context).fontGyColor4
            : _isOpened[index]
                ? TDTheme.of(context).brandColor7
                : null,
      ),
    );
  }

  bool _disabled(int index) {
    return _items![index].disabled == true;
  }

  Future<void> openMenu(int index) async {
    await _openMenu(index);
  }

  Future<void> closeMenu() async {
    await _closeMenu();
  }

  /// 打开菜单
  Future<void>  _openMenu(int index) async {
    /// 如果已经打开了，则关闭
    if (_isOpened.contains(true)) {
      await Navigator.maybePop(context);
    }
    _dropdownPopup ??= TDDropdownPopup(
      child: _items![index],
      parentContext: context,
      handleClose: _closeMenu,
      direction: widget.direction,
      showOverlay: widget.showOverlay,
      closeOnClickOverlay: widget.closeOnClickOverlay,
      duration: Duration(milliseconds: (widget.duration ?? 200).toInt()),
    );
    unawaited(_dropdownPopup!.add(_items![index]).then((value) {
      widget.onMenuOpened?.call(index);
    }));

    _isOpened = List.filled(_items?.length ?? 0, false);
    _isOpened[index] = true;
    setState(() {});
    _iconControllers?.asMap().forEach((key, value) {
      if (value.status == AnimationStatus.completed) {
        value.reverse();
      } else if (key == index) {
        value.forward();
      }
    });
  }

  /// 关闭菜单
  Future<void> _closeMenu() async {
    var index = _isOpened.indexOf(true);
    if (index < 0) {
      return;
    }
    _isOpened = List.filled(_items?.length ?? 0, false);
    setState(() {});
    _iconControllers?.forEach((value) {
      if (value.status == AnimationStatus.completed) {
        value.reverse();
      }
    });
    await _dropdownPopup?.remove();
    if (index >= 0 && widget.onMenuClosed != null) {
      widget.onMenuClosed!(index);
    }
  }
}
