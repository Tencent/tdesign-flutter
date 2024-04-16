import 'package:flutter/material.dart';

import '../../theme/td_colors.dart';
import '../../theme/td_spacers.dart';
import '../../theme/td_theme.dart';
import '../../util/list_ext.dart';
import '../checkbox/td_check_box.dart';
import '../checkbox/td_check_box_group.dart';
import '../radio/td_radio.dart';
import '../tag/td_select_tag.dart';
import '../tag/td_tag_styles.dart';
import 'td_dropdown_inherited.dart';
import 'td_dropdown_menu.dart';

List<TDDropdownItemOption?> _getSelectOptions(
    List<TDDropdownItemOption> options) {
  return options.where((element) => element.selected == true).toList();
}

/// 下拉菜单
class TDDropdownItem extends StatefulWidget {
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
  final ValueChanged<String>? onChange;

  /// 点击确认时触发
  final ValueChanged<String>? onConfirm;

  /// 点击重置时触发
  final ValueChanged<String>? onReset;

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
    return Container(
      padding: EdgeInsets.all(TDTheme.of(context).spacer12),
      color: TDTheme.of(context).whiteColor1,
      child: TDCheckboxGroupContainer(
        selectIds:
            _getSelectOptions(widget.options).map((e) => e!.value).toList(),
        onCheckBoxGroupChange: (ids) {},
        child: Column(
          children: List.generate(chunks.length, (ri) {
            var cols = chunks[ri];
            var colNum =
                cols.length + cols.length % (widget.optionsColumns ?? 1);
            return Padding(
              padding: EdgeInsets.only(bottom: _getPadding(chunks.length, ri)),
              child: Row(
                children: List.generate(colNum, (ci) {
                  var col = ci >= cols.length ? null : cols[ci];
                  return Expanded(
                    child: col == null
                          ? const SizedBox()
                          : TDCheckbox(
                              id: col.value,
                              title: col.label,
                              enable: !(col.disabled ?? false),
                              customIconBuilder: (context, checked) => null,
                              customContentBuilder:
                                  (context, checked, content) {
                                return TDSelectTag(content!,
                                  theme: TDTagTheme.primary,
                                  isOutline: true,
                                  // type: TDButtonType.fill,
                                  // shape: TDButtonShape.rectangle,
                                  // theme: TDButtonTheme.defaultTheme,
                                );
                              },
                            ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _getRadioList() {
    return TDRadioGroup(
      onRadioGroupChange: (selectedId) async {
        late TDDropdownItemOption selectOption;
        widget.options.forEach((element) {
          if (element.value == selectedId) {
            element.selected = true;
            selectOption = element;
          } else {
            element.selected = false;
          }
        });
        if (widget.onChange is Function) {
          widget.onChange!(selectOption.value);
        }
        await Future.delayed(const Duration(milliseconds: 100));
        TDDropdownInherited.of(context)?.state.handleClose!();
      },
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

  double _getPadding(int length, int index) {
    return length - 1 == index ? 0 : TDTheme.of(context).spacer12;
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
