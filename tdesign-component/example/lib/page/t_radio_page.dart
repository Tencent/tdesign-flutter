import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TRadioPage extends StatefulWidget {
  const TRadioPage({super.key});

  @override
  State<TRadioPage> createState() => _TRadioPageState();
}

class _TRadioPageState extends State<TRadioPage> {
  static const _options = [
    TRadioOption(value: 'a', label: '单选'),
    TRadioOption(value: 'b', label: '单选'),
    TRadioOption(value: 'c', label: '单选标题多行单选标题多行单选标题多行单选标题多行'),
    TRadioOption(value: 'd', label: '单选', subTitle: '描述信息描述信息描述信息描述信息描述信息'),
  ];
  static const _cardOptions = [
    TRadioOption(value: 'a', label: '单选'),
    TRadioOption(value: 'b', label: '单选'),
    TRadioOption(value: 'c', label: '单选标题多行单选标题多行单选标题多行'),
  ];

  String? _verticalValue = 'a';
  String? _horizontalValue = 'b';
  String? _verticalCardValue = 'a';
  String? _verticalSpecialCardValue = 'a';
  String? _horizontalCardValue = 'b';
  String? _positionValue = 'left';

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于在一组选项中执行单项选择。',
      exampleCodeGroup: 'radio',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '纵向单选框', builder: _verticalRadios),
            ExampleItem(desc: '横向单选框', builder: _horizontalRadios),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [ExampleItem(desc: '单选框状态', builder: _disabledRadios)],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(desc: '勾选显示位置', builder: _positions),
            ExampleItem(desc: '非通栏单选样式', builder: _verticalCardRadios),
          ],
        ),
        ExampleModule(
          title: '特殊样式',
          children: [ExampleItem(desc: '纵向/横向卡片单选框', builder: _specialRadios)],
        ),
      ],
    );
  }

  @ExampleCode(group: 'radio')
  Widget _verticalRadios(BuildContext context) {
    return TRadioGroup<String>(
      value: _verticalValue,
      options: _options,
      onChanged: (value) => setState(() => _verticalValue = value),
      showDivider: true,
    );
  }

  @ExampleCode(group: 'radio')
  Widget _horizontalRadios(BuildContext context) {
    return TRadioGroup<String>(
      value: _horizontalValue,
      options: _options,
      direction: Axis.horizontal,
      columns: 2,
      onChanged: (value) => setState(() => _horizontalValue = value),
    );
  }

  @ExampleCode(group: 'radio')
  Widget _disabledRadios(BuildContext context) {
    return const TRadioGroup<String>(
      value: 'a',
      options: [
        TRadioOption(value: 'a', label: '单选-已选'),
        TRadioOption(value: 'b', label: '单选-未选'),
      ],
    );
  }

  @ExampleCode(group: 'radio')
  Widget _positions(BuildContext context) {
    return Column(
      children: [
        TRadio<String>(
          value: 'left',
          groupValue: _positionValue,
          title: '图标在左',
          onChanged: (value) => setState(() => _positionValue = value),
        ),
        TRadio<String>(
          value: 'right',
          groupValue: _positionValue,
          title: '图标在右',
          contentDirection: TContentDirection.left,
          onChanged: (value) => setState(() => _positionValue = value),
        ),
      ],
    );
  }

  @ExampleCode(group: 'radio')
  Widget _verticalCardRadios(BuildContext context) {
    return TRadioGroup<String>(
      value: _verticalCardValue,
      options: _cardOptions,
      cardMode: true,
      onChanged: (value) => setState(() => _verticalCardValue = value),
    );
  }

  @ExampleCode(group: 'radio')
  Widget _specialRadios(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TRadioGroup<String>(
          value: _verticalSpecialCardValue,
          options: _cardOptions,
          cardMode: true,
          onChanged: (value) =>
              setState(() => _verticalSpecialCardValue = value),
        ),
        const SizedBox(height: 24),
        const TText('横向卡片单选框'),
        TRadioGroup<String>(
          value: _horizontalCardValue,
          options: _cardOptions,
          cardMode: true,
          direction: Axis.horizontal,
          columns: 2,
          onChanged: (value) => setState(() => _horizontalCardValue = value),
        ),
      ],
    );
  }
}
