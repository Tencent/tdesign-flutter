import 'package:flutter/material.dart';

/// 下拉菜单
class TDDropdownItem<T> extends StatefulWidget {
  const TDDropdownItem({
    Key? key,
    this.disabled = false,
    this.keys,
    this.label,
    this.multiple = false,
    this.options = const [],
    this.optionsColumns = 1,
    this.value,
    this.onChange,
    this.onConfirm,
    this.onReset,
  }) : super(key: key);
  /// 是否禁用
  final bool? disabled;
  /// 用来定义 value / label 在 options 中对应的字段别名
  final TDDropdownItemKeys? keys;
  /// 标题
  final String? label;
  /// 是否多选
  final bool? multiple;
  /// 选项数据
  final List<TDDropdownItemOptions<T>> options;
  /// 选项分栏（1-3）
  final int? optionsColumns;
  /// 选中值
  final T? value;
  /// 值改变时触发
  final ValueChanged<T>? onChange;
  /// 点击确认时触发
  final ValueChanged<T>? onConfirm;
  /// 点击重置时触发
  final ValueChanged<T>? onReset;

  @override
  _TDDropdownItemState createState() => _TDDropdownItemState();
}

class _TDDropdownItemState extends State<TDDropdownItem> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [],
    );
  }

}

/// 用来定义 value / label 在 options 中对应的字段别名
class TDDropdownItemKeys {
  const TDDropdownItemKeys({this.value = 'value', this.label = 'label'});
  /// options的值的key
  final String? value;
  /// options的标题的key
  final String? label;
}

/// 选项数据
class TDDropdownItemOptions<T> {
  const TDDropdownItemOptions({required this.value, required this.label, this.disabled = false});
  /// 选项值
  final T value;
  /// 选项标题
  final String label;
  /// 是否禁用
  final bool? disabled;
}
