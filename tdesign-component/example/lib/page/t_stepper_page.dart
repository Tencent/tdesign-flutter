import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TStepperPage extends StatefulWidget {
  const TStepperPage({super.key});

  @override
  State<TStepperPage> createState() => _TStepperPageState();
}

class _TStepperPageState extends State<TStepperPage> {
  num _baseValue = 1;
  num _minValue = 0;
  num _maxValue = 999;
  num _filledValue = 3;
  num _normalValue = 3;
  num _wideValue = 3;
  num _narrowValue = 3;
  num _customValue = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: ExamplePage(
        title: tTitle(),
        desc: '用于数量的增减。',
        exampleCodeGroup: 'stepper',
        children: [
          ExampleModule(title: '组件类型', children: [
            ExampleItem(desc: '基础步进器', builder: _buildStepperWithBase),
          ]),
          ExampleModule(title: '组件状态', children: [
            ExampleItem(desc: '最大最小状态', builder: _buildStepperWithMaxMinStatus),
            ExampleItem(desc: '禁用状态', builder: _buildStepperWithDisableStatus),
          ]),
          ExampleModule(title: '组件样式', children: [
            ExampleItem(desc: '步进器样式', builder: _buildStepperWithTheme),
            ExampleItem(desc: '输入框宽度', builder: _buildStepperWithInputWidth),
          ]),
        ],
        test: [
          ExampleItem(desc: '自定义步长', builder: _customStepperValue),
        ],
      ),
    );
  }

  @Demo(group: 'stepper')
  Widget _buildStepperWithBase(BuildContext context) {
    return _buildRow(context, [
      _filledStepper(
        value: _baseValue,
        onChanged: (value) => setState(() => _baseValue = value),
      ),
    ]);
  }

  @Demo(group: 'stepper')
  Widget _buildStepperWithMaxMinStatus(BuildContext context) {
    return _buildRow(context, [
      _filledStepper(
        value: _minValue,
        min: 0,
        onChanged: (value) => setState(() => _minValue = value),
      ),
      _filledStepper(
        value: _maxValue,
        max: 999,
        onChanged: (value) => setState(() => _maxValue = value),
      ),
    ]);
  }

  @Demo(group: 'stepper')
  Widget _buildStepperWithDisableStatus(BuildContext context) {
    return _buildRow(context, const [
      TStepper(value: 1),
      TStepper(value: 3),
      TStepper(value: 5),
    ]);
  }

  @Demo(group: 'stepper')
  Widget _buildStepperWithTheme(BuildContext context) {
    return _buildRow(context, [
      _filledStepper(
        value: _filledValue,
        onChanged: (value) => setState(() => _filledValue = value),
      ),
      TStepper(
        value: _normalValue,
        onChanged: (value) => setState(() => _normalValue = value),
      ),
    ]);
  }

  @Demo(group: 'stepper')
  Widget _buildStepperWithInputWidth(BuildContext context) {
    return _buildRow(context, [
      _themedStepper(
        theme: const TStepperThemeData(
          variant: TStepperVariant.filled,
          inputWidth: 72,
        ),
        value: _wideValue,
        onChanged: (value) => setState(() => _wideValue = value),
      ),
      _themedStepper(
        theme: const TStepperThemeData(
          variant: TStepperVariant.filled,
          inputWidth: 36,
        ),
        value: _narrowValue,
        onChanged: (value) => setState(() => _narrowValue = value),
      ),
    ]);
  }

  @Demo(group: 'stepper')
  Widget _buildRow(BuildContext context, List<Widget> stepperItems) {
    final theme = context.tTheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.bgColorContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: stepperItems,
        ),
      ),
    );
  }

  @Demo(group: 'stepper')
  Widget _customStepperValue(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _filledStepper(
            value: _customValue,
            step: 2,
            max: 99,
            onChanged: (value) => setState(() => _customValue = value),
          ),
          TButton(
            child: const Text('value * 2'),
            onPressed: () {
              setState(() {
                _customValue = (_customValue * 2).clamp(0, 99);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _filledStepper({
    required num value,
    required ValueChanged<num>? onChanged,
    num min = 0,
    num max = 100,
    num step = 1,
  }) {
    return _themedStepper(
      theme: const TStepperThemeData(variant: TStepperVariant.filled),
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
      step: step,
    );
  }

  Widget _themedStepper({
    required TStepperThemeData theme,
    required num value,
    required ValueChanged<num>? onChanged,
    num min = 0,
    num max = 100,
    num step = 1,
  }) {
    return Theme(
      data: Theme.of(context).mergeExtension(theme),
      child: TStepper(
        value: value,
        onChanged: onChanged,
        min: min,
        max: max,
        step: step,
      ),
    );
  }
}
