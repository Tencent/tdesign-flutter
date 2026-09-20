import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

/// 在已配置 TDesign 主题的应用中使用 `StepperDisabledExample()`。
@ExampleCode(group: 'stepper')
class StepperDisabledExample extends StatelessWidget {
  const StepperDisabledExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.tTheme.bgColorContainer,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TStepper(
              key: ValueKey('stepper-disabled'),
              value: 0,
              variant: TStepperVariant.filled,
            ),
          ],
        ),
      ),
    );
  }
}
