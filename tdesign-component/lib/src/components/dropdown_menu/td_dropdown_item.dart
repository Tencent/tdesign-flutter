import 'package:flutter/material.dart';

/// 下拉菜单
class TDDropdownItem<T> extends StatefulWidget {
  const TDDropdownItem({
    Key? key,
    this.disabled = false,
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

  /// 标题
  final String? label;

  /// 是否多选
  final bool? multiple;

  /// 选项数据
  final List<TDDropdownItemOptions> options;

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

  String getLabel() {
    if (label != null) {
      return label!;
    }
    try {
      var option = options.firstWhere((element) => element.value == value);
      return option.label;
    } catch (e) {
      return '';
    }
  }
}

class _TDDropdownItemState extends State<TDDropdownItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
                  children: List.generate(
                    10,
                    (index) => Container(
                      height: 50,
                      color: index % 2 == 0 ? Colors.red : Colors.blue,
                      child: Center(child: Text('Item $index')),
                    ),
                  ),
                );
  }
}

/// 选项数据
class TDDropdownItemOptions<E extends Object> {
  const TDDropdownItemOptions(
      {required this.value, required this.label, this.disabled = false});

  /// 选项值，类型限制为int/String
  final E value;

  /// 选项标题
  final String label;

  /// 是否禁用
  final bool? disabled;
}
