import 'package:flutter/material.dart';

import './td_dropdown_item.dart';
import '../../theme/td_colors.dart';
import '../../theme/td_theme.dart';
import '../icon/td_icons.dart';

/// 菜单展开方向
enum TDDropdownMenuDirection { down, up }

/// 下拉菜单构建器
typedef TDDropdownItemBuilder<T> = List<TDDropdownItem<T>> Function(BuildContext context);

/// 下拉菜单
class TDDropdownMenu<T> extends StatefulWidget {
  const TDDropdownMenu({
    Key? key,
    required this.builder,
    this.closeOnClickOverlay = true,
    this.direction = TDDropdownMenuDirection.down,
    this.duration = 200.0,
    this.showOverlay = true,
    this.arrowIcons, //  = const [Icon(TDIcons.caret_up_small), Icon(TDIcons.caret_down_small)]
    this.onMenuOpened,
    this.onMenuClosed,
  }) : super(key: key);

  /// 下拉菜单构建器
  final TDDropdownItemBuilder<T> builder;

  /// 是否在点击遮罩层后关闭菜单
  final bool closeOnClickOverlay;

  /// 菜单展开方向
  final TDDropdownMenuDirection direction;

  /// 动画时长
  final double duration;

  /// 是否显示遮罩层
  final bool showOverlay;

  /// 自定义箭头图标[关闭,展开]
  final List<Icon>? arrowIcons;

  /// 展开菜单事件
  final ValueChanged<TDDropdownItem<T>>? onMenuOpened;

  /// 关闭菜单事件
  final ValueChanged<TDDropdownItem<T>>? onMenuClosed;

  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<TDDropdownMenu> {
  var _isOpen = false;
  late List<TDDropdownItem> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.builder(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: TDTheme.of(context).whiteColor1,
        border: Border(
          bottom: BorderSide(
            color: TDTheme.of(context).grayColor4,
            width: 1,
          ),
        ),
      ),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(_items.length, (index) {
            return Expanded(
                child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      print('Row 被点击了');
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('xxxxx'),
                          Icon(TDIcons.caret_up_small)
                        ])));
          })),
    );
  }

  Map<String, dynamic> _getItemConfig(TDDropdownItem dropdownItem) {
    var label = dropdownItem.label;
    var currentValue = dropdownItem.value;
  }
}

