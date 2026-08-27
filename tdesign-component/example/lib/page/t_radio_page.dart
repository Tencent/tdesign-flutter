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
    TRadioOption(value: 0, label: '单选'),
    TRadioOption(value: 1, label: '单选'),
    TRadioOption(value: 2, label: '单选单选单选单选单选单选单选单选单选单选单选单选单选单选'),
    TRadioOption(
      value: 3,
      label: '单选',
      subTitle: '描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息描述信息',
    ),
  ];
  static const _horizontalOptions = [
    TRadioOption(value: 0, label: '单选标题'),
    TRadioOption(value: 1, label: '单选标题'),
    TRadioOption(value: 2, label: '上限四字'),
  ];
  static const _cardOptions = [
    TRadioOption(value: 0, label: '单选'),
    TRadioOption(value: 1, label: '单选'),
    TRadioOption(value: 2, label: '单选标题多行单选标题多行单选标题多行单选标题多行单选标题多行'),
  ];
  static const _specialVerticalOptions = [
    TRadioOption(value: 0, label: '单选', subTitle: '描述信息描述信息描述信息描述信息描述信息'),
    TRadioOption(value: 1, label: '单选', subTitle: '描述信息描述信息描述信息描述信息描述信息'),
    TRadioOption(value: 2, label: '单选', subTitle: '描述信息描述信息描述信息描述信息描述信息'),
  ];
  static const _specialHorizontalOptions = [
    TRadioOption(value: 0, label: '单选'),
    TRadioOption(value: 1, label: '单选'),
    TRadioOption(value: 2, label: '单选'),
  ];

  int? _verticalValue = 1;
  int? _horizontalValue = 0;
  int? _verticalCardValue = 0;
  int? _verticalSpecialCardValue = 0;
  int? _horizontalCardValue = 0;
  bool _lineSelected = true;
  bool _dotSelected = true;
  bool _leftSelected = true;
  bool _rightSelected = true;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于在预设的一组选项中执行单项选择，并呈现选择结果。',
      exampleCodeGroup: 'radio',
      compactDemo: true,
      showTestModule: false,
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
            ExampleItem(desc: '勾选样式', builder: _themes),
            ExampleItem(desc: '勾选显示位置', builder: _positions),
            ExampleItem(desc: '非通栏单选样式', builder: _verticalCardRadios),
          ],
        ),
        ExampleModule(
          title: '特殊样式',
          children: [ExampleItem(desc: '纵向卡片单选框', builder: _specialRadios)],
        ),
      ],
    );
  }

  @ExampleCode(group: 'radio')
  Widget _verticalRadios(BuildContext context) {
    return TRadioGroup<int>(
      value: _verticalValue,
      options: _options,
      onChanged: (value) {
        setState(() => _verticalValue = _verticalValue == value ? null : value);
      },
      showDivider: true,
      titleMaxLines: 3,
      subTitleMaxLines: 5,
    );
  }

  @ExampleCode(group: 'radio')
  Widget _horizontalRadios(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.tTheme.spacer16),
      child: Theme(
        data: Theme.of(
          context,
        ).mergeExtension(TRadioThemeData(insetSpacing: context.tTheme.spacer4)),
        child: TRadioGroup<int>(
          value: _horizontalValue,
          options: _horizontalOptions,
          direction: Axis.horizontal,
          columns: 3,
          onChanged: (value) => setState(() => _horizontalValue = value),
        ),
      ),
    );
  }

  @ExampleCode(group: 'radio')
  Widget _disabledRadios(BuildContext context) {
    return const TRadioGroup<int>(
      value: 0,
      options: [
        TRadioOption(value: 0, label: '单选'),
        TRadioOption(value: 1, label: '单选'),
      ],
    );
  }

  @ExampleCode(group: 'radio')
  Widget _themes(BuildContext context) {
    return Column(
      children: [
        TRadio<bool>(
          value: true,
          groupValue: _lineSelected,
          title: '单选',
          iconType: TRadioIconType.check,
          onChanged: (_) => setState(() => _lineSelected = !_lineSelected),
        ),
        SizedBox(height: context.tTheme.spacer16),
        TRadio<bool>(
          value: true,
          groupValue: _dotSelected,
          title: '单选',
          iconType: TRadioIconType.dot,
          onChanged: (_) => setState(() => _dotSelected = !_dotSelected),
        ),
      ],
    );
  }

  @ExampleCode(group: 'radio')
  Widget _positions(BuildContext context) {
    return Column(
      children: [
        TRadio<bool>(
          value: true,
          groupValue: _leftSelected,
          title: '单选',
          onChanged: (_) => setState(() => _leftSelected = !_leftSelected),
        ),
        SizedBox(height: context.tTheme.spacer16),
        TRadio<bool>(
          value: true,
          groupValue: _rightSelected,
          title: '单选',
          contentDirection: TContentDirection.left,
          onChanged: (_) => setState(() => _rightSelected = !_rightSelected),
        ),
      ],
    );
  }

  @ExampleCode(group: 'radio')
  Widget _verticalCardRadios(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.tTheme.spacer16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
        child: TRadioGroup<int>(
          value: _verticalCardValue,
          options: _cardOptions,
          titleMaxLines: 2,
          onChanged: (value) => setState(() => _verticalCardValue = value),
        ),
      ),
    );
  }

  @ExampleCode(group: 'radio')
  Widget _specialRadios(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TRadioGroup<int>(
          value: _verticalSpecialCardValue,
          options: _specialVerticalOptions,
          cardMode: true,
          subTitleMaxLines: 1,
          onChanged: (value) =>
              setState(() => _verticalSpecialCardValue = value),
        ),
        SizedBox(height: context.tTheme.spacer24),
        Padding(
          padding: EdgeInsets.fromLTRB(
            context.tTheme.spacer16,
            0,
            context.tTheme.spacer16,
            context.tTheme.spacer16,
          ),
          child: TText('横向卡片单选框', textColor: context.tTheme.textColorSecondary),
        ),
        TRadioGroup<int>(
          value: _horizontalCardValue,
          options: _specialHorizontalOptions,
          direction: Axis.horizontal,
          columns: 3,
          cardMode: true,
          onChanged: (value) => setState(() => _horizontalCardValue = value),
        ),
      ],
    );
  }
}
