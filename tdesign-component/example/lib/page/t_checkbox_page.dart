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
  static const _verticalOptions = [
    TCheckboxOption(value: 'a', label: '多选'),
    TCheckboxOption(value: 'b', label: '多选'),
    TCheckboxOption(value: 'c', label: '多选标题多行多选标题多行多选标题多行多选标题多行多选标题多行多选标题多行'),
    TCheckboxOption(
      value: 'd',
      label: '多选',
      subTitle: '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息',
    ),
  ];
  static const _horizontalOptions = [
    TCheckboxOption(value: 'a', label: '多选标题'),
    TCheckboxOption(value: 'b', label: '多选标题'),
    TCheckboxOption(value: 'c', label: '上限四字'),
  ];
  static const _checkAllOptions = [
    TCheckboxOption(value: 'a', label: '多选'),
    TCheckboxOption(value: 'b', label: '多选'),
    TCheckboxOption(
      value: 'c',
      label: '多选',
      subTitle: '单选描述信息单选描述信息单选描述信息单选描述信息单选描述信息单选描述信息单选描述信息',
    ),
  ];
  static const _nonFullWidthOptions = [
    TCheckboxOption(value: 'a', label: '多选'),
    TCheckboxOption(value: 'b', label: '多选'),
    TCheckboxOption(value: 'c', label: '多选标题多行多选标题多行多选标题多行多选标题多行多选标题多行多选标题'),
  ];
  static const _verticalCardOptions = [
    TCheckboxOption(value: 'a', label: '多选', subTitle: '描述信息描述信息描述信息描述信息描述信息'),
    TCheckboxOption(value: 'b', label: '多选', subTitle: '描述信息描述信息描述信息描述信息描述信息'),
    TCheckboxOption(value: 'c', label: '多选', subTitle: '描述信息描述信息描述信息描述信息描述信息'),
  ];
  static const _horizontalCardOptions = [
    TCheckboxOption(value: 'a', label: '多选'),
    TCheckboxOption(value: 'b', label: '多选'),
    TCheckboxOption(value: 'c', label: '多选'),
  ];

  List<String> _verticalValue = ['a', 'b'];
  List<String> _horizontalValue = ['a', 'b'];
  List<String> _checkAllValue = ['a', 'b', 'c'];
  List<String> _nonFullWidthValue = ['a', 'b'];
  List<String> _verticalCardValue = ['a', 'b'];
  List<String> _horizontalCardValue = ['a', 'b'];
  final Map<TCheckboxVariant, bool> _variantValues = {
    TCheckboxVariant.square: true,
    TCheckboxVariant.check: true,
  };
  bool _leftPositionValue = true;
  bool _rightPositionValue = true;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于预设的一组选项中执行多项选择，并呈现选择结果。',
      exampleCodeGroup: 'checkbox',
      compactDemo: true,
      showTestModule: false,
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
            ExampleItem(desc: '非通栏多选样式', builder: _nonFullWidthCheckbox),
          ],
        ),
        ExampleModule(
          title: '组件规格',
          children: [ExampleItem(desc: '多选框尺寸规格', builder: _cardCheckboxes)],
        ),
      ],
    );
  }

  @ExampleCode(group: 'checkbox')
  Widget _verticalCheckbox(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TCheckboxThemeData(variant: TCheckboxVariant.circle),
      ),
      child: Column(
        children: [
          for (var index = 0; index < _verticalOptions.length; index++)
            TCheckbox(
              value: _verticalValue.contains(_verticalOptions[index].value),
              title: _verticalOptions[index].label,
              subTitle: _verticalOptions[index].subTitle,
              titleMaxLines: index == 2 ? 2 : 1,
              subTitleMaxLines: index == 3 ? 2 : 1,
              showDivider: index < _verticalOptions.length - 1,
              onChanged: (_) => _toggleVertical(_verticalOptions[index].value),
            ),
        ],
      ),
    );
  }

  void _toggleVertical(String value) {
    setState(() {
      _verticalValue = _verticalValue.contains(value)
          ? _verticalValue.where((item) => item != value).toList()
          : [..._verticalValue, value];
    });
  }

  @ExampleCode(group: 'checkbox')
  Widget _horizontalCheckbox(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TCheckboxThemeData(
          variant: TCheckboxVariant.circle,
          customSpace: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      child: ColoredBox(
        color: context.tTheme.bgColorContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final option in _horizontalOptions)
                TCheckbox(
                  value: _horizontalValue.contains(option.value),
                  title: option.label,
                  onChanged: (_) => _toggleHorizontal(option.value),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleHorizontal(String value) {
    setState(() {
      _horizontalValue = _horizontalValue.contains(value)
          ? _horizontalValue.where((item) => item != value).toList()
          : [..._horizontalValue, value];
    });
  }

  @ExampleCode(group: 'checkbox')
  Widget _checkAll(BuildContext context) {
    final enabledValues = _checkAllOptions
        .map((option) => option.value)
        .toList();
    final allSelected = _checkAllValue.length == enabledValues.length;
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TCheckboxThemeData(variant: TCheckboxVariant.circle),
      ),
      child: Column(
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
            options: _checkAllOptions,
            showDivider: true,
            onChanged: (value) => setState(() => _checkAllValue = value),
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'checkbox')
  Widget _disabledCheckbox(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TCheckboxThemeData(variant: TCheckboxVariant.circle),
      ),
      child: const Column(
        children: [
          TCheckbox(value: true, title: '选项禁用-已选'),
          TCheckbox(value: false, title: '选项禁用-默认'),
        ],
      ),
    );
  }

  @ExampleCode(group: 'checkbox')
  Widget _variants(BuildContext context) {
    return Column(
      children: [
        for (final (index, entry) in const [
          (TCheckboxVariant.check, '多选'),
          (TCheckboxVariant.square, '多选'),
        ].indexed) ...[
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
          if (index == 0) const SizedBox(height: 16),
        ],
      ],
    );
  }

  @ExampleCode(group: 'checkbox')
  Widget _positions(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TCheckboxThemeData(variant: TCheckboxVariant.circle),
      ),
      child: Column(
        children: [
          TCheckbox(
            value: _leftPositionValue,
            title: '多选',
            onChanged: (value) {
              setState(() => _leftPositionValue = value == true);
            },
          ),
          const SizedBox(height: 16),
          TCheckbox(
            value: _rightPositionValue,
            title: '多选',
            contentDirection: TContentDirection.left,
            onChanged: (value) {
              setState(() => _rightPositionValue = value == true);
            },
          ),
        ],
      ),
    );
  }

  @ExampleCode(group: 'checkbox')
  Widget _nonFullWidthCheckbox(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TCheckboxThemeData(variant: TCheckboxVariant.circle),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.tTheme.radiusExtraLarge),
          child: TCheckboxGroup<String>(
            value: _nonFullWidthValue,
            options: _nonFullWidthOptions,
            showDivider: true,
            onChanged: (value) => setState(() => _nonFullWidthValue = value),
          ),
        ),
      ),
    );
  }

  @ExampleCode(group: 'checkbox')
  Widget _cardCheckboxes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TCheckboxGroup<String>(
          value: _verticalCardValue,
          options: _verticalCardOptions,
          cardMode: true,
          onChanged: (value) => setState(() => _verticalCardValue = value),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: TText(
            '横向卡片多选框',
            font: context.tTheme.fontBodyMedium,
            textColor: context.tTheme.textColorSecondary,
          ),
        ),
        TCheckboxGroup<String>(
          value: _horizontalCardValue,
          options: _horizontalCardOptions,
          direction: Axis.horizontal,
          columns: 3,
          cardMode: true,
          onChanged: (value) => setState(() => _horizontalCardValue = value),
        ),
      ],
    );
  }
}
