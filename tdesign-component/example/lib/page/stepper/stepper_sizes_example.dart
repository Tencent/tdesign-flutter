import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

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
    return ColoredBox(
      color: context.tTheme.bgColorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
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
        ),
      ),
    );
  }
}
