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
  num _base = 3;
  num _minimum = 0;
  num _middle = 99;
  num _maximum = 999;
  num _filled = 3;
  num _outline = 3;
  num _normal = 3;
  num _large = 3;
  num _medium = 3;
  num _small = 3;

  @override
  Widget build(BuildContext context) => ExamplePage(
    title: tTitle(),
    desc: '用于数量的增减。',
    exampleCodeGroup: 'stepper',
    compactDemo: true,
    showTestModule: false,
    children: [
      ExampleModule(
        title: '组件类型',
        children: [ExampleItem(desc: '基础步进器', builder: _buildBase)],
      ),
      ExampleModule(
        title: '组件状态',
        children: [
          ExampleItem(desc: '最大最小状态', builder: _buildBounds),
          ExampleItem(desc: '禁用状态', builder: _buildDisabled),
        ],
      ),
      ExampleModule(
        title: '组件样式',
        children: [
          ExampleItem(desc: '步进器样式', builder: _buildVariants),
          ExampleItem(desc: '步进器尺寸', builder: _buildSizes),
        ],
      ),
    ],
  );

  @ExampleCode(group: 'stepper')
  Widget _buildBase(BuildContext context) => _row([
    TStepper(
      key: const ValueKey('stepper-base'),
      value: _base,
      variant: TStepperVariant.filled,
      onChanged: (value) => setState(() => _base = value),
    ),
  ]);

  @ExampleCode(group: 'stepper')
  Widget _buildBounds(BuildContext context) => _row([
    TStepper(
      key: const ValueKey('stepper-minimum'),
      value: _minimum,
      variant: TStepperVariant.filled,
      onChanged: (value) => setState(() => _minimum = value),
    ),
    TStepper(
      value: _middle,
      min: 5,
      max: 999,
      variant: TStepperVariant.filled,
      onChanged: (value) => setState(() => _middle = value),
    ),
    TStepper(
      key: const ValueKey('stepper-maximum'),
      value: _maximum,
      max: 999,
      variant: TStepperVariant.filled,
      onChanged: (value) => setState(() => _maximum = value),
    ),
  ]);

  @ExampleCode(group: 'stepper')
  Widget _buildDisabled(BuildContext context) => _row(const [
    TStepper(
      key: ValueKey('stepper-disabled'),
      value: 1,
      variant: TStepperVariant.filled,
    ),
  ]);

  @ExampleCode(group: 'stepper')
  Widget _buildVariants(BuildContext context) => _row([
    TStepper(
      key: const ValueKey('stepper-variants'),
      value: _filled,
      variant: TStepperVariant.filled,
      onChanged: (value) => setState(() => _filled = value),
    ),
    TStepper(
      value: _outline,
      variant: TStepperVariant.outline,
      onChanged: (value) => setState(() => _outline = value),
    ),
    TStepper(
      value: _normal,
      variant: TStepperVariant.normal,
      onChanged: (value) => setState(() => _normal = value),
    ),
  ]);

  @ExampleCode(group: 'stepper')
  Widget _buildSizes(BuildContext context) => _row([
    TStepper(
      key: const ValueKey('stepper-sizes'),
      value: _large,
      size: TStepperSize.large,
      variant: TStepperVariant.filled,
      onChanged: (value) => setState(() => _large = value),
    ),
    TStepper(
      value: _medium,
      size: TStepperSize.medium,
      variant: TStepperVariant.filled,
      onChanged: (value) => setState(() => _medium = value),
    ),
    TStepper(
      value: _small,
      size: TStepperSize.small,
      variant: TStepperVariant.filled,
      onChanged: (value) => setState(() => _small = value),
    ),
  ]);

  Widget _row(List<Widget> children) => Wrap(
    spacing: 16,
    runSpacing: 16,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: children,
  );
}
