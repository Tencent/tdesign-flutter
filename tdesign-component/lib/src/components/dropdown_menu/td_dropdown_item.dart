import 'dart:async';

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/list_ext.dart';
import '../tag/td_select_tag.dart';
import '../tag/td_tag_styles.dart';
import 'td_dropdown_inherited.dart';

List<TDDropdownItemOption?> _getSelectOptions(
    List<TDDropdownItemOption> options) {
  return options.where((element) => element.selected == true).toList();
}

/// 下拉菜单
class TDDropdownItem<T> extends StatefulWidget {
  const TDDropdownItem({
    Key? key,
    this.disabled = false,
    this.label,
    this.multiple = false,
    this.options = const [],
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
  final List<TDDropdownItemOption> options;

  /// 选项分栏（1-3）
  final int? optionsColumns;

  /// 值改变时触发
  final ValueChanged<T>? onChange;

  /// 点击确认时触发
  final ValueChanged<T>? onConfirm;

  /// 点击重置时触发
  final ValueChanged<T>? onReset;

  @override
  _TDDropdownItemState createState() => _TDDropdownItemState();

  String getLabel() {
    if (multiple == true) {
      return label ?? '';
    }
    var list = _getSelectOptions(options);
    if (list.isEmpty) {
      return label ?? '';
    }
    return list[0]?.label ?? label ?? '';
  }
}

class _TDDropdownItemState extends State<TDDropdownItem> {
  @override
  Widget build(BuildContext context) {
    return widget.multiple == true ? _getCheckboxList() : _getRadioList();
  }

  Widget _getCheckboxList() {
    var chunks = widget.options.chunk(widget.optionsColumns ?? 1);
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight:
                  TDDropdownInherited.of(context)?.state.maxContentHeight ??
                      double.infinity),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(TDTheme.of(context).spacer16),
              color: TDTheme.of(context).whiteColor1,
              child: TDCheckboxGroupContainer(
                selectIds: _getSelectOptions(widget.options)
                    .map((e) => e!.value)
                    .toList(),
                onCheckBoxGroupChange: _handleSelectChange,
                child: Column(
                  children: List.generate(chunks.length, (ri) {
                    var cols = chunks[ri];
                    var colNum = cols.length +
                        cols.length % (widget.optionsColumns ?? 1);
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: _getPadding(chunks.length, ri)),
                      child: Row(
                        children: List.generate(colNum, (ci) {
                          var col = ci >= cols.length ? null : cols[ci];
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: _getPadding(colNum, ci)),
                              child: col == null
                                  ? null
                                  : TDCheckbox(
                                      id: col.value,
                                      title: col.label,
                                      enable: !(col.disabled ?? false),
                                      customIconBuilder: (context, checked) =>
                                          null,
                                      customContentBuilder:
                                          (context, checked, content) =>
                                              _getCheckboxItem(checked, content,
                                                  !(col.disabled ?? false)),
                                    ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
        Container(
          // height: 40,
          padding: EdgeInsets.all(TDTheme.of(context).spacer16),
          decoration: BoxDecoration(
            color: TDTheme.of(context).whiteColor1,
            border: Border(
              top: BorderSide(
                color: TDTheme.of(context).grayColor4,
                width: 1,
              ),
            ),
          ),
          child: Row(children: [
            const Expanded(
              child: TDButton(
                text: '重置',
                theme: TDButtonTheme.light,
              ),
            ),
            SizedBox(width: TDTheme.of(context).spacer16),
            const Expanded(
              child: TDButton(
                text: '确定',
                theme: TDButtonTheme.primary,
              ),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _getRadioList() {
    return TDRadioGroup(
      onRadioGroupChange: _handleSelectChange,
      radioCheckStyle: TDRadioStyle.check,
      selectId: _getSelectOptions(widget.options)[0]?.value,
      child: Column(
        children: List.generate(
          widget.options.length,
          (index) => TDRadio(
            id: widget.options[index].value,
            title: widget.options[index].label,
            enable: !(widget.options[index].disabled ?? false),
          ),
        ),
      ),
    );
  }

  Widget _getCheckboxItem(bool checked, String? content, bool enable) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: checked
            ? TDTheme.of(context).brandLightColor
            : TDTheme.of(context).grayColor3,
        borderRadius: BorderRadius.all(
            Radius.circular(TDTheme.of(context).radiusDefault)),
      ),
      child: Center(
          child: TDText(content,
              textColor: enable
                  ? checked
                      ? TDTheme.of(context).brandColor7
                      : TDTheme.of(context).fontGyColor1
                  : TDTheme.of(context).fontGyColor4)),
    );
  }

  double _getPadding(int length, int index) {
    return length - 1 == index ? 0 : TDTheme.of(context).spacer12;
  }

  void _handleSelectChange(selected) async {
    widget.options.forEach((element) {
      element.selected = selected is List<String>
          ? selected.contains(element.value)
          : element.value == selected;
    });
    if (widget.onChange is Function) {
      widget.onChange!(selected);
    }
    await Future.delayed(const Duration(milliseconds: 100));
    var handleClose = TDDropdownInherited.of(context)?.state.handleClose;
    if (handleClose != null) {
      unawaited(handleClose());
    }
  }
}

/// 选项数据
class TDDropdownItemOption {
  TDDropdownItemOption(
      {required this.value,
      required this.label,
      this.disabled = false,
      this.selected = false});

  /// 选项值，类型限制为int/String
  final String value;

  /// 选项标题
  final String label;

  /// 是否禁用
  final bool? disabled;

  /// 是否选中
  late bool? selected;
}
