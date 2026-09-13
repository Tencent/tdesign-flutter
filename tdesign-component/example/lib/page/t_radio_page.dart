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
            ExampleItem(
              desc: '横向单选框',
              builder: _horizontalRadios,
              center: false,
            ),
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
    return TRadioGroup<int>.options(
      value: _verticalValue,
      options: _options,
      onChanged: (value) {
        setState(() => _verticalValue = _verticalValue == value ? null : value);
      },
      showDivider: true,
    );
  }

  @ExampleCode(group: 'radio')
  Widget _horizontalRadios(BuildContext context) {
    return Container(
      key: const ValueKey('radio-horizontal-layout'),
      color: context.tTheme.bgColorContainer,
      padding: EdgeInsets.all(context.tTheme.spacer16),
      child: TRadioGroup<int>.options(
        value: _horizontalValue,
        options: _horizontalOptions,
        direction: Axis.horizontal,
        columns: 3,
        variant: TRadioVariant.inline,
        onChanged: (value) => setState(() => _horizontalValue = value),
      ),
    );
  }

  @ExampleCode(group: 'radio')
  Widget _disabledRadios(BuildContext context) {
    return const TRadioGroup<int>.options(
      value: 0,
      options: [
        TRadioOption(value: 0, label: '单选-已选'),
        TRadioOption(value: 1, label: '单选-未选'),
      ],
    );
  }

  @ExampleCode(group: 'radio')
  Widget _themes(BuildContext context) {
    return Column(
      children: [
        TRadioGroup<bool>(
          value: _lineSelected,
          onChanged: (_) => setState(() => _lineSelected = !_lineSelected),
          child: const TRadio<bool>(
            value: true,
            title: '单选',
            iconType: TRadioIconType.check,
          ),
        ),
        SizedBox(height: context.tTheme.spacer16),
        TRadioGroup<bool>(
          value: _dotSelected,
          onChanged: (_) => setState(() => _dotSelected = !_dotSelected),
          child: const TRadio<bool>(
            value: true,
            title: '单选',
            iconType: TRadioIconType.dot,
          ),
        ),
      ],
    );
  }

  @ExampleCode(group: 'radio')
  Widget _positions(BuildContext context) {
    return Column(
      children: [
        TRadioGroup<bool>(
          value: _leftSelected,
          onChanged: (_) => setState(() => _leftSelected = !_leftSelected),
          child: const TRadio<bool>(value: true, title: '单选'),
        ),
        SizedBox(height: context.tTheme.spacer16),
        TRadioGroup<bool>(
          value: _rightSelected,
          onChanged: (_) => setState(() => _rightSelected = !_rightSelected),
          child: const TRadio<bool>(
            value: true,
            title: '单选',
            contentDirection: TContentDirection.left,
          ),
        ),
      ],
    );
  }

  @ExampleCode(group: 'radio')
  Widget _verticalCardRadios(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.tTheme.spacer16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.tTheme.radiusExtraLarge),
        child: TRadioGroup<int>.options(
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
        TRadioGroup<int>.options(
          key: const ValueKey('radio-vertical-card-layout'),
          value: _verticalSpecialCardValue,
          options: _specialVerticalOptions,
          variant: TRadioVariant.card,
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
        TRadioGroup<int>.options(
          key: const ValueKey('radio-horizontal-card-layout'),
          value: _horizontalCardValue,
          options: _specialHorizontalOptions,
          direction: Axis.horizontal,
          columns: 3,
          variant: TRadioVariant.card,
          onChanged: (value) => setState(() => _horizontalCardValue = value),
        ),
      ],
    );
  }
}
