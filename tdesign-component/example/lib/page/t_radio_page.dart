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
    TRadioOption(value: 'a', label: '单选 A'),
    TRadioOption(value: 'b', label: '单选 B', subTitle: '描述信息'),
    TRadioOption(value: 'c', label: '单选 C'),
    TRadioOption(value: 'd', label: '单选 D'),
  ];
  static const _cardOptions = [
    TRadioOption(value: 'a', label: '单选', subTitle: '描述信息'),
    TRadioOption(value: 'b', label: '单选', subTitle: '描述信息'),
    TRadioOption(value: 'c', label: '单选', subTitle: '描述信息'),
  ];

  String? _verticalValue = 'a';
  String? _horizontalValue = 'b';
  String? _verticalCardValue = 'a';
  String? _horizontalCardValue = 'b';
  String? _positionValue = 'left';
  String? _itemDisabledValue = 'c';

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
          ExampleItem(desc: '禁用状态', builder: _disabledRadios),
        ]),
        ExampleModule(title: '组件样式', children: [
          ExampleItem(desc: '勾选显示位置', builder: _positions),
          ExampleItem(desc: '纵向一列卡片单选框', builder: _verticalCardRadios),
          ExampleItem(desc: '横向两列卡片单选框', builder: _horizontalCardRadios),
        ]),
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
    return Column(
      children: [
        const TRadioGroup<String>(
          value: 'a',
          options: [
            TRadioOption(value: 'a', label: '整组禁用'),
            TRadioOption(value: 'b', label: '不可选择'),
          ],
        ),
        const SizedBox(height: 16),
        TRadioGroup<String>(
          value: _itemDisabledValue,
          options: const [
            TRadioOption(value: 'a', label: '正常选项 A'),
            TRadioOption(value: 'b', label: '正常选项 B'),
            TRadioOption(value: 'c', label: '禁用-已选', disabled: true),
            TRadioOption(value: 'd', label: '禁用-未选', disabled: true),
          ],
          onChanged: (value) => setState(() => _itemDisabledValue = value),
        ),
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
        TRadio<String>(
          value: 'custom',
          groupValue: _positionValue,
          title: '自定义指示器',
          customIconBuilder: (context, selected, disabled) => Icon(
            selected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: disabled
                ? context.tTheme.brandDisabledColor
                : context.tTheme.brandNormalColor,
            size: 24,
          ),
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
  Widget _horizontalCardRadios(BuildContext context) {
    return TRadioGroup<String>(
      value: _horizontalCardValue,
      options: _cardOptions,
      cardMode: true,
      direction: Axis.horizontal,
      columns: 2,
      onChanged: (value) => setState(() => _horizontalCardValue = value),
    );
  }
}
