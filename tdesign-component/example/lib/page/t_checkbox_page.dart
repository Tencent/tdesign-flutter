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
    TCheckboxOption(value: 'a', label: '多选'),
    TCheckboxOption(value: 'b', label: '多选'),
    TCheckboxOption(value: 'c', label: '多选标题多行多选标题多行多选标题多行多选标题多行'),
    TCheckboxOption(value: 'd', label: '多选', subTitle: '描述信息描述信息描述信息描述信息描述信息'),
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
  final Map<TCheckboxVariant, bool> _variantValues = {
    TCheckboxVariant.square: true,
    TCheckboxVariant.circle: true,
    TCheckboxVariant.check: true,
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
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '纵向多选框', builder: _verticalCheckbox),
            ExampleItem(desc: '横向多选框', builder: _horizontalCheckbox),
            ExampleItem(desc: '带全选多选框', builder: _checkAll),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [ExampleItem(desc: '多选框状态', builder: _disabledCheckbox)],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(desc: '勾选样式', builder: _variants),
            ExampleItem(desc: '勾选显示位置', builder: _positions),
            ExampleItem(desc: '非通栏多选样式', builder: _verticalCardCheckbox),
          ],
        ),
        ExampleModule(
          title: '组件规格',
          children: [ExampleItem(desc: '多选框尺寸规格', builder: _sizes)],
        ),
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
  Widget _variants(BuildContext context) {
    return Column(
      children: [
        for (final entry in const [
          (TCheckboxVariant.square, '方形'),
          (TCheckboxVariant.circle, '圆形'),
          (TCheckboxVariant.check, '仅勾选'),
        ])
          Theme(
            data: Theme.of(
              context,
            ).mergeExtension(TCheckboxThemeData(variant: entry.$1)),
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
  Widget _sizes(BuildContext context) {
    return Column(
      children: [
        for (final size in TCheckboxSize.values)
          TCheckbox(
            value: true,
            size: size,
            title: switch (size) {
              TCheckboxSize.small => '小尺寸',
              TCheckboxSize.medium => '中尺寸',
              TCheckboxSize.large => '大尺寸',
            },
            onChanged: (_) {},
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
}
