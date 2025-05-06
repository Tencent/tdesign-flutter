import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import '../../util/list_ext.dart';
import '../tag/td_select_tag.dart';
import '../tag/td_tag_styles.dart';
import 'td_dropdown_inherited.dart';
import 'td_dropdown_popup.dart';

typedef TDDropdownItemContentBuilder = Widget Function(
    BuildContext context, _TDDropdownItemState itemState, TDDropdownPopup? popupState);

List<TDDropdownItemOption?> _getSelected(List<TDDropdownItemOption>? options) {
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

/// 下拉菜单内容
class TDDropdownItem<T> extends StatefulWidget {
  const TDDropdownItem({
    Key? key,
    this.disabled = false,
    this.label,
    this.arrowIcon,
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
  }) : super(key: key);

  /// 是否禁用
  final bool? disabled;

  /// 标题
  final String? label;

  /// 自定义箭头图标
  final IconData? arrowIcon;

  /// 是否多选
  final bool? multiple;

  /// 选项数据
  final List<TDDropdownItemOption>? options;

  /// 完全自定义展示内容
  final TDDropdownItemContentBuilder? builder;

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

  /// 该item在menu上的宽度，仅在[TDDropdownMenu.isScrollable]为true时有效
  final double? tabBarWidth;

  /// [label]和[arrowIcon]/[TDDropdownMenu.arrowIcon]的对齐方式
  final MainAxisAlignment? tabBarAlign;

  /// 该item在menu上的宽度占比，仅在[TDDropdownMenu.isScrollable]为false时有效
  final int? tabBarFlex;

  static const double operateHeight = 73;

  double? get minContentHeight =>
      multiple == true ? (minHeight != null ? minHeight! + TDDropdownItem.operateHeight : null) : minHeight;
  double? get maxContentHeight =>
      multiple == true ? (maxHeight != null ? maxHeight! + TDDropdownItem.operateHeight : null) : maxHeight;

  @override
  _TDDropdownItemState createState() => _TDDropdownItemState();

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

class _TDDropdownItemState extends State<TDDropdownItem> {
  late TDDropdownPopup popupState;
  late ValueNotifier<TDDropdownMenuDirection> directionListenable;

  @override
  Widget build(BuildContext context) {
    popupState = TDDropdownInherited.of(context)!.popupState;
    directionListenable = TDDropdownInherited.of(context)!.directionListenable;
    if (widget.builder != null) {
      return widget.builder!(context, this, popupState);
    }
    return widget.multiple == true || (widget.optionsColumns ?? 1) > 1 ? _getCheckboxList() : _getRadioList();
  }

  Widget _getCheckboxList() {
    var isMultiple = widget.multiple == true;
    var paddingNum = TDTheme.of(context).spacer16;
    var groupCunck = _groupChunkOptions();
    var maxContentHeight = widget.maxContentHeight != null
        ? widget.maxContentHeight!
        : directionListenable.value == TDDropdownMenuDirection.auto
            ? double.infinity
            : max<double>(popupState.maxContentHeight - TDDropdownItem.operateHeight, 0);
    return Column(
      children: [
        Container(
          color: TDTheme.of(context).whiteColor1,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: widget.minContentHeight ?? 0.0, maxHeight: maxContentHeight),
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(groupCunck.length, (index) {
                  var entry = groupCunck.entries.elementAt(index);
                  var chunks = entry.value;
                  var selectIds = _getSelected(widget.options).map((e) => e!.value).toList();
                  return Column(
                    children: [
                      groupCunck.length == 1 && entry.key == '__default__'
                          ? const SizedBox.shrink()
                          : Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(left: paddingNum, top: paddingNum, right: paddingNum),
                              color: TDTheme.of(context).whiteColor1,
                              child: TDText(entry.key == '__default__' ? context.resource.other : entry.key),
                            ),
                      Container(
                        padding: EdgeInsets.all(paddingNum),
                        color: TDTheme.of(context).whiteColor1,
                        child: TDCheckboxGroupContainer(
                          selectIds: isMultiple
                              ? selectIds
                              : selectIds.isEmpty
                                  ? []
                                  : [selectIds[0]],
                          onCheckBoxGroupChange: _handleSelectChange,
                          child: Column(
                            children: List.generate(chunks.length, (ri) {
                              var num = _num(chunks[ri], widget.optionsColumns);
                              return Padding(
                                padding: _getPadding(chunks.length, ri, 'bottom'),
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
                      ),
                    ],
                  );
                }),
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
    var radios = TDRadioGroup(
      onRadioGroupChange: _handleSelectChange,
      radioCheckStyle: TDRadioStyle.check,
      selectId: selected.isEmpty ? null : selected[0]?.value,
      child: Column(
        children: List.generate(
          widget.options?.length ?? 0,
          (index) => TDRadio(
            id: widget.options![index].value,
            title: widget.options![index].label,
            enable: !(widget.options![index].disabled ?? false),
          ),
        ),
      ),
    );
    return widget.minContentHeight != null || widget.maxContentHeight != null
        ? Container(
            color: TDTheme.of(context).whiteColor1,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: widget.minContentHeight ?? 0.0, maxHeight: widget.maxContentHeight ?? double.infinity),
              child: widget.maxContentHeight != null ? SingleChildScrollView(child: radios) : radios,
            ),
          )
        : radios;
  }

  Widget? _getCheckboxItem(List<TDDropdownItemOption> cols, int index) {
    var col = index >= cols.length ? null : cols[index];
    if (col == null) {
      return null;
    }
    var enable = !(col.disabled ?? false);
    return TDCheckbox(
      id: col.value,
      title: col.label,
      enable: !(col.disabled ?? false),
      customIconBuilder: (context, checked) => null,
      customContentBuilder: (context, checked, content) => Container(
        height: 40,
        decoration: BoxDecoration(
          color: enable
              ? checked
                  ? TDTheme.of(context).brandLightColor
                  : TDTheme.of(context).grayColor1
              : TDTheme.of(context).grayColor2,
          borderRadius: BorderRadius.all(
            Radius.circular(TDTheme.of(context).radiusDefault),
          ),
        ),
        child: Center(
          child: TDText(
            content,
            textColor: enable
                ? checked
                    ? TDTheme.of(context).brandColor7
                    : TDTheme.of(context).fontGyColor1
                : TDTheme.of(context).fontGyColor4,
          ),
        ),
      ),
    );
  }

  Widget _getCheckboxOperate() {
    return Container(
      height: TDDropdownItem.operateHeight,
      padding: EdgeInsets.all(TDTheme.of(context).spacer16),
      decoration: BoxDecoration(
        color: TDTheme.of(context).whiteColor1,
        border: Border(
          top: BorderSide(
            color: TDTheme.of(context).grayColor3,
            width: 1,
          ),
          bottom: directionListenable.value == TDDropdownMenuDirection.up
              ? BorderSide(
                  color: TDTheme.of(context).grayColor3,
                  width: 1,
                )
              : BorderSide.none,
        ),
      ),
      child: Row(children: [
        Expanded(
          child: TDButton(
            text: context.resource.reset,
            theme: TDButtonTheme.light,
            onTap: () {
              widget.options?.forEach((element) {
                element.selected = false;
              });
              setState(() {});
              widget.onReset?.call();
            },
          ),
        ),
        SizedBox(width: TDTheme.of(context).spacer16),
        Expanded(
          child: TDButton(
            text: context.resource.confirm,
            theme: TDButtonTheme.primary,
            onTap: () {
              _handleClose();
              widget.onConfirm?.call(_getSelected(widget.options).map((e) => e!.value).toList());
            },
          ),
        ),
      ]),
    );
  }

  EdgeInsets _getPadding(int length, int index, String direction) {
    var value = length - 1 == index ? 0.0 : TDTheme.of(context).spacer12;
    if (direction == 'bottom') {
      return EdgeInsets.only(bottom: value);
    }
    if (direction == 'right') {
      return EdgeInsets.only(right: value);
    }
    return EdgeInsets.all(value);
  }

  Map<String, List<List<TDDropdownItemOption>>> _groupChunkOptions() {
    var groupedOptions = widget.options?.groupBy<String>((option) => option.group ?? '__default__') ?? {};
    var groupedChunkOptions = <String, List<List<TDDropdownItemOption>>>{};
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
      element.selected = selected is List<String> ? selected.contains(element.value) : element.value == selected;
    });
    if (isRadio) {
      setState(() {});
    }
    widget.onChange?.call(_getSelected(widget.options).map((e) => e!.value).toList());
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
}

/// 选项数据
class TDDropdownItemOption {
  TDDropdownItemOption({
    required this.value,
    required this.label,
    this.disabled = false,
    this.group,
    this.selected = false,
  });

  /// 选项值
  final String value;

  /// 选项标题
  final String label;

  /// 是否禁用
  final bool? disabled;

  /// 分组，相同的为一组
  final String? group;

  /// 是否选中
  late bool? selected;
}
