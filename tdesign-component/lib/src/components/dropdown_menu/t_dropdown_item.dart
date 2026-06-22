import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import '../../util/list_ext.dart';
import '../tag/t_select_tag.dart';
import '../tag/t_tag_styles.dart';
import 't_dropdown_inherited.dart';
import 't_dropdown_popup.dart';

typedef TDropdownItemContentBuilder = Widget Function(BuildContext context,
    _TDropdownItemState itemState, TDropdownPopup? popupState);

typedef TDropdownItemOptionsCallback = void Function(
    List<TDropdownItemOption>? options);

List<TDropdownItemOption?> _getSelected(List<TDropdownItemOption>? options) {
  return options?.where((element) => element.selected == true).toList() ?? [];
}

/// 补充列数，使最后一行的选项宽度一样
int _num(List list, int? n) {
  var val = n ?? 1;
  if (list.length < val) {
    return val;
  }
  return list.length + list.length % val;
}

/// 下拉菜单控制器
class TDropdownItemController {
  _TDropdownItemState? _state;

  void _bindState(_TDropdownItemState _tdDropdownMenuState) {
    _state = _tdDropdownMenuState;
  }

  /// 将所有选项重置为未选中状态
  void reset() {
    _state?.reset();
  }

  /// 更新选项内容。注意：增删内容可能导致高度展示异常，请谨慎操作
  void updateOptions(TDropdownItemOptionsCallback callback) {
    _state?.updateOptions(callback);
  }
}

/// 下拉菜单内容
class TDropdownItem<T> extends StatefulWidget {
  const TDropdownItem({
    Key? key,
    this.disabled = false,
    this.label,
    this.arrowIcon,
    this.arrowColor,
    this.multiple = false,
    this.options = const [],
    this.builder,
    this.optionsColumns = 1,
    this.onChange,
    this.onConfirm,
    this.onReset,
    this.minHeight,
    this.maxHeight,
    this.tabBarWidth,
    this.tabBarAlign,
    this.tabBarFlex = 1,
    this.controller,
  }) : super(key: key);

  /// 是否禁用
  final bool? disabled;

  /// 标题
  final String? label;

  /// 自定义箭头图标
  final IconData? arrowIcon;

  /// 自定义箭头颜色
  final Color? arrowColor;

  /// 是否多选
  final bool? multiple;

  /// 选项数据
  final List<TDropdownItemOption>? options;

  /// 完全自定义展示内容
  final TDropdownItemContentBuilder? builder;

  /// 选项分栏（1-3）
  final int? optionsColumns;

  /// 值改变时触发
  final ValueChanged<T?>? onChange;

  /// 点击确认时触发
  final ValueChanged<T?>? onConfirm;

  /// 点击重置时触发
  final VoidCallback? onReset;

  /// 内容最小高度
  final double? minHeight;

  /// 内容最大高度
  final double? maxHeight;

  /// 该item在menu上的宽度，仅在[TDropdownMenu.isScrollable]为true时有效
  final double? tabBarWidth;

  /// [label]和[arrowIcon]/[TDropdownMenu.arrowIcon]的对齐方式
  final MainAxisAlignment? tabBarAlign;

  /// 该item在menu上的宽度占比，仅在[TDropdownMenu.isScrollable]为false时有效
  final int? tabBarFlex;

  /// 下拉菜单控制器
  final TDropdownItemController? controller;

  static const double operateHeight = 73;

  double? get minContentHeight => multiple == true
      ? (minHeight != null ? minHeight! + TDropdownItem.operateHeight : null)
      : minHeight;

  double? get maxContentHeight => multiple == true
      ? (maxHeight != null ? maxHeight! + TDropdownItem.operateHeight : null)
      : maxHeight;

  @override
  _TDropdownItemState createState() => _TDropdownItemState();

  String getLabel() {
    if (multiple == true) {
      return label ?? '';
    }
    var list = _getSelected(options);
    if (list.isEmpty) {
      return label ?? '';
    }
    return list[0]?.label ?? label ?? '';
  }
}

class _TDropdownItemState extends State<TDropdownItem> {
  late TDropdownPopup popupState;
  late ValueNotifier<TDropdownMenuDirection> directionListenable;

  @override
  void initState() {
    super.initState();
    widget.controller?._bindState(this);
  }

