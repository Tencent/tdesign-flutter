import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';
import '../badge/t_badge.dart';
import '../loading/t_loading.dart';
import 't_sidebar_item.dart';
import 't_sidebar_theme_data.dart';
import 't_wrap_sidebar_item.dart';

class _SideBarItemData {
  _SideBarItemData({
    required this.value,
    required this.index,
    required this.key,
    this.disabled,
    this.icon,
    this.label,
    this.badge,
    this.textStyle,
  });

  final int index;
  final int value;
  final GlobalKey key;
  final bool? disabled;
  final IconData? icon;
  final String? label;
  final TBadge? badge;
  final TextStyle? textStyle;
}

/// 受控的侧边导航栏。
///
/// [value] 由调用方持有；用户选择可用项时通过 [onChanged] 报告新的值。
/// 未提供 [onChanged] 时，整个侧边栏以禁用态展示。
class TSideBar extends StatefulWidget {
  const TSideBar({
    Key? key,
    required this.value,
    this.selectedColor,
    this.children = const [],
    this.onChanged,
    this.height,
    this.contentPadding,
    this.selectedTextStyle,
    this.style,
    this.loading = false,
    this.loadingWidget,
    this.selectedBgColor,
    this.unSelectedBgColor,
    this.unSelectedColor,
  }) : super(key: key);

  /// 当前选中项值。
  final int value;

  /// 侧边栏项。
  final List<TSideBarItem> children;

  /// 选中值变化回调；为 null 时禁用整栏。
  final ValueChanged<int>? onChanged;

  /// 选中值后颜色（优先级高于 ThemeData）。
  final Color? selectedColor;

  /// 未选中颜色（优先级高于 ThemeData）。
  final Color? unSelectedColor;

  /// 选中样式（优先级高于 ThemeData）。
  final TextStyle? selectedTextStyle;

  /// 样式（优先级高于 ThemeData）。
  final TSideBarVariant? style;

  /// 高度（优先级高于 ThemeData）。
  final double? height;

  /// 自定义文本框内边距（优先级高于 ThemeData）。
  final EdgeInsetsGeometry? contentPadding;

  /// 是否展示加载态。
  final bool loading;

  /// 自定义加载态内容。
  final Widget? loadingWidget;

  /// 选择的背景颜色（优先级高于 ThemeData）。
  final Color? selectedBgColor;

  /// 未选择的背景颜色（优先级高于 ThemeData）。
  final Color? unSelectedBgColor;

  @override
  State<TSideBar> createState() => _TSideBarState();
}

class _TSideBarState extends State<TSideBar> {
  static const _estimatedItemHeight = 56.0;

  late List<_SideBarItemData> displayChildren;
  int? currentValue;
  int? currentIndex;
  final _scrollerController = ScrollController();
  final Map<int, GlobalKey> _itemKeys = {};

  TSideBarThemeData _resolveTheme() {
    return Theme.of(context).extension<TSideBarThemeData>() ??
        const TSideBarThemeData();
  }

  void _syncSelectedValue(int value) {
    for (final item in displayChildren) {
      if (item.value == value) {
        currentValue = item.value;
        currentIndex = item.index;
        return;
      }
    }
    currentValue = null;
    currentIndex = null;
  }

  _SideBarItemData findSideItem(int value) {
    return displayChildren.where((element) => element.value == value).first;
  }

  void selectValue(int value, {bool needScroll = false}) {
    _SideBarItemData? item;
    for (final element in displayChildren) {
      if (element.value == value) {
        item = element;
      }
    }

    if (needScroll && item != null) {
      _scrollToItem(item);
    }
  }

