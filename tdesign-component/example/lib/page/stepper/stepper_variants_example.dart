import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

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
    return ColoredBox(
      color: context.tTheme.bgColorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
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
        ),
      ),
    );
  }
}
