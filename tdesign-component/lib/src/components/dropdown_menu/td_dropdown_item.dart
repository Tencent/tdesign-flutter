import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
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

/// 下拉菜单
class TDDropdownItem<T> extends StatefulWidget {
  const TDDropdownItem({
    Key? key,
    this.disabled = false,
    this.label,
    this.multiple = false,
    this.options = const [],
    this.builder,
    this.optionsColumns = 1,
    this.onChange,
    this.onConfirm,
    this.onReset,
  }) : super(key: key);

  /// 是否禁用
  final bool? disabled;

  /// 标题
  final String? label;

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

  // TODO minHeight,maxHeight

  static const double operateHeight = 73;

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
  late TDDropdownPopup? popupState;

  @override
  Widget build(BuildContext context) {
    popupState = TDDropdownInherited.of(context)?.state;
    if (widget.builder != null) {
      return widget.builder!(context, this, popupState);
    }
    return widget.multiple == true ? _getCheckboxList() : _getRadioList();
  }

  Widget _getCheckboxList() {
    var paddingNum = TDTheme.of(context).spacer16;
    var groupCunck = _groupChunkOptions();
    var maxContentHeight = max<double>(popupState!.maxContentHeight - TDDropdownItem.operateHeight, 0);
    var selectIds = _getSelected(widget.options).map((e) => e!.value).toList();
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxContentHeight),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(groupCunck.length, (index) {
                var entry = groupCunck.entries.elementAt(index);
                var chunks = entry.value;
                return Column(
                  children: [
                    groupCunck.length == 1 && entry.key == '__default__'
                        ? const SizedBox()
                        : Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(left: paddingNum, top: paddingNum, right: paddingNum),
                            color: TDTheme.of(context).whiteColor1,
                            child: TDText(entry.key == '__default__' ? '其它' : entry.key),
                          ),
                    Container(
                      padding: EdgeInsets.all(paddingNum),
                      color: TDTheme.of(context).whiteColor1,
                      child: TDCheckboxGroupContainer(
                        selectIds: selectIds,
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
        _getCheckboxOperate(selectIds),
      ],
    );
  }

  Widget _getRadioList() {
    var selected = _getSelected(widget.options);
    return TDRadioGroup(
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
          color: checked ? TDTheme.of(context).brandLightColor : TDTheme.of(context).grayColor3,
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

  Widget _getCheckboxOperate(List<String> selectIds) {
    return Container(
      height: TDDropdownItem.operateHeight,
      padding: EdgeInsets.all(TDTheme.of(context).spacer16),
      decoration: BoxDecoration(
        color: TDTheme.of(context).whiteColor1,
        border: Border(
          top: BorderSide(
            color: TDTheme.of(context).grayColor4,
            width: 1,
          ),
          bottom: popupState?.direction == TDDropdownMenuDirection.up
              ? BorderSide(
                  color: TDTheme.of(context).grayColor4,
                  width: 1,
                )
              : BorderSide.none,
        ),
      ),
      child: Row(children: [
        Expanded(
          child: TDButton(
            text: '重置',
            theme: TDButtonTheme.light,
            // disabled: selectIds.isEmpty,
            onTap: () {
              widget.options?.forEach((element) {
                element.selected = false;
              });
              setState(() {});
              if (widget.onReset != null) {
                widget.onReset!();
              }
            },
          ),
        ),
        SizedBox(width: TDTheme.of(context).spacer16),
        Expanded(
          child: TDButton(
            text: '确定',
            theme: TDButtonTheme.primary,
            // disabled: selectIds.isEmpty,
            onTap: () {
              _handleClose();
              if (widget.onConfirm != null) {
                widget.onConfirm!(selectIds);
              }
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

  void _handleSelectChange(selected) async {
    widget.options?.forEach((element) {
      element.selected = selected is List<String> ? selected.contains(element.value) : element.value == selected;
    });
    if (widget.onChange != null) {
      widget.onChange!(selected);
    }
    if (widget.multiple != true) {
      _handleClose();
    } else {
      // setState(() {});
    }
  }

  void _handleClose() async {
    if (widget.multiple != true) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    var handleClose = popupState?.handleClose;
    if (handleClose != null) {
      unawaited(handleClose());
    }
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