  Future<void> _scrollToItem(_SideBarItemData item) async {
    final itemContext = item.key.currentContext;
    if (itemContext != null) {
      await _ensureItemVisible(itemContext);
      return;
    }
    if (!_scrollerController.hasClients) {
      return;
    }

    // ListView 会延迟创建视口外条目。先按默认行高接近目标，再以实际位置校正。
    final position = _scrollerController.position;
    final estimatedOffset = (item.index * _estimatedItemHeight).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    await _scrollerController.animateTo(
      estimatedOffset,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
    if (!mounted) {
      return;
    }

    final resolvedContext = item.key.currentContext;
    if (resolvedContext != null) {
      await _ensureItemVisible(resolvedContext);
    }
  }

  Future<void> _ensureItemVisible(BuildContext context) {
    return Scrollable.ensureVisible(
      context,
      alignment: 0.5,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    getDisplayChildren();
    _syncSelectedValue(widget.value);
  }

  void getDisplayChildren() {
    _itemKeys.removeWhere((index, _) => index >= widget.children.length);
    displayChildren = widget.children
        .asMap()
        .entries
        .map(
          (entry) => _SideBarItemData(
            index: entry.key,
            key: _itemKeys.putIfAbsent(entry.key, GlobalKey.new),
            disabled: entry.value.disabled,
            value: entry.value.value,
            icon: entry.value.icon,
            label: entry.value.label,
            textStyle: entry.value.textStyle,
            badge: entry.value.badge,
          ),
        )
        .toList();
  }

  void onSelect(_SideBarItemData item) {
    if (currentIndex == item.index) {
      return;
    }
    widget.onChanged?.call(item.value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = _resolveTheme();
    final effectiveStyle =
        widget.style ?? theme.style ?? TSideBarVariant.normal;
    if (widget.loading) {
      if (widget.loadingWidget != null) {
        return widget.loadingWidget!;
      }
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Align(
          child: TLoading(icon: TLoadingIcon.circle, size: TLoadingSize.large),
        ),
      );
    }

    final sideBar = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 106,
        maxHeight:
            MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top,
      ),
      child: SizedBox(
        height:
            widget.height ?? theme.height ?? MediaQuery.of(context).size.height,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: displayChildren.length,
            controller: _scrollerController,
            itemBuilder: (BuildContext context, int index) {
              final ele = displayChildren[index];
              return TWrapSideBarItem(
                key: ele.key,
                style: effectiveStyle,
                value: ele.value,
                icon: ele.icon,
                disabled: ele.disabled ?? false,
                label: ele.label ?? '',
                badge: ele.badge,
                textStyle: ele.textStyle,
                selected: currentIndex == ele.index,
                selectedColor: widget.selectedColor ?? theme.selectedColor,
                unSelectedColor:
                    widget.unSelectedColor ?? theme.unSelectedColor,
                selectedTextStyle:
                    widget.selectedTextStyle ?? theme.selectedTextStyle,
                contentPadding: widget.contentPadding ?? theme.contentPadding,
                topAdjacent:
                    currentIndex != null && currentIndex! + 1 == ele.index,
                bottomAdjacent:
                    currentIndex != null && currentIndex! - 1 == ele.index,
                selectedBgColor:
                    widget.selectedBgColor ??
                    theme.selectedBgColor ??
                    context.tTheme.bgColorContainer,
                unSelectedBgColor:
                    widget.unSelectedBgColor ??
                    theme.unSelectedBgColor ??
                    context.tTheme.bgColorSecondaryContainer,
                onTap: () {
                  if (!(ele.disabled ?? false) && widget.onChanged != null) {
                    onSelect(ele);
                  }
                },
              );
            },
          ),
        ),
      ),
    );

    final isDisabled = widget.onChanged == null;
    return Semantics(
      enabled: !isDisabled,
      child: AnimatedOpacity(
        opacity: isDisabled ? 0.4 : 1,
        duration: const Duration(milliseconds: 150),
        child: AbsorbPointer(absorbing: isDisabled, child: sideBar),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant TSideBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    getDisplayChildren();
    _syncSelectedValue(widget.value);
    if (oldWidget.value != widget.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          selectValue(widget.value, needScroll: true);
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollerController.dispose();
    super.dispose();
  }
}
