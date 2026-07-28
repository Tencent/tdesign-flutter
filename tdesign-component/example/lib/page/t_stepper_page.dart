import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TStepperPage extends StatefulWidget {
  const TStepperPage({super.key});

  @override
  State<TStepperPage> createState() => _TStepperPageState();
}

class _TStepperPageState extends State<TStepperPage> {
  num _baseValue = 1;
  num _normalValue = 2;
  num _filledValue = 3;
  num _outlineValue = 4;
  num _smallValue = 1;
  num _mediumValue = 2;
  num _largeValue = 3;
  num _minValue = 0;
  num _maxValue = 10;
  num _integerStepValue = 2;
  num _decimalStepValue = 0.2;
  num _themedValue = 5;

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于数量的增减。',
      exampleCodeGroup: 'stepper',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础步进器', builder: _buildBase),
            ExampleItem(desc: '步进器形态', builder: _buildVariants),
          ],
        ),
        ExampleModule(
          title: '组件尺寸',
          children: [
            ExampleItem(desc: '小、中、大', builder: _buildSizes),
          ],
        ),
        ExampleModule(
          title: '组件状态',
          children: [
            ExampleItem(desc: '边界与整组禁用', builder: _buildStates),
            ExampleItem(desc: '整数与小数步长', builder: _buildSteps),
          ],
        ),
        ExampleModule(
          title: '主题',
          children: [
            ExampleItem(desc: '局部 ThemeData', builder: _buildTheme),
          ],
        ),
      ],
      test: const [],
    );
  }

  @ExampleCode(group: 'stepper')
  Widget _buildBase(BuildContext context) => _buildRow(context, [
        TStepper(
          value: _baseValue,
          onChanged: (value) => setState(() => _baseValue = value),
        ),
      ]);

  @ExampleCode(group: 'stepper')
  Widget _buildVariants(BuildContext context) => _buildRow(context, [
        TStepper(
          value: _normalValue,
          variant: TStepperVariant.normal,
          onChanged: (value) => setState(() => _normalValue = value),
        ),
        TStepper(
          value: _filledValue,
          variant: TStepperVariant.filled,
          onChanged: (value) => setState(() => _filledValue = value),
        ),
        TStepper(
          value: _outlineValue,
          variant: TStepperVariant.outline,
          onChanged: (value) => setState(() => _outlineValue = value),
        ),
      ]);

  @ExampleCode(group: 'stepper')
  Widget _buildSizes(BuildContext context) => _buildRow(context, [
        TStepper(
          value: _smallValue,
          size: TStepperSize.small,
          variant: TStepperVariant.filled,
          onChanged: (value) => setState(() => _smallValue = value),
        ),
        TStepper(
          value: _mediumValue,
          size: TStepperSize.medium,
          variant: TStepperVariant.filled,
          onChanged: (value) => setState(() => _mediumValue = value),
        ),
        TStepper(
          value: _largeValue,
          size: TStepperSize.large,
          variant: TStepperVariant.filled,
          onChanged: (value) => setState(() => _largeValue = value),
        ),
      ]);

  @ExampleCode(group: 'stepper')
  Widget _buildStates(BuildContext context) => _buildRow(context, [
        TStepper(
          value: _minValue,
          min: 0,
          max: 10,
          variant: TStepperVariant.filled,
          onChanged: (value) => setState(() => _minValue = value),
        ),
        TStepper(
          value: _maxValue,
          min: 0,
          max: 10,
          variant: TStepperVariant.filled,
          onChanged: (value) => setState(() => _maxValue = value),
        ),
        const TStepper(
          value: 5,
          variant: TStepperVariant.filled,
        ),
      ]);

  @ExampleCode(group: 'stepper')
  Widget _buildSteps(BuildContext context) => _buildRow(context, [
        TStepper(
          value: _integerStepValue,
          min: 0,
          max: 20,
          step: 2,
          variant: TStepperVariant.outline,
          onChanged: (value) => setState(() => _integerStepValue = value),
        ),
        TStepper(
          value: _decimalStepValue,
          min: 0,
          max: 1,
          step: 0.1,
          variant: TStepperVariant.outline,
          onChanged: (value) => setState(() => _decimalStepValue = value),
        ),
      ]);

  @ExampleCode(group: 'stepper')
  Widget _buildTheme(BuildContext context) {
    return Theme(
      data: Theme.of(context).mergeExtension(
        TStepperThemeData(
          size: TStepperSize.large,
          variant: TStepperVariant.filled,
          inputWidth: 72,
          foregroundColor: context.tTheme.successNormalColor,
          backgroundColor: context.tTheme.successLightColor,
        ),
      ),
      child: _buildRow(context, [
        TStepper(
          value: _themedValue,
          onChanged: (value) => setState(() => _themedValue = value),
        ),
      ]),
    );
  }

  Widget _buildRow(BuildContext context, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: context.tTheme.bgColorContainer,
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: children,
      ),
    );
  }
}
