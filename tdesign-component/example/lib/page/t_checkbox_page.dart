import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TCheckboxPage extends StatefulWidget {
  const TCheckboxPage({super.key});

  @override
  State<TCheckboxPage> createState() => _TCheckboxPageState();
}

class _TCheckboxPageState extends State<TCheckboxPage> {
  static const _options = [
    TCheckboxOption(value: 'a', label: '多选 A'),
    TCheckboxOption(value: 'b', label: '多选 B', subTitle: '描述信息'),
    TCheckboxOption(value: 'c', label: '多选 C'),
    TCheckboxOption(value: 'd', label: '多选 D'),
  ];
  static const _horizontalCardOptions = [
    TCheckboxOption(value: 'a', label: '多选'),
    TCheckboxOption(value: 'b', label: '多选'),
    TCheckboxOption(value: 'c', label: '多选'),
  ];
  static const _verticalCardOptions = [
    TCheckboxOption(value: 'a', label: '多选', subTitle: '描述信息'),
    TCheckboxOption(value: 'b', label: '多选', subTitle: '描述信息'),
    TCheckboxOption(value: 'c', label: '多选', subTitle: '描述信息'),
    TCheckboxOption(value: 'd', label: '多选', subTitle: '描述信息'),
  ];

  List<String> _verticalValue = ['b'];
  List<String> _horizontalValue = ['a', 'c'];
  List<String> _checkAllValue = ['b'];
  List<String> _verticalCardValue = ['b'];
  List<String> _horizontalCardValue = ['a'];
  bool? _singleValue = false;
  bool? _densityValue = false;
  final Map<TCheckboxVariant, bool> _variantValues = {
    TCheckboxVariant.square: true,
  };
  bool _leftPositionValue = true;
  bool _rightPositionValue = true;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于在一组选项中执行多项选择。',
      exampleCodeGroup: 'checkbox',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '纵向多选框', builder: _verticalCheckbox),
          ExampleItem(desc: '横向多选框', builder: _horizontalCheckbox),
          ExampleItem(desc: '全选', builder: _checkAll),
        ]),
        ExampleModule(title: '组件状态', children: [
          ExampleItem(desc: '单颗受控', builder: _singleCheckbox),
          ExampleItem(desc: '禁用状态', builder: _disabledCheckbox),
          ExampleItem(desc: '单项禁用', builder: _itemDisabledCheckbox),
        ]),
        ExampleModule(title: '组件样式', children: [
          ExampleItem(desc: '勾选样式', builder: _variants),
          ExampleItem(desc: '勾选显示位置', builder: _positions),
          ExampleItem(desc: '点击热区密度', builder: _density),
          ExampleItem(desc: '纵向卡片多选框', builder: _verticalCardCheckbox),
          ExampleItem(desc: '横向两列卡片多选框', builder: _horizontalCardCheckbox),
        ]),
      ],
    );
  }

  @ExampleCode(group: 'checkbox')
  Widget _verticalCheckbox(BuildContext context) {
    return TCheckboxGroup<String>(
      value: _verticalValue,
      options: _options,
      onChanged: (value) => setState(() => _verticalValue = value),
      showDivider: true,
    );
  }

  @ExampleCode(group: 'checkbox')
  Widget _horizontalCheckbox(BuildContext context) {
    return TCheckboxGroup<String>(
      value: _horizontalValue,
      options: _options,
      direction: Axis.horizontal,
      columns: 2,
      onChanged: (value) => setState(() => _horizontalValue = value),
    );
  }

  @ExampleCode(group: 'checkbox')
  Widget _checkAll(BuildContext context) {
    final enabledValues = _options.map((option) => option.value).toList();
    final allSelected = _checkAllValue.length == enabledValues.length;
    return Column(
      children: [
        TCheckbox(
          value: allSelected
              ? true
              : _checkAllValue.isEmpty
                  ? false
                  : null,
          title: '全选',
          onChanged: (checked) {
            setState(() {
              _checkAllValue = checked == true ? enabledValues : [];
            });
          },
          showDivider: true,
        ),
        TCheckboxGroup<String>(
          value: _checkAllValue,
          options: _options,
          onChanged: (value) => setState(() => _checkAllValue = value),
        ),
      ],
    );
  }

  @ExampleCode(group: 'checkbox')
  Widget _singleCheckbox(BuildContext context) {
    return TCheckbox(
      value: _singleValue,
      title: '受控多选',
      subTitle: 'value 由页面 State 持有',
      onChanged: (value) => setState(() => _singleValue = value),
    );
  }

  @ExampleCode(group: 'checkbox')
  Widget _disabledCheckbox(BuildContext context) {
    return const Column(
      children: [
        TCheckbox(value: true, title: '禁用-已选'),
        TCheckbox(value: false, title: '禁用-未选'),
        TCheckbox(value: null, title: '禁用-半选'),
      ],
    );
  }

  @ExampleCode(group: 'checkbox')
  Widget _itemDisabledCheckbox(BuildContext context) {
    return TCheckboxGroup<String>(
      value: const ['b'],
      options: const [
        TCheckboxOption(value: 'a', label: '正常选项'),
        TCheckboxOption(value: 'b', label: '禁用-已选', disabled: true),
        TCheckboxOption(value: 'c', label: '禁用-未选', disabled: true),
      ],
      onChanged: (value) {},
    );
  }

  @ExampleCode(group: 'checkbox')
  Widget _variants(BuildContext context) {
    return Column(
      children: [
        for (final entry in const [
          (TCheckboxVariant.square, '方形'),
        ])
          Theme(
            data: Theme.of(context).mergeExtension(
              TCheckboxThemeData(variant: entry.$1),
            ),
            child: TCheckbox(
              value: _variantValues[entry.$1],
              title: entry.$2,
              onChanged: (value) {
                setState(() => _variantValues[entry.$1] = value == true);
              },
            ),
          ),
      ],
    );
  }

  @ExampleCode(group: 'checkbox')
  Widget _positions(BuildContext context) {
    return Column(
      children: [
        TCheckbox(
          value: _leftPositionValue,
          title: '图标在左',
          onChanged: (value) {
            setState(() => _leftPositionValue = value == true);
          },
        ),
        TCheckbox(
          value: _rightPositionValue,
          title: '图标在右',
          contentDirection: TContentDirection.left,
          onChanged: (value) {
            setState(() => _rightPositionValue = value == true);
          },
        ),
      ],
    );
  }

  @ExampleCode(group: 'checkbox')
  Widget _density(BuildContext context) {
    final compactTheme = CheckboxTheme.of(context).copyWith(
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: context.tTheme.componentBorderColor),
          ),
          child: TCheckbox(
            value: _densityValue,
            onChanged: (value) => setState(() => _densityValue = value),
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(checkboxTheme: compactTheme),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: context.tTheme.componentBorderColor),
            ),
            child: TCheckbox(
              value: _densityValue,
              onChanged: (value) => setState(() => _densityValue = value),
            ),
          ),
        ),
      ],
    );
  }

  @ExampleCode(group: 'checkbox')
  Widget _verticalCardCheckbox(BuildContext context) {
    return TCheckboxGroup<String>(
      value: _verticalCardValue,
      options: _verticalCardOptions,
      cardMode: true,
      onChanged: (value) => setState(() => _verticalCardValue = value),
    );
  }

  @ExampleCode(group: 'checkbox')
  Widget _horizontalCardCheckbox(BuildContext context) {
    return TCheckboxGroup<String>(
      value: _horizontalCardValue,
      options: _horizontalCardOptions,
      direction: Axis.horizontal,
      columns: 2,
      cardMode: true,
      onChanged: (value) => setState(() => _horizontalCardValue = value),
    );
  }
}
