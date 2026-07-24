import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tdesign_icons/tdesign_icons.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../text/t_text.dart';
import './t_dropdown_item.dart';
import 't_dropdown_popup.dart';
import 't_dropdown_theme_data.dart';

/// 菜单展开方向
enum TDropdownMenuDirection {
  /// 向下
  down,

  /// 向上
  up,

  /// 根据内容高度动态展示方向
  auto,
}

/// 下拉菜单构建器
typedef TDropdownItemBuilder<T> = List<TDropdownItem<T>> Function(
    BuildContext context);

/// 自定义标签内容
typedef LabelBuilder = Widget Function(
    BuildContext context, String label, bool isOpened, int index);

/// 下拉菜单
class TDropdownMenu<T> extends StatefulWidget {
  const TDropdownMenu({
    Key? key,
    this.builder,
    this.items,
    this.closeOnClickOverlay = true,
    this.direction = TDropdownMenuDirection.auto,
    this.duration = 200.0,
    this.showOverlay = true,
    this.isScrollable = false,
    this.labelBuilder,
    this.onMenuOpened,
    this.onMenuClosed,
  }) : super(key: key);

  /// 下拉菜单构建器，优先级高于[items]
  final TDropdownItemBuilder<T>? builder;

  /// 下拉菜单
  final List<TDropdownItem<T>>? items;

  /// 是否在点击遮罩层后关闭菜单
  final bool? closeOnClickOverlay;

  /// 菜单展开方向（down、up、auto）
  final TDropdownMenuDirection? direction;

  /// 动画时长，毫秒
  final double? duration;

  /// 是否显示遮罩层
  final bool? showOverlay;

  /// 自定义标签内容
  final LabelBuilder? labelBuilder;

  /// 展开菜单事件
  final ValueChanged<int>? onMenuOpened;

  /// 关闭菜单事件
  final ValueChanged<int>? onMenuClosed;

  /// 是否开启滚动列表
  final bool? isScrollable;

  @override
  State<TDropdownMenu<T>> createState() => _TDropdownMenuState<T>();
}

class _TDropdownMenuState<T> extends State<TDropdownMenu<T>>
    with TickerProviderStateMixin {
  List<TDropdownItem<T>>? _items;
  List<AnimationController>? _iconControllers;
  late List<Animation<double>> _iconAnimations;
  late List<bool> _isOpened;
  TDropdownPopup<T>? _dropdownPopup;

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
  void didUpdateWidget(TDropdownMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.builder != oldWidget.builder ||
        widget.items != oldWidget.items) {
      _init();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TDropdownThemeData>() ??
        const TDropdownThemeData();
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
                  flex: _items![index].tabBarFlex,
                  child: _tabBarContent(index),
                );
              },
            ),
          );
    return Container(
      height: theme.height ?? 48,
      width: theme.width ?? double.infinity,
      decoration: theme.decoration ??
          BoxDecoration(
            color: context.tTheme.bgColorContainer,
            border: Border(
              bottom: BorderSide(
                color: context.tTheme.componentStrokeColor,
                width: 0.5,
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
              duration:
                  Duration(milliseconds: (widget.duration ?? 200).toInt()),
              vsync: this,
            ));
    _iconAnimations = _iconControllers
            ?.map((e) => Tween<double>(begin: 0, end: 0.5).animate(e))
            .toList() ??
        [];
  }

  Widget _tabBarContent(int index) {
    final color = _disabled(index)
        ? context.tTheme.textDisabledColor
        : _isOpened[index]
            ? context.tTheme.brandNormalColor
            : context.tTheme.textColorPrimary;

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
        mainAxisAlignment: _items![index].tabBarAlign ??
            Theme.of(context).extension<TDropdownThemeData>()?.tabBarAlign ??
            MainAxisAlignment.center,
        children: [
          Flexible(child: _getText(index, color)),
          _getIcon(index, color)
        ],
      ),
    );
  }

  Widget _getText(int index, Color color) {
    final label = _items![index].getLabel();
    if (widget.labelBuilder != null) {
      return widget.labelBuilder!(context, label, _isOpened[index], index);
    }
    return TText(
      label,
      font: context.tTheme.fontBodyMedium,
      textColor: color,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _getIcon(int index, Color color) {
    var arrowIcon = _items![index].arrowIcon ??
        Theme.of(context).extension<TDropdownThemeData>()?.arrowIcon ??
        (widget.direction == TDropdownMenuDirection.up
            ? TIcons.caret_up_small
            : TIcons.caret_down_small);
    return RotationTransition(
      turns: _iconAnimations[index],
      child: Icon(arrowIcon,
          size: 20,
          color: _items![index].arrowColor ??
              Theme.of(context).extension<TDropdownThemeData>()?.arrowColor ??
              color),
    );
  }

  bool _disabled(int index) {
    return _items![index].disabled == true;
  }

  /// 打开指定索引的菜单
  Future<void> openMenu(int index) async {
    await _openMenu(index);
  }

  /// 关闭菜单
  Future<void> closeMenu() async {
    if (_isOpened.contains(true)) {
      await Navigator.maybePop(context);
    }
  }

  /// 打开菜单
  Future<void> _openMenu(int index) async {
    /// 如果已经打开了，则关闭
    if (_isOpened.contains(true)) {
      await closeMenu();
    }
    _dropdownPopup ??= TDropdownPopup<T>(
      child: _items![index],
      parentContext: context,
      handleClose: _closeMenu,
      direction: widget.direction,
      showOverlay: widget.showOverlay,
      overlayColor:
          Theme.of(context).extension<TDropdownThemeData>()?.overlayColor,
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
    final popup = _dropdownPopup;
    if (popup != null) {
      unawaited(popup.remove());
    }
    if (index >= 0 && widget.onMenuClosed != null) {
      widget.onMenuClosed!(index);
    }
  }
}
