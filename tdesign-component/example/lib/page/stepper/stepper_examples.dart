import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

/// 在已配置 TDesign 主题的应用中使用 `StepperBaseExample()`。
@ExampleCode(group: 'stepper')
class StepperBaseExample extends StatefulWidget {
  const StepperBaseExample({super.key});

  @override
  State<StepperBaseExample> createState() => _StepperBaseExampleState();
}

class _StepperBaseExampleState extends State<StepperBaseExample> {
  num _base = 3;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TStepper(
          key: const ValueKey('stepper-base'),
          value: _base,
          variant: TStepperVariant.filled,
          onChanged: (value) => setState(() => _base = value),
        ),
      ],
    );
  }
}

/// 在已配置 TDesign 主题的应用中使用 `StepperBoundsExample()`。
@ExampleCode(group: 'stepper')
class StepperBoundsExample extends StatefulWidget {
  const StepperBoundsExample({super.key});

  @override
  State<StepperBoundsExample> createState() => _StepperBoundsExampleState();
}

class _StepperBoundsExampleState extends State<StepperBoundsExample> {
  num _minimum = 0;
  num _maximum = 999;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TStepper(
          key: const ValueKey('stepper-minimum'),
          value: _minimum,
          variant: TStepperVariant.filled,
          onChanged: (value) => setState(() => _minimum = value),
        ),
        const SizedBox(width: 32),
        TStepper(
          key: const ValueKey('stepper-maximum'),
          value: _maximum,
          max: 999,
          variant: TStepperVariant.filled,
          onChanged: (value) => setState(() => _maximum = value),
        ),
      ],
    );
  }
}

/// 在已配置 TDesign 主题的应用中使用 `StepperDisabledExample()`。
@ExampleCode(group: 'stepper')
class StepperDisabledExample extends StatelessWidget {
  const StepperDisabledExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TStepper(
          key: ValueKey('stepper-disabled'),
          value: 0,
          variant: TStepperVariant.filled,
        ),
      ],
    );
  }
}

/// 在已配置 TDesign 主题的应用中使用 `StepperVariantsExample()`。
@ExampleCode(group: 'stepper')
class StepperVariantsExample extends StatefulWidget {
  const StepperVariantsExample({super.key});

  @override
  State<StepperVariantsExample> createState() => _StepperVariantsExampleState();
}

class _StepperVariantsExampleState extends State<StepperVariantsExample> {
  num _filled = 3;
  num _outline = 3;
  num _normal = 3;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TStepper(
          key: const ValueKey('stepper-variants'),
          value: _filled,
          variant: TStepperVariant.filled,
          onChanged: (value) => setState(() => _filled = value),
        ),
        TStepper(
          key: const ValueKey('stepper-outline'),
          value: _outline,
          variant: TStepperVariant.outline,
          onChanged: (value) => setState(() => _outline = value),
        ),
        TStepper(
          key: const ValueKey('stepper-normal'),
          value: _normal,
          variant: TStepperVariant.normal,
          onChanged: (value) => setState(() => _normal = value),
        ),
      ],
    );
  }
}

/// 在已配置 TDesign 主题的应用中使用 `StepperSizesExample()`。
@ExampleCode(group: 'stepper')
class StepperSizesExample extends StatefulWidget {
  const StepperSizesExample({super.key});

  @override
  State<StepperSizesExample> createState() => _StepperSizesExampleState();
}

class _StepperSizesExampleState extends State<StepperSizesExample> {
  num _large = 3;
  num _medium = 3;
  num _small = 3;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TStepper(
          key: const ValueKey('stepper-sizes'),
          value: _large,
          size: TStepperSize.large,
          variant: TStepperVariant.filled,
          onChanged: (value) => setState(() => _large = value),
        ),
        TStepper(
          key: const ValueKey('stepper-medium'),
          value: _medium,
          size: TStepperSize.medium,
          variant: TStepperVariant.filled,
          onChanged: (value) => setState(() => _medium = value),
        ),
        TStepper(
          key: const ValueKey('stepper-small'),
          value: _small,
          size: TStepperSize.small,
          variant: TStepperVariant.filled,
          onChanged: (value) => setState(() => _small = value),
        ),
      ],
    );
  }
}
