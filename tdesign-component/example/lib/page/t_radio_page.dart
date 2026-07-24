import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TRadioPage extends StatefulWidget {
  const TRadioPage({super.key});

  @override
  State<TRadioPage> createState() => _TRadioPageState();
}

class _TRadioPageState extends State<TRadioPage> {
  static const _options = [
    TRadioOption(value: 'a', label: '单选 A'),
    TRadioOption(value: 'b', label: '单选 B', subTitle: '描述信息'),
    TRadioOption(value: 'c', label: '单选 C'),
    TRadioOption(value: 'd', label: '单选 D'),
  ];
  static const _horizontalCardOptions = [
    TRadioOption(value: 'a', label: '单选'),
    TRadioOption(value: 'b', label: '单选'),
    TRadioOption(value: 'c', label: '单选'),
  ];
  static const _verticalCardOptions = [
    TRadioOption(value: 'a', label: '单选', subTitle: '描述信息'),
    TRadioOption(value: 'b', label: '单选', subTitle: '描述信息'),
    TRadioOption(value: 'c', label: '单选', subTitle: '描述信息'),
    TRadioOption(value: 'd', label: '单选', subTitle: '描述信息'),
  ];

  String? _verticalValue = 'a';
  String? _horizontalValue = 'b';
  String? _cardValue = 'c';
  String? _positionValue = 'left';

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于在一组选项中执行单项选择。',
      exampleCodeGroup: 'radio',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(desc: '纵向单选框', builder: _verticalRadios),
          ExampleItem(desc: '横向单选框', builder: _horizontalRadios),
        ]),
        ExampleModule(title: '组件状态', children: [
          ExampleItem(desc: '整组禁用', builder: _disabledRadios),
          ExampleItem(desc: '单项禁用', builder: _itemDisabledRadios),
        ]),
        ExampleModule(title: '组件样式', children: [
          ExampleItem(desc: '勾选显示位置', builder: _positions),
          ExampleItem(desc: '纵向卡片单选框', builder: _verticalCardRadios),
          ExampleItem(desc: '横向卡片单选框', builder: _horizontalCardRadios),
        ]),
      ],
    );
  }

  @Demo(group: 'radio')
  Widget _verticalRadios(BuildContext context) {
    return TRadioGroup<String>(
      value: _verticalValue,
      options: _options,
      onChanged: (value) => setState(() => _verticalValue = value),
      showDivider: true,
    );
  }

  @Demo(group: 'radio')
  Widget _horizontalRadios(BuildContext context) {
    return TRadioGroup<String>(
      value: _horizontalValue,
      options: _options,
      direction: Axis.horizontal,
      columns: 2,
      onChanged: (value) => setState(() => _horizontalValue = value),
    );
  }

  @Demo(group: 'radio')
  Widget _disabledRadios(BuildContext context) {
    return const TRadioGroup<String>(
      value: 'a',
      options: _options,
    );
  }

  @Demo(group: 'radio')
  Widget _itemDisabledRadios(BuildContext context) {
    return TRadioGroup<String>(
      value: 'b',
      options: const [
        TRadioOption(value: 'a', label: '正常选项'),
        TRadioOption(value: 'b', label: '禁用-已选', disabled: true),
        TRadioOption(value: 'c', label: '禁用-未选', disabled: true),
      ],
      onChanged: (_) {},
    );
  }

  @Demo(group: 'radio')
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

  @Demo(group: 'radio')
  Widget _verticalCardRadios(BuildContext context) {
    return TRadioGroup<String>(
      value: _cardValue,
      options: _verticalCardOptions,
      cardMode: true,
      onChanged: (value) => setState(() => _cardValue = value),
    );
  }

  @Demo(group: 'radio')
  Widget _horizontalCardRadios(BuildContext context) {
    return TRadioGroup<String>(
      value: _cardValue,
      options: _horizontalCardOptions,
      direction: Axis.horizontal,
      columns: 3,
      cardMode: true,
      onChanged: (value) => setState(() => _cardValue = value),
    );
  }
}