  @override
  Widget build(BuildContext context) {
    popupState = TDropdownInherited.of(context)!.popupState;
    directionListenable = TDropdownInherited.of(context)!.directionListenable;
    if (widget.builder != null) {
      return widget.builder!(context, this, popupState);
    }
    return widget.multiple == true || (widget.optionsColumns ?? 1) > 1
        ? _getCheckboxList()
        : _getRadioList();
  }

  Widget _getCheckboxList() {
    var isMultiple = widget.multiple == true;
    var paddingNum = TTheme.of(context).spacer16;
    var groupChunk = _groupChunkOptions();
    var maxContentHeight = widget.maxContentHeight != null
        ? widget.maxContentHeight!
        : directionListenable.value == TDropdownMenuDirection.auto
            ? double.infinity
            : max<double>(
                popupState.maxContentHeight - TDropdownItem.operateHeight, 0);
    var selectIds = _getSelected(widget.options)
        .map((e) => e!.value)
        .toList();
    return Column(
      children: [
        Container(
          color: TTheme.of(context).bgColorContainer,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: widget.minContentHeight ?? 0.0,
                maxHeight: maxContentHeight),
            child: SingleChildScrollView(
              child: TCheckboxGroupContainer(
                selectIds: isMultiple
                    ? selectIds
                    : selectIds.isEmpty
                        ? []
                        : [selectIds[0]],
                onCheckBoxGroupChange: _handleSelectChange,
                child: Column(
                  children: List.generate(groupChunk.length, (index) {
                    var entry = groupChunk.entries.elementAt(index);
                    var chunks = entry.value;
                    return Column(
                      children: [
                        groupChunk.length == 1 && entry.key == '__default__'
                            ? const SizedBox.shrink()
                            : Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: paddingNum,
                                    top: paddingNum,
                                    right: paddingNum),
                                color: TTheme.of(context).bgColorContainer,
                                child: TText(entry.key == '__default__'
                                    ? context.resource.other
                                    : entry.key),
                              ),
                        Container(
                          padding: EdgeInsets.all(paddingNum),
                          color: TTheme.of(context).bgColorContainer,
                          child: Column(
                            children: List.generate(chunks.length, (ri) {
                              var num = _num(chunks[ri], widget.optionsColumns);
                              return Padding(
                                padding:
                                    _getPadding(chunks.length, ri, 'bottom'),
                                child: Row(
                                  children: List.generate(num, (ci) {
                                    return Expanded(
                                      child: Padding(
                                        padding: _getPadding(num, ci, 'right'),
                                        child: _getCheckboxItem(chunks[ri], ci),
                                      ),
                                    );
                                  }),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
        if (isMultiple) _getCheckboxOperate(),
      ],
    );
  }

  Widget _getRadioList() {
    var selected = _getSelected(widget.options);
    var radios = TRadioGroup(
      onRadioGroupChange: _handleSelectChange,
      radioCheckStyle: TRadioStyle.check,
      selectId: selected.isEmpty ? null : selected[0]?.value,
      child: Column(
        children: List.generate(
          widget.options?.length ?? 0,
          (index) => TRadio(
            id: widget.options![index].value,
            title: widget.options![index].label,
            selectColor: widget.options![index].selectedColor,
            enable: !(widget.options![index].disabled ?? false),
            contentDirection: TContentDirection.left,
          ),
        ),
      ),
    );
    return widget.minContentHeight != null || widget.maxContentHeight != null
        ? Container(
            color: TTheme.of(context).bgColorContainer,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: widget.minContentHeight ?? 0.0,
                  maxHeight: widget.maxContentHeight ?? double.infinity),
              child: widget.maxContentHeight != null
                  ? SingleChildScrollView(child: radios)
                  : radios,
            ),
          )
        : radios;
  }

  Widget? _getCheckboxItem(List<TDropdownItemOption> cols, int index) {
    var col = index >= cols.length ? null : cols[index];
    if (col == null) {
      return null;
    }
    var enable = !(col.disabled ?? false);
    return TCheckbox(
      id: col.value,
      title: col.label,
      enable: !(col.disabled ?? false),
      selectColor: col.selectedColor,
      disableColor: col.disabledColor,
      customIconBuilder: (context, checked) => null,
      customContentBuilder: (context, checked, content) => Container(
        height: 40,
        decoration: BoxDecoration(
          color: enable
              ? checked
                  ? TTheme.of(context).brandLightColor
                  : TTheme.of(context).bgColorSecondaryContainer
              : TTheme.of(context).bgColorSecondaryContainerHover,
          borderRadius: BorderRadius.all(
            Radius.circular(TTheme.of(context).radiusDefault),
          ),
        ),
        child: Center(
          child: TText(
            content,
            textColor: enable
                ? checked
                    ? TTheme.of(context).brandColor7
                    : TTheme.of(context).textColorPrimary
                : TTheme.of(context).textDisabledColor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _getCheckboxOperate() {
    return Container(
      height: TDropdownItem.operateHeight,
      padding: EdgeInsets.all(TTheme.of(context).spacer16),
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        border: Border(
          top: BorderSide(
            color: TTheme.of(context).componentStrokeColor,
            width: 0.5,
          ),
          bottom: directionListenable.value == TDropdownMenuDirection.up
              ? BorderSide(
                  color: TTheme.of(context).componentStrokeColor,
                  width: 0.5,
                )
              : BorderSide.none,
        ),
      ),
      child: Row(
        // spacing: TTheme.of(context).spacer16,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TButton(
              child: Text(context.resource.reset),
              colorScheme: TButtonColorScheme.light,
              onPressed: () {
                reset();
                widget.onReset?.call();
              },
            ),
          ),
          SizedBox(width: TTheme.of(context).spacer16),
          Expanded(
            child: TButton(
              child: Text(context.resource.confirm),
              colorScheme: TButtonColorScheme.primary,
              onPressed: () {
                _handleClose();
                widget.onConfirm?.call(
                    _getSelected(widget.options).map((e) => e!.value).toList());
              },
            ),
          ),
        ],
      ),
    );
  }

  EdgeInsets _getPadding(int length, int index, String direction) {
    var value = length - 1 == index ? 0.0 : TTheme.of(context).spacer12;
    if (direction == 'bottom') {
      return EdgeInsets.only(bottom: value);
    }
    if (direction == 'right') {
      return EdgeInsets.only(right: value);
    }
    return EdgeInsets.all(value);
  }

  Map<String, List<List<TDropdownItemOption>>> _groupChunkOptions() {
    var groupedOptions = widget.options
            ?.groupBy<String>((option) => option.group ?? '__default__') ??
        {};
    var groupedChunkOptions = <String, List<List<TDropdownItemOption>>>{};
    var def = groupedOptions.remove('__default__');
    if (def != null) {
      groupedOptions['__default__'] = def;
    }
    groupedOptions.forEach((key, value) {
      groupedChunkOptions[key] = value.chunk(widget.optionsColumns ?? 1);
    });
    return groupedChunkOptions;
  }

  void _handleSelectChange(selected) {
    var isRadio = widget.multiple != true && selected is List<String>;
    if (isRadio && selected.isNotEmpty) {
      selected = [selected.last];
    }
    widget.options?.forEach((element) {
      element.selected = selected is List<String>
          ? selected.contains(element.value)
          : element.value == selected;
    });
    if (isRadio) {
      setState(() {});
    }
    widget.onChange
        ?.call(_getSelected(widget.options).map((e) => e!.value).toList());
    if (widget.multiple != true && selected.isNotEmpty) {
      _handleClose();
    }
  }

  void _handleClose() async {
    if (widget.multiple != true || (widget.optionsColumns ?? 1) > 1) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    await Navigator.maybePop(context);
  }

  void reset() {
    widget.options?.forEach((element) {
      element.selected = false;
    });
    setState(() {});
  }

  void updateOptions(TDropdownItemOptionsCallback callback) {
    callback(widget.options);
    setState(() {});
  }
}

/// 选项数据
class TDropdownItemOption {
  TDropdownItemOption({
    required this.value,
    required this.label,
    this.disabled = false,
    this.group,
    this.selected = false,
    this.selectedColor,
    this.disabledColor,
  });

  /// 选项值
  String value;

  /// 选项标题
  final String label;

  /// 是否禁用
  bool? disabled;

  /// 分组，相同的为一组
  final String? group;

  /// 是否选中
  bool selected;

  /// 选中颜色
  final Color? selectedColor;

  /// 禁用颜色
  final Color? disabledColor;
}
